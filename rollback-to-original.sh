#!/bin/bash

# Jenkins回滚脚本 - 恢复到迁移前的原始状态
# 使用方法: ./rollback-to-original.sh

set -e

echo "🔄 开始Jenkins回滚操作..."
echo "⚠️  这将恢复Jenkins到迁移前的原始状态"
echo ""

# 确认操作
read -p "确认要继续回滚操作吗？(y/N): " confirm
if [[ $confirm != [yY] ]]; then
    echo "❌ 回滚操作已取消"
    exit 1
fi

echo ""
echo "📋 回滚计划："
echo "1. 停止当前Jenkins容器"
echo "2. 恢复原始凭据配置"
echo "3. 清理迁移过程中添加的文件"
echo "4. 恢复原始docker-compose配置"
echo "5. 重新启动Jenkins"
echo ""

# 步骤1: 停止Jenkins容器
echo "🛑 停止Jenkins容器..."
docker stop jenkins || echo "Jenkins容器可能已经停止"

# 步骤2: 恢复原始凭据配置
echo "🔧 恢复原始凭据配置..."
if [ -f "jenkins_home/credentials.xml.backup" ]; then
    cp jenkins_home/credentials.xml.backup jenkins_home/credentials.xml
    echo "✅ 凭据配置已恢复"
else
    echo "❌ 未找到原始凭据备份文件"
    exit 1
fi

# 步骤3: 清理迁移过程中的工作空间
echo "🧹 清理工作空间..."
if [ -d "jenkins_home/workspace/tbk-pipeline_main" ]; then
    rm -rf jenkins_home/workspace/tbk-pipeline_main
    echo "✅ 已清理tbk-pipeline_main工作空间"
fi

# 清理构建历史（可选）
echo "🗑️  清理构建历史..."
if [ -d "jenkins_home/jobs/tbk-pipeline" ]; then
    rm -rf jenkins_home/jobs/tbk-pipeline
    echo "✅ 已清理tbk-pipeline构建历史"
fi

# 步骤4: 创建原始的docker-compose配置
echo "📝 恢复原始docker-compose配置..."
cat > docker-compose.yml << 'EOF'
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    restart: unless-stopped
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - ./jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker
    environment:
      - JENKINS_OPTS=--httpPort=8080
      - JAVA_OPTS=-Djenkins.install.runSetupWizard=false
    networks:
      - jenkins-network
    user: root

networks:
  jenkins-network:
    driver: bridge

volumes:
  jenkins_home:
EOF

echo "✅ docker-compose.yml已恢复为原始配置"

# 步骤5: 清理迁移过程中添加的文件
echo "🧹 清理迁移过程中添加的文件..."

# 清理新增的Jenkinsfile
if [ -f "Jenkinsfile.dockerhub" ]; then
    rm -f Jenkinsfile.dockerhub
    echo "✅ 已删除Jenkinsfile.dockerhub"
fi

if [ -f "Jenkinsfile.improved" ]; then
    rm -f Jenkinsfile.improved
    echo "✅ 已删除Jenkinsfile.improved"
fi

# 清理新增的配置文件
if [ -f "docker-compose.improved.yml" ]; then
    rm -f docker-compose.improved.yml
    echo "✅ 已删除docker-compose.improved.yml"
fi

if [ -f "pipeline-config.xml" ]; then
    rm -f pipeline-config.xml
    echo "✅ 已删除pipeline-config.xml"
fi

# 清理scripts目录（保留原始脚本）
echo "🧹 清理scripts目录..."
if [ -d "scripts" ]; then
    # 保留可能有用的脚本，删除迁移相关的脚本
    rm -f scripts/setup-dockerhub-credentials.sh
    rm -f scripts/configure-jenkins.sh
    rm -f scripts/diagnose-connectivity.sh
    rm -f scripts/robust-deploy.sh
    rm -f scripts/verify-deployment.sh
    rm -f scripts/configure-email.sh
    rm -f scripts/setup-jenkins-ssh.sh
    echo "✅ 已清理迁移相关脚本"
fi

# 清理docs目录
if [ -d "docs" ]; then
    rm -rf docs
    echo "✅ 已删除docs目录"
fi

# 清理nginx目录
if [ -d "nginx" ]; then
    rm -rf nginx
    echo "✅ 已删除nginx目录"
fi

# 清理jenkins_agent_workdir
if [ -d "jenkins_agent_workdir" ]; then
    rm -rf jenkins_agent_workdir
    echo "✅ 已删除jenkins_agent_workdir"
fi

# 清理markdown文档
rm -f 构建日志.md
rm -f 部署问题解决方案使用指南.md
rm -f 问题解决方案.md

# 步骤6: 重新启动Jenkins
echo "🚀 重新启动Jenkins..."
docker-compose up -d

echo "⏳ 等待Jenkins启动..."
sleep 30

# 检查Jenkins状态
if docker ps | grep -q jenkins; then
    echo "✅ Jenkins已成功启动"
    echo ""
    echo "🎉 回滚操作完成！"
    echo ""
    echo "📋 回滚后的状态："
    echo "- Jenkins已恢复到迁移前的原始配置"
    echo "- 只保留了原始的SSH凭据 (git-credentials)"
    echo "- 清理了所有迁移过程中添加的文件和配置"
    echo "- Jenkins可通过 http://localhost:8080 访问"
    echo ""
    echo "🔍 下一步："
    echo "1. 访问 http://localhost:8080 确认Jenkins正常运行"
    echo "2. 检查原始的SSH凭据是否正常工作"
    echo "3. 如需要，重新配置必要的凭据和项目"
else
    echo "❌ Jenkins启动失败，请检查日志"
    docker logs jenkins
    exit 1
fi

echo ""
echo "📝 备份文件位置："
echo "- 当前凭据备份: jenkins_home/credentials.xml.rollback-backup.*"
echo "- docker-compose备份: docker-compose.yml.rollback-backup.*"
echo ""
echo "⚠️  如果需要恢复迁移后的配置，可以使用这些备份文件"