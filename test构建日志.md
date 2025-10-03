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
Checking out Revision 40e4e3e0144714f61153f8e16e06b902ea5137b3 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 40e4e3e0144714f61153f8e16e06b902ea5137b3 # timeout=10
Commit message: "🔧 修复 Jenkins 构建问题: readJSON -> readFile + JsonSlurper, 改进分支检测逻辑"
 > git rev-list --no-walk 5c35bbfea637955e26ed3281419412386fcc4747 # timeout=10
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
Checking out Revision 40e4e3e0144714f61153f8e16e06b902ea5137b3 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 40e4e3e0144714f61153f8e16e06b902ea5137b3 # timeout=10
Commit message: "🔧 修复 Jenkins 构建问题: readJSON -> readFile + JsonSlurper, 改进分支检测逻辑"
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ git rev-parse --short HEAD
[Pipeline] }
[Pipeline] // script
[Pipeline] echo
✅ Code checkout completed
[Pipeline] echo
📋 Build Info: Build #52, Branch: main, Commit: 40e4e3e
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
Preparing multi-arch build: crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:52-40e4e3e (+ latest)
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

WARNING! Your credentials are stored unencrypted in '/var/jenkins_home/workspace/tbk-pipeline@tmp/42490f68-d318-436f-a1a8-58710db98afe/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded
[Pipeline] {
[Pipeline] sh
+ set -e
+ docker buildx create --use --name tbk-builder
tbk-builder
+ docker buildx inspect --bootstrap
#1 [internal] booting buildkit
#1 pulling image moby/buildkit:buildx-stable-1
#1 pulling image moby/buildkit:buildx-stable-1 15.4s done
#1 creating container buildx_buildkit_tbk-builder0
#1 creating container buildx_buildkit_tbk-builder0 1.2s done
#1 DONE 16.6s
Name:          tbk-builder
Driver:        docker-container
Last Activity: 2025-10-03 22:42:37 +0000 UTC

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
+ docker buildx build --platform linux/amd64,linux/arm64 -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:52-40e4e3e -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest --push .
#0 building with "tbk-builder" instance using docker-container driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 881B 0.0s done
#1 DONE 0.1s

#2 [linux/amd64 internal] load metadata for docker.io/library/node:18-alpine
#2 ...

#3 [linux/arm64 internal] load metadata for docker.io/library/node:18-alpine
#3 DONE 5.2s

#4 [internal] load .dockerignore
#4 transferring context: 1.10kB done
#4 DONE 0.0s

#2 [linux/amd64 internal] load metadata for docker.io/library/node:18-alpine
#2 DONE 6.1s

#5 [linux/amd64 1/7] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#5 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e done
#5 ...

#6 [internal] load build context
#6 transferring context: 277.59kB 0.1s done
#6 DONE 0.1s

#5 [linux/amd64 1/7] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#5 sha256:1e5a4c89cee5c0826c540ab06d4b6b491c96eda01837f430bd47f0d26702d6e3 0B / 1.26MB 0.2s
#5 sha256:25ff2da83641908f65c3a74d80409d6b1b62ccfaab220b9ea70b80df5a2e0549 0B / 446B 0.2s
#5 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 0B / 40.01MB 0.2s
#5 sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870 0B / 3.64MB 0.2s
#5 sha256:25ff2da83641908f65c3a74d80409d6b1b62ccfaab220b9ea70b80df5a2e0549 446B / 446B 0.7s done
#5 sha256:1e5a4c89cee5c0826c540ab06d4b6b491c96eda01837f430bd47f0d26702d6e3 1.26MB / 1.26MB 2.1s done
#5 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 2.10MB / 40.01MB 2.5s
#5 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 5.24MB / 40.01MB 2.8s
#5 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 8.39MB / 40.01MB 3.0s
#5 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 22.02MB / 40.01MB 3.3s
#5 sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870 1.05MB / 3.64MB 3.3s
#5 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 40.01MB / 40.01MB 3.6s done
#5 sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870 2.10MB / 3.64MB 3.5s
#5 sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870 3.64MB / 3.64MB 3.6s done
#5 extracting sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870 0.1s done
#5 DONE 3.8s

#7 [linux/arm64 1/7] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#7 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e 0.0s done
#7 sha256:02bb84e9f3412827f177bc6c020812249b32a8425d2c1858e9d71bd4c015f031 443B / 443B 1.4s done
#7 sha256:8bfa36aa66ce614f6da68a16fb71f875da8d623310f0cb80ae1ecfa092f587f6 1.26MB / 1.26MB 0.9s done
#7 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 0B / 39.66MB 1.5s
#7 sha256:6e771e15690e2fabf2332d3a3b744495411d6e0b00b2aea64419b58b0066cf81 0B / 3.99MB 0.6s
#7 sha256:6e771e15690e2fabf2332d3a3b744495411d6e0b00b2aea64419b58b0066cf81 2.10MB / 3.99MB 1.1s
#7 sha256:6e771e15690e2fabf2332d3a3b744495411d6e0b00b2aea64419b58b0066cf81 3.15MB / 3.99MB 1.2s
#7 sha256:6e771e15690e2fabf2332d3a3b744495411d6e0b00b2aea64419b58b0066cf81 3.99MB / 3.99MB 1.2s done
#7 extracting sha256:6e771e15690e2fabf2332d3a3b744495411d6e0b00b2aea64419b58b0066cf81
#7 extracting sha256:6e771e15690e2fabf2332d3a3b744495411d6e0b00b2aea64419b58b0066cf81 0.1s done
#7 ...

#5 [linux/amd64 1/7] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#5 extracting sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 1.5s done
#5 extracting sha256:1e5a4c89cee5c0826c540ab06d4b6b491c96eda01837f430bd47f0d26702d6e3 0.0s done
#5 extracting sha256:25ff2da83641908f65c3a74d80409d6b1b62ccfaab220b9ea70b80df5a2e0549 done
#5 DONE 5.3s

#7 [linux/arm64 1/7] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#7 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 2.10MB / 39.66MB 3.2s
#7 ...

#8 [linux/amd64 2/7] WORKDIR /app
#8 DONE 0.1s

#9 [linux/amd64 3/7] COPY package*.json ./
#9 DONE 0.0s

#7 [linux/arm64 1/7] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#7 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 5.46MB / 39.66MB 3.5s
#7 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 9.44MB / 39.66MB 3.6s
#7 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 14.94MB / 39.66MB 3.8s
#7 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 22.56MB / 39.66MB 3.9s
#7 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 35.65MB / 39.66MB 4.1s
#7 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 39.66MB / 39.66MB 4.1s done
#7 extracting sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a
#7 extracting sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 1.4s done
#7 DONE 7.8s

#10 [linux/amd64 4/7] RUN npm ci && npm cache clean --force
#10 ...

#7 [linux/arm64 1/7] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#7 extracting sha256:8bfa36aa66ce614f6da68a16fb71f875da8d623310f0cb80ae1ecfa092f587f6 0.1s done
#7 extracting sha256:02bb84e9f3412827f177bc6c020812249b32a8425d2c1858e9d71bd4c015f031 done
#7 DONE 7.8s

#11 [linux/arm64 2/7] WORKDIR /app
#11 DONE 0.1s

#12 [linux/arm64 3/7] COPY package*.json ./
#12 DONE 0.0s

#13 [linux/arm64 4/7] RUN npm ci && npm cache clean --force
#13 ...

#10 [linux/amd64 4/7] RUN npm ci && npm cache clean --force
#10 8.669 
#10 8.669 added 122 packages, and audited 123 packages in 7s
#10 8.669 
#10 8.669 22 packages are looking for funding
#10 8.669   run `npm fund` for details
#10 8.670 
#10 8.670 found 0 vulnerabilities
#10 8.675 npm notice
#10 8.675 npm notice New major version of npm available! 10.8.2 -> 11.6.1
#10 8.675 npm notice Changelog: https://github.com/npm/cli/releases/tag/v11.6.1
#10 8.675 npm notice To update run: npm install -g npm@11.6.1
#10 8.675 npm notice
#10 ...

#13 [linux/arm64 4/7] RUN npm ci && npm cache clean --force
#13 6.128 
#13 6.128 added 122 packages, and audited 123 packages in 6s
#13 6.128 
#13 6.128 22 packages are looking for funding
#13 6.128   run `npm fund` for details
#13 6.129 
#13 6.129 found 0 vulnerabilities
#13 6.130 npm notice
#13 6.130 npm notice New major version of npm available! 10.8.2 -> 11.6.1
#13 6.130 npm notice Changelog: https://github.com/npm/cli/releases/tag/v11.6.1
#13 6.130 npm notice To update run: npm install -g npm@11.6.1
#13 6.130 npm notice
#13 6.275 npm warn using --force Recommended protections disabled.
#13 DONE 6.5s

#14 [linux/arm64 5/7] COPY . .
#14 DONE 0.0s

#15 [linux/arm64 6/7] RUN addgroup -g 1001 -S nodejs &&     adduser -S nodejs -u 1001
#15 DONE 0.1s

#10 [linux/amd64 4/7] RUN npm ci && npm cache clean --force
#10 9.438 npm warn using --force Recommended protections disabled.
#10 DONE 9.9s

#16 [linux/arm64 7/7] RUN mkdir -p /app/logs &&     chown -R nodejs:nodejs /app
#16 ...

#17 [linux/amd64 5/7] COPY . .
#17 DONE 0.0s

#18 [linux/amd64 6/7] RUN addgroup -g 1001 -S nodejs &&     adduser -S nodejs -u 1001
#18 DONE 0.1s

#19 [linux/amd64 7/7] RUN mkdir -p /app/logs &&     chown -R nodejs:nodejs /app
#19 ...

#16 [linux/arm64 7/7] RUN mkdir -p /app/logs &&     chown -R nodejs:nodejs /app
#16 DONE 1.9s

#19 [linux/amd64 7/7] RUN mkdir -p /app/logs &&     chown -R nodejs:nodejs /app
#19 DONE 1.8s

#20 exporting to image
#20 exporting layers
#20 exporting layers 0.5s done
#20 exporting manifest sha256:46fc6e09fd02738363ecacc8abb5b9710a5f47b561d59a715f62bac22eb6216c done
#20 exporting config sha256:32811ba4e573d8a483d00c921f92c18cb8bc01066a73ced13f923f35ae82ca72 done
#20 exporting attestation manifest sha256:0d127a6cbf23f8e3ff8506b7e53f717e55f6f65926c80c8233c72d06477ba265 done
#20 exporting manifest sha256:df7917253724c7b1103b25aea7a5c58d27c86e9589f0634ee737b2f84ac15bd3 done
#20 exporting config sha256:fcab47c46187dcfd018ef3b2a74678b69ea8fb3f68982e90593c18a6e3522b10 done
#20 exporting attestation manifest sha256:bee238cfdd12863c24cce9609c8d3da40a68307b7b0f6eb01641a04d6854f8b6 done
#20 exporting manifest list sha256:24848d92a4f16e8336f491ac28b0ab7ef67548aecc5e60fbe2ffc45b7220f6fa done
#20 pushing layers
#20 ...

#21 [auth] hanchanglin/tbk:pull,push token for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com
#21 DONE 0.0s

#20 exporting to image
#20 pushing layers 12.0s done
#20 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:52-40e4e3e@sha256:24848d92a4f16e8336f491ac28b0ab7ef67548aecc5e60fbe2ffc45b7220f6fa
#20 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:52-40e4e3e@sha256:24848d92a4f16e8336f491ac28b0ab7ef67548aecc5e60fbe2ffc45b7220f6fa 1.2s done
#20 pushing layers 0.5s done
#20 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest@sha256:24848d92a4f16e8336f491ac28b0ab7ef67548aecc5e60fbe2ffc45b7220f6fa
#20 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest@sha256:24848d92a4f16e8336f491ac28b0ab7ef67548aecc5e60fbe2ffc45b7220f6fa 0.5s done
#20 DONE 14.7s
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
   - crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:52-40e4e3e
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
[Pipeline] echo
❌ Deployment failed: No such property: ENV_ARG for class: groovy.lang.Binding
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
📋 Build Info: Build #52, Commit: 40e4e3e
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Also:   org.jenkinsci.plugins.workflow.actions.ErrorAction$ErrorId: 69c75059-9333-4d32-ac6f-113d7fa0fe09
groovy.lang.MissingPropertyException: No such property: ENV_ARG for class: groovy.lang.Binding
	at groovy.lang.Binding.getVariable(Binding.java:63)
	at PluginClassLoader for script-security//org.jenkinsci.plugins.scriptsecurity.sandbox.groovy.SandboxInterceptor.onGetProperty(SandboxInterceptor.java:285)
	at PluginClassLoader for script-security//org.kohsuke.groovy.sandbox.impl.Checker$7.call(Checker.java:375)
	at PluginClassLoader for script-security//org.kohsuke.groovy.sandbox.impl.Checker.checkedGetProperty(Checker.java:379)
	at PluginClassLoader for script-security//org.kohsuke.groovy.sandbox.impl.Checker.checkedGetProperty(Checker.java:355)
	at PluginClassLoader for script-security//org.kohsuke.groovy.sandbox.impl.Checker.checkedGetProperty(Checker.java:355)
	at PluginClassLoader for script-security//org.kohsuke.groovy.sandbox.impl.Checker.checkedGetProperty(Checker.java:355)
	at PluginClassLoader for workflow-cps//com.cloudbees.groovy.cps.sandbox.SandboxInvoker.getProperty(SandboxInvoker.java:29)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.LoggingInvoker.getProperty(LoggingInvoker.java:134)
	at PluginClassLoader for workflow-cps//com.cloudbees.groovy.cps.impl.PropertyAccessBlock.rawGet(PropertyAccessBlock.java:20)
	at WorkflowScript.run(WorkflowScript:320)
	at ___cps.transform___(Native Method)
	at PluginClassLoader for workflow-cps//com.cloudbees.groovy.cps.impl.PropertyishBlock$ContinuationImpl.get(PropertyishBlock.java:73)
	at PluginClassLoader for workflow-cps//com.cloudbees.groovy.cps.LValueBlock$GetAdapter.receive(LValueBlock.java:30)
	at PluginClassLoader for workflow-cps//com.cloudbees.groovy.cps.impl.PropertyishBlock$ContinuationImpl.fixName(PropertyishBlock.java:65)
	at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(Unknown Source)
	at java.base/java.lang.reflect.Method.invoke(Unknown Source)
	at PluginClassLoader for workflow-cps//com.cloudbees.groovy.cps.impl.ContinuationPtr$ContinuationImpl.receive(ContinuationPtr.java:72)
	at PluginClassLoader for workflow-cps//com.cloudbees.groovy.cps.impl.ConstantBlock.eval(ConstantBlock.java:21)
	at PluginClassLoader for workflow-cps//com.cloudbees.groovy.cps.Next.step(Next.java:83)
	at PluginClassLoader for workflow-cps//com.cloudbees.groovy.cps.Continuable.run0(Continuable.java:147)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.SandboxContinuable.access$001(SandboxContinuable.java:17)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.SandboxContinuable.run0(SandboxContinuable.java:49)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.CpsThread.runNextChunk(CpsThread.java:181)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.CpsThreadGroup.run(CpsThreadGroup.java:443)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.CpsThreadGroup$2.call(CpsThreadGroup.java:351)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.CpsThreadGroup$2.call(CpsThreadGroup.java:299)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.CpsVmExecutorService.lambda$wrap$4(CpsVmExecutorService.java:140)
	at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
	at hudson.remoting.SingleLaneExecutorService$1.run(SingleLaneExecutorService.java:139)
	at jenkins.util.ContextResettingExecutorService$1.run(ContextResettingExecutorService.java:28)
	at jenkins.security.ImpersonatingExecutorService$1.run(ImpersonatingExecutorService.java:68)
	at jenkins.util.ErrorLoggingExecutorService.lambda$wrap$0(ErrorLoggingExecutorService.java:51)
	at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Unknown Source)
	at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
	at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
	at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.CpsVmExecutorService$1.call(CpsVmExecutorService.java:53)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.CpsVmExecutorService$1.call(CpsVmExecutorService.java:50)
	at org.codehaus.groovy.runtime.GroovyCategorySupport$ThreadCategoryInfo.use(GroovyCategorySupport.java:136)
	at org.codehaus.groovy.runtime.GroovyCategorySupport.use(GroovyCategorySupport.java:275)
	at PluginClassLoader for workflow-cps//org.jenkinsci.plugins.workflow.cps.CpsVmExecutorService.lambda$categoryThreadFactory$0(CpsVmExecutorService.java:50)
	at java.base/java.lang.Thread.run(Unknown Source)
Finished: FAILURE
