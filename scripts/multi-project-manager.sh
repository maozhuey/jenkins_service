#!/bin/bash

# Multi-Project Environment Manager
# 多项目环境管理工具

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_ROOT/multi-project-config.json"

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

log_project() {
    echo -e "${PURPLE}[PROJECT]${NC} $1"
}

log_env() {
    echo -e "${CYAN}[ENV]${NC} $1"
}

show_help() {
    echo "多项目环境管理工具"
    echo ""
    echo "用法: $0 <命令> [选项]"
    echo ""
    echo "命令:"
    echo "  list                 列出所有项目及其环境状态"
    echo "  status <project>     查看指定项目的详细状态"
    echo "  switch <project> <env>  切换指定项目的环境"
    echo "  deploy <project> <env>  部署指定项目的环境"
    echo "  stop <project> <env>    停止指定项目的环境"
    echo "  add <project> <path>    添加新项目到管理列表"
    echo "  remove <project>        从管理列表移除项目"
    echo "  ports                   查看所有项目的端口分配"
    echo "  health                  检查所有项目的健康状态"
    echo ""
    echo "示例:"
    echo "  $0 list                              # 列出所有项目"
    echo "  $0 status jenkins-service            # 查看jenkins-service状态"
    echo "  $0 switch jenkins-service production # 切换到生产环境"
    echo "  $0 deploy jenkins-service local      # 部署本地环境"
    echo "  $0 add my-project /path/to/project   # 添加新项目"
}

check_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "配置文件不存在: $CONFIG_FILE"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        log_error "需要安装jq来解析JSON配置文件"
        log_info "安装命令: brew install jq"
        exit 1
    fi
}

get_projects() {
    jq -r '.projects | keys[]' "$CONFIG_FILE"
}

get_project_info() {
    local project="$1"
    local field="$2"
    jq -r ".projects[\"$project\"].$field" "$CONFIG_FILE" 2>/dev/null || echo "null"
}

get_project_env_info() {
    local project="$1"
    local env="$2"
    local field="$3"
    jq -r ".projects[\"$project\"].environments[\"$env\"].$field" "$CONFIG_FILE" 2>/dev/null || echo "null"
}

# 新增: 更新/追加 .env 中的键值
update_env_var() {
    local file="$1"
    local key="$2"
    local value="$3"
    if [ ! -f "$file" ]; then
        touch "$file"
    fi
    if grep -qE "^${key}=" "$file"; then
        # macOS sed 原地更新需要空字符串参数
        sed -i "" -E "s#^${key}=.*#${key}=${value}#g" "$file"
    else
        echo "${key}=${value}" >> "$file"
    fi
}

# 新增: 按项目配置同步 .env.<env> 文件（DB_*, NODE_ENV, PORT）
sync_env_file() {
    local project="$1"
    local target_env="$2"

    local project_path
    project_path=$(jq -r ".projects[\"$project\"].path" "$CONFIG_FILE")
    if [ ! -d "$project_path" ]; then
        log_error "项目路径不存在: $project_path"
        return 1
    fi

    local env_file
    case "$target_env" in
        production)
            env_file=".env.production";;
        local)
            env_file=".env.local";;
        *)
            env_file=".env.${target_env}";;
    esac

    local db_kind
    db_kind=$(get_project_env_info "$project" "$target_env" "database")
    if [ "$db_kind" = "null" ] || [ -z "$db_kind" ]; then
        log_warning "环境未配置 database 字段，默认使用 cloud"
        db_kind="cloud"
    fi

    local host port dbname user password port_http
    host=$(jq -r ".projects[\"$project\"].database_config[\"$db_kind\"].host" "$CONFIG_FILE")
    port=$(jq -r ".projects[\"$project\"].database_config[\"$db_kind\"].port" "$CONFIG_FILE")
    dbname=$(jq -r ".projects[\"$project\"].database_config[\"$db_kind\"].database" "$CONFIG_FILE")
    user=$(jq -r ".projects[\"$project\"].database_config[\"$db_kind\"].user" "$CONFIG_FILE")
    password=$(jq -r ".projects[\"$project\"].database_config[\"$db_kind\"].password" "$CONFIG_FILE")
    port_http=$(get_project_env_info "$project" "$target_env" "port")

    pushd "$project_path" >/dev/null

    update_env_var "$env_file" "NODE_ENV" "$target_env"
    update_env_var "$env_file" "PORT" "$port_http"
    update_env_var "$env_file" "DB_HOST" "$host"
    update_env_var "$env_file" "DB_PORT" "$port"
    update_env_var "$env_file" "DB_NAME" "$dbname"
    update_env_var "$env_file" "DB_USER" "$user"
    update_env_var "$env_file" "DB_PASSWORD" "$password"

    log_success "同步环境文件完成: $project/$env_file"
    popd >/dev/null
}

list_projects() {
    log_info "项目环境状态列表"
    echo "================================================"
    
    local projects=$(get_projects)
    if [ -z "$projects" ]; then
        log_warning "没有找到任何项目"
        return
    fi
    
    printf "%-20s %-12s %-8s %-15s %-10s\n" "项目名称" "当前环境" "端口" "数据库" "状态"
    echo "------------------------------------------------"
    
    for project in $projects; do
        local name=$(get_project_info "$project" "name")
        local current_env=$(get_project_info "$project" "current_environment")
        local port=$(get_project_env_info "$project" "$current_env" "port")
        local database=$(get_project_env_info "$project" "$current_env" "database")
        
        # Check if service is running
        local status="停止"
        if curl -f "http://localhost:$port/api/health" &> /dev/null; then
            status="${GREEN}运行${NC}"
        else
            status="${RED}停止${NC}"
        fi
        
        printf "%-20s %-12s %-8s %-15s %-10s\n" "$name" "$current_env" "$port" "$database" "$status"
    done
}

show_project_status() {
    local project="$1"
    
    if [ -z "$project" ]; then
        log_error "请指定项目名称"
        exit 1
    fi
    
    local project_info=$(jq ".projects[\"$project\"]" "$CONFIG_FILE" 2>/dev/null)
    if [ "$project_info" = "null" ]; then
        log_error "项目不存在: $project"
        exit 1
    fi
    
    log_project "项目详细状态: $project"
    echo "================================================"
    
    local name=$(get_project_info "$project" "name")
    local path=$(get_project_info "$project" "path")
    local current_env=$(get_project_info "$project" "current_environment")
    
    echo "项目名称: $name"
    echo "项目路径: $path"
    echo "当前环境: $current_env"
    echo ""
    
    echo "可用环境:"
    local environments=$(jq -r ".projects[\"$project\"].environments | keys[]" "$CONFIG_FILE")
    for env in $environments; do
        local port=$(get_project_env_info "$project" "$env" "port")
        local database=$(get_project_env_info "$project" "$env" "database")
        local network=$(get_project_env_info "$project" "$env" "docker_network")
        
        local status_icon="○"
        if [ "$env" = "$current_env" ]; then
            status_icon="${GREEN}●${NC}"
        fi
        
        echo "  $status_icon $env (端口: $port, 数据库: $database, 网络: $network)"
    done
    
    echo ""
    echo "数据库配置:"
    local db_configs=$(jq -r ".projects[\"$project\"].database_config | keys[]" "$CONFIG_FILE")
    for db in $db_configs; do
        local host=$(jq -r ".projects[\"$project\"].database_config[\"$db\"].host" "$CONFIG_FILE")
        local db_port=$(jq -r ".projects[\"$project\"].database_config[\"$db\"].port" "$CONFIG_FILE")
        local database_name=$(jq -r ".projects[\"$project\"].database_config[\"$db\"].database" "$CONFIG_FILE")
        
        echo "  $db: $host:$db_port/$database_name"
    done
}

switch_project_environment() {
    local project="$1"
    local target_env="$2"
    
    if [ -z "$project" ] || [ -z "$target_env" ]; then
        log_error "请指定项目名称和目标环境"
        exit 1
    fi
    
    # Validate project exists
    local project_info=$(jq ".projects[\"$project\"]" "$CONFIG_FILE" 2>/dev/null)
    if [ "$project_info" = "null" ]; then
        log_error "项目不存在: $project"
        exit 1
    fi
    
    # Validate environment exists
    local env_info=$(get_project_env_info "$project" "$target_env" "port")
    if [ "$env_info" = "null" ]; then
        log_error "环境不存在: $target_env"
        exit 1
    fi
    
    log_info "切换项目 $project 到环境 $target_env"
    
    # Update configuration
    local temp_file=$(mktemp)
    jq ".projects[\"$project\"].current_environment = \"$target_env\"" "$CONFIG_FILE" > "$temp_file"
    mv "$temp_file" "$CONFIG_FILE"

    # 新增：在部署之前同步 .env 文件
    sync_env_file "$project" "$target_env"
    
    # Get project path and execute switch
    local project_path=$(get_project_info "$project" "path")
    if [ -d "$project_path" ]; then
        cd "$project_path"
        
        # Stop current environment
        log_info "停止当前环境..."
        ./scripts/stop-local.sh &> /dev/null || true
        ./scripts/stop-production.sh &> /dev/null || true
        
        # Deploy target environment
        log_info "部署目标环境..."
        if [ "$target_env" = "local" ]; then
            if [ -f "./scripts/deploy-local.sh" ]; then
                ./scripts/deploy-local.sh
            else
                log_error "本地部署脚本不存在"
                exit 1
            fi
        elif [ "$target_env" = "production" ]; then
            # For projects created with template generator, use docker-compose directly
             if [ -f "./docker-compose.production.yml" ]; then
                 log_info "使用Docker Compose部署生产环境..."
                 
                 # Load environment variables
                 if [ -f "./.env.production" ]; then
                     export $(grep -v '^#' ./.env.production | xargs)
                 fi
                 
                 # Check for docker-compose command
                 if command -v docker-compose &> /dev/null; then
                     DOCKER_COMPOSE_CMD="docker-compose"
                 elif docker compose version &> /dev/null; then
                     DOCKER_COMPOSE_CMD="docker compose"
                 else
                     log_error "Docker Compose未安装"
                     exit 1
                 fi
                 
                 # For tbk project, use simplified deployment without nginx
                 if [[ "$project_path" == *"tbk"* ]]; then
                     log_info "使用简化部署（不含nginx）..."
                     # Create a temporary simplified docker-compose file
                     cat > docker-compose.production.simple.yml << EOF
version: '3.8'

services:
  tbk-production:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "\${PORT:-3003}:3000"
    environment:
      - NODE_ENV=\${NODE_ENV:-production}
      - PORT=3000
      - DB_HOST=\${DB_HOST}
      - DB_PORT=\${DB_PORT}
      - DB_NAME=\${DB_NAME}
      - DB_USER=\${DB_USER}
      - DB_PASSWORD=\${DB_PASSWORD}
    networks:
      - tbk-prod-net
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  tbk-prod-net:
    driver: bridge
EOF
                     $DOCKER_COMPOSE_CMD -f docker-compose.production.simple.yml up -d --build
                 else
                     # Deploy with docker-compose
                     $DOCKER_COMPOSE_CMD -f docker-compose.production.yml up -d --build
                 fi
                 log_success "生产环境部署完成"
            elif [ -f "./scripts/deploy-production.sh" ]; then
                ./scripts/deploy-production.sh
            else
                log_error "生产部署配置不存在"
                exit 1
            fi
        fi
        
        log_success "环境切换完成: $project -> $target_env"
    else
        log_error "项目路径不存在: $project_path"
        exit 1
    fi
}

deploy_project() {
    local project="$1"
    local env="$2"
    
    if [ -z "$project" ] || [ -z "$env" ]; then
        log_error "请指定项目名称和环境"
        exit 1
    fi
    
    local project_path=$(get_project_info "$project" "path")
    if [ ! -d "$project_path" ]; then
        log_error "项目路径不存在: $project_path"
        exit 1
    fi
    
    log_info "部署项目 $project 的 $env 环境"
    
    cd "$project_path"

    # 新增：在部署之前同步 .env 文件
    sync_env_file "$project" "$env"
    
    case "$env" in
        local)
            if [ -f "./scripts/deploy-local.sh" ]; then
                ./scripts/deploy-local.sh
            else
                log_error "本地部署脚本不存在: $project_path/scripts/deploy-local.sh"
                exit 1
            fi
            ;;
        production)
            # For projects created with template generator, use docker-compose directly
            if [ -f "./docker-compose.production.yml" ]; then
                log_info "使用Docker Compose部署生产环境..."
                
                # Load environment variables
                if [ -f "./.env.production" ]; then
                    export $(grep -v '^#' ./.env.production | xargs)
                fi
                
                # Check for docker-compose command
                if command -v docker-compose &> /dev/null; then
                    DOCKER_COMPOSE_CMD="docker-compose"
                elif docker compose version &> /dev/null; then
                    DOCKER_COMPOSE_CMD="docker compose"
                else
                    log_error "Docker Compose未安装"
                    exit 1
                fi
                
                # Deploy with docker-compose
                $DOCKER_COMPOSE_CMD -f docker-compose.production.yml up -d --build
                log_success "生产环境部署完成"
            elif [ -f "./scripts/deploy-production.sh" ]; then
                ./scripts/deploy-production.sh
            else
                log_error "生产部署配置不存在: 需要 docker-compose.production.yml 或 scripts/deploy-production.sh"
                exit 1
            fi
            ;;
        *)
            log_error "不支持的环境: $env"
            exit 1
            ;;
    esac
    
    # Update current environment in config
    local temp_file=$(mktemp)
    jq ".projects[\"$project\"].current_environment = \"$env\"" "$CONFIG_FILE" > "$temp_file"
    mv "$temp_file" "$CONFIG_FILE"
    
    log_success "项目 $project 已部署到 $env 环境"
}

stop_project() {
    local project="$1"
    local env="$2"
    
    if [ -z "$project" ] || [ -z "$env" ]; then
        log_error "请指定项目名称和环境"
        exit 1
    fi
    
    local project_path=$(get_project_info "$project" "path")
    if [ ! -d "$project_path" ]; then
        log_error "项目路径不存在: $project_path"
        exit 1
    fi
    
    log_info "停止项目 $project 的 $env 环境"
    
    cd "$project_path"
    if [ "$env" = "local" ]; then
        ./scripts/stop-local.sh
    elif [ "$env" = "production" ]; then
        ./scripts/stop-production.sh
    else
        log_error "不支持的环境: $env"
        exit 1
    fi
}

show_ports() {
    log_info "项目端口分配"
    echo "================================================"
    
    printf "%-20s %-12s %-8s %-15s\n" "项目名称" "环境" "端口" "状态"
    echo "------------------------------------------------"
    
    local projects=$(get_projects)
    for project in $projects; do
        local name=$(get_project_info "$project" "name")
        local environments=$(jq -r ".projects[\"$project\"].environments | keys[]" "$CONFIG_FILE")
        
        for env in $environments; do
            local port=$(get_project_env_info "$project" "$env" "port")
            
            # Check if port is in use
            local status="空闲"
            if lsof -i :$port &> /dev/null; then
                status="${GREEN}使用中${NC}"
            fi
            
            printf "%-20s %-12s %-8s %-15s\n" "$name" "$env" "$port" "$status"
        done
    done
}

health_check() {
    log_info "项目健康检查"
    echo "================================================"
    
    local projects=$(get_projects)
    for project in $projects; do
        local name=$(get_project_info "$project" "name")
        local current_env=$(get_project_info "$project" "current_environment")
        local port=$(get_project_env_info "$project" "$current_env" "port")
        
        log_project "检查项目: $name ($current_env)"
        
        if curl -f "http://localhost:$port/api/health" &> /dev/null; then
            log_success "健康检查通过 - http://localhost:$port"
        else
            log_warning "健康检查失败 - 服务可能未运行"
        fi
        echo ""
    done
}

# Main script logic
case "$1" in
    list)
        check_config
        list_projects
        ;;
    status)
        check_config
        show_project_status "$2"
        ;;
    switch)
        check_config
        switch_project_environment "$2" "$3"
        ;;
    deploy)
        check_config
        deploy_project "$2" "$3"
        ;;
    stop)
        check_config
        stop_project "$2" "$3"
        ;;
    ports)
        check_config
        show_ports
        ;;
    health)
        check_config
        health_check
        ;;
    --help|-h|help)
        show_help
        ;;
    *)
        log_error "未知命令: $1"
        show_help
        exit 1
        ;;
esac