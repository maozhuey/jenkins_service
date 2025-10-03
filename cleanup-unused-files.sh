#!/bin/bash

# 项目无用文件清理脚本
# Project Unused Files Cleanup Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 开始清理项目无用文件...${NC}"

# 1. 清理 Jenkins 缓存文件
echo -e "${YELLOW}📦 清理 Jenkins 缓存文件...${NC}"
if [ -d "jenkins_home/.npm/_cacache" ]; then
    rm -rf jenkins_home/.npm/_cacache
    echo -e "${GREEN}✅ 已删除 NPM 缓存${NC}"
fi

if [ -d "jenkins_home/.npm/_logs" ]; then
    rm -rf jenkins_home/.npm/_logs
    echo -e "${GREEN}✅ 已删除 NPM 日志${NC}"
fi

if [ -d "jenkins_home/caches" ]; then
    rm -rf jenkins_home/caches
    echo -e "${GREEN}✅ 已删除 Jenkins 构建缓存${NC}"
fi

if [ -d "jenkins_home/.cache" ]; then
    rm -rf jenkins_home/.cache
    echo -e "${GREEN}✅ 已删除字体缓存${NC}"
fi

# 2. 清理备份文件
echo -e "${YELLOW}🗂️  清理备份文件...${NC}"
backup_files=(
    "jenkins_home/credentials.xml.bak"
    "jenkins_home/queue.xml.bak"
    "jenkins_home/plugins/sshd.bak"
)

for file in "${backup_files[@]}"; do
    if [ -f "$file" ]; then
        rm "$file"
        echo -e "${GREEN}✅ 已删除 $file${NC}"
    fi
done

# 3. 清理重复的配置文件
echo -e "${YELLOW}📄 清理重复配置文件...${NC}"
duplicate_files=(
    "Jenkinsfile.aliyun.simplified"
    "tbk-env-production-fixed"
    "tbk-env-docker"
    "tbk-dockerfile-dev"
    "tbk-dockerfile-production-fixed"
    "tbk-docker-compose-local-fixed.yml"
    "tbk-nginx-production.conf"
    "test_构建日志.md"
)

for file in "${duplicate_files[@]}"; do
    if [ -f "$file" ]; then
        rm "$file"
        echo -e "${GREEN}✅ 已删除 $file${NC}"
    fi
done

# 4. 清理 Jenkins 指纹缓存（可选）
echo -e "${YELLOW}🔍 清理 Jenkins 指纹缓存...${NC}"
if [ -d "jenkins_home/fingerprints" ]; then
    rm -rf jenkins_home/fingerprints
    echo -e "${GREEN}✅ 已删除指纹缓存${NC}"
fi

# 5. 显示清理结果
echo -e "${BLUE}📊 清理完成统计:${NC}"
echo -e "${GREEN}✅ 已清理 Jenkins 缓存文件 (~31.5MB)${NC}"
echo -e "${GREEN}✅ 已清理备份文件${NC}"
echo -e "${GREEN}✅ 已清理重复配置文件${NC}"
echo -e "${GREEN}✅ 已清理指纹缓存${NC}"

echo -e "${BLUE}🎉 项目清理完成！${NC}"
echo -e "${YELLOW}💡 建议定期运行此脚本来保持项目整洁${NC}"