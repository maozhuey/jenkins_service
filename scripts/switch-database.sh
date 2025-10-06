#!/bin/bash

# TBK Database Switching Script
# 本地环境数据库切换脚本

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
    echo "TBK 数据库切换工具"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  local     切换到本地Docker数据库"
    echo "  cloud     切换到阿里云数据库"
    echo "  status    显示当前数据库配置"
    echo "  --help    显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 local    # 切换到本地数据库"
    echo "  $0 cloud    # 切换到阿里云数据库"
    echo "  $0 status   # 查看当前配置"
}

get_current_db_config() {
    if [ -f "$ENV_FILE" ]; then
        DB_HOST=$(grep "^DB_HOST=" "$ENV_FILE" | cut -d'=' -f2)
        DB_NAME=$(grep "^DB_NAME=" "$ENV_FILE" | cut -d'=' -f2)
        echo "当前数据库配置:"
        echo "  主机: $DB_HOST"
        echo "  数据库: $DB_NAME"
        
        if [ "$DB_HOST" = "localhost" ]; then
            echo "  类型: 本地Docker数据库"
        else
            echo "  类型: 阿里云数据库"
        fi
    else
        log_error "环境配置文件不存在: $ENV_FILE"
        exit 1
    fi
}

switch_to_local() {
    log_info "切换到本地Docker数据库..."
    
    # Backup current config
    cp "$ENV_FILE" "$ENV_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Update database configuration
    sed -i '' 's/^DB_HOST=.*/DB_HOST=mysql-local/' "$ENV_FILE"
    sed -i '' 's/^DB_USER=.*/DB_USER=root/' "$ENV_FILE"
    sed -i '' 's/^DB_PASSWORD=.*/DB_PASSWORD=han0419\//' "$ENV_FILE"
    sed -i '' 's/^DB_NAME=.*/DB_NAME=peach_wiki/' "$ENV_FILE"
    sed -i '' 's/^DB_PORT=.*/DB_PORT=3306/' "$ENV_FILE"
    
    log_success "已切换到本地Docker数据库"
    log_info "请重启应用以使配置生效"
}

switch_to_cloud() {
    log_info "切换到阿里云数据库..."
    
    # Backup current config
    cp "$ENV_FILE" "$ENV_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Update database configuration
    sed -i '' 's/^DB_HOST=.*/DB_HOST=60.205.0.185/' "$ENV_FILE"
    sed -i '' 's/^DB_USER=.*/DB_USER=peach_wiki/' "$ENV_FILE"
    sed -i '' 's/^DB_PASSWORD=.*/DB_PASSWORD=han0419\//' "$ENV_FILE"
    sed -i '' 's/^DB_NAME=.*/DB_NAME=peach_wiki/' "$ENV_FILE"
    sed -i '' 's/^DB_PORT=.*/DB_PORT=3306/' "$ENV_FILE"
    
    log_success "已切换到阿里云数据库"
    log_info "请重启应用以使配置生效"
}

test_database_connection() {
    log_info "测试数据库连接..."
    
    # Get current database config
    source "$ENV_FILE"
    
    # Test connection using mysql client if available
    if command -v mysql &> /dev/null; then
        if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; then
            log_success "数据库连接测试成功"
        else
            log_error "数据库连接测试失败"
        fi
    else
        log_warning "未安装mysql客户端，跳过连接测试"
    fi
}

# Main script logic
case "${1:-}" in
    "local")
        switch_to_local
        test_database_connection
        ;;
    "cloud")
        switch_to_cloud
        test_database_connection
        ;;
    "status")
        get_current_db_config
        ;;
    "--help"|"-h"|"help")
        show_help
        ;;
    "")
        log_error "请指定操作类型"
        echo ""
        show_help
        exit 1
        ;;
    *)
        log_error "未知选项: $1"
        echo ""
        show_help
        exit 1
        ;;
esac