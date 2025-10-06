#!/bin/bash

# TBK Development Environment - Public Access Deployment Script
# 部署支持公网访问的开发环境

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# 检查必要条件
check_prerequisites() {
    log_info "Checking prerequisites for public deployment..."
    
    # 检查Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed"
        exit 1
    fi
    
    # 检查Docker Compose (支持新旧版本)
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker-compose"
    elif docker compose version &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker compose"
    else
        log_error "Docker Compose is not installed"
        log_info "Please install Docker Compose or use Docker Desktop which includes it"
        exit 1
    fi
    
    log_info "Using Docker Compose command: $DOCKER_COMPOSE_CMD"
    
    # 检查必要文件
    local required_files=(
        "docker-compose.public.yml"
        "nginx/public.conf"
        "Dockerfile.dev"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            log_error "Required file missing: $file"
            exit 1
        fi
    done
    
    log_success "Prerequisites check passed"
}

# 生成SSL证书（自签名，用于开发）
generate_ssl_cert() {
    log_info "Generating SSL certificate for development..."
    
    if [[ ! -f "ssl/cert.pem" ]] || [[ ! -f "ssl/key.pem" ]]; then
        mkdir -p ssl
        
        # 生成自签名证书
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout ssl/key.pem \
            -out ssl/cert.pem \
            -subj "/C=CN/ST=Beijing/L=Beijing/O=TBK/OU=Development/CN=dev.tbk.example.com"
        
        log_success "SSL certificate generated"
    else
        log_info "SSL certificate already exists"
    fi
}

# 创建环境配置文件
create_env_file() {
    log_info "Creating environment configuration..."
    
    cat > .env.public << EOF
# TBK Development Environment - Public Access Configuration

# Application Configuration
NODE_ENV=development
PUBLIC_PORT=8080
PUBLIC_ACCESS=true
TRUST_PROXY=true

# Database Configuration
DB_HOST=60.205.0.185
DB_USER=peach_wiki
DB_PASSWORD=han0419/
DB_NAME=peach_wiki
DB_PORT=3306

# Local MySQL Configuration (if using local database)
MYSQL_ROOT_PASSWORD=han0419/
MYSQL_PORT=3307

# Redis Configuration
REDIS_PASSWORD=han0419

# CORS Configuration
CORS_ORIGIN=*

# Logging
LOG_LEVEL=debug

# SSL Configuration
SSL_ENABLED=true

# Security Configuration
RATE_LIMIT_ENABLED=true
RATE_LIMIT_MAX=100

# Monitoring
MONITORING_ENABLED=true
EOF
    
    log_success "Environment configuration created"
}

# 清理现有容器
cleanup_containers() {
    log_info "Cleaning up existing public containers..."
    
    # 停止并删除相关容器
    $DOCKER_COMPOSE_CMD -f docker-compose.public.yml down --remove-orphans 2>/dev/null || true
    
    # 清理未使用的网络（保护外部网络）
    docker network prune -f --filter "label!=external" 2>/dev/null || true
    
    log_success "Cleanup completed"
}

# 部署公网环境
deploy_public_environment() {
    log_info "Deploying public development environment..."
    
    # 构建并启动服务
    $DOCKER_COMPOSE_CMD -f docker-compose.public.yml up -d --build
    
    log_success "Public environment deployed"
}

# 等待服务启动
wait_for_services() {
    log_info "Waiting for services to start..."
    
    local max_attempts=30
    local attempt=0
    
    while [[ $attempt -lt $max_attempts ]]; do
        if curl -f http://localhost:8080/health &>/dev/null; then
            log_success "Services are ready!"
            return 0
        fi
        
        echo -n "."
        sleep 2
        ((attempt++))
    done
    
    log_error "Services failed to start within expected time"
    return 1
}

# 运行健康检查
run_health_checks() {
    log_info "Running health checks..."
    
    local services=(
        "http://localhost:8080/health:TBK Application"
        "http://localhost:80/health:Nginx Proxy"
        "http://localhost:9000:Portainer"
    )
    
    for service in "${services[@]}"; do
        local url="${service%%:*}"
        local name="${service##*:}"
        
        if curl -f "$url" &>/dev/null; then
            log_success "$name is healthy"
        else
            log_warning "$name health check failed"
        fi
    done
}

# 显示访问信息
show_access_info() {
    log_info "Public Development Environment Access Information"
    echo "================================================"
    echo ""
    echo "🌐 Application Access:"
    echo "   HTTP:  http://localhost:8080"
    echo "   HTTPS: https://localhost (with self-signed cert)"
    echo ""
    echo "🔧 Management Tools:"
    echo "   Portainer: http://localhost:9000"
    echo "   Nginx Status: http://localhost:8081/nginx_status"
    echo ""
    echo "📊 Database Access:"
    echo "   MySQL: localhost:3306"
    echo "   Redis: localhost:6379"
    echo ""
    echo "📁 Log Files:"
    echo "   Application: ./logs/"
    echo "   Nginx: ./logs/nginx/"
    echo ""
    echo "🔒 Security Notes:"
    echo "   - Rate limiting is enabled"
    echo "   - CORS is set to allow all origins (development only)"
    echo "   - Self-signed SSL certificate is used"
    echo ""
    echo "🌍 Public Access Setup:"
    echo "   1. Configure your router/firewall to forward ports 80, 443, 8080"
    echo "   2. Update DNS to point to your public IP"
    echo "   3. Consider using a proper SSL certificate for production"
    echo ""
}

# 显示防火墙配置建议
show_firewall_config() {
    log_info "Firewall Configuration Recommendations"
    echo "======================================"
    echo ""
    echo "For Ubuntu/Debian (ufw):"
    echo "  sudo ufw allow 80/tcp"
    echo "  sudo ufw allow 443/tcp"
    echo "  sudo ufw allow 8080/tcp"
    echo "  sudo ufw enable"
    echo ""
    echo "For CentOS/RHEL (firewalld):"
    echo "  sudo firewall-cmd --permanent --add-port=80/tcp"
    echo "  sudo firewall-cmd --permanent --add-port=443/tcp"
    echo "  sudo firewall-cmd --permanent --add-port=8080/tcp"
    echo "  sudo firewall-cmd --reload"
    echo ""
    echo "For Cloud Providers:"
    echo "  - AWS: Configure Security Groups"
    echo "  - Aliyun: Configure Security Groups"
    echo "  - Azure: Configure Network Security Groups"
    echo ""
}

# 主函数
main() {
    echo ""
    log_info "Starting TBK Development Environment - Public Access Deployment"
    echo "=============================================================="
    echo ""
    
    # 执行部署步骤
    check_prerequisites
    generate_ssl_cert
    create_env_file
    cleanup_containers
    deploy_public_environment
    
    # 等待服务启动
    if wait_for_services; then
        run_health_checks
        echo ""
        show_access_info
        echo ""
        show_firewall_config
        echo ""
        log_success "Public development environment deployment completed!"
        echo ""
        log_info "To stop the environment, run: ./scripts/stop-public.sh"
    else
        log_error "Deployment failed - services did not start properly"
        echo ""
        log_info "Check logs with: $DOCKER_COMPOSE_CMD -f docker-compose.public.yml logs"
        exit 1
    fi
}

# 运行主函数
main "$@"