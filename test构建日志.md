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
Checking out Revision e0023f949affffdea7e518ed28a14de2d51a9ec3 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f e0023f949affffdea7e518ed28a14de2d51a9ec3 # timeout=10
Commit message: "修复Dockerfile基础镜像地址 - 使用Docker Hub官方镜像配合镜像加速"
 > git rev-list --no-walk 813cb145e28bca4b5bd2529e977911e89cd661be # timeout=10
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
Checking out Revision e0023f949affffdea7e518ed28a14de2d51a9ec3 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f e0023f949affffdea7e518ed28a14de2d51a9ec3 # timeout=10
Commit message: "修复Dockerfile基础镜像地址 - 使用Docker Hub官方镜像配合镜像加速"
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ git rev-parse --short HEAD
[Pipeline] }
[Pipeline] // script
[Pipeline] echo
✅ Code checkout completed
[Pipeline] echo
📋 Build Info: Build #60, Branch: main, Commit: e0023f9
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

added 93 packages in 1m

18 packages are looking for funding
  run `npm fund` for details
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
Preparing multi-arch build: crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:60-e0023f9 (+ latest)
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

WARNING! Your credentials are stored unencrypted in '/var/jenkins_home/workspace/tbk-pipeline@tmp/12e67709-7c33-456b-9152-6cd3db39cacb/config.json'.
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
Last Activity: 2025-10-03 23:15:02 +0000 UTC

Nodes:
Name:                  tbk-builder0
Endpoint:              unix:///var/run/docker.sock
Status:                running
BuildKit daemon flags: --allow-insecure-entitlement=network.host
BuildKit version:      v0.24.0
Platforms:             linux/arm64, linux/amd64, linux/amd64/v2, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
Labels:
 org.mobyproject.buildkit.worker.executor:         oci
 org.mobyproject.buildkit.worker.hostname:         11f68274aaee
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
+ docker buildx build --platform linux/amd64,linux/arm64 -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:60-e0023f9 -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest --push .
#0 building with "tbk-builder" instance using docker-container driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 875B 0.0s done
#1 DONE 0.0s

#2 [linux/arm64 internal] load metadata for docker.io/library/node:18-alpine
#2 ERROR: failed to do request: Head "https://registry-1.docker.io/v2/library/node/manifests/18-alpine": EOF

#3 [linux/amd64 internal] load metadata for docker.io/library/node:18-alpine
#3 CANCELED
------
 > [linux/arm64 internal] load metadata for docker.io/library/node:18-alpine:
------
Dockerfile:2
--------------------
   1 |     # 使用 Node.js 18 Alpine 镜像作为基础镜像
   2 | >>> FROM node:18-alpine
   3 |     
   4 |     # 设置工作目录
--------------------
ERROR: failed to build: failed to solve: node:18-alpine: failed to resolve source metadata for docker.io/library/node:18-alpine: failed to do request: Head "https://registry-1.docker.io/v2/library/node/manifests/18-alpine": EOF
[Pipeline] }
[Pipeline] // withDockerRegistry
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Database Migration)
Stage "Database Migration" skipped due to earlier failure(s)
[Pipeline] getContext
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Deploy to Aliyun ECS)
Stage "Deploy to Aliyun ECS" skipped due to earlier failure(s)
[Pipeline] getContext
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
📋 Build Info: Build #60, Commit: e0023f9
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
