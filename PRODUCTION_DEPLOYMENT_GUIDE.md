# 生产环境部署指南

## 概述

本文档描述了基于主分支的生产环境部署流程。该方案简化了部署流程，只使用main分支进行生产环境部署，通过Jenkins手动触发构建。

## 部署架构

### 分支策略
- **主分支 (main)**: 唯一的生产分支，所有生产部署都基于此分支
- **开发流程**: 在本地开发完成后直接提交到main分支

### Jenkins配置
- **项目**: tbk-pipeline
- **监控分支**: 仅main分支 (`*/main`)
- **构建脚本**: Jenkinsfile.aliyun
- **触发方式**: 手动触发（自动构建已禁用）

## 部署流程

### 1. 本地开发
```bash
# 在本地进行开发
git checkout main
git pull origin main

# 进行代码修改
# ... 开发工作 ...

# 提交代码到main分支
git add .
git commit -m "feat: 添加新功能"
git push origin main
```

### 2. 手动触发Jenkins构建

#### 方式一：通过Jenkins Web界面
1. 访问Jenkins: http://localhost:8080
2. 登录Jenkins（用户名: admin）
3. 点击 "tbk-pipeline" 项目
4. 点击 "立即构建" 按钮

#### 方式二：通过管理脚本
```bash
# 检查项目状态
./manage-auto-build.sh --status

# 查看所有项目
./manage-auto-build.sh --list
```

### 3. 构建流程

Jenkins将执行以下步骤：

1. **代码检出** - 从main分支拉取最新代码
2. **环境设置** - 配置Node.js和Docker环境
3. **依赖安装** - 安装项目依赖 (`npm ci`)
4. **代码分析** - 运行ESLint代码检查
5. **单元测试** - 执行Jest测试套件
6. **Docker镜像构建** - 构建应用Docker镜像
7. **推送到阿里云ACR** - 上传镜像到阿里云容器镜像服务
8. **数据库迁移** - 执行数据库变更
9. **部署到阿里云ECS** - 部署到生产服务器
10. **部署后测试** - 运行健康检查和集成测试

### 4. 部署验证

构建完成后，验证部署是否成功：

```bash
# 检查应用健康状态
curl -f http://your-production-domain/health

# 查看应用日志
docker logs your-app-container
```

## 配置信息

### Docker镜像配置
- **镜像仓库**: crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com
- **命名空间**: hanchanglin
- **应用名称**: tbk
- **标签格式**: `{BUILD_NUMBER}-{GIT_COMMIT_SHORT}`

### 环境变量
- `DOCKER_REGISTRY`: 阿里云ACR地址
- `DOCKER_NAMESPACE`: 镜像命名空间
- `APP_NAME`: 应用名称
- `NODE_VERSION`: Node.js版本 (18)

## 管理命令

### 项目状态管理
```bash
# 查看所有项目状态
./manage-auto-build.sh --list

# 查看特定项目状态
./manage-auto-build.sh --status tbk-pipeline

# 如需重新启用自动构建（不推荐）
./manage-auto-build.sh --enable tbk-pipeline

# 确保自动构建禁用
./manage-auto-build.sh --disable tbk-pipeline
```

### Jenkins服务管理
```bash
# 启动Jenkins
docker compose up -d

# 停止Jenkins
docker compose down

# 查看Jenkins日志
docker compose logs -f jenkins
```

## 安全注意事项

1. **分支保护**: 建议在GitHub上设置main分支保护规则
2. **代码审查**: 重要变更应通过Pull Request进行代码审查
3. **备份策略**: 定期备份Jenkins配置和构建历史
4. **访问控制**: 确保只有授权人员可以触发生产部署

## 故障排除

### 常见问题

1. **构建失败**
   - 检查代码是否通过测试
   - 查看Jenkins构建日志
   - 验证Docker镜像构建过程

2. **部署失败**
   - 检查阿里云ECS连接
   - 验证镜像是否成功推送到ACR
   - 查看应用启动日志

3. **Jenkins无法访问**
   - 确认Docker容器正在运行
   - 检查端口8080是否被占用
   - 查看Jenkins容器日志

### 回滚策略

如果部署出现问题，可以：

1. 回滚到上一个稳定版本的Docker镜像
2. 使用Git回滚到上一个稳定的commit
3. 重新触发Jenkins构建

## 联系信息

如有问题，请联系开发团队或查看相关文档：
- Jenkins配置文档: `DISABLE_AUTO_BUILD_SUMMARY.md`

- 公共访问指南: `PUBLIC_ACCESS_GUIDE.md`

---

**最后更新**: 2025年10月3日
**版本**: 1.0