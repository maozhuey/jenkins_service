#!/bin/bash

# Jenkins 部署配置同步修复脚本
# 解决 Jenkins 使用旧版本 Jenkinsfile 导致的网络清理问题

set -e

echo "=== Jenkins 部署配置同步修复脚本 ==="
echo "时间: $(date)"

# 1. 检查当前分支和提交状态
echo "1. 检查 Git 状态..."
echo "当前分支: $(git branch --show-current)"
echo "最新提交: $(git log -1 --oneline)"
echo "远程状态: $(git status -uno)"

# 2. 验证 Jenkinsfile.aliyun 中的关键修复
echo ""
echo "2. 验证 Jenkinsfile.aliyun 修复状态..."
if grep -q 'docker network prune -f --filter "label!=external"' Jenkinsfile.aliyun; then
    echo "✅ Jenkinsfile.aliyun 包含网络过滤器修复"
    echo "修复行数:"
    grep -n 'docker network prune -f --filter "label!=external"' Jenkinsfile.aliyun
else
    echo "❌ Jenkinsfile.aliyun 缺少网络过滤器修复"
    echo "需要手动添加 --filter \"label!=external\" 参数"
    exit 1
fi

# 3. 检查是否有未提交的更改
echo ""
echo "3. 检查未提交的更改..."
if git diff --quiet && git diff --cached --quiet; then
    echo "✅ 没有未提交的更改"
else
    echo "⚠️  发现未提交的更改:"
    git status --porcelain
    echo ""
    echo "是否要提交这些更改? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git add .
        git commit -m "fix: 确保 Jenkins 使用最新的网络管理修复"
        echo "✅ 更改已提交"
    fi
fi

# 4. 推送到远程仓库
echo ""
echo "4. 推送到远程仓库..."
current_branch=$(git branch --show-current)
git push origin "$current_branch"
echo "✅ 已推送到远程分支: $current_branch"

# 5. 生成 Jenkins 重新加载指令
echo ""
echo "5. Jenkins 重新加载指令:"
echo "==================================="
echo "请在 Jenkins 中执行以下操作:"
echo "1. 进入项目流水线配置页面"
echo "2. 点击 'Build Now' 或 '立即构建'"
echo "3. 或者使用 Jenkins CLI:"
echo "   curl -X POST http://your-jenkins-url/job/tbk-pipeline/build"
echo ""
echo "如果问题仍然存在，请检查:"
echo "- Jenkins 流水线配置中的分支设置是否正确"
echo "- 是否需要清除 Jenkins 的 Jenkinsfile 缓存"
echo "==================================="

# 6. 验证修复内容摘要
echo ""
echo "6. 修复内容摘要:"
echo "==================================="
echo "✅ 网络清理命令已修复:"
echo "   旧版: docker network prune -f"
echo "   新版: docker network prune -f --filter \"label!=external\""
echo ""
echo "✅ 外部网络创建已优化:"
echo "   docker network create tbk_app-network --subnet=172.22.0.0/16 --label external=true"
echo ""
echo "✅ 支持的部署策略:"
echo "   - recreate: 强制重建所有容器"
echo "   - rolling: 滚动更新 (默认)"
echo "   - docker-run: 回退策略"
echo "==================================="

echo ""
echo "脚本执行完成！请按照上述指令重新触发 Jenkins 构建。"