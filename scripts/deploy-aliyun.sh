#!/bin/bash

# TBK Development Environment - Aliyun ECS Deployment Script
# 阿里云ECS部署脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量
ALIYUN_REGION="cn-beijing"
ECS_INSTANCE_TYPE="ecs.t5-lc1m1.small"
IMAGE_ID="centos_7_9_x64_20G_alibase_20210318.vhd"
SECURITY_GROUP_NAME="tbk-dev-sg"
KEY_PAIR_NAME="tbk-dev-key"

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查阿里云CLI
check_aliyun_cli() {
    log_info "Checking Aliyun CLI..."
    
    if ! command -v aliyun &> /dev/null; then
        log_error "Aliyun CLI is not installed"
        log_info "Please install it from: https://github.com/aliyun/aliyun-cli"
        exit 1
    fi
    
    # 检查配置
    if ! aliyun configure list &> /dev/null; then
        log_error "Aliyun CLI is not configured"
        log_info "Please run: aliyun configure"
        exit 1
    fi
    
    log_success "Aliyun CLI is ready"
}

# 创建安全组
create_security_group() {
    log_info "Creating security group..."
    
    # 检查安全组是否存在
    if aliyun ecs DescribeSecurityGroups --SecurityGroupName "$SECURITY_GROUP_NAME" --output json | jq -e '.SecurityGroups.SecurityGroup | length > 0' &> /dev/null; then
        log_info "Security group already exists"
        return 0
    fi
    
    # 创建安全组
    local sg_id=$(aliyun ecs CreateSecurityGroup \
        --SecurityGroupName "$SECURITY_GROUP_NAME" \
        --Description "TBK Development Environment Security Group" \
        --output json | jq -r '.SecurityGroupId')
    
    if [[ -n "$sg_id" ]]; then
        log_success "Security group created: $sg_id"
        
        # 添加安全组规则
        add_security_group_rules "$sg_id"
    else
        log_error "Failed to create security group"
        exit 1
    fi
}

# 添加安全组规则
add_security_group_rules() {
    local sg_id="$1"
    log_info "Adding security group rules..."
    
    # 定义端口规则
    local ports=(
        "22:SSH"
        "80:HTTP"
        "443:HTTPS"
        "3000:Application"
        "8080:Nginx-HTTP"
        "8443:Nginx-HTTPS"
        "9000:Portainer"
    )
    
    for port_info in "${ports[@]}"; do
        local port="${port_info%%:*}"
        local desc="${port_info##*:}"
        
        aliyun ecs AuthorizeSecurityGroup \
            --SecurityGroupId "$sg_id" \
            --IpProtocol tcp \
            --PortRange "$port/$port" \
            --SourceCidrIp "0.0.0.0/0" \
            --Description "$desc" &> /dev/null || true
        
        log_info "Added rule for port $port ($desc)"
    done
    
    log_success "Security group rules added"
}

# 创建密钥对
create_key_pair() {
    log_info "Creating key pair..."
    
    # 检查密钥对是否存在
    if aliyun ecs DescribeKeyPairs --KeyPairName "$KEY_PAIR_NAME" --output json | jq -e '.KeyPairs.KeyPair | length > 0' &> /dev/null; then
        log_info "Key pair already exists"
        return 0
    fi
    
    # 创建密钥对
    local key_content=$(aliyun ecs CreateKeyPair \
        --KeyPairName "$KEY_PAIR_NAME" \
        --output json | jq -r '.PrivateKeyBody')
    
    if [[ -n "$key_content" ]]; then
        # 保存私钥
        echo "$key_content" > "${KEY_PAIR_NAME}.pem"
        chmod 600 "${KEY_PAIR_NAME}.pem"
        
        log_success "Key pair created and saved to ${KEY_PAIR_NAME}.pem"
    else
        log_error "Failed to create key pair"
        exit 1
    fi
}

# 创建ECS实例
create_ecs_instance() {
    log_info "Creating ECS instance..."
    
    # 获取安全组ID
    local sg_id=$(aliyun ecs DescribeSecurityGroups \
        --SecurityGroupName "$SECURITY_GROUP_NAME" \
        --output json | jq -r '.SecurityGroups.SecurityGroup[0].SecurityGroupId')
    
    if [[ -z "$sg_id" || "$sg_id" == "null" ]]; then
        log_error "Security group not found"
        exit 1
    fi
    
    # 创建实例
    local instance_id=$(aliyun ecs CreateInstance \
        --ImageId "$IMAGE_ID" \
        --InstanceType "$ECS_INSTANCE_TYPE" \
        --SecurityGroupId "$sg_id" \
        --KeyPairName "$KEY_PAIR_NAME" \
        --InstanceName "tbk-dev-server" \
        --Description "TBK Development Environment Server" \
        --InternetMaxBandwidthOut 5 \
        --output json | jq -r '.InstanceId')
    
    if [[ -n "$instance_id" && "$instance_id" != "null" ]]; then
        log_success "ECS instance created: $instance_id"
        
        # 启动实例
        aliyun ecs StartInstance --InstanceId "$instance_id"
        log_info "Starting instance..."
        
        # 等待实例启动
        wait_for_instance "$instance_id"
        
        # 获取公网IP
        get_instance_ip "$instance_id"
    else
        log_error "Failed to create ECS instance"
        exit 1
    fi
}

# 等待实例启动
wait_for_instance() {
    local instance_id="$1"
    local max_attempts=30
    local attempt=0
    
    log_info "Waiting for instance to start..."
    
    while [[ $attempt -lt $max_attempts ]]; do
        local status=$(aliyun ecs DescribeInstances \
            --InstanceIds "[$instance_id]" \
            --output json | jq -r '.Instances.Instance[0].Status')
        
        if [[ "$status" == "Running" ]]; then
            log_success "Instance is running"
            return 0
        fi
        
        echo -n "."
        sleep 10
        ((attempt++))
    done
    
    log_error "Instance failed to start within expected time"
    return 1
}

# 获取实例IP
get_instance_ip() {
    local instance_id="$1"
    
    local public_ip=$(aliyun ecs DescribeInstances \
        --InstanceIds "[$instance_id]" \
        --output json | jq -r '.Instances.Instance[0].PublicIpAddress.IpAddress[0]')
    
    local private_ip=$(aliyun ecs DescribeInstances \
        --InstanceIds "[$instance_id]" \
        --output json | jq -r '.Instances.Instance[0].InnerIpAddress.IpAddress[0]')
    
    echo ""
    log_success "Instance created successfully!"
    echo "Instance ID: $instance_id"
    echo "Public IP: $public_ip"
    echo "Private IP: $private_ip"
    echo ""
    
    # 保存连接信息
    cat > connection_info.txt << EOF
# TBK Development Environment - Connection Information
Instance ID: $instance_id
Public IP: $public_ip
Private IP: $private_ip
Key File: ${KEY_PAIR_NAME}.pem

# SSH Connection:
ssh -i ${KEY_PAIR_NAME}.pem root@$public_ip

# SCP File Transfer:
scp -i ${KEY_PAIR_NAME}.pem file.txt root@$public_ip:/path/to/destination/
EOF
    
    log_info "Connection information saved to connection_info.txt"
}

# 生成部署脚本
generate_deployment_script() {
    log_info "Generating deployment script for ECS..."
    
    cat > deploy_to_ecs.sh << 'EOF'
#!/bin/bash

# TBK Development Environment - ECS Server Setup Script
# 在ECS服务器上运行此脚本来部署应用

set -e

# 更新系统
yum update -y

# 安装Docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io

# 启动Docker
systemctl start docker
systemctl enable docker

# 安装Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 创建应用目录
mkdir -p /opt/tbk
cd /opt/tbk

# 创建必要目录
mkdir -p logs nginx ssl redis uploads

# 设置防火墙
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=8443/tcp
firewall-cmd --permanent --add-port=9000/tcp
firewall-cmd --reload

echo "ECS server setup completed!"
echo "Please upload your application files to /opt/tbk/"
EOF
    
    chmod +x deploy_to_ecs.sh
    log_success "Deployment script generated: deploy_to_ecs.sh"
}

# 显示部署信息
show_deployment_info() {
    log_info "Aliyun ECS Deployment Information"
    echo "================================="
    echo ""
    echo "📋 Next Steps:"
    echo "1. Connect to your ECS instance:"
    echo "   ssh -i ${KEY_PAIR_NAME}.pem root@[PUBLIC_IP]"
    echo ""
    echo "2. Upload deployment script:"
    echo "   scp -i ${KEY_PAIR_NAME}.pem deploy_to_ecs.sh root@[PUBLIC_IP]:/root/"
    echo ""
    echo "3. Run setup script on ECS:"
    echo "   ./deploy_to_ecs.sh"
    echo ""
    echo "4. Upload application files:"
    echo "   scp -i ${KEY_PAIR_NAME}.pem -r . root@[PUBLIC_IP]:/opt/tbk/"
    echo ""
    echo "5. Start the application:"
    echo "   cd /opt/tbk && docker-compose -f aliyun-ecs-deploy.yml up -d"
    echo ""
    echo "🔧 Management:"
    echo "- View logs: docker-compose -f aliyun-ecs-deploy.yml logs"
    echo "- Stop services: docker-compose -f aliyun-ecs-deploy.yml down"
    echo "- Update application: git pull && docker-compose -f aliyun-ecs-deploy.yml up -d --build"
    echo ""
    echo "🌐 Access URLs (replace [PUBLIC_IP] with actual IP):"
    echo "- Application: http://[PUBLIC_IP]:8080"
    echo "- HTTPS: https://[PUBLIC_IP]:8443"
    echo "- Portainer: http://[PUBLIC_IP]:9000"
    echo ""
}

# 主函数
main() {
    echo ""
    log_info "Starting TBK Development Environment - Aliyun ECS Deployment"
    echo "=========================================================="
    echo ""
    
    check_aliyun_cli
    create_security_group
    create_key_pair
    create_ecs_instance
    generate_deployment_script
    
    echo ""
    show_deployment_info
    echo ""
    
    log_success "Aliyun ECS deployment preparation completed!"
    log_info "Check connection_info.txt for instance details"
}

# 运行主函数
main "$@"