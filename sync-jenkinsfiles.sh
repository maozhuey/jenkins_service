#!/bin/bash

# 自动同步 Jenkinsfile.aliyun.template 到其他项目
# 作者: AI Assistant
# 创建时间: $(date '+%Y-%m-%d %H:%M:%S')

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/multi-project-config.json"
TEMPLATE_FILE="$SCRIPT_DIR/Jenkinsfile.aliyun.template"

log_info "开始执行 Jenkinsfile 自动同步..."
log_info "脚本目录: $SCRIPT_DIR"
log_info "配置文件: $CONFIG_FILE"
log_info "模板文件: $TEMPLATE_FILE"

# 检查必要文件是否存在
if [[ ! -f "$CONFIG_FILE" ]]; then
    log_error "配置文件不存在: $CONFIG_FILE"
    exit 1
fi

if [[ ! -f "$TEMPLATE_FILE" ]]; then
    log_error "模板文件不存在: $TEMPLATE_FILE"
    exit 1
fi

# 检查 jq 是否安装
if ! command -v jq &> /dev/null; then
    log_error "jq 未安装，请先安装 jq: brew install jq"
    exit 1
fi

log_success "所有必要文件检查通过"

# 读取项目配置
log_info "读取项目配置..."
PROJECTS=$(jq -r '.projects | keys[]' "$CONFIG_FILE" 2>/dev/null)

if [[ -z "$PROJECTS" ]]; then
    log_error "无法读取项目配置或配置为空"
    exit 1
fi

log_info "发现以下项目:"
echo "$PROJECTS" | while read -r project; do
    echo "  - $project"
done

# 同步计数器
SYNC_COUNT=0
ERROR_COUNT=0

# 遍历每个项目进行同步
echo "$PROJECTS" | while read -r project; do
    # 跳过 jenkins-service 项目本身
    if [[ "$project" == "jenkins-service" ]]; then
        log_info "跳过 jenkins-service 项目本身"
        continue
    fi
    
    log_info "处理项目: $project"
    
    # 获取项目路径
    PROJECT_PATH=$(jq -r ".projects[\"$project\"].path" "$CONFIG_FILE" 2>/dev/null)
    
    if [[ "$PROJECT_PATH" == "null" || -z "$PROJECT_PATH" ]]; then
        log_warning "项目 $project 没有配置路径，跳过"
        ((ERROR_COUNT++))
        continue
    fi
    
    # 转换为绝对路径
    if [[ "$PROJECT_PATH" != /* ]]; then
        PROJECT_PATH="$SCRIPT_DIR/../$PROJECT_PATH"
    fi
    
    log_info "项目路径: $PROJECT_PATH"
    
    # 检查项目目录是否存在
    if [[ ! -d "$PROJECT_PATH" ]]; then
        log_warning "项目目录不存在: $PROJECT_PATH，跳过"
        ((ERROR_COUNT++))
        continue
    fi
    
    # 目标 Jenkinsfile 路径
    TARGET_JENKINSFILE="$PROJECT_PATH/Jenkinsfile.aliyun"
    
    # 备份现有的 Jenkinsfile.aliyun（如果存在）
    if [[ -f "$TARGET_JENKINSFILE" ]]; then
        BACKUP_FILE="$TARGET_JENKINSFILE.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "备份现有文件: $TARGET_JENKINSFILE -> $BACKUP_FILE"
        cp "$TARGET_JENKINSFILE" "$BACKUP_FILE"
    fi
    
    # 复制模板文件
    log_info "复制模板文件到: $TARGET_JENKINSFILE"
    cp "$TEMPLATE_FILE" "$TARGET_JENKINSFILE"
    
    # 检查是否为 Git 仓库并提交更改
    if [[ -d "$PROJECT_PATH/.git" ]]; then
        log_info "检测到 Git 仓库，尝试提交更改..."
        cd "$PROJECT_PATH"
        
        # 检查是否有更改
        if git diff --quiet HEAD -- Jenkinsfile.aliyun 2>/dev/null; then
            log_info "没有检测到更改，跳过提交"
        else
            # 添加文件到 Git
            git add Jenkinsfile.aliyun
            
            # 提交更改
            COMMIT_MSG="自动同步: 更新 Jenkinsfile.aliyun 从 jenkins-service 模板 ($(date '+%Y-%m-%d %H:%M:%S'))"
            if git commit -m "$COMMIT_MSG" 2>/dev/null; then
                log_success "已提交更改到 Git"
            else
                log_warning "Git 提交失败，但文件已复制"
            fi
        fi
        
        cd "$SCRIPT_DIR"
    else
        log_info "非 Git 仓库，跳过版本控制操作"
    fi
    
    log_success "项目 $project 同步完成"
    ((SYNC_COUNT++))
done

# 输出同步结果
echo ""
log_info "同步操作完成"
log_success "成功同步项目数: $SYNC_COUNT"
if [[ $ERROR_COUNT -gt 0 ]]; then
    log_warning "遇到错误的项目数: $ERROR_COUNT"
fi

# 显示使用说明
echo ""
log_info "使用说明:"
echo "1. 当你修改 jenkins-service/Jenkinsfile.aliyun.template 后"
echo "2. 运行此脚本: ./sync-jenkinsfiles.sh"
echo "3. 脚本会自动将模板同步到所有配置的项目"
echo "4. 如果项目是 Git 仓库，会自动提交更改"
echo ""
log_info "注意事项:"
echo "- 现有的 Jenkinsfile.aliyun 会被自动备份"
echo "- 只同步到 multi-project-config.json 中配置的项目"
echo "- jenkins-service 项目本身会被跳过"

exit 0