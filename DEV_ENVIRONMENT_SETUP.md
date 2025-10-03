# TBK 开发环境配置指南

## 概述

本文档描述了为 TBK (桃百科) 项目配置的完整开发环境，包括代码和数据库的开发环境支持。

## 环境类型

### 1. 本地环境 (Local)
- **代码**: 本地代码
- **数据库**: 本地 Docker MySQL
- **端口**: 3000
- **配置文件**: `.env.local`

### 2. 开发环境 (Development)
- **代码**: 开发分支代码 (develop)
- **数据库**: 阿里云在线数据库
- **端口**: 3000 (本地运行) / 3001 (Docker容器)
- **配置文件**: `.env` / `.env.dev`

### 3. 生产环境 (Production)
- **代码**: 主分支代码 (main)
- **数据库**: 阿里云生产数据库
- **端口**: 3000
- **配置文件**: `.env.production`

## 开发环境配置文件

### 1. Docker 配置

#### Dockerfile.dev
```dockerfile
FROM node:18
ENV NODE_ENV=development
ENV PORT=3000
# 包含开发工具和热重载支持
```

#### docker-compose.dev.yml
```yaml
services:
  tbk-dev:
    build:
      dockerfile: Dockerfile.dev
    environment:
      - NODE_ENV=development
    ports:
      - "3001:3000"
  mysql-dev:
    image: mysql:8.0
  redis-dev:
    image: redis:7-alpine
```

### 2. Jenkins 配置

#### Jenkinsfile.develop
- 支持 `develop` 分支的自动化部署
- 环境变量: `NODE_ENV=development`
- 开发端口: `DEV_PORT=3001`
- 包含完整的 CI/CD 流程

#### Jenkins Pipeline
- **Pipeline 名称**: `tbk-dev-pipeline`
- **触发分支**: `develop`, `feature/*`
- **构建参数**: `FORCE_REBUILD`, `SKIP_TESTS`, `LOG_LEVEL`

### 3. 部署脚本

#### deploy-dev.sh
```bash
# 自动化开发环境部署
- 环境检查
- 容器清理
- 环境配置
- 服务部署
- 健康检查
```

#### stop-dev.sh
```bash
# 停止开发环境
- 停止服务
- 清理容器
- 可选清理卷和镜像
```

## 环境切换

### 使用环境切换脚本

位置: `tbk/scripts/switch-env.sh`

```bash
# 查看当前状态
./scripts/switch-env.sh status

# 切换到本地环境
./scripts/switch-env.sh local

# 切换到开发环境
./scripts/switch-env.sh development

# 切换到生产环境
./scripts/switch-env.sh production

# 停止当前服务
./scripts/switch-env.sh stop

# 查看帮助
./scripts/switch-env.sh help
```

### 手动切换

```bash
# 开发环境
NODE_ENV=development npm start

# 本地环境
NODE_ENV=local npm start

# 生产环境
NODE_ENV=production npm start
```

## Jenkins 自动化部署

### 开发环境 CI/CD 流程

1. **代码检出**: 从 `develop` 分支拉取代码
2. **环境设置**: 配置开发环境变量
3. **依赖安装**: `npm install`
4. **代码质量检查**: ESLint, Prettier
5. **单元测试**: Jest 测试套件
6. **构建 Docker 镜像**: 使用 `Dockerfile.dev`
7. **推送镜像**: 推送到开发镜像仓库
8. **部署服务**: 部署到开发环境
9. **健康检查**: 验证服务状态
10. **冒烟测试**: 基本功能测试

### 触发条件

- **自动触发**: `develop` 分支代码推送
- **手动触发**: Jenkins 控制台手动构建
- **定时触发**: 可配置定时构建

## 测试和验证

### 配置测试

```bash
# 运行配置测试脚本
./scripts/test-dev-config.sh
```

测试内容:
- ✅ 必要文件存在性检查
- ✅ Docker 配置验证
- ✅ Jenkins 配置验证
- ✅ 脚本权限检查
- ✅ 环境变量配置检查

### 部署测试

```bash
# 部署开发环境
./scripts/deploy-dev.sh

# 停止开发环境
./scripts/stop-dev.sh
```

## 访问地址

- **本地环境**: http://localhost:3000
- **开发环境 (本地运行)**: http://localhost:3000
- **开发环境 (Docker)**: http://localhost:3001
- **生产环境**: http://localhost:3000

## 数据库连接

### 本地环境
- **主机**: localhost
- **端口**: 3306
- **数据库**: peach_wiki_local

### 开发/生产环境
- **主机**: 60.205.0.185
- **端口**: 3306
- **数据库**: peach_wiki

## 故障排除

### 常见问题

1. **Docker 镜像拉取失败**
   - 检查网络连接
   - 尝试使用国内镜像源

2. **端口冲突**
   - 检查端口占用: `lsof -i :3000`
   - 停止冲突服务或更改端口

3. **数据库连接失败**
   - 检查网络连接
   - 验证数据库凭据
   - 确认数据库服务状态

4. **Jenkins 构建失败**
   - 检查 Jenkins 日志
   - 验证 Git 凭据
   - 确认构建环境

## 维护和更新

### 定期维护

1. **更新依赖**: 定期更新 npm 包
2. **清理镜像**: 清理未使用的 Docker 镜像
3. **日志清理**: 清理旧的构建日志
4. **备份配置**: 备份 Jenkins 配置

### 配置更新

1. **环境变量**: 更新 `.env.*` 文件
2. **Docker 配置**: 更新 Dockerfile 和 docker-compose 文件
3. **Jenkins 配置**: 更新 Jenkinsfile 和 pipeline 配置

## 总结

通过以上配置，TBK 项目现在支持:

✅ **完整的环境隔离**: 本地、开发、生产环境完全分离
✅ **自动化部署**: Jenkins CI/CD 流程
✅ **便捷的环境切换**: 一键切换脚本
✅ **Docker 容器化**: 开发环境容器化部署
✅ **配置验证**: 自动化配置测试
✅ **故障排除**: 完整的故障排除指南

这个配置确保了开发团队可以在不同环境之间无缝切换，同时保持代码和数据库环境的一致性。