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
Checking out Revision 27920da1d0f5c3b809170bef66c60692aa6f88e6 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 27920da1d0f5c3b809170bef66c60692aa6f88e6 # timeout=10
Commit message: "修复本地数据库环境配置"
 > git rev-list --no-walk 7f9731a215d8eb8dc6e4cf493e4d77b7abbf9981 # timeout=10
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
Checking out Revision 27920da1d0f5c3b809170bef66c60692aa6f88e6 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 27920da1d0f5c3b809170bef66c60692aa6f88e6 # timeout=10
Commit message: "修复本地数据库环境配置"
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ git rev-parse --short HEAD
[Pipeline] sh
+ git rev-parse --abbrev-ref HEAD
[Pipeline] }
[Pipeline] // script
[Pipeline] echo
✅ Code checkout completed
[Pipeline] echo
📋 Build Info: Build #39, Commit: 27920da
[Pipeline] echo
🌍 Environment: null (Branch: HEAD)
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

added 93 packages, and audited 94 packages in 5s

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

ESLint: 9.36.0

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
Building image: crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:39-27920da
[Pipeline] sh
+ docker build -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:39-27920da .
#0 building with "default" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 881B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/node:18-alpine
#2 DONE 0.2s

#3 [internal] load .dockerignore
#3 transferring context: 1.10kB done
#3 DONE 0.0s

#4 [internal] load build context
#4 DONE 0.0s

#5 [1/7] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#5 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#5 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e 2.9s done
#5 DONE 2.9s

#4 [internal] load build context
#4 transferring context: 262.50kB 0.0s done
#4 DONE 0.1s

#6 [2/7] WORKDIR /app
#6 CACHED

#7 [3/7] COPY package*.json ./
#7 DONE 0.0s

#8 [4/7] RUN npm ci && npm cache clean --force
#8 5.846 
#8 5.846 added 122 packages, and audited 123 packages in 6s
#8 5.846 
#8 5.846 22 packages are looking for funding
#8 5.846   run `npm fund` for details
#8 5.847 
#8 5.847 found 0 vulnerabilities
#8 5.848 npm notice
#8 5.848 npm notice New major version of npm available! 10.8.2 -> 11.6.1
#8 5.848 npm notice Changelog: https://github.com/npm/cli/releases/tag/v11.6.1
#8 5.848 npm notice To update run: npm install -g npm@11.6.1
#8 5.848 npm notice
#8 5.933 npm warn using --force Recommended protections disabled.
#8 DONE 6.1s

#9 [5/7] COPY . .
#9 DONE 0.0s

#10 [6/7] RUN addgroup -g 1001 -S nodejs &&     adduser -S nodejs -u 1001
#10 DONE 0.1s

#11 [7/7] RUN mkdir -p /app/logs &&     chown -R nodejs:nodejs /app
#11 DONE 1.4s

#12 exporting to image
#12 exporting layers
#12 exporting layers 0.4s done
#12 exporting manifest sha256:b7bcbc74fef3ea0d1dd6d6253b5ca7088bd9c8bb619ff98324287ea0917550ca done
#12 exporting config sha256:b6263f370a9e239f9385c6a10d9e0190485bfe2ca5edefcbfee606bfe66ed537 done
#12 exporting attestation manifest sha256:18fb7d8caadb901476318304f4d5864182910d8da1ffd7c39a315eca417c2f21 0.0s done
#12 exporting manifest list sha256:43b91d71357ece46110fa4d243191b78b2d9b7341e47b24ec5d0f5ee1ce847db done
#12 naming to crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:39-27920da done
#12 unpacking to crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:39-27920da
#12 unpacking to crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:39-27920da 0.3s done
#12 DONE 0.8s
+ docker tag crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:39-27920da crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/tbk:latest
+ echo Docker image built successfully
Docker image built successfully
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
[Pipeline] // withDockerRegistry
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Deploy Application)
Stage "Deploy Application" skipped due to earlier failure(s)
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
[Pipeline] { (Declarative: Post Actions)
[Pipeline] echo
🧹 Cleaning up workspace...
[Pipeline] sh
+ docker system prune -f --volumes
Deleted Networks:
jenkins-service_tbk-public-network

Deleted Volumes:
00d89febad9523e35329357196f24e7132d5136e245f76c7fadf91e886f57993
8d9ac358b7b3353ff18c11ddd3048179ae84d7194433e35c35fc211f16057b2d
1925a2090829d3d38ab842cce158b44efd50d1d7f02ae2727baa4807ffa58549

Deleted build cache objects:
c3gkg8nakyq0bkcinf6myg6l2
ptb3lxt34fvl8no5ffa30859o
ire5cf2c8331s5ixba3ytveki
2eoxi1v7g27t0539x04k0uccb
fdqw9wcfgytum70rh2mvrfmo6
ss3bcg3s120hhj1gat2ms09fv
ua8suh0cb616h9utowuslzyi1
8eo8hy5d29whyjrzvkfantbar
66c1210s2bqfbtg0b5x975vbs
swcltnm0oxdssrta5x7fph400
xbbh5fhqgfst28ciw116hoavi
kdfejb98f7u0t72vt581pxt22
yob14hb5g4wmafcszkt8vzitn
viqlsvbq2wsuyhq7s42lnyrlv
e8wcq72a8yuw5knp2btbq89ok
hzupo6la2k2d4fblx96936p6w
ndu07g95mvzoevy67tg1v28x3
99o5gg6p1qys3vmhpif59yfc2
xksrb0t4fvzlg07e8s4yt58ix
xnhmo6g4vnmx3oowzhcpfrflx
nyw5gy4sgn6ko2j9a3m9eojm4
qnfua03nsubwnkfruuuuc82ik
lg4du7jnb3ijgk0m24p9thty3
7mfon6iojxc1dq3b32w15os8h
ssr8kmjngynudm9zqrle6nw87
07xnlvtvvvkl4a6pw8cxh5ayv
yg7kruhtraxuqt91kb91ndod9
seuz7v3jc166v02dhtkrb0iir
xftgbcf9chii96dbkw19fsblz
aj37tvxl9uttqh9zdxr7s1sqi
wh5ckiaqer6qsf2riv03eya35
xbysujenoprt4ozs2jpth0x59
wz05l8ztbx715bqkvhwnti5g8
axnnjg33a6kiwz5n6pwm04c3x
ks38d07pemv4tgywtbc1upxgv
n36hjm34tshij6b8au6x9azru
1lvfzj5fk1kppv26tzm4uzr4v
qop3qrmtbzwihyzczsecv24ey
dfp8hf0vfzpyu5uvkyy1u5e67
m7eypvuw2zf94twy7thtuk19t
uc1xi4g6g9ok9vkh9cn7j2xg6
hl0wzym0gy4akrakxg8qwgdz2
4wuwqtbojpzyfpvr7j1n0d2ug

Total reclaimed space: 650MB
+ echo Cleanup completed
Cleanup completed
[Pipeline] echo
❌ Pipeline failed!
[Pipeline] echo
📋 Build Info: Build #39, Commit: 27920da
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
ERROR: Could not find credentials matching aliyun-acr
Finished: FAILURE
