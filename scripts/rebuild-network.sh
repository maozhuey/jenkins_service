#!/bin/bash

# 网络重建脚本 - 安全地重新创建正确的网络配置
# 解决Docker网络配置与文件配置不一致的问题

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 加载中心化配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config-loader.sh"

# 加载网络配置
if ! load_network_config; then
    echo -e "${RED}❌ 无法加载网络配置${NC}"
    exit 1
fi

# 使用中心化配置
CORRECT_SUBNET="$SUBNET"

echo -e "${BLUE}=== 网络重建开始 ===${NC}"
echo "目标网络: $NETWORK_NAME"
echo "正确子网: $CORRECT_SUBNET"
echo ""

# 检查当前网络状态
echo -e "${BLUE}1. 检查当前网络状态${NC}"
if docker network ls | grep -q "$NETWORK_NAME"; then
    # 使用 docker inspect --format 提取子网，避免依赖 jq
    current_subnet=$(docker network inspect "$NETWORK_NAME" --format '{{range .IPAM.Config}}{{.Subnet}}{{end}}' 2>/dev/null || echo "未知")
    echo "当前网络子网: $current_subnet"
    
    if [[ "$current_subnet" == "$CORRECT_SUBNET" ]]; then
        echo -e "${GREEN}✅ 网络配置已正确，无需重建${NC}"
        exit 0
    fi
    
    echo -e "${YELLOW}⚠️  网络子网不正确，需要重建${NC}"
    
    # 检查连接的容器
    echo -e "${BLUE}2. 检查连接的容器${NC}"
    # 提取连接的容器ID列表（以空格分隔）。当没有容器时输出为空字符串
    connected_containers=$(docker network inspect "$NETWORK_NAME" --format '{{range $id, $v := .Containers}}{{$id}} {{end}}' 2>/dev/null || echo "")
    
    if [[ -n "$connected_containers" ]]; then
        echo "发现连接的容器:"
        for container_id in $connected_containers; do
            container_name=$(docker inspect --format '{{.Name}}' "$container_id" | sed 's/^\///')
            echo "  - $container_name ($container_id)"
        done
        
        # 断开所有容器连接
        echo -e "${BLUE}3. 断开容器连接${NC}"
        for container_id in $connected_containers; do
            container_name=$(docker inspect --format '{{.Name}}' "$container_id" | sed 's/^\///')
            echo "断开容器: $container_name"
            docker network disconnect "$NETWORK_NAME" "$container_id" || {
                echo -e "${YELLOW}⚠️  容器 $container_name 断开失败，可能已断开${NC}"
            }
        done
    else
        echo "没有发现连接的容器"
    fi
    
    # 删除旧网络
    echo -e "${BLUE}4. 删除旧网络${NC}"
    docker network rm "$NETWORK_NAME" || {
        echo -e "${RED}❌ 删除网络失败${NC}"
        exit 1
    }
    echo -e "${GREEN}✅ 旧网络已删除${NC}"
else
    echo "网络不存在，将直接创建"
fi

# 创建新网络
echo -e "${BLUE}5. 创建新网络${NC}"
docker network create "$NETWORK_NAME" --subnet="$CORRECT_SUBNET" --label external=true || {
    echo -e "${RED}❌ 创建网络失败${NC}"
    exit 1
}
echo -e "${GREEN}✅ 新网络已创建${NC}"

# 重新连接容器（如果需要）
if [[ -n "$connected_containers" ]]; then
    echo -e "${BLUE}6. 重新连接容器${NC}"
    for container_id in $connected_containers; do
        container_name=$(docker inspect --format '{{.Name}}' "$container_id" | sed 's/^\///')
        if docker ps -q --filter "id=$container_id" | grep -q .; then
            echo "重新连接容器: $container_name"
            docker network connect "$NETWORK_NAME" "$container_id" || {
                echo -e "${YELLOW}⚠️  容器 $container_name 重连失败${NC}"
            }
        else
            echo "容器 $container_name 未运行，跳过重连"
        fi
    done
fi

# 验证结果
echo -e "${BLUE}7. 验证结果${NC}"
new_subnet=$(docker network inspect "$NETWORK_NAME" --format '{{range .IPAM.Config}}{{.Subnet}}{{end}}' 2>/dev/null || echo "")
if [[ "$new_subnet" == "$CORRECT_SUBNET" ]]; then
    echo -e "${GREEN}🎉 网络重建成功！${NC}"
    echo "网络名称: $NETWORK_NAME"
    echo "子网配置: $new_subnet"
    echo "标签: external=true"
else
    echo -e "${RED}❌ 网络重建失败，子网不正确: $new_subnet${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=== 网络重建完成 ===${NC}"