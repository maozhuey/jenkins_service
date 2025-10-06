#!/bin/bash

# 配置审计脚本 - 检查网络配置一致性
# 用于防止配置漂移和重复修复问题

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
EXPECTED_SUBNET="$SUBNET"
# 自动检测项目根目录：优先使用脚本所在目录的父目录，其次使用部署路径环境变量，最后回退到/opt/apps/tbk
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
if [[ -d "$PROJECT_ROOT" ]]; then
    BASE_DIR="$PROJECT_ROOT"
else
    BASE_DIR="${ECS_DEPLOY_PATH:-/opt/apps/tbk}"
fi

echo -e "${BLUE}=== 网络配置审计开始 ===${NC}"
echo "期望子网: ${EXPECTED_SUBNET}"
echo "网络名称: ${NETWORK_NAME}"
echo "检查目录: ${BASE_DIR}"
echo ""

# 检查函数
check_file_config() {
    local file="$1"
    local description="$2"
    
    if [[ ! -f "$file" ]]; then
        echo -e "${YELLOW}⚠️  文件不存在: $file（远端环境可能未包含该文件，跳过）${NC}"
        # 在远端环境缺失非关键文件时不计为错误
        return 0
    fi
    
    echo -e "${BLUE}检查: $description${NC}"
    echo "文件: $file"
    
    # 查找所有子网配置
    local subnets=$(grep -n "172\.[0-9]\+\.[0-9]\+\.[0-9]\+/[0-9]\+" "$file" 2>/dev/null || true)
    
    if [[ -z "$subnets" ]]; then
        echo -e "${GREEN}✅ 未找到子网配置${NC}"
        return 0
    fi
    
    local has_error=false
    while IFS= read -r line; do
        if [[ "$line" =~ 172\.([0-9]+)\.([0-9]+)\.([0-9]+)/([0-9]+) ]]; then
            local found_subnet="${BASH_REMATCH[0]}"
            local line_num=$(echo "$line" | cut -d: -f1)
            
            if [[ "$found_subnet" == "$EXPECTED_SUBNET" ]]; then
                echo -e "${GREEN}✅ 行 $line_num: $found_subnet (正确)${NC}"
            else
                echo -e "${RED}❌ 行 $line_num: $found_subnet (应为 $EXPECTED_SUBNET)${NC}"
                echo "   内容: $(echo "$line" | cut -d: -f2-)"
                has_error=true
            fi
        fi
    done <<< "$subnets"
    
    if [[ "$has_error" == "true" ]]; then
        return 1
    else
        return 0
    fi
}

# 检查文件列表
declare -a files_to_check=(
    "$BASE_DIR/Jenkinsfile.aliyun.template:Jenkins模板文件"
    "$BASE_DIR/ensure_network.sh:网络创建脚本"
    "$BASE_DIR/rebuild-network.sh:网络重建脚本"
    "$BASE_DIR/emergency-production-fix.sh:紧急修复脚本"
    "$BASE_DIR/fix-deployment-sync.sh:部署同步脚本"
)

# 检查tbk项目的Jenkinsfile
TBK_JENKINSFILE="/Users/hanchanglin/AI编程代码库/product/tbk/Jenkinsfile.aliyun"
if [[ -f "$TBK_JENKINSFILE" ]]; then
    files_to_check+=("$TBK_JENKINSFILE:TBK项目Jenkins文件")
fi

# 执行检查
total_files=0
error_files=0

for file_info in "${files_to_check[@]}"; do
    IFS=':' read -r file_path description <<< "$file_info"
    total_files=$((total_files + 1))
    
    if ! check_file_config "$file_path" "$description"; then
        error_files=$((error_files + 1))
    fi
    echo ""
done

# 检查Docker网络状态（如果可能）
echo -e "${BLUE}=== Docker网络状态检查 ===${NC}"
if command -v docker &> /dev/null; then
    if docker network ls | grep -q "$NETWORK_NAME"; then
        # 使用docker自带的--format避免依赖jq
        network_info=$(docker network inspect "$NETWORK_NAME" --format '{{ (index .IPAM.Config 0).Subnet }}' 2>/dev/null || echo "未知")
        if [[ "$network_info" == "$EXPECTED_SUBNET" ]]; then
            echo -e "${GREEN}✅ Docker网络 $NETWORK_NAME 子网正确: $network_info${NC}"
        else
            echo -e "${RED}❌ Docker网络 $NETWORK_NAME 子网错误: $network_info (应为 $EXPECTED_SUBNET)${NC}"
            error_files=$((error_files + 1))
        fi
    else
        echo -e "${YELLOW}⚠️  Docker网络 $NETWORK_NAME 不存在${NC}"
        # 不将缺失网络计为文件配置错误，由ensure_network负责创建
    fi
else
    echo -e "${YELLOW}⚠️  Docker命令不可用，跳过网络检查${NC}"
fi

# 生成报告
echo ""
echo -e "${BLUE}=== 审计报告 ===${NC}"
echo "检查文件总数: $total_files"
echo "配置错误文件: $error_files"

if [[ $error_files -eq 0 ]]; then
    echo -e "${GREEN}🎉 所有配置检查通过！${NC}"
    exit 0
else
    echo -e "${RED}💥 发现 $error_files 个配置错误，需要修复${NC}"
    echo ""
    echo -e "${YELLOW}建议修复措施:${NC}"
    echo "1. 将所有错误的子网配置改为: $EXPECTED_SUBNET"
    echo "2. 运行 sync-jenkinsfiles.sh 同步配置"
    echo "3. 重新运行此审计脚本验证修复结果"
    exit 1
fi