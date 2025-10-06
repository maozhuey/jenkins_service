#!/bin/bash

# 紧急生产环境修复脚本
# 解决 Jenkins 部署中的网络配置和版本警告问题

set -e

echo "=== 紧急生产环境修复脚本 ==="
echo "时间: $(date)"
echo "目标: 修复 tbk_app-network not found 和 version 警告问题"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. 检查当前环境状态
echo ""
echo "=== 1. 环境状态检查 ==="
log_info "检查 Docker 状态..."
if ! docker info >/dev/null 2>&1; then
    log_error "Docker 未运行，请先启动 Docker"
    exit 1
fi

log_info "检查当前网络状态..."
docker network ls | grep -E "(tbk|NETWORK)"

log_info "检查当前容器状态..."
docker ps -a | grep -E "(tbk|nginx)" || echo "没有找到相关容器"

# 2. 强制清理和重建网络
echo ""
echo "=== 2. 网络修复 ==="
log_info "停止所有相关容器..."
docker stop tbk-production nginx-production 2>/dev/null || true
docker rm tbk-production nginx-production 2>/dev/null || true

log_info "清理网络（保留外部网络）..."
# 只清理未使用的网络，但保留外部网络
docker network prune -f --filter "label!=external" || true

log_info "创建必需的网络..."
# 创建外部网络（如果不存在）
docker network create tbk_app-network --subnet=172.22.0.0/16 --label external=true 2>/dev/null || {
    log_warn "tbk_app-network 已存在，跳过创建"
}

# 创建生产网络（如果不存在）
docker network create tbk-production-network --subnet=172.23.0.0/16 2>/dev/null || {
    log_warn "tbk-production-network 已存在，跳过创建"
}

log_info "验证网络创建结果..."
docker network ls | grep -E "(tbk|NETWORK)"

# 3. 修复配置文件
echo ""
echo "=== 3. 配置文件修复 ==="

# 检查并修复 aliyun-ecs-deploy.yml
if [ -f "aliyun-ecs-deploy.yml" ]; then
    log_info "检查 aliyun-ecs-deploy.yml 配置..."
    
    # 检查是否包含 version 字段
    if grep -q "^version:" aliyun-ecs-deploy.yml; then
        log_warn "发现 version 字段，正在移除..."
        # 创建备份
        cp aliyun-ecs-deploy.yml aliyun-ecs-deploy.yml.backup.$(date +%Y%m%d_%H%M%S)
        # 移除 version 行
        sed -i.tmp '/^version:/d' aliyun-ecs-deploy.yml
        rm -f aliyun-ecs-deploy.yml.tmp
        log_info "已移除 version 字段"
    else
        log_info "aliyun-ecs-deploy.yml 配置正确，无需修改"
    fi
    
    # 验证网络配置
    if grep -q "tbk_app-network" aliyun-ecs-deploy.yml; then
        log_info "✅ 外部网络配置正确"
    else
        log_error "❌ 配置文件中缺少 tbk_app-network 网络配置"
    fi
else
    log_error "aliyun-ecs-deploy.yml 文件不存在"
    exit 1
fi

# 4. 测试部署
echo ""
echo "=== 4. 测试部署 ==="
log_info "尝试启动服务..."

# 设置环境变量
ENV_ARG=""
if [ -f ".env.production" ]; then
    ENV_ARG="--env-file .env.production"
fi

# 拉取最新镜像
log_info "拉取最新镜像..."
docker compose $ENV_ARG -f aliyun-ecs-deploy.yml pull tbk-production

# 启动服务
log_info "启动服务..."
docker compose $ENV_ARG -f aliyun-ecs-deploy.yml up -d tbk-production nginx-production

# 5. 健康检查
echo ""
echo "=== 5. 健康检查 ==="
log_info "等待服务启动..."
sleep 10

log_info "检查容器状态..."
docker ps | grep -E "(tbk|nginx)" || {
    log_error "容器启动失败"
    docker logs tbk-production --tail 20 2>/dev/null || true
    docker logs nginx-production --tail 20 2>/dev/null || true
    exit 1
}

log_info "检查网络连接..."
docker network inspect tbk_app-network --format '{{range .Containers}}{{.Name}} {{end}}' || true
docker network inspect tbk-production-network --format '{{range .Containers}}{{.Name}} {{end}}' || true

# 6. 验证修复结果
echo ""
echo "=== 6. 修复结果验证 ==="
log_info "验证服务健康状态..."

# HTTP 健康检查
if curl -f http://localhost:8080/health >/dev/null 2>&1; then
    log_info "✅ HTTP 健康检查通过"
else
    log_warn "⚠️  HTTP 健康检查失败，但容器可能仍在启动中"
fi

# 最终状态报告
echo ""
echo "=== 修复完成报告 ==="
echo "✅ 网络状态:"
docker network ls | grep tbk

echo ""
echo "✅ 容器状态:"
docker ps | grep -E "(tbk|nginx)"

echo ""
echo "✅ 配置文件状态:"
if grep -q "^version:" aliyun-ecs-deploy.yml; then
    echo "❌ aliyun-ecs-deploy.yml 仍包含 version 字段"
else
    echo "✅ aliyun-ecs-deploy.yml 已移除 version 字段"
fi

echo ""
log_info "=== 紧急修复完成 ==="
log_info "如果问题仍然存在，请检查 Jenkins 流水线配置是否指向正确的分支"
log_info "建议在 Jenkins 中重新触发构建以验证修复效果"