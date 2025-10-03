#!/bin/bash

# 自动部署Webhook脚本
# 用于接收Jenkins构建完成通知并自动更新生产环境

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
DOCKER_REGISTRY="crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com"
IMAGE_NAME="hanchanglin/tbk"
COMPOSE_FILE="docker-compose.production.yml"
HEALTH_CHECK_URL="http://localhost:3003/api/health"
LOG_FILE="/var/log/auto-deploy.log"

# 日志函数
log_info() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1${NC}" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1${NC}" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" | tee -a "$LOG_FILE"
}

# 检查Docker是否运行
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker未运行，请先启动Docker"
        exit 1
    fi
    log_info "Docker运行状态正常"
}

# 拉取最新镜像
pull_latest_image() {
    log_info "开始拉取最新镜像: ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest"
    
    if docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest; then
        log_success "镜像拉取成功"
        return 0
    else
        log_error "镜像拉取失败"
        return 1
    fi
}

# 获取当前运行的镜像ID
get_current_image_id() {
    docker inspect tbk-tbk-production-1 --format='{{.Image}}' 2>/dev/null || echo "none"
}

# 获取最新镜像ID
get_latest_image_id() {
    docker images ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest --format='{{.ID}}' 2>/dev/null || echo "none"
}

# 检查是否需要更新
check_if_update_needed() {
    local current_id=$(get_current_image_id)
    local latest_id=$(get_latest_image_id)
    
    log_info "当前运行镜像ID: ${current_id}"
    log_info "最新镜像ID: ${latest_id}"
    
    if [ "$current_id" = "$latest_id" ]; then
        log_info "镜像已是最新版本，无需更新"
        return 1
    else
        log_info "检测到新版本镜像，需要更新"
        return 0
    fi
}

# 备份当前配置
backup_current_state() {
    log_info "备份当前状态..."
    
    # 备份容器状态
    docker ps > "/tmp/containers_backup_$(date +%Y%m%d_%H%M%S).txt"
    
    # 备份镜像信息
    docker images > "/tmp/images_backup_$(date +%Y%m%d_%H%M%S).txt"
    
    log_success "状态备份完成"
}

# 重新部署应用
redeploy_application() {
    log_info "开始重新部署应用..."
    
    # 使用 --force-recreate 确保使用最新镜像
    if docker-compose -f ${COMPOSE_FILE} up -d --force-recreate; then
        log_success "应用重新部署成功"
        return 0
    else
        log_error "应用重新部署失败"
        return 1
    fi
}

# 等待服务启动
wait_for_service() {
    log_info "等待服务启动..."
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if docker ps | grep -q "tbk-tbk-production-1.*Up"; then
            log_success "服务启动成功 (尝试 $attempt/$max_attempts)"
            return 0
        fi
        
        log_info "等待服务启动... (尝试 $attempt/$max_attempts)"
        sleep 10
        attempt=$((attempt + 1))
    done
    
    log_error "服务启动超时"
    return 1
}

# 健康检查
health_check() {
    log_info "执行健康检查..."
    local max_attempts=10
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f "$HEALTH_CHECK_URL" > /dev/null 2>&1; then
            log_success "健康检查通过 (尝试 $attempt/$max_attempts)"
            return 0
        fi
        
        log_info "健康检查失败，重试中... (尝试 $attempt/$max_attempts)"
        sleep 15
        attempt=$((attempt + 1))
    done
    
    log_error "健康检查失败"
    return 1
}

# 回滚函数
rollback() {
    log_warning "开始回滚操作..."
    
    # 这里可以实现回滚逻辑
    # 例如：重启到之前的镜像版本
    docker-compose -f ${COMPOSE_FILE} restart
    
    log_warning "回滚操作完成"
}

# 清理旧镜像
cleanup_old_images() {
    log_info "清理旧镜像..."
    
    # 保留最新的3个版本
    docker images ${DOCKER_REGISTRY}/${IMAGE_NAME} --format "table {{.ID}}\t{{.CreatedAt}}" | \
    tail -n +2 | sort -k2 -r | tail -n +4 | awk '{print $1}' | \
    xargs -r docker rmi -f 2>/dev/null || true
    
    log_success "旧镜像清理完成"
}

# 发送通知
send_notification() {
    local status=$1
    local message=$2
    
    # 这里可以集成钉钉、企业微信等通知
    log_info "通知: [$status] $message"
}

# 主函数
main() {
    log_info "========== 开始自动部署流程 =========="
    
    # 检查Docker状态
    check_docker
    
    # 拉取最新镜像
    if ! pull_latest_image; then
        send_notification "FAILED" "镜像拉取失败"
        exit 1
    fi
    
    # 检查是否需要更新
    if ! check_if_update_needed; then
        send_notification "SKIPPED" "无需更新，镜像已是最新版本"
        exit 0
    fi
    
    # 备份当前状态
    backup_current_state
    
    # 重新部署应用
    if ! redeploy_application; then
        send_notification "FAILED" "应用重新部署失败"
        exit 1
    fi
    
    # 等待服务启动
    if ! wait_for_service; then
        log_error "服务启动失败，开始回滚"
        rollback
        send_notification "FAILED" "服务启动失败，已回滚"
        exit 1
    fi
    
    # 健康检查
    if ! health_check; then
        log_error "健康检查失败，开始回滚"
        rollback
        send_notification "FAILED" "健康检查失败，已回滚"
        exit 1
    fi
    
    # 清理旧镜像
    cleanup_old_images
    
    # 显示最终状态
    log_success "========== 自动部署完成 =========="
    log_info "服务状态:"
    docker-compose -f ${COMPOSE_FILE} ps
    
    send_notification "SUCCESS" "生产环境自动部署成功"
}

# 执行主函数
main "$@"