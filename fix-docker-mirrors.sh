#!/bin/bash

# 修复Docker镜像仓库配置脚本
# 移除无效的镜像仓库地址

echo "🔧 修复Docker镜像仓库配置..."

# 备份当前配置
if [ -f ~/.docker/daemon.json ]; then
    echo "📋 备份当前Docker配置..."
    cp ~/.docker/daemon.json ~/.docker/daemon.json.backup.$(date +%Y%m%d_%H%M%S)
fi

# 创建新的Docker配置，移除无效的镜像仓库，使用稳定镜像源
echo "📝 创建新的Docker配置..."
cat > ~/.docker/daemon.json << 'EOF'
{
  "debug": false,
  "experimental": false,
  "insecure-registries": [],
  "registry-mirrors": [
    "https://registry-1.docker.io",
    "https://registry.cn-hangzhou.aliyuncs.com",
    "https://mirror.ccs.tencentyun.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
EOF

echo "✅ Docker配置已更新"
echo "📋 新的镜像仓库配置："
cat ~/.docker/daemon.json

echo ""
echo "🔄 重启Docker服务以应用新配置..."
echo "请手动执行以下操作重启Docker："
echo "  - Linux: sudo systemctl restart docker"
echo "  - macOS/Windows: 重启 Docker Desktop 应用"

echo ""
echo "⚠️  重启Docker后，请重启Jenkins容器："
echo "  docker restart jenkins"