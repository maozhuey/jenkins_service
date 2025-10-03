#!/bin/bash

# 安全备份文件清理脚本
# 只删除环境配置和Docker配置备份文件

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 开始清理安全的备份文件...${NC}"
echo "========================================"

# 统计变量
deleted_files=0
total_size=0

# 函数：安全删除文件
safe_delete() {
    local file="$1"
    if [ -f "$file" ]; then
        local size=$(stat -f%z "$file" 2>/dev/null || echo 0)
        rm -f "$file"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ 已删除: $file ($(numfmt --to=iec $size))${NC}"
            ((deleted_files++))
            ((total_size+=size))
        else
            echo -e "${RED}❌ 删除失败: $file${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  文件不存在: $file${NC}"
    fi
}

echo -e "${YELLOW}📁 清理环境配置备份文件...${NC}"
echo "----------------------------------------"

# 删除所有 .env.local.backup.* 文件
for file in .env.local.backup.*; do
    if [ -f "$file" ]; then
        safe_delete "$file"
    fi
done

echo ""
echo -e "${YELLOW}🐳 清理Docker配置备份文件...${NC}"
echo "----------------------------------------"

# 删除Docker配置备份文件
safe_delete "docker-compose.public.yml.backup"
safe_delete "docker-compose.yml.rollback-backup.20251003_045132"

echo ""
echo "========================================"
echo -e "${BLUE}📊 清理完成统计${NC}"
echo "========================================"
echo -e "${GREEN}✅ 删除文件数量: $deleted_files${NC}"
echo -e "${GREEN}✅ 释放空间大小: $(numfmt --to=iec $total_size)${NC}"

if [ $deleted_files -gt 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 备份文件清理完成！项目更加整洁了！${NC}"
else
    echo ""
    echo -e "${YELLOW}ℹ️  没有找到需要清理的备份文件${NC}"
fi

echo ""
echo -e "${BLUE}💡 提示: Jenkins凭据备份文件已保留，如需删除请手动处理${NC}"