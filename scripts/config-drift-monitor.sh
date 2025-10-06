#!/bin/bash

# 配置漂移监控脚本
# 定期检查配置一致性，发现问题时发送通知和记录日志

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

# 配置
LOG_FILE="$SCRIPT_DIR/../logs/config-drift.log"
REPORT_FILE="$SCRIPT_DIR/../logs/config-drift-report.json"
ALERT_THRESHOLD=1  # 连续失败次数阈值

# 确保日志目录存在
mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$(dirname "$REPORT_FILE")"

# 记录日志函数
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    echo -e "${BLUE}[$timestamp]${NC} $message"
}

# 发送通知函数（可扩展为邮件、钉钉等）
send_notification() {
    local title="$1"
    local message="$2"
    local severity="$3"
    
    log_message "ALERT" "$title: $message"
    
    # 这里可以添加实际的通知逻辑
    # 例如：发送邮件、钉钉消息、Slack等
    echo -e "${RED}🚨 配置漂移警报${NC}"
    echo -e "${YELLOW}标题: $title${NC}"
    echo -e "${YELLOW}消息: $message${NC}"
    echo -e "${YELLOW}严重程度: $severity${NC}"
}

# 生成检查报告
generate_report() {
    local status="$1"
    local details="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local check_count=$(get_check_count)
    local last_success=$(get_last_success)
    local consecutive_failures=$(get_consecutive_failures)
    
    # 确保数值有默认值
    check_count=${check_count:-0}
    consecutive_failures=${consecutive_failures:-0}
    
    # 如果是成功状态，更新最后成功时间
    if [[ "$status" == "success" ]]; then
        last_success="$timestamp"
        consecutive_failures=0
    fi
    
    cat > "$REPORT_FILE" << EOF
{
    "timestamp": "$timestamp",
    "status": "$status",
    "network_name": "$NETWORK_NAME",
    "expected_subnet": "$SUBNET",
    "config_version": "$CONFIG_VERSION",
    "details": $details,
    "check_count": $((check_count + 1)),
    "last_success": "$last_success",
    "consecutive_failures": $consecutive_failures
}
EOF
}

# 获取检查次数
get_check_count() {
    if [[ -f "$REPORT_FILE" ]]; then
        jq -r '.check_count // 0' "$REPORT_FILE" 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

# 获取最后成功时间
get_last_success() {
    if [[ -f "$REPORT_FILE" ]]; then
        jq -r '.last_success // "从未成功"' "$REPORT_FILE" 2>/dev/null || echo "从未成功"
    else
        echo "从未成功"
    fi
}

# 获取连续失败次数
get_consecutive_failures() {
    if [[ -f "$REPORT_FILE" ]]; then
        jq -r '.consecutive_failures // 0' "$REPORT_FILE" 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

# 更新连续失败计数
update_failure_count() {
    local current_failures=$(get_consecutive_failures)
    echo $((current_failures + 1))
}

# 重置失败计数
reset_failure_count() {
    echo "0"
}

# 主检查函数
main_check() {
    log_message "INFO" "开始配置漂移检查"
    
    # 运行配置审计
    local audit_output
    local audit_exit_code=0
    
    audit_output=$("$SCRIPT_DIR/config-audit.sh" 2>&1) || audit_exit_code=$?
    
    if [[ $audit_exit_code -eq 0 ]]; then
        # 检查成功
        log_message "SUCCESS" "配置检查通过"
        
        local details='{"status": "success", "message": "所有配置检查通过", "audit_output": ""}'
        generate_report "success" "$details"
        
        # 重置失败计数
        local new_failures=$(reset_failure_count)
        
        echo -e "${GREEN}✅ 配置漂移检查通过${NC}"
        return 0
    else
        # 检查失败
        log_message "ERROR" "配置检查失败: $audit_output"
        
        local escaped_output=$(echo "$audit_output" | sed 's/"/\\"/g' | tr '\n' ' ')
        local details="{\"status\": \"failed\", \"message\": \"配置检查失败\", \"audit_output\": \"$escaped_output\"}"
        generate_report "failed" "$details"
        
        # 更新失败计数
        local new_failures=$(update_failure_count)
        
        # 检查是否需要发送警报
        if [[ $new_failures -ge $ALERT_THRESHOLD ]]; then
            send_notification "配置漂移检测到问题" "连续 $new_failures 次检查失败" "HIGH"
            
            # 尝试自动修复
            log_message "INFO" "尝试自动修复配置问题"
            if "$SCRIPT_DIR/rebuild-network.sh" >> "$LOG_FILE" 2>&1; then
                log_message "SUCCESS" "自动修复成功"
                send_notification "自动修复成功" "配置问题已自动修复" "INFO"
            else
                log_message "ERROR" "自动修复失败"
                send_notification "自动修复失败" "需要手动干预" "CRITICAL"
            fi
        fi
        
        echo -e "${RED}❌ 配置漂移检查失败${NC}"
        return 1
    fi
}

# 显示状态函数
show_status() {
    if [[ -f "$REPORT_FILE" ]]; then
        echo -e "${BLUE}=== 配置漂移监控状态 ===${NC}"
        echo "最后检查时间: $(jq -r '.timestamp' "$REPORT_FILE")"
        echo "检查状态: $(jq -r '.status' "$REPORT_FILE")"
        echo "网络名称: $(jq -r '.network_name' "$REPORT_FILE")"
        echo "期望子网: $(jq -r '.expected_subnet' "$REPORT_FILE")"
        echo "检查次数: $(jq -r '.check_count' "$REPORT_FILE")"
        echo "最后成功: $(jq -r '.last_success' "$REPORT_FILE")"
        echo "连续失败: $(jq -r '.consecutive_failures' "$REPORT_FILE")"
        echo "========================="
    else
        echo -e "${YELLOW}⚠️  尚未进行过配置检查${NC}"
    fi
}

# 清理日志函数
cleanup_logs() {
    local days=${1:-30}
    log_message "INFO" "清理 $days 天前的日志"
    
    # 保留最近N天的日志
    if [[ -f "$LOG_FILE" ]]; then
        local temp_file=$(mktemp)
        tail -n 1000 "$LOG_FILE" > "$temp_file"
        mv "$temp_file" "$LOG_FILE"
    fi
    
    echo -e "${GREEN}✅ 日志清理完成${NC}"
}

# 主程序
case "${1:-check}" in
    "check")
        main_check
        ;;
    "status")
        show_status
        ;;
    "cleanup")
        cleanup_logs "${2:-30}"
        ;;
    "test-alert")
        send_notification "测试通知" "这是一个测试通知" "INFO"
        ;;
    *)
        echo "用法: $0 [check|status|cleanup|test-alert]"
        echo "  check      - 执行配置漂移检查（默认）"
        echo "  status     - 显示监控状态"
        echo "  cleanup    - 清理旧日志"
        echo "  test-alert - 测试通知功能"
        exit 1
        ;;
esac