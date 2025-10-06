#!/bin/bash

# 强制Jenkins重新加载配置脚本
# 解决Jenkins配置同步问题

set -e

echo "🔄 强制Jenkins重新加载配置..."

# 1. 重启Jenkins容器以确保使用最新配置
echo "1. 重启Jenkins容器..."
docker restart jenkins

# 等待Jenkins启动
echo "2. 等待Jenkins启动..."
sleep 30

# 3. 检查Jenkins状态
echo "3. 检查Jenkins状态..."
docker logs jenkins --tail 10

# 4. 验证Jenkinsfile是否包含正确的网络过滤器
echo "4. 验证当前Jenkinsfile配置..."
echo "当前Jenkinsfile中的网络清理命令："
grep -n "docker network prune" Jenkinsfile.aliyun || echo "未找到网络清理命令"

# 5. 提示手动操作
echo ""
echo "✅ Jenkins已重启，请执行以下操作："
echo "1. 访问 http://localhost:8082"
echo "2. 进入 tbk-pipeline 项目"
echo "3. 点击 'Build Now' 触发新构建"
echo "4. 观察构建日志中的网络清理命令是否包含过滤器"
echo ""
echo "🔍 预期看到的正确命令："
echo "   docker network prune -f --filter \"label!=external\" || true"
echo ""
echo "❌ 如果仍看到错误命令："
echo "   docker network prune -f || true"
echo "   则说明Jenkins缓存问题，需要清除Jenkins工作空间"