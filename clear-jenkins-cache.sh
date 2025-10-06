#!/bin/bash

# 清除Jenkins缓存脚本
# 解决Jenkins使用旧版Jenkinsfile的问题

set -e

echo "🧹 清除Jenkins缓存和工作空间..."

# 1. 停止Jenkins
echo "1. 停止Jenkins容器..."
docker stop jenkins

# 2. 清除Jenkins工作空间缓存
echo "2. 清除Jenkins工作空间缓存..."
if [ -d "jenkins_home/workspace" ]; then
    rm -rf jenkins_home/workspace/*
    echo "   ✅ 工作空间已清除"
fi

# 3. 清除构建历史（保留配置）
echo "3. 清除构建历史..."
if [ -d "jenkins_home/jobs/tbk-pipeline/builds" ]; then
    rm -rf jenkins_home/jobs/tbk-pipeline/builds/*
    echo "   ✅ 构建历史已清除"
fi

# 4. 重置构建编号
echo "4. 重置构建编号..."
echo "1" > jenkins_home/jobs/tbk-pipeline/nextBuildNumber

# 5. 清除Jenkins缓存文件
echo "5. 清除Jenkins缓存文件..."
find jenkins_home -name "*.cache" -delete 2>/dev/null || true
find jenkins_home -name "*.tmp" -delete 2>/dev/null || true

# 6. 重启Jenkins
echo "6. 重启Jenkins..."
docker start jenkins

# 等待启动
echo "7. 等待Jenkins启动..."
sleep 30

# 8. 验证状态
echo "8. 验证Jenkins状态..."
docker logs jenkins --tail 5

echo ""
echo "✅ Jenkins缓存已清除，现在应该使用最新的Jenkinsfile配置"
echo ""
echo "🔄 请现在触发一次新的构建来验证修复："
echo "1. 访问 http://localhost:8082"
echo "2. 进入 tbk-pipeline 项目"
echo "3. 点击 'Build Now'"
echo "4. 查看构建日志，确认网络清理命令包含过滤器"