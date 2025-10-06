#!/bin/bash

# Jenkinsfile 同步提醒脚本
# 用于提醒用户在修改 Jenkinsfile.aliyun.template 后执行同步

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo ""
echo -e "${BOLD}${BLUE}🔔 Jenkinsfile 同步提醒${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}如果你刚刚修改了 ${GREEN}Jenkinsfile.aliyun.template${NC}${BOLD}，请记得执行同步：${NC}"
echo ""
echo -e "  ${BLUE}1.${NC} 检查修改内容："
echo -e "     ${GREEN}git diff Jenkinsfile.aliyun.template${NC}"
echo ""
echo -e "  ${BLUE}2.${NC} 执行同步到所有项目："
echo -e "     ${GREEN}./sync-jenkinsfiles.sh${NC}"
echo ""
echo -e "  ${BLUE}3.${NC} 验证同步结果："
echo -e "     ${GREEN}# 脚本会显示同步统计和日志${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}💡 提示：${NC}同步会自动备份现有文件并提交到 Git"
echo ""

# 检查是否有未同步的修改
TEMPLATE_FILE="Jenkinsfile.aliyun.template"
if [[ -f "$TEMPLATE_FILE" ]]; then
    # 检查模板文件的最后修改时间
    TEMPLATE_MTIME=$(stat -f %m "$TEMPLATE_FILE" 2>/dev/null || stat -c %Y "$TEMPLATE_FILE" 2>/dev/null)
    
    # 检查同步脚本的最后执行时间（通过日志文件）
    LOG_FILE="构建日志.md"
    if [[ -f "$LOG_FILE" ]]; then
        # 查找最后一次同步记录的时间
        LAST_SYNC=$(grep -o "修复时间.*[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}" "$LOG_FILE" | tail -1 | grep -o "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}")
        
        if [[ -n "$LAST_SYNC" ]]; then
            echo -e "${BLUE}📅 最后同步时间：${NC}$LAST_SYNC"
        fi
    fi
    
    echo -e "${BLUE}📝 模板文件状态：${NC}$(ls -la "$TEMPLATE_FILE" | awk '{print $6, $7, $8}')"
fi

echo ""
echo -e "${BOLD}${GREEN}按任意键继续...${NC}"
read -n 1 -s