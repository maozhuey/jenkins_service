#!/bin/bash

# Jenkins 安装脚本
# 适用于 macOS 系统

set -e

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

# 检查 Docker 是否安装
check_docker() {
    log_info "检查 Docker 安装状态..."
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker 未安装，请先安装 Docker Desktop"
        log_info "下载地址: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    
    # 检查 Docker 是否运行
    if ! docker info &> /dev/null; then
        log_warning "Docker 服务未启动，正在启动..."
        open -a Docker
        log_info "等待 Docker 启动..."
        
        # 等待 Docker 启动
        for i in {1..30}; do
            if docker info &> /dev/null; then
                break
            fi
            sleep 2
            echo -n "."
        done
        echo
        
        if ! docker info &> /dev/null; then
            log_error "Docker 启动失败，请手动启动 Docker Desktop"
            exit 1
        fi
    fi
    
    log_success "Docker 检查完成"
}

# 创建 Jenkins 目录
create_jenkins_directories() {
    log_info "创建 Jenkins 目录..."
    
    mkdir -p jenkins_home
    mkdir -p jenkins_agent_workdir
    
    # 设置权限（macOS 不需要特殊的用户权限设置）
    chmod 755 jenkins_home jenkins_agent_workdir
    
    log_success "Jenkins 目录创建完成"
}

# 配置 Docker 镜像源（解决网络问题）
configure_docker_registry() {
    log_info "配置 Docker 镜像源..."
    
    # 检查是否可以访问 Docker Hub
    if ! curl -s --connect-timeout 5 https://registry-1.docker.io &> /dev/null; then
        log_warning "无法访问 Docker Hub，尝试使用国内镜像源"
        
        # 创建或更新 Docker daemon 配置
        local docker_config_dir="$HOME/.docker"
        local daemon_config="$docker_config_dir/daemon.json"
        
        mkdir -p "$docker_config_dir"
        
        # 备份现有配置
        if [[ -f "$daemon_config" ]]; then
            cp "$daemon_config" "$daemon_config.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        # 创建新的配置文件
        cat > "$daemon_config" << 'EOF'
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ],
  "insecure-registries": [],
  "debug": false,
  "experimental": false
}
EOF
        
        log_info "已配置国内镜像源，请重启 Docker Desktop"
        log_warning "请手动重启 Docker Desktop 后重新运行此脚本"
        
        read -p "是否现在重启 Docker Desktop? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            osascript -e 'quit app "Docker"'
            sleep 3
            open -a Docker
            log_info "等待 Docker 重启..."
            sleep 15
        else
            log_warning "请手动重启 Docker Desktop 后继续"
            exit 1
        fi
    fi
}

# 拉取 Jenkins 镜像
pull_jenkins_image() {
    log_info "拉取 Jenkins 镜像..."
    
    # 尝试拉取镜像
    if docker pull jenkins/jenkins:lts; then
        log_success "Jenkins 镜像拉取成功"
    else
        log_error "Jenkins 镜像拉取失败"
        
        # 尝试使用国内镜像
        log_info "尝试使用国内镜像源..."
        if docker pull registry.cn-hangzhou.aliyuncs.com/library/jenkins:lts; then
            # 重新标记镜像
            docker tag registry.cn-hangzhou.aliyuncs.com/library/jenkins:lts jenkins/jenkins:lts
            log_success "使用国内镜像源拉取成功"
        else
            log_error "无法拉取 Jenkins 镜像，请检查网络连接"
            exit 1
        fi
    fi
}

# 启动 Jenkins
start_jenkins() {
    log_info "启动 Jenkins 服务..."
    
    # 检查是否已有 Jenkins 容器
    if docker ps -a | grep -q jenkins; then
        log_warning "发现已存在的 Jenkins 容器"
        read -p "是否删除现有容器并重新创建? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker stop jenkins 2>/dev/null || true
            docker rm jenkins 2>/dev/null || true
        else
            log_info "启动现有容器..."
            docker start jenkins
            log_success "Jenkins 容器已启动"
            return 0
        fi
    fi
    
    # 使用 Docker Compose 启动
    if [[ -f "docker-compose.jenkins.yml" ]]; then
        log_info "使用 Docker Compose 启动 Jenkins..."
        docker-compose -f docker-compose.jenkins.yml up -d jenkins
    else
        # 直接使用 Docker 命令启动
        log_info "使用 Docker 命令启动 Jenkins..."
        docker run -d \
            --name jenkins \
            --restart unless-stopped \
            -p 8080:8080 \
            -p 50000:50000 \
            -v "$(pwd)/jenkins_home:/var/jenkins_home" \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v "$(which docker):/usr/bin/docker" \
            --user root \
            jenkins/jenkins:lts
    fi
    
    log_success "Jenkins 容器已启动"
}

# 等待 Jenkins 启动
wait_for_jenkins() {
    log_info "等待 Jenkins 启动..."
    
    local max_attempts=60
    local attempt=0
    
    while [[ $attempt -lt $max_attempts ]]; do
        if curl -s http://localhost:8080 &> /dev/null; then
            log_success "Jenkins 已启动并可访问"
            return 0
        fi
        
        echo -n "."
        sleep 2
        ((attempt++))
    done
    
    echo
    log_error "Jenkins 启动超时"
    return 1
}

# 获取初始密码
get_initial_password() {
    log_info "获取 Jenkins 初始密码..."
    
    local password_file="jenkins_home/secrets/initialAdminPassword"
    
    if [[ -f "$password_file" ]]; then
        local password=$(cat "$password_file")
        echo
        echo "=========================================="
        echo "Jenkins 初始管理员密码:"
        echo "$password"
        echo "=========================================="
        echo
        log_info "请访问 http://localhost:8080 开始配置 Jenkins"
        log_info "使用上面的密码进行初始化设置"
    else
        log_warning "无法找到初始密码文件"
        log_info "请检查 Jenkins 容器日志: docker logs jenkins"
    fi
}

# 显示后续步骤
show_next_steps() {
    echo
    log_success "Jenkins 安装完成！"
    echo
    echo "后续步骤："
    echo "1. 访问 http://localhost:8080"
    echo "2. 使用上面显示的初始密码登录"
    echo "3. 安装推荐的插件"
    echo "4. 创建管理员用户"
    echo "5. 配置系统设置"
    echo
    echo "有用的命令："
    echo "  查看 Jenkins 日志: docker logs jenkins"
    echo "  停止 Jenkins:     docker stop jenkins"
    echo "  启动 Jenkins:     docker start jenkins"
    echo "  重启 Jenkins:     docker restart jenkins"
    echo
    echo "配置文件位置："
    echo "  Jenkins 数据:     $(pwd)/jenkins_home"
    echo "  Docker Compose:   $(pwd)/docker-compose.jenkins.yml"
    echo
}

# 主函数
main() {
    log_info "开始安装 Jenkins..."
    echo
    
    check_docker
    create_jenkins_directories
    configure_docker_registry
    pull_jenkins_image
    start_jenkins
    
    if wait_for_jenkins; then
        get_initial_password
        show_next_steps
    else
        log_error "Jenkins 安装失败"
        log_info "请检查 Docker 日志: docker logs jenkins"
        exit 1
    fi
}

# 处理命令行参数
case "${1:-}" in
    -h|--help)
        echo "Jenkins 安装脚本"
        echo
        echo "用法: $0 [选项]"
        echo
        echo "选项:"
        echo "  -h, --help     显示此帮助信息"
        echo "  -c, --clean    清理 Jenkins 数据并重新安装"
        echo "  -s, --status   查看 Jenkins 状态"
        echo
        exit 0
        ;;
    -c|--clean)
        log_warning "这将删除所有 Jenkins 数据"
        read -p "确定要继续吗? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker stop jenkins 2>/dev/null || true
            docker rm jenkins 2>/dev/null || true
            rm -rf jenkins_home jenkins_agent_workdir
            log_success "Jenkins 数据已清理"
            main
        fi
        ;;
    -s|--status)
        echo "Jenkins 状态:"
        docker ps | grep jenkins || echo "Jenkins 容器未运行"
        echo
        if curl -s http://localhost:8080 &> /dev/null; then
            echo "Jenkins Web 界面: ✅ 可访问 (http://localhost:8080)"
        else
            echo "Jenkins Web 界面: ❌ 不可访问"
        fi
        ;;
    "")
        main
        ;;
    *)
        log_error "未知选项: $1"
        echo "使用 $0 --help 查看帮助"
        exit 1
        ;;
esac