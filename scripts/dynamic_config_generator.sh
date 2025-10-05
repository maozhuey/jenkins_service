#!/bin/bash
# 环境变量动态注入脚本
# 使用envsubst工具动态生成docker-compose.yml

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$PROJECT_ROOT/templates"
CONFIG_DIR="$PROJECT_ROOT/config"
OUTPUT_DIR="$PROJECT_ROOT"

# 环境配置文件路径
ENV_FILE="${CONFIG_DIR}/deployment.env"
TEMPLATE_FILE="${TEMPLATE_DIR}/docker-compose.template.yml"
OUTPUT_FILE="${OUTPUT_DIR}/aliyun-ecs-deploy.yml"

# 创建配置目录
mkdir -p "$CONFIG_DIR"

# 默认环境变量配置函数
setup_default_env() {
    local env_type=${1:-production}
    
    echo "设置 $env_type 环境的默认配置..."
    
    case $env_type in
        "production")
            cat > "$ENV_FILE" << EOF
# 生产环境配置
# Docker镜像配置
DOCKER_REGISTRY=crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin
DOCKER_IMAGE=tbk
DOCKER_TAG=\${DOCKER_TAG:-latest}
PLATFORM=linux/amd64

# 服务配置
SERVICE_NAME=tbk-production
CONTAINER_NAME=tbk-production
SERVICE_PORT=3000
NODE_ENV=production

# 网络配置
NETWORK_NAME=tbk_app-network

# 数据库配置
DB_HOST=tbk-mysql
DB_USER=tbk_admin
DB_PASSWORD=Han0419@MySQL
DB_NAME=tbk
DB_PORT=3306

# Redis配置
REDIS_HOST=tbk-redis
REDIS_PORT=6379

# 日志配置
LOG_LEVEL=info
LOG_VOLUME=./logs
LOG_VOLUME_NAME=tbk-logs
LOG_VOLUME_PATH=/opt/apps/tbk/logs

# 配置文件
CONFIG_VOLUME=./config
CONFIG_VOLUME_NAME=tbk-config
CONFIG_VOLUME_PATH=/opt/apps/tbk/config

# 健康检查配置
HEALTH_CHECK_INTERVAL=30s
HEALTH_CHECK_TIMEOUT=10s
HEALTH_CHECK_RETRIES=3
HEALTH_CHECK_START_PERIOD=40s

# 资源限制
CPU_LIMIT=1.0
MEMORY_LIMIT=1G
CPU_RESERVATION=0.5
MEMORY_RESERVATION=512M

# Nginx配置
NGINX_SERVICE_NAME=tbk-nginx
NGINX_CONTAINER_NAME=tbk-nginx
NGINX_IMAGE=nginx:alpine
HTTP_PORT=80
HTTPS_PORT=443
NGINX_CONFIG_PATH=./nginx/nginx.conf
SSL_CERT_PATH=./ssl
NGINX_LOG_PATH=./nginx/logs
NGINX_HEALTH_INTERVAL=30s
NGINX_HEALTH_TIMEOUT=5s
NGINX_HEALTH_RETRIES=3
EOF
            ;;
        "staging")
            cat > "$ENV_FILE" << EOF
# 预发布环境配置
DOCKER_REGISTRY=crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin
DOCKER_IMAGE=tbk
DOCKER_TAG=staging
SERVICE_NAME=tbk-staging
CONTAINER_NAME=tbk-staging
NETWORK_NAME=tbk_staging-network
NODE_ENV=staging
LOG_LEVEL=debug
CPU_LIMIT=0.5
MEMORY_LIMIT=512M
EOF
            ;;
        "development")
            cat > "$ENV_FILE" << EOF
# 开发环境配置
DOCKER_REGISTRY=localhost:5000
DOCKER_IMAGE=tbk
DOCKER_TAG=dev
SERVICE_NAME=tbk-dev
CONTAINER_NAME=tbk-dev
NETWORK_NAME=tbk_dev-network
NODE_ENV=development
LOG_LEVEL=debug
DB_PASSWORD=dev_password
EOF
            ;;
    esac
}

# 验证环境变量完整性
validate_env_vars() {
    local required_vars=(
        "DOCKER_REGISTRY"
        "DOCKER_IMAGE"
        "SERVICE_NAME"
        "CONTAINER_NAME"
        "NETWORK_NAME"
        "DB_PASSWORD"
    )
    
    echo "验证必需的环境变量..."
    
    local missing_vars=()
    for var in "${required_vars[@]}"; do
        if [ -z "${!var:-}" ]; then
            missing_vars+=("$var")
        fi
    done
    
    if [ ${#missing_vars[@]} -gt 0 ]; then
        echo "错误：缺少必需的环境变量："
        printf '  %s\n' "${missing_vars[@]}"
        return 1
    fi
    
    echo "环境变量验证通过"
    return 0
}

# 生成docker-compose.yml
generate_compose_file() {
    local template_file=$1
    local output_file=$2
    
    echo "从模板生成 docker-compose 文件..."
    echo "模板文件: $template_file"
    echo "输出文件: $output_file"
    
    # 检查模板文件是否存在
    if [ ! -f "$template_file" ]; then
        echo "错误：模板文件不存在: $template_file"
        return 1
    fi
    
    # 使用envsubst替换环境变量
    if command -v envsubst >/dev/null 2>&1; then
        envsubst < "$template_file" > "$output_file"
        echo "✅ docker-compose 文件生成成功"
    else
        echo "错误：envsubst 命令未找到，请安装 gettext 包"
        return 1
    fi
    
    # 验证生成的文件
    if [ -f "$output_file" ]; then
        echo "验证生成的配置文件..."
        if docker compose -f "$output_file" config >/dev/null 2>&1; then
            echo "✅ 配置文件语法验证通过"
        else
            echo "⚠️  配置文件语法验证失败，请检查"
            return 1
        fi
    else
        echo "错误：输出文件生成失败"
        return 1
    fi
}

# Jenkins环境配置函数
setup_jenkins_env() {
    cat << 'EOF'
# Jenkins Pipeline中的环境变量配置示例

pipeline {
    agent any
    
    environment {
        // 从Jenkins凭据中获取敏感信息
        DB_PASSWORD = credentials('tbk-db-password')
        DOCKER_REGISTRY_TOKEN = credentials('aliyun-acr-token')
        
        // 动态设置构建标签
        DOCKER_TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
        
        // 环境特定配置
        NETWORK_NAME = "tbk_app-network"
        SERVICE_NAME = "tbk-production"
        NODE_ENV = "production"
    }
    
    stages {
        stage('Generate Config') {
            steps {
                script {
                    // 设置环境特定变量
                    env.DEPLOYMENT_ENV = env.BRANCH_NAME == 'main' ? 'production' : 'staging'
                    
                    // 生成动态配置
                    sh '''
                        # 导出所有环境变量到配置文件
                        printenv | grep -E '^(DOCKER_|SERVICE_|NETWORK_|DB_|NODE_)' > config/jenkins.env
                        
                        # 生成docker-compose文件
                        ./scripts/dynamic_config_generator.sh generate
                    '''
                }
            }
        }
        
        stage('Deploy') {
            steps {
                sh '''
                    # 使用生成的配置文件部署
                    docker compose -f aliyun-ecs-deploy.yml up -d
                '''
            }
        }
    }
}
EOF
}

# 主函数
main() {
    local action=${1:-help}
    local env_type=${2:-production}
    
    case $action in
        "setup")
            echo "=== 设置环境配置 ==="
            setup_default_env "$env_type"
            echo "环境配置文件已创建: $ENV_FILE"
            ;;
        "generate")
            echo "=== 生成 docker-compose 文件 ==="
            
            # 加载环境变量
            if [ -f "$ENV_FILE" ]; then
                echo "加载环境配置: $ENV_FILE"
                set -a  # 自动导出变量
                source "$ENV_FILE"
                set +a
            else
                echo "警告：环境配置文件不存在，使用默认配置"
                setup_default_env "$env_type"
                set -a
                source "$ENV_FILE"
                set +a
            fi
            
            # 验证环境变量
            validate_env_vars
            
            # 生成配置文件
            generate_compose_file "$TEMPLATE_FILE" "$OUTPUT_FILE"
            ;;
        "validate")
            echo "=== 验证配置 ==="
            if [ -f "$ENV_FILE" ]; then
                set -a
                source "$ENV_FILE"
                set +a
                validate_env_vars
            else
                echo "错误：环境配置文件不存在"
                exit 1
            fi
            ;;
        "jenkins")
            echo "=== Jenkins 配置示例 ==="
            setup_jenkins_env
            ;;
        "help"|*)
            cat << EOF
用法: $0 <action> [env_type]

Actions:
  setup <env_type>    - 设置环境配置 (production|staging|development)
  generate [env_type] - 生成 docker-compose 文件
  validate           - 验证环境配置
  jenkins            - 显示 Jenkins 配置示例
  help               - 显示此帮助信息

示例:
  $0 setup production
  $0 generate
  $0 validate
  $0 jenkins
EOF
            ;;
    esac
}

# 执行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi