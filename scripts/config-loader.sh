#!/bin/bash

# 配置加载器 - 统一加载网络配置
# 提供标准化的配置加载接口

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "DEBUG: SCRIPT_DIR = $SCRIPT_DIR" >&2

# 智能检测配置文件路径
if [[ "$SCRIPT_DIR" == *"/scripts" ]]; then
    # 本地开发环境：脚本在scripts目录下
    PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
    CONFIG_FILE="$PROJECT_ROOT/config/network.conf"
    echo "DEBUG: 本地开发环境，PROJECT_ROOT = $PROJECT_ROOT" >&2
elif [[ "$SCRIPT_DIR" == "/opt/apps/tbk" ]] || [[ "$SCRIPT_DIR" == "/opt/apps" ]]; then
    # ECS部署环境：脚本直接在部署目录下
    CONFIG_FILE="/opt/apps/tbk/config/network.conf"
    echo "DEBUG: ECS部署环境，使用固定路径" >&2
else
    # 其他环境：使用环境变量或默认路径
    PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
    CONFIG_FILE="${ECS_DEPLOY_PATH:-$PROJECT_ROOT}/config/network.conf"
    echo "DEBUG: 其他环境，PROJECT_ROOT = $PROJECT_ROOT" >&2
fi

echo "DEBUG: 初始CONFIG_FILE = $CONFIG_FILE" >&2

# 如果默认路径不存在，尝试候选路径
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "DEBUG: 默认配置文件不存在，尝试候选路径..." >&2
    for candidate in \
        "/opt/apps/tbk/config/network.conf" \
        "/opt/apps/config/network.conf" \
        "$SCRIPT_DIR/config/network.conf" \
        "$(dirname "$SCRIPT_DIR")/config/network.conf"; do
        echo "DEBUG: 检查候选路径: $candidate" >&2
        if [[ -f "$candidate" ]]; then
            CONFIG_FILE="$candidate"
            echo "DEBUG: 找到配置文件: $CONFIG_FILE" >&2
            break
        fi
    done
fi

echo "DEBUG: 最终CONFIG_FILE = $CONFIG_FILE" >&2

# 加载网络配置的函数
load_network_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "错误: 配置文件不存在: $CONFIG_FILE" >&2
        echo "DEBUG: 当前工作目录: $(pwd)" >&2
        echo "DEBUG: 脚本目录: $SCRIPT_DIR" >&2
        echo "DEBUG: 项目根目录: $PROJECT_ROOT" >&2
        echo "DEBUG: /opt/apps/ 目录内容:" >&2
        ls -la /opt/apps/ 2>/dev/null || echo "DEBUG: /opt/apps/ 目录不存在" >&2
        echo "DEBUG: /opt/apps/tbk/ 目录内容:" >&2
        ls -la /opt/apps/tbk/ 2>/dev/null || echo "DEBUG: /opt/apps/tbk/ 目录不存在" >&2
        return 1
    fi
    
    # 加载配置文件
    source "$CONFIG_FILE"
    
    # 验证必要的配置是否存在
    if [[ -z "$NETWORK_NAME" || -z "$SUBNET" ]]; then
        echo "错误: 配置文件中缺少必要的网络配置" >&2
        return 1
    fi
    
    echo "✓ 已加载网络配置: $NETWORK_NAME ($SUBNET)"
    return 0
}

# 显示当前配置的函数
show_config() {
    if ! load_network_config; then
        return 1
    fi
    
    echo "=== 当前网络配置 ==="
    echo "网络名称: $NETWORK_NAME"
    echo "子网: $SUBNET"
    echo "网关: $GATEWAY"
    echo "生产网络: $PRODUCTION_NETWORK_NAME ($PRODUCTION_SUBNET)"
    echo "本地网络: $LOCAL_NETWORK_NAME ($LOCAL_SUBNET)"
    echo "配置版本: $CONFIG_VERSION"
    echo "最后更新: $LAST_UPDATED"
    echo "==================="
}

# 验证配置一致性的函数
validate_config() {
    if ! load_network_config; then
        return 1
    fi
    
    # 检查网络配置的合理性
    if [[ "$SUBNET" != "172.21.0.0/16" ]]; then
        echo "警告: 子网配置与标准不符: $SUBNET" >&2
        return 1
    fi
    
    if [[ "$NETWORK_NAME" != "tbk_app-network" ]]; then
        echo "警告: 网络名称与标准不符: $NETWORK_NAME" >&2
        return 1
    fi
    
    echo "✓ 配置验证通过"
    return 0
}

# 如果直接运行此脚本，显示配置信息
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-show}" in
        "show")
            show_config
            ;;
        "validate")
            validate_config
            ;;
        "load")
            load_network_config
            ;;
        *)
            echo "用法: $0 [show|validate|load]"
            echo "  show     - 显示当前配置"
            echo "  validate - 验证配置一致性"
            echo "  load     - 加载配置（用于其他脚本）"
            exit 1
            ;;
    esac
fi