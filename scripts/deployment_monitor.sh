#!/bin/bash
# 部署监控增强方案
# 实时感知部署异常，关键步骤插入追踪日志

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="${PROJECT_ROOT}/logs"
MONITOR_LOG="${LOG_DIR}/deployment_monitor.log"

# 创建日志目录
mkdir -p "$LOG_DIR"

# 日志函数
log_with_timestamp() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$MONITOR_LOG"
}

log_info() { log_with_timestamp "INFO" "$@"; }
log_warn() { log_with_timestamp "WARN" "$@"; }
log_error() { log_with_timestamp "ERROR" "$@"; }
log_success() { log_with_timestamp "SUCCESS" "$@"; }

# 容器状态快照函数
capture_container_snapshot() {
    local snapshot_type=${1:-"all"}
    
    log_info "=== 容器状态快照 ($snapshot_type) ==="
    
    case $snapshot_type in
        "restarting")
            log_info "重启中的容器："
            local restarting_containers
            restarting_containers=$(docker ps --filter "status=restarting" --format "{{.Names}}" 2>/dev/null || true)
            if [ -n "$restarting_containers" ]; then
                echo "$restarting_containers" | while read -r container; do
                    log_warn "容器重启中: $container"
                    # 获取重启原因
                    local restart_count
                    restart_count=$(docker inspect --format '{{.RestartCount}}' "$container" 2>/dev/null || echo "unknown")
                    log_warn "  重启次数: $restart_count"
                done
            else
                log_info "  无重启中的容器"
            fi
            ;;
        "unhealthy")
            log_info "不健康的容器："
            local unhealthy_containers
            unhealthy_containers=$(docker ps --filter "health=unhealthy" --format "{{.Names}}" 2>/dev/null || true)
            if [ -n "$unhealthy_containers" ]; then
                echo "$unhealthy_containers" | while read -r container; do
                    log_error "容器不健康: $container"
                    # 获取健康检查详情
                    docker inspect --format '{{range .State.Health.Log}}{{.Output}}{{end}}' "$container" 2>/dev/null | tail -3 | while read -r line; do
                        log_error "  健康检查: $line"
                    done
                done
            else
                log_info "  无不健康的容器"
            fi
            ;;
        "exited")
            log_info "异常退出的容器："
            local exited_containers
            exited_containers=$(docker ps -a --filter "status=exited" --format "{{.Names}} (退出码: {{.Status}})" 2>/dev/null || true)
            if [ -n "$exited_containers" ]; then
                echo "$exited_containers" | while read -r container_info; do
                    log_error "容器异常退出: $container_info"
                done
            else
                log_info "  无异常退出的容器"
            fi
            ;;
        "all"|*)
            capture_container_snapshot "restarting"
            capture_container_snapshot "unhealthy"
            capture_container_snapshot "exited"
            
            # 额外的系统资源信息
            log_info "=== 系统资源状态 ==="
            log_info "Docker系统信息："
            docker system df 2>/dev/null | while read -r line; do
                log_info "  $line"
            done
            
            log_info "网络状态："
            docker network ls --format "{{.Name}}: {{.Driver}} ({{.Scope}})" 2>/dev/null | while read -r line; do
                log_info "  $line"
            done
            ;;
    esac
}

# 网络状态监控
monitor_network_status() {
    local network_name=${1:-"tbk_app-network"}
    
    log_info "=== 网络状态监控 ==="
    log_info "监控网络: $network_name"
    
    # 检查网络是否存在
    if docker network inspect "$network_name" >/dev/null 2>&1; then
        log_success "网络存在且可访问"
        
        # 获取网络详细信息
        local network_info
        network_info=$(docker network inspect "$network_name" --format '{{.IPAM.Config}}' 2>/dev/null || echo "unknown")
        log_info "网络配置: $network_info"
        
        # 获取连接的容器
        local connected_containers
        connected_containers=$(docker network inspect "$network_name" --format '{{range $k,$v := .Containers}}{{$v.Name}} {{end}}' 2>/dev/null || true)
        if [ -n "$connected_containers" ]; then
            log_info "连接的容器: $connected_containers"
        else
            log_warn "网络无连接的容器"
        fi
    else
        log_error "网络不存在或不可访问"
        return 1
    fi
}

# 服务健康状态监控
monitor_service_health() {
    local service_name=${1:-"tbk-production"}
    local service_url=${2:-"http://localhost:3000/health"}
    
    log_info "=== 服务健康监控 ==="
    log_info "监控服务: $service_name"
    log_info "健康检查URL: $service_url"
    
    # 检查容器状态
    if docker ps --format "{{.Names}}" | grep -q "^${service_name}$"; then
        local container_status
        container_status=$(docker inspect --format '{{.State.Status}}' "$service_name" 2>/dev/null || echo "unknown")
        log_info "容器状态: $container_status"
        
        # 检查健康状态
        local health_status
        health_status=$(docker inspect --format '{{.State.Health.Status}}' "$service_name" 2>/dev/null || echo "none")
        if [ "$health_status" != "none" ]; then
            case $health_status in
                "healthy")
                    log_success "容器健康状态: 健康"
                    ;;
                "unhealthy")
                    log_error "容器健康状态: 不健康"
                    # 获取最近的健康检查日志
                    docker inspect --format '{{range .State.Health.Log}}{{.Output}}{{end}}' "$service_name" 2>/dev/null | tail -1 | while read -r line; do
                        log_error "最近健康检查: $line"
                    done
                    ;;
                "starting")
                    log_warn "容器健康状态: 启动中"
                    ;;
            esac
        else
            log_info "容器未配置健康检查"
        fi
        
        # HTTP健康检查
        if curl -f -s -m 10 "$service_url" >/dev/null 2>&1; then
            log_success "HTTP健康检查: 通过"
        else
            log_error "HTTP健康检查: 失败"
        fi
    else
        log_error "容器不存在: $service_name"
        return 1
    fi
}

# 告警对接函数
send_alert() {
    local alert_level=$1
    local alert_message=$2
    local webhook_url=${3:-""}
    
    log_info "=== 发送告警 ==="
    log_info "告警级别: $alert_level"
    log_info "告警消息: $alert_message"
    
    # 钉钉告警示例
    if [ -n "$webhook_url" ]; then
        local alert_color
        case $alert_level in
            "critical") alert_color="red" ;;
            "warning") alert_color="yellow" ;;
            "info") alert_color="green" ;;
            *) alert_color="blue" ;;
        esac
        
        local payload
        payload=$(cat << EOF
{
    "msgtype": "markdown",
    "markdown": {
        "title": "TBK部署告警",
        "text": "## TBK部署告警\\n\\n**级别**: $alert_level\\n\\n**消息**: $alert_message\\n\\n**时间**: $(date '+%Y-%m-%d %H:%M:%S')\\n\\n**主机**: $(hostname)"
    }
}
EOF
        )
        
        if curl -s -X POST -H "Content-Type: application/json" -d "$payload" "$webhook_url" >/dev/null 2>&1; then
            log_success "告警发送成功"
        else
            log_error "告警发送失败"
        fi
    else
        log_warn "未配置告警webhook，跳过发送"
    fi
}

# 部署步骤监控包装器
monitor_deployment_step() {
    local step_name=$1
    shift
    local command="$*"
    
    log_info "=== 开始执行: $step_name ==="
    local start_time=$(date +%s)
    
    # 执行命令并监控
    if eval "$command"; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log_success "步骤完成: $step_name (耗时: ${duration}s)"
        
        # 执行后状态检查
        case $step_name in
            *"network"*)
                monitor_network_status
                ;;
            *"compose up"*|*"deploy"*)
                sleep 5  # 等待容器启动
                capture_container_snapshot "all"
                monitor_service_health
                ;;
        esac
        
        return 0
    else
        local exit_code=$?
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log_error "步骤失败: $step_name (耗时: ${duration}s, 退出码: $exit_code)"
        
        # 失败时的详细诊断
        log_error "=== 失败诊断 ==="
        capture_container_snapshot "all"
        
        # 发送告警
        send_alert "critical" "部署步骤失败: $step_name (退出码: $exit_code)" "${ALERT_WEBHOOK_URL:-}"
        
        return $exit_code
    fi
}

# Jenkins集成监控函数
jenkins_monitoring_snippet() {
    cat << 'EOF'
# Jenkins Pipeline中的监控集成示例

pipeline {
    agent any
    
    environment {
        ALERT_WEBHOOK_URL = credentials('dingtalk-webhook-url')
    }
    
    stages {
        stage('Network Setup') {
            steps {
                script {
                    sh './scripts/deployment_monitor.sh monitor_step "网络创建" "./scripts/robust_network_manager.sh"'
                }
            }
        }
        
        stage('Deploy Services') {
            steps {
                script {
                    sh './scripts/deployment_monitor.sh monitor_step "服务部署" "docker compose -f aliyun-ecs-deploy.yml up -d"'
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    sh './scripts/deployment_monitor.sh monitor_step "健康检查" "./scripts/enhanced_health_check.sh tbk-production"'
                }
            }
        }
    }
    
    post {
        always {
            script {
                // 生成部署报告
                sh './scripts/deployment_monitor.sh generate_report'
            }
        }
        failure {
            script {
                // 失败时发送详细告警
                sh './scripts/deployment_monitor.sh send_failure_alert'
            }
        }
    }
}
EOF
}

# 生成部署报告
generate_deployment_report() {
    local report_file="${LOG_DIR}/deployment_report_$(date +%Y%m%d_%H%M%S).html"
    
    log_info "=== 生成部署报告 ==="
    log_info "报告文件: $report_file"
    
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>TBK部署报告 - $(date '+%Y-%m-%d %H:%M:%S')</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; }
        .warning { color: orange; }
        .error { color: red; }
        .info { color: blue; }
        pre { background: #f5f5f5; padding: 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>TBK部署报告</h1>
    <p><strong>生成时间:</strong> $(date '+%Y-%m-%d %H:%M:%S')</p>
    <p><strong>主机:</strong> $(hostname)</p>
    
    <h2>容器状态</h2>
    <pre>$(docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "无法获取容器信息")</pre>
    
    <h2>网络状态</h2>
    <pre>$(docker network ls --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}" 2>/dev/null || echo "无法获取网络信息")</pre>
    
    <h2>部署日志</h2>
    <pre>$(tail -50 "$MONITOR_LOG" 2>/dev/null || echo "无部署日志")</pre>
</body>
</html>
EOF
    
    log_success "部署报告已生成: $report_file"
}

# 主函数
main() {
    local action=${1:-help}
    shift || true
    
    case $action in
        "monitor_step")
            monitor_deployment_step "$@"
            ;;
        "snapshot")
            capture_container_snapshot "$@"
            ;;
        "network")
            monitor_network_status "$@"
            ;;
        "service")
            monitor_service_health "$@"
            ;;
        "alert")
            send_alert "$@"
            ;;
        "jenkins")
            jenkins_monitoring_snippet
            ;;
        "generate_report")
            generate_deployment_report
            ;;
        "send_failure_alert")
            local failure_msg="部署失败，请检查日志"
            send_alert "critical" "$failure_msg" "${ALERT_WEBHOOK_URL:-}"
            capture_container_snapshot "all"
            ;;
        "help"|*)
            cat << EOF
用法: $0 <action> [参数...]

Actions:
  monitor_step <名称> <命令>  - 监控部署步骤执行
  snapshot [类型]            - 捕获容器状态快照 (all|restarting|unhealthy|exited)
  network [网络名]           - 监控网络状态
  service [服务名] [URL]     - 监控服务健康状态
  alert <级别> <消息> [URL]  - 发送告警
  jenkins                    - 显示Jenkins集成示例
  generate_report            - 生成部署报告
  send_failure_alert         - 发送失败告警
  help                       - 显示此帮助信息

示例:
  $0 monitor_step "网络创建" "docker network create tbk_app-network"
  $0 snapshot restarting
  $0 network tbk_app-network
  $0 service tbk-production http://localhost:3000/health
  $0 alert warning "服务启动缓慢"
EOF
            ;;
    esac
}

# 执行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi