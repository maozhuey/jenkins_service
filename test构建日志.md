+ set -e
+ echo Connecting to Aliyun ECS host...
Connecting to Aliyun ECS host...
+ pwd
+ pwd
+ pwd
+ pwd
+ pwd
+ pwd
+ ssh -o StrictHostKeyChecking=no root@60.205.0.185 
                              set -e
                              cd /opt/apps/tbk
                              echo 'Cleaning up existing containers and networks...'
                              docker network create tbk_app-network || true
                              ENV_ARG=''
                              if [ -f .env.production ]; then ENV_ARG='--env-file .env.production'; fi
                              DEPLOY_STRATEGY='rolling'
                              echo Using strategy: rolling
                              case rolling in
                                recreate)
                                  docker compose  -f aliyun-ecs-deploy.yml down --remove-orphans || true
                                  docker network prune -f || true
                                  echo 'Pulling latest image...'
                                  docker compose  -f aliyun-ecs-deploy.yml pull tbk-production
                                  echo 'Starting services with force recreate...'
                                  docker compose  -f aliyun-ecs-deploy.yml up -d --force-recreate tbk-production nginx-production
                                  ;;
                                docker-run)
                                  echo 'Using docker-run fallback strategy...'
                                  docker rm -f nginx-production tbk-production || true
                                  docker network create tbk-production-network || true
                                  echo 'Pulling latest image...'
                                  docker pull crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest
                                  DOCKER_RUN_ENV=''
                                  if [ -f .env.production ]; then DOCKER_RUN_ENV='--env-file .env.production'; fi
                                  echo 'Starting app container...'
                                  docker run -d --name tbk-production --restart unless-stopped                                     --network tbk-production-network                                     -v /var/jenkins_home/workspace/tbk-pipeline/logs:/app/logs -v /var/jenkins_home/workspace/tbk-pipeline/uploads:/app/uploads -v /var/jenkins_home/workspace/tbk-pipeline/ssl:/app/ssl:ro                                                                          crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest
                                  echo 'Connecting app to external MySQL network...'
                                  docker network connect tbk_app-network tbk-production || true
                                  echo 'Starting nginx container...'
                                  docker run -d --name nginx-production --restart unless-stopped                                     --network tbk-production-network                                     -p 8080:80 -p 8443:443                                     -v /var/jenkins_home/workspace/tbk-pipeline/nginx/production.conf:/etc/nginx/conf.d/default.conf:ro                                     -v /var/jenkins_home/workspace/tbk-pipeline/ssl:/etc/nginx/ssl:ro                                     -v /var/jenkins_home/workspace/tbk-pipeline/logs/nginx:/var/log/nginx                                     nginx:alpine
                                  ;;
                                *)
                                  docker compose  -f aliyun-ecs-deploy.yml down --remove-orphans || true
                                  docker network prune -f || true
                                  echo 'Pulling latest image...'
                                  docker compose  -f aliyun-ecs-deploy.yml pull tbk-production
                                  echo 'Starting services (rolling)...'
                                  docker compose  -f aliyun-ecs-deploy.yml up -d tbk-production nginx-production
                                  ;;
                              esac
                              echo 'Waiting for services to start...'
                              sleep 10
                              echo 'Checking service health...'
                              for i in 1 2 3; do
                                  if curl -fsSL http://localhost:8080/api/health; then
                                      echo 'Health check passed!'
                                      break
                                  else
                                      echo Health check attempt failed, retrying in 5 seconds...
                                      sleep 5
                                  fi
                              done
                              echo 'Deployment completed'
                            
Cleaning up existing containers and networks...
Error response from daemon: network with name tbk_app-network already exists
Using strategy: rolling
time="2025-10-05T05:40:58+08:00" level=warning msg="/opt/apps/tbk/aliyun-ecs-deploy.yml: `version` is obsolete"
 Container fluentd-production  Stopping
 Container nginx-production  Stopping
 Container portainer-production  Stopping
 Container fluentd-production  Stopped
 Container fluentd-production  Removing
 Container fluentd-production  Removed
 Container portainer-production  Stopped
 Container portainer-production  Removing
 Container portainer-production  Removed
 Container nginx-production  Stopped
 Container nginx-production  Removing
 Container nginx-production  Removed
 Container tbk-production  Stopping
 Container tbk-production  Stopped
 Container tbk-production  Removing
 Container tbk-production  Removed
 Container redis-production  Stopping
 Container redis-production  Stopped
 Container redis-production  Removing
 Container redis-production  Removed
 Network tbk_tbk-production-network  Removing
 Network tbk_tbk-production-network  Removed
Deleted Networks:
tbk_app-network

Pulling latest image...
time="2025-10-05T05:40:58+08:00" level=warning msg="/opt/apps/tbk/aliyun-ecs-deploy.yml: `version` is obsolete"
 tbk-production Pulling 
 tbk-production Pulled 
Starting services (rolling)...
time="2025-10-05T05:40:59+08:00" level=warning msg="/opt/apps/tbk/aliyun-ecs-deploy.yml: `version` is obsolete"
 tbk-production Pulling 
 tbk-production Pulled 
 Network tbk_tbk-production-network  Creating
 Network tbk_tbk-production-network  Created
Error response from daemon: network tbk_app-network not found

## 问题分析与修复记录

### 第二次构建失败 (2025-10-05)

#### 发现的问题
1. **配置文件被覆盖**：生产环境的 `aliyun-ecs-deploy.yml` 又出现了 `version: '3.8'` 警告
2. **网络错误重现**：`Error response from daemon: network tbk_app-network not found`
3. **根本原因**：Jenkins部署时会从本地的 `docker-compose.production.yml` 复制到生产环境并重命名为 `aliyun-ecs-deploy.yml`，但本地文件没有修复

#### 修复措施
1. **修复本地配置文件**：
   - 移除本地 `docker-compose.production.yml` 中的 `version: '3.8'`
   - 从生产环境复制正确的网络配置到本地
   - 提交并推送到Git仓库

2. **修复fluentd配置**：
   - 发现 `/opt/apps/tbk/fluentd/fluent.conf` 是目录而不是文件
   - 删除错误的目录，创建正确的配置文件

3. **创建缺失的网络**：
   - 手动创建 `tbk_app-network` 外部网络

#### 验证结果
- ✅ 所有容器正常启动
- ✅ 没有 `version is obsolete` 警告
- ✅ 没有网络错误
- ✅ HTTP访问返回 200 OK
- ✅ 服务健康检查通过

### 第一次构建失败记录

#### 发现的问题
1. **网络冲突问题**：
   - `tbk_app-network` 网络存在冲突
   - 部署脚本中网络创建和删除逻辑不一致
   - 主目录和jenkins_home中的配置文件网络配置不统一

2. **Docker Compose版本警告**：
   - `version: '3.8'` 字段已过时，导致构建警告

3. **配置不一致**：
   - 数据库连接配置在不同文件中不一致
   - 端口配置可能导致冲突

### 修复措施
1. **移除过时的version字段**：
   - 从 `aliyun-ecs-deploy.yml` 中移除 `version: '3.8'`

2. **统一网络配置**：
   - 在主配置文件中添加 `tbk_app-network` 外部网络
   - 确保 `tbk-production` 服务连接到两个网络：
     - `tbk-production-network`（内部网络）
     - `tbk_app-network`（外部网络，用于MySQL连接）

3. **优化部署脚本**：
   - 在 `Jenkinsfile.aliyun` 中优化网络创建逻辑
   - 确保在所有部署策略中都正确创建网络

4. **统一数据库配置**：
   - 使用 `tbk-mysql` 作为数据库主机
   - 统一数据库用户名和密码配置

5. **优化端口配置**：
   - 使用 `expose` 而不是 `ports` 避免端口冲突

### 验证结果
✅ 所有配置验证通过：
- Docker Compose文件语法正确
- 网络配置完整
- 环境变量配置正确
- 端口配置优化
- 健康检查配置存在

### 修复时间
- 修复日期：2025年1月5日
- 修复人员：hanchanglin
- 验证状态：通过

---

## 第二次部署失败与修复记录

### 问题发现
2025年1月5日再次部署失败，发现问题：
1. **配置文件未同步**：生产环境中的 `aliyun-ecs-deploy.yml` 仍然是旧版本
2. **nginx配置错误**：nginx配置文件中upstream指向错误的服务名和端口

### 根本原因分析
- 本地修复的配置文件没有部署到生产环境
- nginx配置文件中 `server tbk-app:8080;` 应该是 `server tbk-production:3000;`

### 修复措施
1. **同步配置文件**：
   ```bash
   scp aliyun-ecs-deploy.yml root@60.205.0.185:/opt/apps/tbk/
   ```

2. **修复nginx配置**：
   ```bash
   sed -i 's/server tbk-app:8080;/server tbk-production:3000;/' nginx/production.conf
   ```

3. **重新部署验证**：
   - 清理现有容器
   - 重新启动服务
   - 验证网络连接

### 最终验证结果
✅ **部署成功**：
- 所有容器正常运行：
  - `tbk-production`: Up (health: starting)
  - `nginx-production`: Up (health: starting) 
  - `redis-production`: Up (healthy)
- 网络配置正确，无错误信息
- HTTP响应正常：`HTTP/1.1 200 OK`
- 无Docker Compose版本警告
- 无网络找不到错误

### 最终修复时间
- 第二次修复日期：2025年1月5日
- 修复人员：hanchanglin
- 最终验证状态：✅ 完全成功


