#!/bin/bash

# Jenkinsfile 编辑和同步组合脚本
# 自动处理编辑后的同步流程，避免忘记

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

TEMPLATE_FILE="Jenkinsfile.aliyun.template"
EDITOR="${EDITOR:-vim}"  # 默认使用 vim，可以通过环境变量修改

echo -e "${BOLD}${BLUE}🔧 Jenkinsfile 编辑和同步工具${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 检查模板文件是否存在
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo -e "${RED}❌ 错误：找不到模板文件 $TEMPLATE_FILE${NC}"
    exit 1
fi

# 记录修改前的文件状态
BEFORE_HASH=$(md5sum "$TEMPLATE_FILE" 2>/dev/null | cut -d' ' -f1 || md5 "$TEMPLATE_FILE" 2>/dev/null | cut -d' ' -f4)

echo -e "${BLUE}📝 正在打开编辑器...${NC}"
echo -e "   编辑器: ${GREEN}$EDITOR${NC}"
echo -e "   文件: ${GREEN}$TEMPLATE_FILE${NC}"
echo ""

# 打开编辑器
$EDITOR "$TEMPLATE_FILE"

# 检查文件是否被修改
AFTER_HASH=$(md5sum "$TEMPLATE_FILE" 2>/dev/null | cut -d' ' -f1 || md5 "$TEMPLATE_FILE" 2>/dev/null | cut -d' ' -f4)

echo ""
if [[ "$BEFORE_HASH" == "$AFTER_HASH" ]]; then
    echo -e "${YELLOW}ℹ️  文件未发生变化，无需同步${NC}"
    exit 0
fi

echo -e "${GREEN}✅ 检测到文件已修改${NC}"
echo ""

# 显示修改内容
echo -e "${BLUE}📋 修改内容预览：${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
git diff --no-index /dev/null "$TEMPLATE_FILE" 2>/dev/null | tail -n +5 | head -20 || echo "无法显示差异"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 询问是否执行同步
echo -e "${BOLD}🔄 是否立即同步到所有项目？${NC}"
echo -e "   ${GREEN}y/Y${NC} - 立即同步"
echo -e "   ${RED}n/N${NC} - 稍后手动同步"
echo -e "   ${BLUE}d/D${NC} - 显示完整差异后决定"
echo ""
read -p "请选择 [y/n/d]: " choice

case $choice in
    [Dd]*)
        echo ""
        echo -e "${BLUE}📋 完整修改差异：${NC}"
        git diff "$TEMPLATE_FILE" || echo "显示完整文件内容："
        cat "$TEMPLATE_FILE"
        echo ""
        read -p "查看完毕，是否同步？[y/n]: " sync_choice
        if [[ $sync_choice =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}🚀 开始同步...${NC}"
            ./sync-jenkinsfiles.sh
        else
            echo -e "${YELLOW}⏸️  同步已跳过，请记得稍后手动执行：${NC}"
            echo -e "   ${GREEN}./sync-jenkinsfiles.sh${NC}"
        fi
        ;;
    [Yy]*)
        echo -e "${BLUE}🚀 开始同步...${NC}"
        ./sync-jenkinsfiles.sh
        ;;
    *)
        echo -e "${YELLOW}⏸️  同步已跳过，请记得稍后手动执行：${NC}"
        echo -e "   ${GREEN}./sync-jenkinsfiles.sh${NC}"
        echo ""
        echo -e "${BOLD}💡 提醒：${NC}你也可以运行 ${GREEN}./remind-sync.sh${NC} 来查看同步提醒"
        ;;
esac

echo ""
echo -e "${GREEN}✨ 操作完成！${NC}"