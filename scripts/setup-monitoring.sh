#!/bin/bash

# 配置漂移监控设置脚本
# 安装和配置定期监控任务

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CRON_CONFIG="$PROJECT_ROOT/config/crontab-config"

echo -e "${BLUE}=== 配置漂移监控设置 ===${NC}"

# 检查依赖
check_dependencies() {
    echo -e "${BLUE}1. 检查依赖项${NC}"
    
    # 检查jq
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}⚠️  jq 未安装，正在安装...${NC}"
        if command -v brew &> /dev/null; then
            brew install jq
        else
            echo -e "${RED}❌ 请先安装 Homebrew 或手动安装 jq${NC}"
            exit 1
        fi
    fi
    echo -e "${GREEN}✅ jq 已安装${NC}"
    
    # 检查配置文件
    if [[ ! -f "$SCRIPT_DIR/config-loader.sh" ]]; then
        echo -e "${RED}❌ 配置加载器不存在${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ 配置加载器存在${NC}"
    
    # 检查审计脚本
    if [[ ! -f "$SCRIPT_DIR/config-audit.sh" ]]; then
        echo -e "${RED}❌ 配置审计脚本不存在${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ 配置审计脚本存在${NC}"
}

# 创建必要的目录
create_directories() {
    echo -e "${BLUE}2. 创建必要目录${NC}"
    
    mkdir -p "$PROJECT_ROOT/logs"
    echo -e "${GREEN}✅ 日志目录已创建${NC}"
    
    mkdir -p "$PROJECT_ROOT/config"
    echo -e "${GREEN}✅ 配置目录已创建${NC}"
}

# 测试监控脚本
test_monitoring() {
    echo -e "${BLUE}3. 测试监控脚本${NC}"
    
    if "$SCRIPT_DIR/config-drift-monitor.sh" check; then
        echo -e "${GREEN}✅ 监控脚本测试通过${NC}"
    else
        echo -e "${RED}❌ 监控脚本测试失败${NC}"
        exit 1
    fi
}

# 安装cron任务
install_cron() {
    echo -e "${BLUE}4. 安装定时任务${NC}"
    
    if [[ ! -f "$CRON_CONFIG" ]]; then
        echo -e "${RED}❌ cron配置文件不存在: $CRON_CONFIG${NC}"
        exit 1
    fi
    
    # 备份现有的crontab
    local backup_file="$PROJECT_ROOT/logs/crontab-backup-$(date +%Y%m%d-%H%M%S)"
    if crontab -l > "$backup_file" 2>/dev/null; then
        echo -e "${GREEN}✅ 已备份现有crontab到: $backup_file${NC}"
    else
        echo -e "${YELLOW}⚠️  没有现有的crontab需要备份${NC}"
    fi
    
    # 询问用户是否要安装cron任务
    echo -e "${YELLOW}是否要安装配置漂移监控的定时任务？${NC}"
    echo "这将添加以下任务："
    echo "- 每小时检查一次配置漂移"
    echo "- 每天凌晨2点清理旧日志"
    echo "- 每周一上午9点发送状态报告"
    
    read -p "继续安装？(y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 获取现有的crontab
        local temp_cron=$(mktemp)
        crontab -l > "$temp_cron" 2>/dev/null || true
        
        # 添加新的任务（避免重复）
        if ! grep -q "config-drift-monitor.sh" "$temp_cron" 2>/dev/null; then
            echo "" >> "$temp_cron"
            echo "# 配置漂移监控任务 - 由setup-monitoring.sh添加" >> "$temp_cron"
            cat "$CRON_CONFIG" >> "$temp_cron"
            
            # 安装新的crontab
            crontab "$temp_cron"
            echo -e "${GREEN}✅ 定时任务已安装${NC}"
        else
            echo -e "${YELLOW}⚠️  定时任务已存在，跳过安装${NC}"
        fi
        
        rm -f "$temp_cron"
    else
        echo -e "${YELLOW}⚠️  跳过定时任务安装${NC}"
        echo "如需手动安装，请运行: crontab $CRON_CONFIG"
    fi
}

# 显示安装结果
show_summary() {
    echo -e "${BLUE}5. 安装总结${NC}"
    
    echo -e "${GREEN}✅ 配置漂移监控设置完成${NC}"
    echo ""
    echo "可用命令："
    echo "  $SCRIPT_DIR/config-drift-monitor.sh check    - 手动检查配置"
    echo "  $SCRIPT_DIR/config-drift-monitor.sh status   - 查看监控状态"
    echo "  $SCRIPT_DIR/config-drift-monitor.sh cleanup  - 清理旧日志"
    echo ""
    echo "日志文件："
    echo "  $PROJECT_ROOT/logs/config-drift.log         - 监控日志"
    echo "  $PROJECT_ROOT/logs/config-drift-report.json - 状态报告"
    echo "  $PROJECT_ROOT/logs/cron.log                 - 定时任务日志"
    echo ""
    echo "配置文件："
    echo "  $PROJECT_ROOT/config/network.conf           - 网络配置"
    echo "  $PROJECT_ROOT/config/crontab-config         - 定时任务配置"
    echo ""
    
    if crontab -l | grep -q "config-drift-monitor.sh" 2>/dev/null; then
        echo -e "${GREEN}✅ 定时任务已激活${NC}"
        echo "当前定时任务："
        crontab -l | grep "config-drift-monitor.sh" || true
    else
        echo -e "${YELLOW}⚠️  定时任务未安装${NC}"
        echo "如需安装，请运行: crontab $CRON_CONFIG"
    fi
}

# 主程序
main() {
    check_dependencies
    create_directories
    test_monitoring
    install_cron
    show_summary
}

# 如果直接运行此脚本
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi