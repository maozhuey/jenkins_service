#!/bin/bash
# 增强的健康检查机制
# 基于容器状态的多维检查 + 指数退避算法

set -euo pipefail

CONTAINER_NAME=${1:-tbk-production}
SERVICE_URL=${2:-http://localhost:3000/health}
MAX_RETRIES=${3:-10}
INITIAL_DELAY=${4:-2}
MAX_DELAY=${5:-60}
HTTP_TIMEOUT=${6:-30}

# 指数退避算法计算延迟时间
calculate_backoff_delay() {
    local attempt=$1
    local initial_delay=$2
    local max_delay=$3
    
    # 指数退避公式: delay = min(initial_delay * 2^attempt, max_delay)
    local delay=$((initial_delay * (1 << attempt)))
    
    if [ $delay -gt $max_delay ]; then
        delay=$max_delay
    fi
    
    echo $delay
}

# 容器状态检查（第一轨）
check_container_status() {
    local container_name=$1
    
    echo "[容器检查] 检查容器 '${container_name}' 状态..."
    
    # 检查容器是否存在
    if ! docker ps -a --format "{{.Names}}" | grep -q "^${container_name}$"; then
        echo "[容器检查] 错误：容器不存在"
        return 1
    fi
    
    # 使用docker inspect检查容器Running状态
    local container_state
    container_state=$(docker inspect --format '{{.State.Status}}' "$container_name" 2>/dev/null || echo "unknown")
    
    case $container_state in
        "running")
            echo "[容器检查] 容器状态：运行中"
            
            # 检查容器健康状态（如果定义了healthcheck）
            local health_status
            health_status=$(docker inspect --format '{{.State.Health.Status}}' "$container_name" 2>/dev/null || echo "none")
            
            if [ "$health_status" != "none" ]; then
                echo "[容器检查] 健康状态：$health_status"
                case $health_status in
                    "healthy")
                        return 0
                        ;;
                    "unhealthy")
                        echo "[容器检查] 警告：容器不健康"
                        return 2
                        ;;
                    "starting")
                        echo "[容器检查] 容器启动中..."
                        return 3
                        ;;
                esac
            else
                echo "[容器检查] 无健康检查定义，仅检查运行状态"
                return 0
            fi
            ;;
        "restarting")
            echo "[容器检查] 容器重启中..."
            return 3
            ;;
        "exited")
            local exit_code
            exit_code=$(docker inspect --format '{{.State.ExitCode}}' "$container_name")
            echo "[容器检查] 容器已退出，退出码：$exit_code"
            return 1
            ;;
        "dead"|"created"|"paused")
            echo "[容器检查] 容器状态异常：$container_state"
            return 1
            ;;
        *)
            echo "[容器检查] 未知容器状态：$container_state"
            return 1
            ;;
    esac
}

# HTTP健康检查（第二轨）
check_http_health() {
    local service_url=$1
    local timeout=$2
    
    echo "[HTTP检查] 检查服务端点：$service_url"
    
    # 使用curl进行HTTP健康检查，延长超时参数
    if curl -f -s -m "$timeout" --connect-timeout 10 "$service_url" >/dev/null 2>&1; then
        echo "[HTTP检查] HTTP健康检查通过"
        return 0
    else
        local curl_exit_code=$?
        echo "[HTTP检查] HTTP健康检查失败，curl退出码：$curl_exit_code"
        return 1
    fi
}

# 端口连通性检查
check_port_connectivity() {
    local container_name=$1
    local port=${2:-3000}
    
    echo "[端口检查] 检查容器端口连通性..."
    
    # 获取容器IP
    local container_ip
    container_ip=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_name" 2>/dev/null | head -1)
    
    if [ -z "$container_ip" ]; then
        echo "[端口检查] 无法获取容器IP"
        return 1
    fi
    
    echo "[端口检查] 容器IP：$container_ip"
    
    # 检查端口是否监听
    if nc -z -w5 "$container_ip" "$port" 2>/dev/null; then
        echo "[端口检查] 端口 $port 连通"
        return 0
    else
        echo "[端口检查] 端口 $port 不通"
        return 1
    fi
}

# 综合健康检查主函数
comprehensive_health_check() {
    local container_name=$1
    local service_url=$2
    local max_retries=$3
    local initial_delay=$4
    local max_delay=$5
    local http_timeout=$6
    
    local attempt=0
    local success=false
    
    echo "=== 开始综合健康检查 ==="
    echo "容器名称: $container_name"
    echo "服务URL: $service_url"
    echo "最大重试: $max_retries"
    echo "初始延迟: ${initial_delay}s"
    echo "最大延迟: ${max_delay}s"
    echo "HTTP超时: ${http_timeout}s"
    echo ""
    
    while [ $attempt -lt $max_retries ] && [ "$success" = false ]; do
        echo "--- 第 $((attempt + 1)) 次检查 ---"
        
        # 第一轨：容器状态检查
        local container_check_result
        container_check_result=$(check_container_status "$container_name"; echo $?)
        
        case $container_check_result in
            0)
                echo "[综合检查] 容器状态正常，继续HTTP检查..."
                
                # 第二轨：HTTP健康检查
                if check_http_health "$service_url" "$http_timeout"; then
                    echo "[综合检查] ✅ 所有检查通过！"
                    success=true
                    break
                else
                    echo "[综合检查] HTTP检查失败，尝试端口检查..."
                    
                    # 备用检查：端口连通性
                    if check_port_connectivity "$container_name"; then
                        echo "[综合检查] ⚠️  端口通但HTTP不通，可能服务未完全启动"
                    else
                        echo "[综合检查] ❌ 端口和HTTP都不通"
                    fi
                fi
                ;;
            2)
                echo "[综合检查] 容器不健康，跳过HTTP检查"
                ;;
            3)
                echo "[综合检查] 容器启动中，等待..."
                ;;
            *)
                echo "[综合检查] 容器状态异常，跳过HTTP检查"
                ;;
        esac
        
        # 如果未成功且还有重试机会
        if [ "$success" = false ] && [ $attempt -lt $((max_retries - 1)) ]; then
            local delay
            delay=$(calculate_backoff_delay $attempt $initial_delay $max_delay)
            echo "[综合检查] 等待 ${delay}s 后重试..."
            sleep $delay
        fi
        
        attempt=$((attempt + 1))
    done
    
    if [ "$success" = true ]; then
        echo ""
        echo "=== 健康检查成功 ==="
        return 0
    else
        echo ""
        echo "=== 健康检查失败 ==="
        echo "已尝试 $attempt 次，均未成功"
        
        # 输出最终状态快照
        echo ""
        echo "=== 最终状态快照 ==="
        echo "重启中的容器："
        docker ps --filter "status=restarting" --format "{{.Names}}" || true
        echo "异常退出的容器："
        docker ps -a --filter "status=exited" --format "{{.Names}} (退出码: {{.Status}})" || true
        
        return 1
    fi
}

# Jenkins集成函数
jenkins_health_check_snippet() {
    cat << 'EOF'
# 可嵌入Jenkinsfile的增强健康检查
echo "开始增强健康检查..."

# 设置检查参数
CONTAINER_NAME="tbk-production"
SERVICE_URL="http://localhost:3000/health"
MAX_RETRIES=10
INITIAL_DELAY=2
MAX_DELAY=60

# 执行增强健康检查
if ./scripts/enhanced_health_check.sh "$CONTAINER_NAME" "$SERVICE_URL" "$MAX_RETRIES" "$INITIAL_DELAY" "$MAX_DELAY"; then
    echo "✅ 服务健康检查通过"
else
    echo "❌ 服务健康检查失败"
    
    # 收集诊断信息
    echo "=== 诊断信息 ==="
    docker logs --tail 50 "$CONTAINER_NAME" || true
    docker inspect "$CONTAINER_NAME" --format '{{.State}}' || true
    
    exit 1
fi
EOF
}

# 主函数
main() {
    comprehensive_health_check "$@"
}

# 如果直接执行脚本
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi