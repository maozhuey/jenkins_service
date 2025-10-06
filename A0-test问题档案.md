# A0-test文档档案

## 核心问题概述 (Core Problem Summary):
["我的Jenkins在我本地运行，我使用Jenkins将tbk项目部署到阿里云docker中时，在构建过程中总是在部署阶段失败"]

## 期望行为 (Expected Behavior):
["Jenkins构建应该成功部署到阿里云docker，所有容器正常启动，服务可访问。"]

## 实际行为与完整错误日志 (Actual Behavior & Full Error Log):
set -e
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
Using strategy: rolling
Error response from daemon: network with name tbk_app-network already exists
time="2025-10-06T15:34:28+08:00" level=warning msg="/opt/apps/tbk/aliyun-ecs-deploy.yml: `version` is obsolete"
 Network tbk_tbk-production-network  Removing
 Network tbk_tbk-production-network  Resource is still in use
Deleted Networks:
tbk_app-network

Pulling latest image...
time="2025-10-06T15:34:28+08:00" level=warning msg="/opt/apps/tbk/aliyun-ecs-deploy.yml: `version` is obsolete"
 tbk-production Pulling 
 tbk-production Pulled 
Starting services (rolling)...
time="2025-10-06T15:34:29+08:00" level=warning msg="/opt/apps/tbk/aliyun-ecs-deploy.yml: `version` is obsolete"
 tbk-production Pulling 
 tbk-production Pulled 
Error response from daemon: network tbk_app-network not found

## 完整的错误日志与堆栈追踪:
```
[请在此处粘贴从Jenkins、Docker、阿里云ECS等服务捕获的、未经删减的完整错误日志和堆栈追踪。]
```

## 复现步骤:
1. [步骤1]:打开Jenkins
2. [步骤2]：开始构建，并启动默认部署到生产环境
3. [步骤3]：等待构建结果


## 已尝试的修复方案:
见文档：A0-test修复记录
## 其他相关信息:
[任何其他可能相关的信息，如最近的配置变更、环境变化等]

---
*请填写完整信息后告知我继续诊断流程*