#!/bin/bash

# TBK Production Environment Stop Script
# 停止生产环境脚本

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Functions
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

show_help() {
    echo "TBK 生产环境停止脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  --backup            停止前备份数据"
    echo "  --remove-images     同时删除镜像"
    echo "  --help              显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0                  # 停止服务"
    echo "  $0 --backup         # 备份后停止服务"
}

backup_before_stop() {
    if [ "$BACKUP_ENABLED" = "true" ]; then
        log_info "停止前备份数据..."
        
        local backup_dir="$PROJECT_ROOT/backups/$(date +%Y%m%d_%H%M%S)_stop"
        mkdir -p "$backup_dir"
        
        # Backup configuration
        cp "$PROJECT_ROOT/.env.production" "$backup_dir/" 2>/dev/null || true
        
        # Add database backup logic here if needed
        
        log_success "备份完成: $backup_dir"
    fi
}

stop_services() {
    log_info "停止生产环境服务..."
    
    cd "$PROJECT_ROOT"
    
    # Check Docker Compose
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker-compose"
    elif docker compose version &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker compose"
    else
        log_error "Docker Compose未安装"
        exit 1
    fi
    
    # Stop services
    $DOCKER_COMPOSE_CMD -f docker-compose.production.yml down --remove-orphans
    log_success "生产环境服务已停止"
    
    # Remove images if requested
    if [ "$REMOVE_IMAGES" = "true" ]; then
        log_info "删除相关镜像..."
        docker rmi $(docker images -q --filter "reference=*tbk*") 2>/dev/null || true
        log_success "镜像已删除"
    fi
}

# Parse command line arguments
BACKUP_ENABLED=false
REMOVE_IMAGES=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --backup)
            BACKUP_ENABLED=true
            shift
            ;;
        --remove-images)
            REMOVE_IMAGES=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            log_error "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main process
log_info "停止TBK生产环境"
echo "================================================"

backup_before_stop
stop_services

log_success "生产环境已停止！"