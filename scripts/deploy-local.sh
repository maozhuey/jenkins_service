#!/bin/bash

# TBK Local Environment Deployment Script
# 本地环境部署脚本

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
ENV_FILE="$PROJECT_ROOT/.env.local"

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
    echo "TBK 本地环境部署脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  --clean-images       删除现有Docker镜像后重新部署"
    echo "  --skip-health-check  跳过健康检查"
    echo "  --local-db          使用本地数据库（默认）"
    echo "  --cloud-db          使用阿里云数据库"
    echo "  --help              显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0                    # 使用默认配置部署"
    echo "  $0 --cloud-db         # 部署并使用阿里云数据库"
    echo "  $0 --clean-images     # 清理镜像后重新部署"
}

check_prerequisites() {
    log_info "检查部署前提条件..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker未安装，请先安装Docker"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker未运行，请启动Docker"
        exit 1
    fi
    
    # Check Docker Compose
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker-compose"
    elif docker compose version &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker compose"
    else
        log_error "Docker Compose未安装"
        exit 1
    fi
    
    log_success "前提条件检查通过"
}

setup_environment() {
    log_info "设置环境配置..."
    
    # Copy environment file if it doesn't exist
    if [ ! -f "$ENV_FILE" ]; then
        log_warning "环境配置文件不存在，创建默认配置..."
        cp "$PROJECT_ROOT/.env.local" "$ENV_FILE" 2>/dev/null || {
            log_error "无法创建环境配置文件"
            exit 1
        }
    fi
    
    # Set database configuration based on options
    if [ "$USE_CLOUD_DB" = "true" ]; then
        log_info "配置使用阿里云数据库..."
        "$SCRIPT_DIR/switch-database.sh" cloud
    else
        log_info "配置使用本地数据库..."
        "$SCRIPT_DIR/switch-database.sh" local
    fi
    
    log_success "环境配置完成"
}

clean_images() {
    if [ "$CLEAN_IMAGES" = "true" ]; then
        log_info "清理现有Docker镜像..."
        
        # Stop and remove containers
        $DOCKER_COMPOSE_CMD -f docker-compose.local.yml down --remove-orphans 2>/dev/null || true
        
        # Remove images
        docker rmi $(docker images -q --filter "reference=*tbk*") 2>/dev/null || true
        
        log_success "镜像清理完成"
    fi
}

deploy_services() {
    log_info "部署本地环境服务..."
    
    cd "$PROJECT_ROOT"
    
    # Load environment variables
    export $(grep -v '^#' "$ENV_FILE" | xargs)
    
    # Build and start services
    $DOCKER_COMPOSE_CMD -f docker-compose.local.yml up -d --build
    
    log_success "服务部署完成"
}

health_check() {
    if [ "$SKIP_HEALTH_CHECK" = "true" ]; then
        log_info "跳过健康检查"
        return
    fi
    
    log_info "执行健康检查..."
    
    # Wait for services to be ready
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f http://localhost:3001/api/health &> /dev/null; then
            log_success "应用健康检查通过"
            break
        fi
        
        if [ $attempt -eq $max_attempts ]; then
            log_error "健康检查失败，服务可能未正常启动"
            exit 1
        fi
        
        log_info "等待服务启动... ($attempt/$max_attempts)"
        sleep 5
        ((attempt++))
    done
}

show_deployment_info() {
    log_success "本地环境部署完成！"
    echo ""
    echo "访问信息:"
    echo "  应用地址: http://localhost:3001"
    echo "  健康检查: http://localhost:3001/api/health"
    echo "  API文档: http://localhost:3001/api/docs"
    echo ""
    echo "数据库信息:"
    source "$ENV_FILE"
    echo "  主机: $DB_HOST"
    echo "  数据库: $DB_NAME"
    echo "  端口: $DB_PORT"
    echo ""
    echo "管理命令:"
    echo "  查看日志: docker-compose -f docker-compose.local.yml logs -f"
    echo "  停止服务: ./scripts/stop-local.sh"
    echo "  切换数据库: ./scripts/switch-database.sh [local|cloud]"
}

# Parse command line arguments
CLEAN_IMAGES=false
SKIP_HEALTH_CHECK=false
USE_CLOUD_DB=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --clean-images)
            CLEAN_IMAGES=true
            shift
            ;;
        --skip-health-check)
            SKIP_HEALTH_CHECK=true
            shift
            ;;
        --local-db)
            USE_CLOUD_DB=false
            shift
            ;;
        --cloud-db)
            USE_CLOUD_DB=true
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

# Main deployment process
log_info "开始TBK本地环境部署"
echo "================================================"

check_prerequisites
setup_environment
clean_images
deploy_services
health_check
show_deployment_info

log_success "部署流程完成！"