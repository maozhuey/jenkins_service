#!/bin/bash

# 配置加载器 - 统一加载网络配置
# 提供标准化的配置加载接口

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 智能路径检测：支持本地开发环境和ECS部署环境
if [[ "$SCRIPT_DIR" == */scripts ]]; then
    # 本地开发环境：脚本在 scripts/ 子目录中
    PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
    CONFIG_FILE="$PROJECT_ROOT/config/network.conf"
else
    # ECS部署环境：脚本直接在项目根目录中
    PROJECT_ROOT="$SCRIPT_DIR"
    CONFIG_FILE="$PROJECT_ROOT/config/network.conf"
fi

# 加载网络配置的函数
load_network_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "错误: 配置文件不存在: $CONFIG_FILE" >&2
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