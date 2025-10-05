#!/bin/bash
# 稳健的Docker网络管理策略
# 解决网络"已存在/未找到"的时序逻辑矛盾

set -euo pipefail

NETWORK_NAME=${1:-tbk_app-network}
SUBNET_CIDR=${2:-172.22.0.0/16}
MAX_RETRIES=3
RETRY_DELAY=2

# 网络状态预检函数
check_network_status() {
    local network_name=$1
    local network_id
    
    echo "[网络检查] 检查网络 '${network_name}' 状态..."
    
    # 检查网络是否存在
    if network_id=$(docker network ls -q -f name="^${network_name}$"); then
        if [ -n "$network_id" ]; then
            echo "[网络检查] 网络存在，ID: $network_id"
            
            # 检查网络是否可用（无僵尸状态）
            if docker network inspect "$network_id" >/dev/null 2>&1; then
                echo "[网络检查] 网络状态正常"
                return 0
            else
                echo "[网络检查] 网络处于僵尸状态，需要清理"
                return 2
            fi
        fi
    fi
    
    echo "[网络检查] 网络不存在"
    return 1
}

# 安全网络清理函数
safe_network_cleanup() {
    local network_name=$1
    local retry_count=0
    
    echo "[网络清理] 开始清理网络 '${network_name}'..."
    
    while [ $retry_count -lt $MAX_RETRIES ]; do
        # 强制断开所有容器连接
        echo "[网络清理] 断开容器连接..."
        docker network inspect "$network_name" --format '{{range .Containers}}{{.Name}} {{end}}' 2>/dev/null | \
        xargs -r -n1 docker network disconnect "$network_name" --force 2>/dev/null || true
        
        # 等待网络引用计数归零
        sleep $RETRY_DELAY
        
        # 尝试删除网络
        if docker network rm "$network_name" 2>/dev/null; then
            echo "[网络清理] 网络删除成功"
            return 0
        fi
        
        retry_count=$((retry_count + 1))
        echo "[网络清理] 删除失败，重试 $retry_count/$MAX_RETRIES..."
        sleep $((RETRY_DELAY * retry_count))
    done
    
    echo "[网络清理] 警告：网络删除失败，但继续执行"
    return 0
}

# 网络创建函数（带容错机制）
create_network_with_fallback() {
    local network_name=$1
    local subnet_cidr=$2
    local retry_count=0
    
    echo "[网络创建] 创建网络 '${network_name}' (${subnet_cidr})..."
    
    while [ $retry_count -lt $MAX_RETRIES ]; do
        # &&逻辑短路与||true的容错配合原理：
        # 1. docker network create 成功 → 短路，不执行后续
        # 2. docker network create 失败 → 执行 || true，防止脚本退出
        if docker network create "$network_name" \
           --subnet="$subnet_cidr" \
           --label external=true \
           --driver bridge 2>/dev/null || true; then
            
            # 验证网络创建成功
            if docker network inspect "$network_name" >/dev/null 2>&1; then
                echo "[网络创建] 网络创建成功"
                return 0
            fi
        fi
        
        retry_count=$((retry_count + 1))
        echo "[网络创建] 创建失败，重试 $retry_count/$MAX_RETRIES..."
        sleep $((RETRY_DELAY * retry_count))
    done
    
    echo "[网络创建] 错误：网络创建失败"
    return 1
}

# 主函数：稳健的网络管理
main() {
    echo "=== 稳健网络管理开始 ==="
    echo "网络名称: $NETWORK_NAME"
    echo "子网CIDR: $SUBNET_CIDR"
    
    # 检查网络状态
    case $(check_network_status "$NETWORK_NAME"; echo $?) in
        0)
            echo "[主流程] 网络已存在且正常，跳过创建"
            ;;
        1)
            echo "[主流程] 网络不存在，开始创建"
            create_network_with_fallback "$NETWORK_NAME" "$SUBNET_CIDR"
            ;;
        2)
            echo "[主流程] 网络处于异常状态，先清理后创建"
            safe_network_cleanup "$NETWORK_NAME"
            create_network_with_fallback "$NETWORK_NAME" "$SUBNET_CIDR"
            ;;
    esac
    
    echo "=== 稳健网络管理完成 ==="
}

# 嵌入Jenkinsfile的Shell检查函数
jenkins_network_check() {
    cat << 'EOF'
# 可嵌入Jenkinsfile的网络检查逻辑
if [ ! "$(docker network ls -q -f name=^tbk_app-network$)" ]; then
    echo "网络不存在，创建中..."
    docker network create tbk_app-network --subnet=172.22.0.0/16 --label external=true || {
        echo "网络创建失败，检查冲突..."
        docker network ls | grep tbk
        exit 1
    }
else
    echo "网络已存在，验证状态..."
    docker network inspect tbk_app-network >/dev/null || {
        echo "网络状态异常，重新创建..."
        docker network rm tbk_app-network --force || true
        docker network create tbk_app-network --subnet=172.22.0.0/16 --label external=true
    }
fi
EOF
}

# 执行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi