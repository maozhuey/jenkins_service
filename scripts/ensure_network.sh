#!/usr/bin/env bash
set -euo pipefail

# Usage: ensure_network.sh <network_name> [subnet]
# Ensures a Docker network exists and carries label external=true.
# If missing, creates it with the provided subnet (default from config).

# 加载中心化配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/config-loader.sh" ]]; then
    source "$SCRIPT_DIR/config-loader.sh"
    if load_network_config >/dev/null 2>&1; then
        DEFAULT_NETWORK_NAME="$NETWORK_NAME"
        DEFAULT_SUBNET="$SUBNET"
    else
        DEFAULT_NETWORK_NAME="tbk_app-network"
        DEFAULT_SUBNET="172.21.0.0/16"
    fi
else
    DEFAULT_NETWORK_NAME="tbk_app-network"
    DEFAULT_SUBNET="172.21.0.0/16"
fi

NETWORK_NAME=${1:-$DEFAULT_NETWORK_NAME}
SUBNET_CIDR=${2:-$DEFAULT_SUBNET}

echo "[ensure_network] Checking Docker daemon..."
if ! docker info >/dev/null 2>&1; then
  echo "[ensure_network] ERROR: Docker daemon not reachable"
  exit 1
fi

echo "[ensure_network] Inspecting network '${NETWORK_NAME}'..."
if docker network inspect "${NETWORK_NAME}" >/dev/null 2>&1; then
  LABEL_VAL=$(docker network inspect -f '{{ index .Labels "external" }}' "${NETWORK_NAME}" || echo "")
  echo "[ensure_network] Found network. Label external=${LABEL_VAL}"
  if [ "${LABEL_VAL}" != "true" ]; then
    echo "[ensure_network] WARNING: Network exists but missing external=true label."
    echo "[ensure_network] Leaving as-is to avoid disrupting running services."
  fi
else
  echo "[ensure_network] Network not found. Creating '${NETWORK_NAME}' with subnet '${SUBNET_CIDR}'..."
  docker network create "${NETWORK_NAME}" --subnet="${SUBNET_CIDR}" --label external=true
  echo "[ensure_network] Created network '${NETWORK_NAME}'. Verifying..."
  LABEL_VAL=$(docker network inspect -f '{{ index .Labels "external" }}' "${NETWORK_NAME}" || echo "")
  if [ "${LABEL_VAL}" != "true" ]; then
    echo "[ensure_network] ERROR: Failed to set external=true label on '${NETWORK_NAME}'"
    exit 1
  fi
fi

echo "[ensure_network] Safe prune: removing unused non-external networks..."
docker network prune -f --filter "label!=external" || true

echo "[ensure_network] OK: '${NETWORK_NAME}' is present with label external=true"
exit 0