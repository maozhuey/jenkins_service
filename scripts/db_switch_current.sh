#!/bin/bash

set -euo pipefail

# 简洁数据库切换脚本：基于当前目录项目，仅修改当前目录的环境文件
# 使用：
#  - 作为系统命令名调用：DB_local / DB_production （通过软链接实现）
#  - 或直接调用：scripts/db_switch_current.sh local|production

MODE="${1:-}"

# 如果以命令名调用，自动识别模式
if [[ -z "$MODE" ]]; then
  cmd_name="$(basename "$0")"
  case "$cmd_name" in
    DB_local)
      MODE="local"
      ;;
    DB_production)
      MODE="production"
      ;;
    *)
      echo "用法: $0 [local|production] 或通过命令 DB_local / DB_production 调用" >&2
      exit 1
      ;;
  esac
fi

CWD="$(pwd)"

log_info()   { echo -e "\033[0;34m[INFO]\033[0m $1"; }
log_ok()     { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
log_warn()   { echo -e "\033[1;33m[WARNING]\033[0m $1"; }
log_err()    { echo -e "\033[0;31m[ERROR]\033[0m $1"; }

# 在 env 文件中更新/追加键值
update_env_var() {
  local file="$1" key="$2" value="$3"
  if [ ! -f "$file" ]; then
    echo "$key=$value" >> "$file"
    return
  fi
  if grep -q "^$key=" "$file"; then
    # macOS sed 需要 -i ''；使用 | 作为分隔符并转义值中的特殊字符
    local esc_value
    esc_value=$(printf '%s' "$value" | sed 's/[&|]/\\&/g')
    sed -i '' "s|^$key=.*|$key=$esc_value|" "$file"
  else
    echo "$key=$value" >> "$file"
  fi
}

# 选择目标 env 文件（优先使用更贴近目标环境的文件）
choose_env_file() {
  local mode="$1"
  local target=""
  if [[ "$mode" == "local" ]]; then
    if [ -f "$CWD/.env.local" ]; then
      target="$CWD/.env.local"
    elif [ -f "$CWD/.env" ]; then
      target="$CWD/.env"
    else
      target="$CWD/.env.local" # 不存在则创建
    fi
  else
    if [ -f "$CWD/.env.production" ]; then
      target="$CWD/.env.production"
    elif [ -f "$CWD/.env" ]; then
      target="$CWD/.env"
    else
      target="$CWD/.env.production" # 不存在则创建
    fi
  fi
  echo "$target"
}

# 根据当前目录是否存在 docker-compose.local.yml 判断是否使用容器服务名
detect_service_host() {
  local service_name="$1" # e.g. mysql-local / redis-local
  local fallback_host="$2" # e.g. localhost / 60.205.0.185
  if [ -f "$CWD/docker-compose.local.yml" ] && grep -q "$service_name" "$CWD/docker-compose.local.yml"; then
    echo "$service_name"
  else
    echo "$fallback_host"
  fi
}

apply_local() {
  local env_file
  env_file="$(choose_env_file local)"

  # MySQL/Redis 主机：优先容器服务名，否则使用 localhost
  local db_host redis_host
  db_host="$(detect_service_host mysql-local localhost)"
  redis_host="$(detect_service_host redis-local localhost)"

  update_env_var "$env_file" DB_HOST "$db_host"
  update_env_var "$env_file" DB_USER "root"
  update_env_var "$env_file" DB_PASSWORD "han0419/"
  update_env_var "$env_file" DB_NAME "peach_wiki"
  update_env_var "$env_file" DB_PORT "3306"

  update_env_var "$env_file" REDIS_HOST "$redis_host"
  update_env_var "$env_file" REDIS_PORT "6379"
  update_env_var "$env_file" REDIS_PASSWORD "han0419"

  # 兼容运行时默认加载 .env 的项目：同步更新 .env
  local default_env="$CWD/.env"
  update_env_var "$default_env" DB_HOST "$db_host"
  update_env_var "$default_env" DB_USER "root"
  update_env_var "$default_env" DB_PASSWORD "han0419/"
  update_env_var "$default_env" DB_NAME "peach_wiki"
  update_env_var "$default_env" DB_PORT "3306"
  update_env_var "$default_env" REDIS_HOST "$redis_host"
  update_env_var "$default_env" REDIS_PORT "6379"
  update_env_var "$default_env" REDIS_PASSWORD "han0419"

  log_ok "已切换为本地数据库，并更新: $env_file"
}

apply_production() {
  local env_file
  env_file="$(choose_env_file production)"

  update_env_var "$env_file" DB_HOST "60.205.0.185"
  update_env_var "$env_file" DB_USER "peach_wiki"
  update_env_var "$env_file" DB_PASSWORD "han0419/"
  update_env_var "$env_file" DB_NAME "peach_wiki"
  update_env_var "$env_file" DB_PORT "3306"

  update_env_var "$env_file" REDIS_HOST "60.205.0.185"
  update_env_var "$env_file" REDIS_PORT "6379"
  update_env_var "$env_file" REDIS_PASSWORD "han0419"

  # 可选：生产开启 SSL（若项目支持）
  update_env_var "$env_file" SSL_ENABLED "true"
  update_env_var "$env_file" TRUST_PROXY "true"

  # 兼容运行时默认加载 .env 的项目：同步更新 .env
  local default_env="$CWD/.env"
  update_env_var "$default_env" DB_HOST "60.205.0.185"
  update_env_var "$default_env" DB_USER "peach_wiki"
  update_env_var "$default_env" DB_PASSWORD "han0419/"
  update_env_var "$default_env" DB_NAME "peach_wiki"
  update_env_var "$default_env" DB_PORT "3306"
  update_env_var "$default_env" REDIS_HOST "60.205.0.185"
  update_env_var "$default_env" REDIS_PORT "6379"
  update_env_var "$default_env" REDIS_PASSWORD "han0419"
  update_env_var "$default_env" SSL_ENABLED "true"
  update_env_var "$default_env" TRUST_PROXY "true"

  log_ok "已切换为阿里云生产数据库，并更新: $env_file"
}

case "$MODE" in
  local)
    log_info "当前项目: $CWD"
    apply_local
    ;;
  production)
    log_info "当前项目: $CWD"
    apply_production
    ;;
  *)
    log_err "未知模式: $MODE（允许值: local / production）"
    exit 1
    ;;
esac