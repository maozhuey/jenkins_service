#!/bin/bash

# 自动部署设置脚本
# 用于配置和启用自动部署功能

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
WEBHOOK_SCRIPT="scripts/auto-deploy-webhook.sh"
NEW_JENKINSFILE="Jenkinsfile.aliyun.auto-deploy"
CURRENT_JENKINSFILE="Jenkinsfile.aliyun"
LOG_DIR="/var/log"
CRON_JOB_FILE="/tmp/auto-deploy-cron"

echo -e "${BLUE}🚀 自动部署功能设置向导${NC}"
echo "=================================="

# 检查必要文件
check_files() {
    echo -e "${YELLOW}📋 检查必要文件...${NC}"
    
    if [ ! -f "$WEBHOOK_SCRIPT" ]; then
        echo -e "${RED}❌ 自动部署脚本不存在: $WEBHOOK_SCRIPT${NC}"
        exit 1
    fi
    
    if [ ! -f "$NEW_JENKINSFILE" ]; then
        echo -e "${RED}❌ 新的Jenkinsfile不存在: $NEW_JENKINSFILE${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ 必要文件检查通过${NC}"
}

# 设置脚本权限
setup_permissions() {
    echo -e "${YELLOW}🔐 设置脚本权限...${NC}"
    
    chmod +x "$WEBHOOK_SCRIPT"
    echo -e "${GREEN}✅ 脚本权限设置完成${NC}"
}

# 创建日志目录
setup_logging() {
    echo -e "${YELLOW}📝 设置日志目录...${NC}"
    
    if [ ! -d "$LOG_DIR" ]; then
        sudo mkdir -p "$LOG_DIR" 2>/dev/null || mkdir -p "./logs"
        LOG_DIR="./logs"
    fi
    
    # 确保日志文件可写
    touch "${LOG_DIR}/auto-deploy.log" 2>/dev/null || touch "./logs/auto-deploy.log"
    
    echo -e "${GREEN}✅ 日志目录设置完成: $LOG_DIR${NC}"
}

# 备份当前Jenkinsfile
backup_jenkinsfile() {
    echo -e "${YELLOW}💾 备份当前Jenkinsfile...${NC}"
    
    if [ -f "$CURRENT_JENKINSFILE" ]; then
        cp "$CURRENT_JENKINSFILE" "${CURRENT_JENKINSFILE}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}✅ Jenkinsfile备份完成${NC}"
    else
        echo -e "${YELLOW}⚠️  当前Jenkinsfile不存在，跳过备份${NC}"
    fi
}

# 询问用户是否要替换Jenkinsfile
ask_replace_jenkinsfile() {
    echo ""
    echo -e "${YELLOW}❓ 是否要替换当前的Jenkinsfile以启用自动部署？${NC}"
    echo "   当前: $CURRENT_JENKINSFILE"
    echo "   新的: $NEW_JENKINSFILE"
    echo ""
    read -p "请输入 y/n: " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$NEW_JENKINSFILE" "$CURRENT_JENKINSFILE"
        echo -e "${GREEN}✅ Jenkinsfile已更新为自动部署版本${NC}"
        return 0
    else
        echo -e "${YELLOW}⏭️  跳过Jenkinsfile替换${NC}"
        return 1
    fi
}

# 设置定时检查（可选）
setup_cron_job() {
    echo ""
    echo -e "${YELLOW}❓ 是否要设置定时检查新镜像？${NC}"
    echo "   这将每5分钟检查一次是否有新镜像需要部署"
    echo ""
    read -p "请输入 y/n: " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 创建cron任务
        echo "*/5 * * * * cd $(pwd) && ./scripts/auto-deploy-webhook.sh >> ${LOG_DIR}/auto-deploy-cron.log 2>&1" > "$CRON_JOB_FILE"
        
        # 安装cron任务
        if command -v crontab > /dev/null; then
            crontab "$CRON_JOB_FILE"
            rm "$CRON_JOB_FILE"
            echo -e "${GREEN}✅ 定时检查任务已设置（每5分钟）${NC}"
        else
            echo -e "${YELLOW}⚠️  crontab命令不可用，请手动设置定时任务${NC}"
            echo "   任务内容: */5 * * * * cd $(pwd) && ./scripts/auto-deploy-webhook.sh"
        fi
    else
        echo -e "${YELLOW}⏭️  跳过定时检查设置${NC}"
    fi
}

# 测试自动部署脚本
test_auto_deploy() {
    echo ""
    echo -e "${YELLOW}❓ 是否要测试自动部署脚本？${NC}"
    echo "   这将执行一次完整的部署流程"
    echo ""
    read -p "请输入 y/n: " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}🧪 开始测试自动部署...${NC}"
        
        if ./"$WEBHOOK_SCRIPT"; then
            echo -e "${GREEN}✅ 自动部署测试成功${NC}"
        else
            echo -e "${RED}❌ 自动部署测试失败${NC}"
            echo -e "${YELLOW}💡 请检查日志文件: ${LOG_DIR}/auto-deploy.log${NC}"
        fi
    else
        echo -e "${YELLOW}⏭️  跳过自动部署测试${NC}"
    fi
}

# 显示配置信息
show_configuration() {
    echo ""
    echo -e "${BLUE}📋 自动部署配置信息${NC}"
    echo "=================================="
    echo "自动部署脚本: $WEBHOOK_SCRIPT"
    echo "Jenkins文件: $CURRENT_JENKINSFILE"
    echo "日志目录: $LOG_DIR"
    echo "健康检查URL: http://localhost:3003/api/health"
    echo ""
    echo -e "${GREEN}🎯 使用方法:${NC}"
    echo "1. 手动触发: ./$WEBHOOK_SCRIPT"
    echo "2. Jenkins自动触发: 在Jenkins中启用'CONFIRM_PRODUCTION_DEPLOY'参数"
    echo "3. 查看日志: tail -f ${LOG_DIR}/auto-deploy.log"
    echo ""
}

# 显示后续步骤
show_next_steps() {
    echo -e "${BLUE}📝 后续步骤${NC}"
    echo "=================================="
    echo "1. 在Jenkins中配置阿里云ACR凭据"
    echo "   - 凭据ID: aliyun-acr-credentials"
    echo "   - 用户名: aliyun7971892098"
    echo "   - 密码: han0419/"
    echo ""
    echo "2. 确保生产环境服务器可访问"
    echo "   - 检查Docker服务状态"
    echo "   - 检查网络连接"
    echo ""
    echo "3. 测试完整的CI/CD流程"
    echo "   - 提交代码到main分支"
    echo "   - 在Jenkins中启用生产部署"
    echo "   - 观察自动部署过程"
    echo ""
    echo -e "${YELLOW}⚠️  注意事项:${NC}"
    echo "- 首次使用前请在测试环境验证"
    echo "- 确保有回滚计划"
    echo "- 监控部署过程和应用状态"
    echo ""
}

# 主函数
main() {
    echo -e "${GREEN}开始设置自动部署功能...${NC}"
    echo ""
    
    # 检查文件
    check_files
    
    # 设置权限
    setup_permissions
    
    # 设置日志
    setup_logging
    
    # 备份Jenkinsfile
    backup_jenkinsfile
    
    # 询问是否替换Jenkinsfile
    jenkinsfile_replaced=false
    if ask_replace_jenkinsfile; then
        jenkinsfile_replaced=true
    fi
    
    # 设置定时检查
    setup_cron_job
    
    # 测试自动部署
    test_auto_deploy
    
    # 显示配置信息
    show_configuration
    
    # 显示后续步骤
    show_next_steps
    
    echo -e "${GREEN}🎉 自动部署功能设置完成！${NC}"
    
    if [ "$jenkinsfile_replaced" = true ]; then
        echo -e "${YELLOW}💡 请重新加载Jenkins配置以使用新的Jenkinsfile${NC}"
    fi
}

# 执行主函数
main "$@"