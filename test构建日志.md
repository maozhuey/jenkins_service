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
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
Warning: CredentialId "git-credentials" could not be found.
 > git rev-parse --resolve-git-dir /var/jenkins_home/workspace/tbk-pipeline/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url git@github.com:maozhuey/tbk.git # timeout=10
Fetching upstream changes from git@github.com:maozhuey/tbk.git
 > git --version # timeout=10
 > git --version # 'git version 2.39.5'
 > git fetch --tags --force --progress -- git@github.com:maozhuey/tbk.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 23fabacf52f4b9cd70fb0ea1bcfeb61d3ec90b54 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 23fabacf52f4b9cd70fb0ea1bcfeb61d3ec90b54 # timeout=10
Commit message: "修复 nginx 配置文件挂载路径错误：使用正确的文件路径而非目录路径"
 > git rev-list --no-walk a590634766339bdb8b8452b8533957d06de40fa0 # timeout=10
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
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
Warning: CredentialId "git-credentials" could not be found.
 > git rev-parse --resolve-git-dir /var/jenkins_home/workspace/tbk-pipeline/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url git@github.com:maozhuey/tbk.git # timeout=10
Fetching upstream changes from git@github.com:maozhuey/tbk.git
 > git --version # timeout=10
 > git --version # 'git version 2.39.5'
 > git fetch --tags --force --progress -- git@github.com:maozhuey/tbk.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 23fabacf52f4b9cd70fb0ea1bcfeb61d3ec90b54 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 23fabacf52f4b9cd70fb0ea1bcfeb61d3ec90b54 # timeout=10
Commit message: "修复 nginx 配置文件挂载路径错误：使用正确的文件路径而非目录路径"
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ git rev-parse --short HEAD
[Pipeline] }
[Pipeline] // script
[Pipeline] echo
✅ Code checkout completed
[Pipeline] echo
📋 Build Info: Build #77, Branch: main, Commit: 23fabac
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
[Pipeline] readFile
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
❤️ HEALTH_CHECK_URL: http://60.205.0.185:8080/api/health
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
Preparing multi-arch build: crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:77-23fabac (+ latest)
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

WARNING! Your credentials are stored unencrypted in '/var/jenkins_home/workspace/tbk-pipeline@tmp/b448f697-81f9-416c-9804-f52bb84468bb/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded
[Pipeline] {
[Pipeline] sh
+ set -e
+ echo Building Docker image...
Building Docker image...
+ docker build --platform linux/amd64 -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:77-23fabac -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest .
#0 building with "default" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 875B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/node:18-alpine
#2 DONE 0.3s

#3 [internal] load .dockerignore
#3 transferring context: 1.10kB done
#3 DONE 0.0s

#4 [internal] load build context
#4 DONE 0.0s

#5 [1/7] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#5 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#5 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e 2.8s done
#5 DONE 2.8s

#4 [internal] load build context
#4 transferring context: 281.34kB 0.0s done
#4 DONE 0.1s

#6 [2/7] WORKDIR /app
#6 CACHED

#7 [3/7] COPY package*.json ./
#7 CACHED

#8 [4/7] RUN npm ci && npm cache clean --force
#8 CACHED

#9 [5/7] COPY . .
#9 DONE 0.0s

#10 [6/7] RUN addgroup -g 1001 -S nodejs &&     adduser -S nodejs -u 1001
#10 DONE 0.2s

#11 [7/7] RUN mkdir -p /app/logs &&     chown -R nodejs:nodejs /app
#11 DONE 1.2s

#12 exporting to image
#12 exporting layers
#12 exporting layers 0.3s done
#12 exporting manifest sha256:a0990dde0cab24d7b90654b9ada6e87650f04d06a9ad07b9c68565797c7df011 0.0s done
#12 exporting config sha256:0be4d138e0335403b127bd214610c73c3182f6dd5b3bb21ca460a004fa86801b done
#12 exporting attestation manifest sha256:7662e778a1e7c9af1336e88f813212b5004fe1b78e4e069048a6efd6af9fe3c1 0.0s done
#12 exporting manifest list sha256:2e929c57ed1e8b393b76325e4906a1ba92fff74b20ee7366c9058fd845f09187 done
#12 naming to crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:77-23fabac done
#12 naming to crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest done
#12 DONE 0.4s
+ echo Pushing Docker images...
Pushing Docker images...
+ docker push crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:77-23fabac
The push refers to repository [crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk]
28fe9502dba9: Waiting
1e5a4c89cee5: Waiting
25ff2da83641: Waiting
acbdf6764093: Waiting
573b4d5974a9: Waiting
f18232174bc9: Waiting
dbf85f68f708: Waiting
3229bf938a3b: Waiting
7c2bc64261a2: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
dbf85f68f708: Waiting
3229bf938a3b: Waiting
7c2bc64261a2: Waiting
acbdf6764093: Waiting
573b4d5974a9: Waiting
f18232174bc9: Waiting
28fe9502dba9: Waiting
1e5a4c89cee5: Waiting
25ff2da83641: Waiting
dbf85f68f708: Waiting
3229bf938a3b: Waiting
7c2bc64261a2: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
28fe9502dba9: Waiting
1e5a4c89cee5: Waiting
25ff2da83641: Waiting
acbdf6764093: Waiting
573b4d5974a9: Waiting
f18232174bc9: Waiting
25ff2da83641: Waiting
acbdf6764093: Waiting
573b4d5974a9: Waiting
f18232174bc9: Waiting
28fe9502dba9: Waiting
1e5a4c89cee5: Waiting
7c2bc64261a2: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
dbf85f68f708: Waiting
3229bf938a3b: Waiting
f18232174bc9: Waiting
28fe9502dba9: Waiting
1e5a4c89cee5: Waiting
25ff2da83641: Waiting
acbdf6764093: Waiting
573b4d5974a9: Waiting
dbf85f68f708: Waiting
3229bf938a3b: Waiting
7c2bc64261a2: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
dbf85f68f708: Waiting
3229bf938a3b: Waiting
7c2bc64261a2: Waiting
acbdf6764093: Waiting
573b4d5974a9: Waiting
f18232174bc9: Waiting
28fe9502dba9: Waiting
1e5a4c89cee5: Waiting
25ff2da83641: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Layer already exists
dbf85f68f708: Waiting
3229bf938a3b: Waiting
7c2bc64261a2: Layer already exists
acbdf6764093: Waiting
573b4d5974a9: Waiting
f18232174bc9: Waiting
28fe9502dba9: Waiting
1e5a4c89cee5: Waiting
25ff2da83641: Layer already exists
1e5a4c89cee5: Layer already exists
acbdf6764093: Layer already exists
573b4d5974a9: Layer already exists
f18232174bc9: Layer already exists
3229bf938a3b: Waiting
acaa6fa823ea: Waiting
3229bf938a3b: Pushed
acaa6fa823ea: Pushed
28fe9502dba9: Pushed
dbf85f68f708: Pushed
77-23fabac: digest: sha256:2e929c57ed1e8b393b76325e4906a1ba92fff74b20ee7366c9058fd845f09187 size: 856
+ docker push crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest
The push refers to repository [crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk]
acbdf6764093: Waiting
1e5a4c89cee5: Waiting
f18232174bc9: Waiting
28fe9502dba9: Waiting
25ff2da83641: Waiting
573b4d5974a9: Waiting
3229bf938a3b: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
dbf85f68f708: Waiting
7c2bc64261a2: Waiting
28fe9502dba9: Waiting
25ff2da83641: Waiting
acbdf6764093: Waiting
1e5a4c89cee5: Waiting
f18232174bc9: Waiting
dbf85f68f708: Waiting
7c2bc64261a2: Waiting
573b4d5974a9: Waiting
3229bf938a3b: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
f18232174bc9: Waiting
28fe9502dba9: Waiting
25ff2da83641: Waiting
acbdf6764093: Waiting
1e5a4c89cee5: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
dbf85f68f708: Waiting
7c2bc64261a2: Waiting
573b4d5974a9: Waiting
3229bf938a3b: Waiting
7c2bc64261a2: Waiting
573b4d5974a9: Waiting
3229bf938a3b: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
dbf85f68f708: Waiting
25ff2da83641: Waiting
acbdf6764093: Waiting
1e5a4c89cee5: Waiting
f18232174bc9: Waiting
28fe9502dba9: Waiting
28fe9502dba9: Waiting
25ff2da83641: Waiting
acbdf6764093: Waiting
1e5a4c89cee5: Waiting
f18232174bc9: Waiting
dbf85f68f708: Waiting
7c2bc64261a2: Waiting
573b4d5974a9: Waiting
3229bf938a3b: Waiting
acaa6fa823ea: Waiting
dd71dde834b5: Waiting
28fe9502dba9: Waiting
25ff2da83641: Waiting
acbdf6764093: Waiting
1e5a4c89cee5: Waiting
f18232174bc9: Layer already exists
dd71dde834b5: Waiting
dbf85f68f708: Waiting
7c2bc64261a2: Waiting
573b4d5974a9: Waiting
3229bf938a3b: Waiting
acaa6fa823ea: Layer already exists
28fe9502dba9: Already exists
25ff2da83641: Layer already exists
acbdf6764093: Layer already exists
1e5a4c89cee5: Layer already exists
dbf85f68f708: Layer already exists
7c2bc64261a2: Layer already exists
573b4d5974a9: Layer already exists
3229bf938a3b: Layer already exists
dd71dde834b5: Layer already exists
latest: digest: sha256:2e929c57ed1e8b393b76325e4906a1ba92fff74b20ee7366c9058fd845f09187 size: 856
+ echo Docker images pushed successfully
Docker images pushed successfully
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
   - crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:77-23fabac
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
[Pipeline] sh
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
time="2025-10-04T20:54:13+08:00" level=warning msg="/opt/apps/tbk/aliyun-ecs-deploy.yml: `version` is obsolete"
 Container nginx-production  Stopping
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
 Network tbk_tbk-production-network  Resource is still in use
Pulling latest image...
time="2025-10-04T20:54:14+08:00" level=warning msg="/opt/apps/tbk/aliyun-ecs-deploy.yml: `version` is obsolete"
 tbk-production Pulling 
 f18232174bc9 Already exists 
 dd71dde834b5 Already exists 
 1e5a4c89cee5 Already exists 
 25ff2da83641 Already exists 
 7c2bc64261a2 Already exists 
 573b4d5974a9 Already exists 
 acbdf6764093 Already exists 
 3229bf938a3b Pulling fs layer 
 acaa6fa823ea Pulling fs layer 
 dbf85f68f708 Pulling fs layer 
 acaa6fa823ea Downloading [==================================================>]     971B/971B
 acaa6fa823ea Verifying Checksum 
 acaa6fa823ea Download complete 
 3229bf938a3b Downloading [===>                                               ]   3.63kB/56.84kB
 3229bf938a3b Downloading [==================================================>]  56.84kB/56.84kB
 3229bf938a3b Download complete 
 3229bf938a3b Extracting [============================>                      ]  32.77kB/56.84kB
 3229bf938a3b Extracting [==================================================>]  56.84kB/56.84kB
 dbf85f68f708 Downloading [>                                                  ]  25.59kB/2.181MB
 3229bf938a3b Pull complete 
 acaa6fa823ea Extracting [==================================================>]     971B/971B
 acaa6fa823ea Extracting [==================================================>]     971B/971B
 dbf85f68f708 Downloading [=============>                                     ]  580.4kB/2.181MB
 acaa6fa823ea Pull complete 
 dbf85f68f708 Downloading [==========================>                        ]  1.143MB/2.181MB
 dbf85f68f708 Downloading [=======================================>           ]  1.734MB/2.181MB
 dbf85f68f708 Verifying Checksum 
 dbf85f68f708 Download complete 
 dbf85f68f708 Extracting [>                                                  ]  32.77kB/2.181MB
 dbf85f68f708 Extracting [=====================>                             ]  917.5kB/2.181MB
 dbf85f68f708 Extracting [========================>                          ]  1.081MB/2.181MB
 dbf85f68f708 Extracting [=============================>                     ]  1.278MB/2.181MB
 dbf85f68f708 Extracting [====================================>              ]  1.606MB/2.181MB
 dbf85f68f708 Extracting [==============================================>    ]  2.032MB/2.181MB
 dbf85f68f708 Extracting [==================================================>]  2.181MB/2.181MB
 dbf85f68f708 Pull complete 
 tbk-production Pulled 
Starting services (rolling)...
time="2025-10-04T20:54:16+08:00" level=warning msg="/opt/apps/tbk/aliyun-ecs-deploy.yml: `version` is obsolete"
 tbk-production Pulling 
 tbk-production Pulled 
 Container redis-production  Creating
 Container redis-production  Created
 Container tbk-production  Creating
 Container tbk-production  Created
 Container nginx-production  Creating
 Container nginx-production  Created
 Container redis-production  Starting
 Container redis-production  Started
 Container tbk-production  Starting
 Container tbk-production  Started
 Container nginx-production  Starting
Waiting for services to start...
 Container nginx-production  Started
Checking service health...
{"success":true,"message":"服务运行正常","timestamp":"2025-10-04T12:54:29.017Z","uptime":9.034906595,"environment":"production","version":"1.0.0","services":{"database":"healthy","server":"healthy"}}Health check passed!
Deployment completed
[Pipeline] echo
🔍 Performing health check...
[Pipeline] sh
+ echo Health check URL: http://60.205.0.185:8080/api/health
Health check URL: http://60.205.0.185:8080/api/health
+ echo Service health check passed
Service health check passed
[Pipeline] }
[Pipeline] // script
[Pipeline] echo
✅ Aliyun ECS deployment completed successfully
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Post-Deploy Tests)
[Pipeline] echo
🔬 Running post-deployment tests...
[Pipeline] sh
+ echo Running health checks...
Running health checks...
+ echo Running integration tests...
Running integration tests...
+ echo Running smoke tests...
Running smoke tests...
+ echo Post-deploy tests completed
Post-deploy tests completed
[Pipeline] echo
✅ Post-deployment tests completed
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Build Only Summary)
Stage "Build Only Summary" skipped due to when conditional
[Pipeline] getContext
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Declarative: Post Actions)
[Pipeline] echo
🧹 Cleaning up workspace...
[Pipeline] sh
+ docker system prune -f --volumes
Deleted build cache objects:
sek304q4m97qncktit1qxx5f7
s81r6ldkshyti1me5t4dfhfjl
yd2orxa07samtdfjgpyu30ysk

Total reclaimed space: 446.5kB
+ echo Cleanup completed
Cleanup completed
[Pipeline] echo
🎉 Pipeline completed successfully!
[Pipeline] echo
📊 Build Summary:
[Pipeline] echo
   - Build Number: 77
[Pipeline] echo
   - Git Commit: 23fabac
[Pipeline] echo
   - Docker Image: crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:77-23fabac
[Pipeline] echo
   - Registry: crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
