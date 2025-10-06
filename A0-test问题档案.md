# A0-test文档档案

## 核心问题概述 (Core Problem Summary):
["我的Jenkins在我本地运行，我使用Jenkins将tbk项目部署到阿里云docker中时，在构建过程中总是在部署阶段失败"]

## 期望行为 (Expected Behavior):
["Jenkins构建应该成功部署到阿里云docker，所有容器正常启动，服务可访问。"]

## 实际行为与完整错误日志 (Actual Behavior & Full Error Log):
["在部署阶段失败，构建日志信息为：
Started by user admin

Obtained Jenkinsfile.aliyun from git git@github.com:maozhuey/tbk.git
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins
 in /var/jenkins_home/workspace/tbk-pipeline
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
The recommended git tool is: git
Warning: CredentialId "git-credentials" could not be found.
 > git rev-parse --resolve-git-dir /var/jenkins_home/workspace/tbk-pipeline/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url git@github.com:maozhuey/tbk.git # timeout=10
Fetching upstream changes from git@github.com:maozhuey/tbk.git
 > git --version # timeout=10
 > git --version # 'git version 2.39.5'
 > git fetch --tags --force --progress -- git@github.com:maozhuey/tbk.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision c64c70940f2c03320caa2b7516abfc00dc3cb52a (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f c64c70940f2c03320caa2b7516abfc00dc3cb52a # timeout=10
Commit message: "策略C修复：恢复config-loader.sh运行时上传逻辑"
 > git rev-list --no-walk c64c70940f2c03320caa2b7516abfc00dc3cb52a # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Checkout)
[Pipeline] echo
🔄 Checking out code from repository...
[Pipeline] echo
🌿 Target Branch: main (生产环境)
[Pipeline] echo
📝 Branch Info: main (生产环境)
[Pipeline] checkout
The recommended git tool is: git
Warning: CredentialId "git-credentials" could not be found.
 > git rev-parse --resolve-git-dir /var/jenkins_home/workspace/tbk-pipeline/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url git@github.com:maozhuey/tbk.git # timeout=10
Fetching upstream changes from git@github.com:maozhuey/tbk.git
 > git --version # timeout=10
 > git --version # 'git version 2.39.5'
 > git fetch --tags --force --progress -- git@github.com:maozhuey/tbk.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision c64c70940f2c03320caa2b7516abfc00dc3cb52a (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f c64c70940f2c03320caa2b7516abfc00dc3cb52a # timeout=10
Commit message: "策略C修复：恢复config-loader.sh运行时上传逻辑"
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ git rev-parse --short HEAD
[Pipeline] }
[Pipeline] // script
[Pipeline] echo
✅ Code checkout completed
[Pipeline] echo
📋 Build Info: Build #31, Branch: main, Commit: c64c709
[Pipeline] echo
🎯 Production Deploy: true
[Pipeline] echo
🔒 Auto Deploy Enabled: true
[Pipeline] echo
📋 Deploy Strategy: rolling
[Pipeline] echo
🌐 Deploy Env: production
[Pipeline] script
[Pipeline] {
[Pipeline] echo
🛡️ Branch Security Check:
[Pipeline] echo
   - Current Branch: main
[Pipeline] echo
   - Is Main Branch: true
[Pipeline] echo
   - Production Deploy Allowed: true
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Resolve Config by DEPLOY_ENV and PROJECT)
[Pipeline] echo
🧭 Resolving env and compose files from configuration...
[Pipeline] script
[Pipeline] {
[Pipeline] readJSON
[Pipeline] echo
📦 PROJECT: tbk
[Pipeline] echo
🌐 DEPLOY_ENV: production
[Pipeline] echo
📄 ENV_FILE: .env.production
[Pipeline] echo
🗂️ LOCAL COMPOSE: docker-compose.production.yml
[Pipeline] echo
🗂️ REMOTE COMPOSE: aliyun-ecs-deploy.yml
[Pipeline] echo
📍 ECS_DEPLOY_PATH: /opt/apps/tbk
[Pipeline] echo
❤️ HEALTH_CHECK_URL: http://60.205.0.185/api/health
[Pipeline] }
[Pipeline] // script
[Pipeline] echo
✅ Configuration resolved
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Environment Setup)
[Pipeline] echo
🔧 Setting up build environment...
[Pipeline] sh
+ echo Node.js version:
Node.js version:
+ node --version
v18.20.8
+ echo NPM version:
NPM version:
+ npm --version
10.8.2
+ echo Docker version:
Docker version:
+ docker --version
Docker version 28.5.0, build 887030f
[Pipeline] echo
✅ Environment setup completed
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Install Dependencies)
[Pipeline] echo
📦 Installing project dependencies...
[Pipeline] sh
+ npm ci --only=production
npm warn config only Use `--omit=dev` to omit dev dependencies from the install.

added 93 packages, and audited 94 packages in 2s

18 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
+ echo Dependencies installed successfully
Dependencies installed successfully
[Pipeline] echo
✅ Dependencies installation completed
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Code Analysis)
[Pipeline] echo
🔍 Running code analysis...
[Pipeline] sh
+ echo Running ESLint...
Running ESLint...
+ npx eslint . --ext .js,.jsx,.ts,.tsx --format compact

Oops! Something went wrong! :(

ESLint: 9.37.0

ESLint couldn't find an eslint.config.(js|mjs|cjs) file.

From ESLint v9.0.0, the default configuration file is now eslint.config.js.
If you are using a .eslintrc.* file, please follow the migration guide
to update your configuration file to the new format:

https://eslint.org/docs/latest/use/configure/migration-guide

If you still have problems after following the migration guide, please stop by
https://eslint.org/chat/help to chat with the team.

+ true
+ echo Code analysis completed
Code analysis completed
[Pipeline] echo
✅ Code analysis completed
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Unit Tests)
[Pipeline] echo
🧪 Running unit tests...
[Pipeline] sh
+ echo Running Jest tests...
Running Jest tests...
+ npm test -- --coverage --watchAll=false

> peach-wiki-backend@1.0.0 test
> echo 'Tests completed - no tests configured' --coverage --watchAll=false

Tests completed - no tests configured --coverage --watchAll=false
+ echo Unit tests completed
Unit tests completed
[Pipeline] echo
✅ Unit tests completed
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Build Docker Image)
[Pipeline] echo
🐳 Building Docker image...
[Pipeline] script
[Pipeline] {
[Pipeline] echo
Preparing multi-arch build: crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:31-c64c709 (+ latest)
[Pipeline] echo
Image will be built and pushed in next stage using buildx
[Pipeline] }
[Pipeline] // script
[Pipeline] echo
✅ Docker image build completed
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Push to Aliyun ACR)
[Pipeline] echo
📤 Pushing Docker image to Aliyun ACR...
[Pipeline] script
[Pipeline] {
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withDockerRegistry
$ docker login -u aliyun7971892098 -p ******** https://crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com
WARNING! Using --password via the CLI is insecure. Use --password-stdin.

WARNING! Your credentials are stored unencrypted in '/var/jenkins_home/workspace/tbk-pipeline@tmp/aac33ecf-8669-418e-99ee-8f1b843dccc7/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded
[Pipeline] {
[Pipeline] sh
+ set -e
+ docker buildx create --use --name tbk-builder
tbk-builder
+ docker buildx inspect --bootstrap
Name:          tbk-builder
Driver:        docker-container
Last Activity: 2025-10-06 15:19:51 +0000 UTC

Nodes:
Name:                  tbk-builder0
Endpoint:              unix:///var/run/docker.sock
Status:                running
BuildKit daemon flags: --allow-insecure-entitlement=network.host
BuildKit version:      v0.24.0
Platforms:             linux/arm64, linux/amd64, linux/amd64/v2, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
Labels:
 org.mobyproject.buildkit.worker.executor:         oci
 org.mobyproject.buildkit.worker.hostname:         e7f7a5b5d8a7
 org.mobyproject.buildkit.worker.network:          host
 org.mobyproject.buildkit.worker.oci.process-mode: sandbox
 org.mobyproject.buildkit.worker.selinux.enabled:  false
 org.mobyproject.buildkit.worker.snapshotter:      overlayfs
GC Policy rule#0:
 All:            false
 Filters:        type==source.local,type==exec.cachemount,type==source.git.checkout
 Keep Duration:  48h0m0s
 Max Used Space: 488.3MiB
GC Policy rule#1:
 All:            false
 Keep Duration:  1440h0m0s
 Reserved Space: 9.313GiB
 Max Used Space: 93.13GiB
 Min Free Space: 188.1GiB
GC Policy rule#2:
 All:            false
 Reserved Space: 9.313GiB
 Max Used Space: 93.13GiB
 Min Free Space: 188.1GiB
GC Policy rule#3:
 All:            true
 Reserved Space: 9.313GiB
 Max Used Space: 93.13GiB
 Min Free Space: 188.1GiB
+ echo Building and pushing multi-arch image (amd64, arm64)...
Building and pushing multi-arch image (amd64, arm64)...
+ docker buildx build --platform linux/amd64,linux/arm64 -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:31-c64c709 -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest --push .
#0 building with "tbk-builder" instance using docker-container driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 957B done
#1 DONE 0.0s

#2 [linux/amd64 internal] load metadata for docker.io/library/node:18-alpine
#2 ...

#3 [linux/arm64 internal] load metadata for docker.io/library/node:18-alpine
#3 DONE 1.8s

#2 [linux/amd64 internal] load metadata for docker.io/library/node:18-alpine
#2 DONE 1.8s

#4 [internal] load .dockerignore
#4 transferring context: 1.10kB done
#4 DONE 0.0s

#5 [linux/amd64 1/8] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#5 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e done
#5 DONE 0.0s

#6 [linux/arm64 1/8] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#6 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e 0.0s done
#6 DONE 0.0s

#7 [internal] load build context
#7 transferring context: 21.27MB 0.3s done
#7 DONE 0.3s

#8 [linux/amd64 2/8] WORKDIR /app
#8 CACHED

#9 [linux/amd64 7/8] RUN addgroup -g 1001 -S nodejs &&     adduser -S nodejs -u 1001
#9 CACHED

#10 [linux/amd64 5/8] COPY . .
#10 CACHED

#11 [linux/amd64 4/8] RUN npm ci && npm cache clean --force
#11 CACHED

#12 [linux/amd64 6/8] RUN chmod +x scripts/*.sh
#12 CACHED

#13 [linux/amd64 3/8] COPY package*.json ./
#13 CACHED

#14 [linux/amd64 8/8] RUN mkdir -p /app/logs &&     chown -R nodejs:nodejs /app
#14 CACHED

#15 [linux/arm64 2/8] WORKDIR /app
#15 CACHED

#16 [linux/arm64 6/8] RUN chmod +x scripts/*.sh
#16 CACHED

#17 [linux/arm64 5/8] COPY . .
#17 CACHED

#18 [linux/arm64 4/8] RUN npm ci && npm cache clean --force
#18 CACHED

#19 [linux/arm64 3/8] COPY package*.json ./
#19 CACHED

#20 [linux/arm64 7/8] RUN addgroup -g 1001 -S nodejs &&     adduser -S nodejs -u 1001
#20 CACHED

#21 [linux/arm64 8/8] RUN mkdir -p /app/logs &&     chown -R nodejs:nodejs /app
#21 CACHED

#22 exporting to image
#22 exporting layers done
#22 exporting manifest sha256:70c87b2703c7a66a07ebef3dcb8720355db74fdfa1288174a6b2ac14a3fc85a8 done
#22 exporting config sha256:f7cfde57c00bcf413effd5021c74555de957e0c5b4d66bf6c39ae87d34d14a9f done
#22 exporting attestation manifest sha256:0cb50804c7273dc3974bb311500cf106ae2b14e8bd7a8c31e293a5f385cd329a
#22 exporting attestation manifest sha256:0cb50804c7273dc3974bb311500cf106ae2b14e8bd7a8c31e293a5f385cd329a done
#22 exporting manifest sha256:ddfe65c18942da04e8f1cac1941e48832438b90e3daf433589f0020a4c38657f done
#22 exporting config sha256:85df7e1cdfea4d32a4307dc14a80b5b92e0f0f07c09af6200ac75fc3edc97024 done
#22 exporting attestation manifest sha256:d08488763c1b793fc9d91de6b94cb6bfafadf2098182c0cd28a58ada073fe734 done
#22 exporting manifest list sha256:8c20cc7f9f76b95efa0fba301770753095aaa4ab178700a13cab295cf10ce36b done
#22 pushing layers
#22 ...

#23 [auth] hanchanglin/tbk:pull,push token for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com
#23 DONE 0.0s

#22 exporting to image
#22 pushing layers 1.6s done
#22 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:31-c64c709@sha256:8c20cc7f9f76b95efa0fba301770753095aaa4ab178700a13cab295cf10ce36b
#22 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:31-c64c709@sha256:8c20cc7f9f76b95efa0fba301770753095aaa4ab178700a13cab295cf10ce36b 1.4s done
#22 pushing layers 0.6s done
#22 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest@sha256:8c20cc7f9f76b95efa0fba301770753095aaa4ab178700a13cab295cf10ce36b
#22 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest@sha256:8c20cc7f9f76b95efa0fba301770753095aaa4ab178700a13cab295cf10ce36b 0.6s done
#22 DONE 4.1s
+ echo Docker images pushed successfully (multi-arch)
Docker images pushed successfully (multi-arch)
[Pipeline] }
[Pipeline] // withDockerRegistry
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // script
[Pipeline] echo
✅ Docker image push completed
[Pipeline] echo
🎯 Images available at:
[Pipeline] echo
   - crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:31-c64c709
[Pipeline] echo
   - crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Database Migration)
[Pipeline] echo
🗄️ Running database migrations...
[Pipeline] sh
+ echo Checking database connection...
Checking database connection...
+ echo Running migrations...
Running migrations...
+ echo Database migration completed
Database migration completed
[Pipeline] echo
✅ Database migration completed
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Deploy to Aliyun ECS)
[Pipeline] lock
Trying to acquire lock on [Resource: tbk-ecs-deploy]
Resource [tbk-ecs-deploy] did not exist. Created.
Lock acquired on [Resource: tbk-ecs-deploy]
[Pipeline] {
[Pipeline] echo
🚀 Deploying to Aliyun ECS...
[Pipeline] echo
📋 Deployment Configuration:
[Pipeline] echo
   - Strategy: rolling
[Pipeline] echo
   - Branch: main
[Pipeline] echo
   - Image: crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ bash ./verify-deployment-fix.sh
🔍 验证部署配置修复...
1. 检查Docker Compose文件语法...
✅ Docker Compose文件语法正确
2. 检查网络配置...
time="2025-10-06T23:20:00+08:00" level=warning msg="/var/jenkins_home/workspace/tbk-pipeline/aliyun-ecs-deploy.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
✅ tbk_app-network 网络配置存在
time="2025-10-06T23:20:00+08:00" level=warning msg="/var/jenkins_home/workspace/tbk-pipeline/aliyun-ecs-deploy.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
✅ tbk-production-network 网络配置存在
3. 检查服务配置...
time="2025-10-06T23:20:00+08:00" level=warning msg="/var/jenkins_home/workspace/tbk-pipeline/aliyun-ecs-deploy.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
配置的服务: fluentd
redis-production
tbk-production
nginx-production
portainer
4. 检查环境变量配置...
time="2025-10-06T23:20:00+08:00" level=warning msg="/var/jenkins_home/workspace/tbk-pipeline/aliyun-ecs-deploy.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
✅ 数据库主机配置正确
5. 检查端口配置...
time="2025-10-06T23:20:00+08:00" level=warning msg="/var/jenkins_home/workspace/tbk-pipeline/aliyun-ecs-deploy.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
✅ 使用expose配置，避免端口冲突
6. 检查健康检查配置...
time="2025-10-06T23:20:00+08:00" level=warning msg="/var/jenkins_home/workspace/tbk-pipeline/aliyun-ecs-deploy.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
✅ 健康检查配置存在
7. 检查Jenkinsfile安全清理规则...
✅ Jenkinsfile 使用安全的 prune 规则
8. 检查外部网络标签...
✅ tbk_app-network 已设置 external=true 标签

🎉 部署配置验证完成！

修复总结:
- ✅ 移除了过时的version字段
- ✅ 统一了网络配置 (tbk-production-network + tbk_app-network)
- ✅ 修复了数据库连接配置
- ✅ 优化了端口配置 (使用expose)
- ✅ 优化了Jenkinsfile中的网络创建逻辑

现在可以重新运行Jenkins构建来测试修复效果。
[Pipeline] sh
+ set -e
+ echo Ensuring remote deploy directory exists...
Ensuring remote deploy directory exists...
+ ssh -o StrictHostKeyChecking=no root@60.205.0.185 mkdir -p /opt/apps/tbk
+ echo Syncing compose and env files to remote...
Syncing compose and env files to remote...
+ [ -f aliyun-ecs-deploy.yml ]
+ scp -o StrictHostKeyChecking=no aliyun-ecs-deploy.yml root@60.205.0.185:/opt/apps/tbk/
+ [ -f .env.production ]
+ scp -o StrictHostKeyChecking=no .env.production root@60.205.0.185:/opt/apps/tbk/
+ [ -f scripts/config-loader.sh ]
+ scp -o StrictHostKeyChecking=no scripts/config-loader.sh root@60.205.0.185:/opt/apps/tbk/config-loader.sh
+ ssh -o StrictHostKeyChecking=no root@60.205.0.185 chmod +x /opt/apps/tbk/config-loader.sh
+ echo ✅ config-loader.sh uploaded and made executable
✅ config-loader.sh uploaded and made executable
+ [ -f scripts/config-audit.sh ]
+ scp -o StrictHostKeyChecking=no scripts/config-audit.sh root@60.205.0.185:/opt/apps/tbk/config-audit.sh
+ ssh -o StrictHostKeyChecking=no root@60.205.0.185 chmod +x /opt/apps/tbk/config-audit.sh
+ echo ✅ config-audit.sh uploaded and made executable
✅ config-audit.sh uploaded and made executable
+ [ -f scripts/rebuild-network.sh ]
+ scp -o StrictHostKeyChecking=no scripts/rebuild-network.sh root@60.205.0.185:/opt/apps/tbk/rebuild-network.sh
+ ssh -o StrictHostKeyChecking=no root@60.205.0.185 chmod +x /opt/apps/tbk/rebuild-network.sh
+ echo ✅ rebuild-network.sh uploaded and made executable
✅ rebuild-network.sh uploaded and made executable
+ [ -f scripts/ensure_network.sh ]
+ scp -o StrictHostKeyChecking=no scripts/ensure_network.sh root@60.205.0.185:/opt/apps/tbk/ensure_network.sh
+ ssh -o StrictHostKeyChecking=no root@60.205.0.185 chmod +x /opt/apps/tbk/ensure_network.sh
+ echo ✅ ensure_network.sh uploaded and made executable
✅ ensure_network.sh uploaded and made executable
[Pipeline] sh
+ set -e
+ echo Connecting to Aliyun ECS host...
Connecting to Aliyun ECS host...
+ ssh -o StrictHostKeyChecking=no root@60.205.0.185 
                                  set -e
                                  cd /opt/apps/tbk
                                  
                                  echo "Pre-deployment: running configuration audit..."
                                  if [ -f /opt/apps/tbk/config-audit.sh ]; then
                                      echo "✅ Found config-audit.sh script, executing..."
                                      if ! bash /opt/apps/tbk/config-audit.sh; then
                                          echo "❌ Configuration audit failed, attempting auto-repair..."
                                          if [ -f /opt/apps/tbk/rebuild-network.sh ]; then
                                              echo "🔧 Running network rebuild script..."
                                              bash /opt/apps/tbk/rebuild-network.sh
                                              
                                              # 再次验证配置
                                              if ! bash /opt/apps/tbk/config-audit.sh; then
                                                  echo "❌ Auto-repair failed, stopping deployment"
                                                  exit 1
                                
                                
                                # 上传config目录
                                if [ -d config ]; then
                                    ssh -o StrictHostKeyChecking=no root@60.205.0.185 "mkdir -p /opt/apps/tbk/config"
                                    scp -o StrictHostKeyChecking=no -r config/* root@60.205.0.185:/opt/apps/tbk/config/
                                    echo "✅ config directory uploaded"
                                else
                                    echo "❌ WARNING: config directory not found locally!"
                                    exit 1
                                fi
                                              fi
                                              echo "✅ Auto-repair successful"
                                          else
                                              echo "❌ rebuild-network.sh not found, cannot auto-repair"
                                              exit 1
                                
                                
                                # 上传config目录
                                if [ -d config ]; then
                                    ssh -o StrictHostKeyChecking=no root@60.205.0.185 "mkdir -p /opt/apps/tbk/config"
                                    scp -o StrictHostKeyChecking=no -r config/* root@60.205.0.185:/opt/apps/tbk/config/
                                    echo "✅ config directory uploaded"
                                else
                                    echo "❌ WARNING: config directory not found locally!"
                                    exit 1
                                fi
                                          fi
                                      else
                                          echo "✅ Configuration audit passed"
                                      fi
                                  else
                                      echo "⚠️ WARNING: config-audit.sh not found, skipping configuration validation"
                                  fi
                                  
                                  echo "Pre-flight: ensuring external network exists and labeled..."
                                  if [ -f /opt/apps/tbk/ensure_network.sh ]; then
                                      echo "✅ Found ensure_network.sh script, executing..."
                                      bash /opt/apps/tbk/ensure_network.sh tbk_app-network 172.21.0.0/16
                                  else
                                      echo "❌ ERROR: ensure_network.sh script not found at /opt/apps/tbk/ensure_network.sh"
                                      echo "Falling back to manual network creation..."
                                      docker network prune -f --filter "label!=external" || true
                                      docker network create tbk_app-network --subnet=172.21.0.0/16 --label external=true || true
                                  fi
                                  echo "Cleaning up existing containers and networks..."
                                  ENV_ARG=""
                                  if [ -f .env.production ]; then ENV_ARG="--env-file .env.production"; fi
                                  DEPLOY_STRATEGY="rolling"
                                  echo "Using strategy: $DEPLOY_STRATEGY"
                                  case $DEPLOY_STRATEGY in
                                    recreate)
                                      # 安全停止容器，不删除外部网络
                                      docker compose $ENV_ARG -f aliyun-ecs-deploy.yml stop || true
                                      docker compose $ENV_ARG -f aliyun-ecs-deploy.yml rm -f || true
                                      # 只清理未使用的网络，但保留外部网络
                                      docker network prune -f --filter "label!=external" || true
                                      echo "Ensuring required external networks exist..."
                                      docker network create tbk_app-network --subnet=172.21.0.0/16 --label external=true || true
                                      echo "Pulling latest image..."
                                      docker compose $ENV_ARG -f aliyun-ecs-deploy.yml pull tbk-production
                                      echo "Starting services with force recreate..."
                                      docker compose $ENV_ARG -f aliyun-ecs-deploy.yml up -d --force-recreate tbk-production nginx-production
                                      ;;
                                    docker-run)
                                      echo "Using docker-run fallback strategy..."
                                      docker rm -f nginx-production tbk-production || true
                                      docker network create tbk-production-network || true
                                      echo "Pulling latest image..."
                                      docker pull crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest
                                      DOCKER_RUN_ENV=""
                                      if [ -f .env.production ]; then DOCKER_RUN_ENV="--env-file .env.production"; fi
                                      echo "Starting app container..."
                                      docker run -d --name tbk-production --restart unless-stopped                                         --network tbk-production-network                                         -v /opt/apps/tbk/logs:/app/logs -v /opt/apps/tbk/uploads:/app/uploads -v /opt/apps/tbk/ssl:/app/ssl:ro                                         $DOCKER_RUN_ENV                                         crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest
                                      echo "Connecting app to external MySQL network..."
                                      docker network connect tbk_app-network tbk-production || true
                                      echo "Starting nginx container..."
                                      docker run -d --name nginx-production --restart unless-stopped                                         --network tbk-production-network                                         -p 8080:80 -p 8443:443                                         -v /opt/apps/tbk/nginx/production.conf:/etc/nginx/conf.d/default.conf:ro                                         -v /opt/apps/tbk/ssl:/etc/nginx/ssl:ro                                         -v /opt/apps/tbk/logs/nginx:/var/log/nginx                                         nginx:alpine
                                      ;;
                                    rolling|*)
                                      # 安全停止容器，不删除外部网络
                                      docker compose $ENV_ARG -f aliyun-ecs-deploy.yml stop || true
                                      docker compose $ENV_ARG -f aliyun-ecs-deploy.yml rm -f || true
                                      # 只清理未使用的网络，但保留外部网络
                                      docker network prune -f --filter "label!=external" || true
                                      echo "Ensuring required external networks exist..."
                                       docker network create tbk_app-network --subnet=172.21.0.0/16 --label external=true || true
                                      echo "Pulling latest image..."
                                      docker compose $ENV_ARG -f aliyun-ecs-deploy.yml pull tbk-production
                                      echo "Starting services (rolling)..."
                                      docker compose $ENV_ARG -f aliyun-ecs-deploy.yml up -d tbk-production nginx-production
                                      ;;
                                  esac
                                  echo "Waiting for services to start..."
                                  sleep 10
                                  echo "Checking service health..."
                                  for i in 1 2 3; do
                                      if curl -fsSL http://localhost:8080/api/health; then
                                          echo "Health check passed!"
                                          break
                                      else
                                          echo "Health check attempt $i failed, retrying in 5 seconds..."
                                          sleep 5
                                      fi
                                  done
                                  echo "Deployment completed"
                                
Pre-deployment: running configuration audit...
✅ Found config-audit.sh script, executing...
[0;31m❌ 无法加载网络配置[0m
❌ Configuration audit failed, attempting auto-repair...
🔧 Running network rebuild script...
错误: 配置文件不存在: /opt/apps/config/network.conf
[0;31m❌ 无法加载网络配置[0m
错误: 配置文件不存在: /opt/apps/config/network.conf
[Pipeline] echo
❌ Deployment failed: script returned exit code 1
[Pipeline] echo
🔄 Initiating rollback...
[Pipeline] sh
+ echo Rolling back to previous version...
Rolling back to previous version...
+ echo Rollback completed
Rollback completed
[Pipeline] }
[Pipeline] // script
[Pipeline] }
Lock released on resource [Resource: tbk-ecs-deploy]
[Pipeline] // lock
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Post-Deploy Tests)
Stage "Post-Deploy Tests" skipped due to earlier failure(s)
[Pipeline] getContext
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Build Only Summary)
Stage "Build Only Summary" skipped due to earlier failure(s)
[Pipeline] getContext
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Declarative: Post Actions)
[Pipeline] echo
🧹 Cleaning up workspace...
[Pipeline] sh
+ docker system prune -f --volumes
Total reclaimed space: 0B
+ echo Cleanup completed
Cleanup completed
[Pipeline] echo
❌ Pipeline failed!
[Pipeline] echo
📋 Build Info: Build #31, Commit: c64c709
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
ERROR: script returned exit code 1
Finished: FAILURE
