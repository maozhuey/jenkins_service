#!/bin/bash

# TBK Development Environment - Stop Public Access Script
# 停止公网访问开发环境

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

# 检查Docker Compose命令
check_docker_compose() {
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker-compose"
    elif docker compose version &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker compose"
    else
        log_error "Docker Compose is not available"
        exit 1
    fi
}

# 停止公网环境
stop_public_environment() {
    log_info "Stopping public development environment..."
    
    check_docker_compose
    
    if [[ -f "docker-compose.public.yml" ]]; then
        # 停止所有服务
        $DOCKER_COMPOSE_CMD -f docker-compose.public.yml down --remove-orphans
        
        log_success "Public environment stopped"
    else
        log_warning "docker-compose.public.yml not found"
    fi
}

# 清理资源
cleanup_resources() {
    log_info "Cleaning up resources..."
    
    # 清理未使用的容器
    docker container prune -f 2>/dev/null || true
    
    # 清理未使用的网络
    docker network prune -f 2>/dev/null || true
    
    # 清理未使用的卷（可选，谨慎使用）
    # docker volume prune -f 2>/dev/null || true
    
    log_success "Resource cleanup completed"
}

# 显示状态
show_status() {
    log_info "Current container status:"
    echo ""
    
    # 显示相关容器状态
    docker ps -a --filter "name=tbk" --filter "name=nginx" --filter "name=mysql" --filter "name=redis" --filter "name=portainer" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "No containers found"
    
    echo ""
    log_info "Network status:"
    docker network ls --filter "name=tbk" 2>/dev/null || echo "No networks found"
}

# 主函数
main() {
    echo ""
    log_info "Stopping TBK Development Environment - Public Access"
    echo "=================================================="
    echo ""
    
    stop_public_environment
    cleanup_resources
    
    echo ""
    show_status
    echo ""
    
    log_success "Public development environment stopped successfully!"
    echo ""
    log_info "To restart the environment, run: ./scripts/deploy-public.sh"
}

# 运行主函数
main "$@"