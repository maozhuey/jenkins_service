#!/bin/bash

# 生产环境更新部署脚本
# 用于拉取最新的Docker镜像并重新部署应用

set -e

echo "🚀 开始生产环境更新部署..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
DOCKER_REGISTRY="registry.cn-hangzhou.aliyuncs.com"
IMAGE_NAME="hanchanglin/tbk"
COMPOSE_FILE="docker-compose.production.yml"

echo -e "${YELLOW}📋 部署配置:${NC}"
echo "  - Docker Registry: ${DOCKER_REGISTRY}"
echo "  - Image: ${IMAGE_NAME}:latest"
echo "  - Compose File: ${COMPOSE_FILE}"
echo ""

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker未运行，请先启动Docker${NC}"
    exit 1
fi

# 登录阿里云ACR (如果需要)
echo -e "${YELLOW}🔐 登录阿里云ACR...${NC}"
if ! docker login ${DOCKER_REGISTRY} -u aliyun7971892098 -p han0419/; then
    echo -e "${RED}❌ ACR登录失败${NC}"
    exit 1
fi

# 拉取最新镜像
echo -e "${YELLOW}📥 拉取最新镜像...${NC}"
if ! docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest; then
    echo -e "${RED}❌ 镜像拉取失败${NC}"
    exit 1
fi

# 停止现有服务
echo -e "${YELLOW}⏹️  停止现有服务...${NC}"
docker-compose -f ${COMPOSE_FILE} down || true

# 清理旧镜像 (保留最新的)
echo -e "${YELLOW}🧹 清理旧镜像...${NC}"
docker image prune -f || true

# 启动服务
echo -e "${YELLOW}🚀 启动更新后的服务...${NC}"
if ! docker-compose -f ${COMPOSE_FILE} up -d; then
    echo -e "${RED}❌ 服务启动失败${NC}"
    exit 1
fi

# 等待服务启动
echo -e "${YELLOW}⏳ 等待服务启动...${NC}"
sleep 30

# 健康检查
echo -e "${YELLOW}🏥 执行健康检查...${NC}"
if curl -f http://localhost:3003/api/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 健康检查通过${NC}"
else
    echo -e "${RED}❌ 健康检查失败${NC}"
    echo -e "${YELLOW}📋 查看服务状态:${NC}"
    docker-compose -f ${COMPOSE_FILE} ps
    echo -e "${YELLOW}📋 查看服务日志:${NC}"
    docker-compose -f ${COMPOSE_FILE} logs --tail=50 tbk-production
    exit 1
fi

# 显示服务状态
echo -e "${YELLOW}📋 服务状态:${NC}"
docker-compose -f ${COMPOSE_FILE} ps

echo ""
echo -e "${GREEN}🎉 生产环境更新部署完成！${NC}"
echo -e "${GREEN}🌐 应用访问地址: http://localhost:3003${NC}"
echo ""
echo -e "${YELLOW}💡 提示:${NC}"
echo "  - 查看日志: docker-compose -f ${COMPOSE_FILE} logs -f tbk-production"
echo "  - 停止服务: docker-compose -f ${COMPOSE_FILE} down"
echo "  - 重启服务: docker-compose -f ${COMPOSE_FILE} restart"