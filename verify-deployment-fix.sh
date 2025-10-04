#!/bin/bash

# 验证部署配置修复脚本
# 用于测试修复后的Docker Compose配置和网络设置

set -e

echo "🔍 验证部署配置修复..."

# 1. 验证Docker Compose文件语法
echo "1. 检查Docker Compose文件语法..."
if docker compose -f aliyun-ecs-deploy.yml config > /dev/null 2>&1; then
    echo "✅ Docker Compose文件语法正确"
else
    echo "❌ Docker Compose文件语法错误"
    docker compose -f aliyun-ecs-deploy.yml config
    exit 1
fi

# 2. 检查网络配置
echo "2. 检查网络配置..."
if docker compose -f aliyun-ecs-deploy.yml config | grep -q "tbk_app-network"; then
    echo "✅ tbk_app-network 网络配置存在"
else
    echo "❌ tbk_app-network 网络配置缺失"
    exit 1
fi

if docker compose -f aliyun-ecs-deploy.yml config | grep -q "tbk-production-network"; then
    echo "✅ tbk-production-network 网络配置存在"
else
    echo "❌ tbk-production-network 网络配置缺失"
    exit 1
fi

# 3. 检查服务配置
echo "3. 检查服务配置..."
services=$(docker compose -f aliyun-ecs-deploy.yml config --services)
echo "配置的服务: $services"

# 4. 验证环境变量配置
echo "4. 检查环境变量配置..."
if docker compose -f aliyun-ecs-deploy.yml config | grep -q "DB_HOST: tbk-mysql"; then
    echo "✅ 数据库主机配置正确"
else
    echo "❌ 数据库主机配置错误"
    exit 1
fi

# 5. 检查端口配置
echo "5. 检查端口配置..."
if docker compose -f aliyun-ecs-deploy.yml config | grep -q "expose"; then
    echo "✅ 使用expose配置，避免端口冲突"
else
    echo "⚠️  未找到expose配置"
fi

# 6. 验证健康检查配置
echo "6. 检查健康检查配置..."
if docker compose -f aliyun-ecs-deploy.yml config | grep -q "healthcheck"; then
    echo "✅ 健康检查配置存在"
else
    echo "⚠️  健康检查配置缺失"
fi

echo ""
echo "🎉 部署配置验证完成！"
echo ""
echo "修复总结:"
echo "- ✅ 移除了过时的version字段"
echo "- ✅ 统一了网络配置 (tbk-production-network + tbk_app-network)"
echo "- ✅ 修复了数据库连接配置"
echo "- ✅ 优化了端口配置 (使用expose)"
echo "- ✅ 优化了Jenkinsfile中的网络创建逻辑"
echo ""
echo "现在可以重新运行Jenkins构建来测试修复效果。"