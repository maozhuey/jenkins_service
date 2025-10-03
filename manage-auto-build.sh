#!/bin/bash

# Jenkins自动构建管理脚本
# 用于启用或禁用Jenkins项目的自动构建触发器

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Jenkins配置路径
JENKINS_HOME="./jenkins_home"
JOBS_DIR="${JENKINS_HOME}/jobs"

# 显示帮助信息
show_help() {
    echo -e "${BLUE}Jenkins自动构建管理脚本${NC}"
    echo ""
    echo "用法: $0 [选项] [项目名称]"
    echo ""
    echo "选项:"
    echo "  -d, --disable     禁用自动构建触发器"
    echo "  -e, --enable      启用自动构建触发器"
    echo "  -s, --status      查看当前状态"
    echo "  -l, --list        列出所有项目"
    echo "  -h, --help        显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 --disable                    # 禁用所有项目的自动构建"
    echo "  $0 --disable tbk-pipeline       # 禁用指定项目的自动构建"
    echo "  $0 --enable tbk-pipeline        # 启用指定项目的自动构建"
    echo "  $0 --status                     # 查看所有项目状态"
    echo ""
}

# 检查Jenkins是否运行
check_jenkins_status() {
    if ! docker ps | grep -q jenkins; then
        echo -e "${RED}错误: Jenkins容器未运行${NC}"
        echo "请先启动Jenkins: docker-compose up -d"
        exit 1
    fi
}

# 获取所有项目列表
get_projects() {
    if [ ! -d "$JOBS_DIR" ]; then
        echo -e "${RED}错误: Jenkins jobs目录不存在: $JOBS_DIR${NC}"
        exit 1
    fi
    
    find "$JOBS_DIR" -maxdepth 1 -type d -name "*-pipeline" | xargs -I {} basename {}
}

# 检查项目是否存在
check_project_exists() {
    local project_name="$1"
    if [ ! -d "$JOBS_DIR/$project_name" ]; then
        echo -e "${RED}错误: 项目 '$project_name' 不存在${NC}"
        echo "可用项目:"
        get_projects | sed 's/^/  - /'
        exit 1
    fi
}

# 检查项目的自动构建状态
check_auto_build_status() {
    local project_name="$1"
    local config_file="$JOBS_DIR/$project_name/config.xml"
    
    if [ ! -f "$config_file" ]; then
        echo "未知"
        return
    fi
    
    # 检查是否有SCM触发器配置
    if grep -q "<hudson.triggers.SCMTrigger>" "$config_file"; then
        local spec=$(grep -A1 "<spec>" "$config_file" | grep -v "<spec>" | sed 's/^[[:space:]]*//' | sed 's/<\/spec>//')
        echo "启用 (${spec})"
    else
        echo "禁用"
    fi
}

# 禁用自动构建
disable_auto_build() {
    local project_name="$1"
    local config_file="$JOBS_DIR/$project_name/config.xml"
    
    echo -e "${YELLOW}正在禁用项目 '$project_name' 的自动构建...${NC}"
    
    # 创建备份
    cp "$config_file" "$config_file.backup-$(date +%Y%m%d_%H%M%S)"
    
    # 使用sed移除SCM触发器配置
    sed -i.tmp '/<hudson.triggers.SCMTrigger>/,/<\/hudson.triggers.SCMTrigger>/d' "$config_file"
    
    # 确保triggers标签为空
    sed -i.tmp 's/<triggers>.*<\/triggers>/<triggers\/>/g' "$config_file"
    
    # 清理临时文件
    rm -f "$config_file.tmp"
    
    echo -e "${GREEN}✓ 项目 '$project_name' 的自动构建已禁用${NC}"
}

# 启用自动构建
enable_auto_build() {
    local project_name="$1"
    local config_file="$JOBS_DIR/$project_name/config.xml"
    local polling_spec="H/5 * * * *"  # 默认每5分钟检查一次
    
    echo -e "${YELLOW}正在启用项目 '$project_name' 的自动构建...${NC}"
    
    # 创建备份
    cp "$config_file" "$config_file.backup-$(date +%Y%m%d_%H%M%S)"
    
    # 检查是否已经有SCM触发器
    if grep -q "<hudson.triggers.SCMTrigger>" "$config_file"; then
        echo -e "${YELLOW}项目 '$project_name' 的自动构建已经启用${NC}"
        return
    fi
    
    # 替换空的triggers标签
    sed -i.tmp 's|<triggers/>|<triggers>\
        <hudson.triggers.SCMTrigger>\
          <spec>'"$polling_spec"'</spec>\
          <ignorePostCommitHooks>false</ignorePostCommitHooks>\
        </hudson.triggers.SCMTrigger>\
      </triggers>|g' "$config_file"
    
    # 清理临时文件
    rm -f "$config_file.tmp"
    
    echo -e "${GREEN}✓ 项目 '$project_name' 的自动构建已启用 (${polling_spec})${NC}"
}

# 显示项目状态
show_status() {
    local projects=()
    
    if [ $# -eq 0 ]; then
        # 显示所有项目状态
        projects=($(get_projects))
    else
        # 显示指定项目状态
        projects=("$@")
    fi
    
    echo -e "${BLUE}Jenkins项目自动构建状态:${NC}"
    echo ""
    printf "%-20s %-15s\n" "项目名称" "自动构建状态"
    printf "%-20s %-15s\n" "--------" "------------"
    
    for project in "${projects[@]}"; do
        if [ -n "$project" ]; then
            check_project_exists "$project"
            local status=$(check_auto_build_status "$project")
            printf "%-20s %-15s\n" "$project" "$status"
        fi
    done
    echo ""
}

# 列出所有项目
list_projects() {
    echo -e "${BLUE}可用的Jenkins项目:${NC}"
    echo ""
    get_projects | while read -r project; do
        if [ -n "$project" ]; then
            local status=$(check_auto_build_status "$project")
            echo -e "  - ${GREEN}$project${NC} (自动构建: $status)"
        fi
    done
    echo ""
}

# 重启Jenkins以应用配置
restart_jenkins() {
    echo -e "${YELLOW}正在重启Jenkins以应用配置更改...${NC}"
    docker-compose restart jenkins
    echo -e "${GREEN}✓ Jenkins已重启${NC}"
}

# 主函数
main() {
    # 检查参数
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    # 检查Jenkins状态
    check_jenkins_status
    
    local action=""
    local projects=()
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--disable)
                action="disable"
                shift
                ;;
            -e|--enable)
                action="enable"
                shift
                ;;
            -s|--status)
                action="status"
                shift
                ;;
            -l|--list)
                action="list"
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -*)
                echo -e "${RED}错误: 未知选项 $1${NC}"
                show_help
                exit 1
                ;;
            *)
                projects+=("$1")
                shift
                ;;
        esac
    done
    
    # 执行操作
    case $action in
        disable)
            if [ ${#projects[@]} -eq 0 ]; then
                # 禁用所有项目
                projects=($(get_projects))
                echo -e "${YELLOW}将禁用所有项目的自动构建${NC}"
            fi
            
            for project in "${projects[@]}"; do
                if [ -n "$project" ]; then
                    check_project_exists "$project"
                    disable_auto_build "$project"
                fi
            done
            
            restart_jenkins
            ;;
        enable)
            if [ ${#projects[@]} -eq 0 ]; then
                echo -e "${RED}错误: 启用自动构建时必须指定项目名称${NC}"
                exit 1
            fi
            
            for project in "${projects[@]}"; do
                check_project_exists "$project"
                enable_auto_build "$project"
            done
            
            restart_jenkins
            ;;
        status)
            show_status "${projects[@]}"
            ;;
        list)
            list_projects
            ;;
        *)
            echo -e "${RED}错误: 必须指定操作 (--disable, --enable, --status, --list)${NC}"
            show_help
            exit 1
            ;;
    esac
}

# 运行主函数
main "$@"