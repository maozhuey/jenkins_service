#!/bin/bash

# 修复Docker镜像仓库配置脚本
# 移除无效的镜像仓库地址

echo "🔧 修复Docker镜像仓库配置..."

# 备份当前配置
if [ -f ~/.docker/daemon.json ]; then
    echo "📋 备份当前Docker配置..."
    cp ~/.docker/daemon.json ~/.docker/daemon.json.backup.$(date +%Y%m%d_%H%M%S)
fi

# 创建新的Docker配置，移除无效的镜像仓库
echo "📝 创建新的Docker配置..."
cat > ~/.docker/daemon.json << 'EOF'
{
  "debug": false,
  "experimental": false,
  "insecure-registries": [],
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
EOF

echo "✅ Docker配置已更新"
echo "📋 新的镜像仓库配置："
cat ~/.docker/daemon.json

echo ""
echo "🔄 重启Docker服务以应用新配置..."
echo "请手动执行以下命令重启Docker："
echo "  sudo systemctl restart docker  # Linux"
echo "  或重启Docker Desktop应用      # macOS/Windows"

echo ""
echo "⚠️  重启Docker后，请重启Jenkins容器："
echo "  docker restart jenkins"