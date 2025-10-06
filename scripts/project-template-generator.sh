#!/bin/bash

# 简易项目模板生成器
# 作用：为新项目生成环境文件并使用统一云端数据库默认值

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}[INFO]${NC} 项目模板生成器"

TARGET_DIR="$1"
PROJECT_NAME="$2"

if [ -z "$TARGET_DIR" ] || [ -z "$PROJECT_NAME" ]; then
  echo -e "${YELLOW}[USAGE]${NC} $0 <目标目录> <项目名>"
  echo "示例: $0 /path/to/my-app my-app"
  exit 1
fi

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

echo -e "${BLUE}[INFO]${NC} 初始化环境文件 (.env.local / .env.production)"

cat > .env.local << EOF
NODE_ENV=local
PORT=3001
DB_HOST=localhost
DB_PORT=3307
DB_NAME=peach_wiki
DB_USER=root
DB_PASSWORD=han0419/
EOF

cat > .env.production << EOF
NODE_ENV=production
PORT=3000
DB_HOST=60.205.0.185
DB_PORT=3306
DB_NAME=peach_wiki
DB_USER=peach_wiki
DB_PASSWORD=han0419/
EOF

echo -e "${GREEN}[SUCCESS]${NC} 已生成 ${PROJECT_NAME} 的默认环境文件于: $TARGET_DIR"
echo "- .env.local 使用本地数据库默认值"
echo "- .env.production 使用统一云端默认值 (peach_wiki/han0419/)"