# A0-test文档档案

## 核心问题概述 (Core Problem Summary):
["我的Jenkins在我本地运行，我使用Jenkins将tbk项目部署到阿里云docker中时，在构建过程中总是失败"]

## 期望行为 (Expected Behavior):
["Jenkins构建应该成功部署到阿里云docker，所有容器正常启动，服务可访问。"]

## 实际行为与完整错误日志 (Actual Behavior & Full Error Log):
Started by user admin

Obtained Jenkinsfile from git git@github.com:maozhuey/Product-Catalog.git
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins
 in /var/jenkins_home/workspace/product-catalog-pipeline
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential git-credentials
Cloning the remote Git repository
Cloning repository git@github.com:maozhuey/Product-Catalog.git
 > git init /var/jenkins_home/workspace/product-catalog-pipeline # timeout=10
Fetching upstream changes from git@github.com:maozhuey/Product-Catalog.git
 > git --version # timeout=10
 > git --version # 'git version 2.39.5'
using GIT_ASKPASS to set credentials GitHub Personal Access Token for tbk repository
 > git fetch --tags --force --progress -- git@github.com:maozhuey/Product-Catalog.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config remote.origin.url git@github.com:maozhuey/Product-Catalog.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
Avoid second fetch
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 6a16d0e9aa77027ddb0b6ebd2b2f2522f13e0658 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 6a16d0e9aa77027ddb0b6ebd2b2f2522f13e0658 # timeout=10
Commit message: "修复Jenkins前端构建路径问题：添加dir('frontend')包装"
 > git rev-list --no-walk 9b1fd8853d59e507e52a2bbee4a161371eed77de # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (环境检查)
[Pipeline] echo
🔍 检查构建环境...
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ docker --version
Docker version 28.5.0, build 887030f
[Pipeline] sh
+ node --version
v18.20.8
[Pipeline] sh
+ npm --version
10.8.2
[Pipeline] echo
构建分支: origin/main
[Pipeline] echo
提交ID: 6a16d0e
[Pipeline] echo
构建号: 3
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (代码检出)
[Pipeline] echo
📥 检出代码...
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential git-credentials
 > git rev-parse --resolve-git-dir /var/jenkins_home/workspace/product-catalog-pipeline/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url git@github.com:maozhuey/Product-Catalog.git # timeout=10
Fetching upstream changes from git@github.com:maozhuey/Product-Catalog.git
 > git --version # timeout=10
 > git --version # 'git version 2.39.5'
using GIT_ASKPASS to set credentials GitHub Personal Access Token for tbk repository
 > git fetch --tags --force --progress -- git@github.com:maozhuey/Product-Catalog.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 6a16d0e9aa77027ddb0b6ebd2b2f2522f13e0658 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 6a16d0e9aa77027ddb0b6ebd2b2f2522f13e0658 # timeout=10
Commit message: "修复Jenkins前端构建路径问题：添加dir('frontend')包装"
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ ls -la
total 288
drwxr-xr-x 36 jenkins jenkins  1152 Oct  7 05:44 .
drwxr-xr-x  6 jenkins jenkins   192 Oct  7 05:43 ..
-rw-r--r--  1 jenkins jenkins    88 Oct  7 05:44 .dockerignore
-rw-r--r--  1 jenkins jenkins   424 Oct  7 05:44 .env.docker
-rw-r--r--  1 jenkins jenkins   110 Oct  7 05:44 .env.local
-rw-r--r--  1 jenkins jenkins   342 Oct  7 05:44 .env.production
drwxr-xr-x 13 jenkins jenkins   416 Oct  7 05:44 .git
-rw-r--r--  1 jenkins jenkins   669 Oct  7 05:44 .gitignore
-rw-r--r--  1 jenkins jenkins  6170 Oct  7 05:44 JENKINS_DEPLOY_GUIDE.md
-rw-r--r--  1 jenkins jenkins 11378 Oct  7 05:44 Jenkinsfile
-rw-r--r--  1 jenkins jenkins 29657 Oct  7 05:44 Jenkinsfile.aliyun
-rw-r--r--  1 jenkins jenkins 26091 Oct  7 05:44 Jenkinsfile.aliyun.backup.20251006_163630
-rw-r--r--  1 jenkins jenkins 26091 Oct  7 05:44 Jenkinsfile.aliyun.backup.20251006_164809
-rw-r--r--  1 jenkins jenkins 26204 Oct  7 05:44 Jenkinsfile.aliyun.backup.20251006_174928
-rw-r--r--  1 jenkins jenkins 26204 Oct  7 05:44 Jenkinsfile.aliyun.backup.20251006_175804
-rw-r--r--  1 jenkins jenkins  4811 Oct  7 05:44 README.md
-rw-r--r--  1 jenkins jenkins  1945 Oct  7 05:44 aliyun-ecs-deploy.yml
drwxr-xr-x 14 jenkins jenkins   448 Oct  7 05:44 backend
-rw-r--r--  1 jenkins jenkins  4770 Oct  7 05:44 database.js
-rwxr-xr-x  1 jenkins jenkins  6933 Oct  7 05:44 deploy.sh
-rwxr-xr-x  1 jenkins jenkins  1735 Oct  7 05:44 docker-build.sh
-rw-r--r--  1 jenkins jenkins  1838 Oct  7 05:44 docker-compose.prod.yml
-rw-r--r--  1 jenkins jenkins  1874 Oct  7 05:44 docker-compose.yml
drwxr-xr-x  7 jenkins jenkins   224 Oct  7 05:44 frontend
-rw-r--r--  1 jenkins jenkins  8207 Oct  7 05:44 init_data.sql
-rw-r--r--  1 jenkins jenkins  5573 Oct  7 05:44 init_database.sql
drwxr-xr-x  3 jenkins jenkins    96 Oct  7 05:44 migrations
-rw-r--r--  1 jenkins jenkins  1386 Oct  7 05:44 multi-project-config.json
drwxr-xr-x 16 jenkins jenkins   512 Oct  7 05:44 node_modules
-rw-r--r--  1 jenkins jenkins  5279 Oct  7 05:44 package-lock.json
-rw-r--r--  1 jenkins jenkins   559 Oct  7 05:44 package.json
-rw-r--r--  1 jenkins jenkins  6186 Oct  7 05:44 run_migration.js
drwxr-xr-x  5 jenkins jenkins   160 Oct  7 05:44 scripts
-rw-r--r--  1 jenkins jenkins  7434 Oct  7 05:44 setup_database.js
-rw-r--r--  1 jenkins jenkins  4340 Oct  7 05:44 test_database.js
-rwxr-xr-x  1 jenkins jenkins   937 Oct  7 05:44 verify-deployment-fix.sh
[Pipeline] sh
+ pwd
/var/jenkins_home/workspace/product-catalog-pipeline
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (前端构建)
[Pipeline] echo
🎨 构建前端静态文件...
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ ls -la js/ css/
ls: cannot access 'js/': No such file or directory
ls: cannot access 'css/': No such file or directory
+ echo 静态文件目录检查完成
静态文件目录检查完成
[Pipeline] fileExists
[Pipeline] sh
+ npm install

up to date, audited 14 packages in 1s

2 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
[Pipeline] sh
+ npm run build
npm error Missing script: "build"
npm error
npm error To see a list of scripts, run:
npm error   npm run
npm error A complete log of this run can be found in: /var/jenkins_home/.npm/_logs/2025-10-06T21_44_12_196Z-debug-0.log
+ echo 跳过前端构建步骤
跳过前端构建步骤
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (后端构建)
[Pipeline] echo
⚙️ 构建后端服务...
[Pipeline] dir
Running in /var/jenkins_home/workspace/product-catalog-pipeline/backend
[Pipeline] {
[Pipeline] sh
+ npm install --production
npm warn config production Use `--omit=dev` instead.

up to date, audited 91 packages in 1s

17 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
[Pipeline] sh
+ npm test

> product-catalog-backend@1.0.0 test
> echo "Error: no test specified" && exit 1

Error: no test specified
+ echo 跳过测试步骤
跳过测试步骤
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Docker镜像构建)
[Pipeline] parallel
[Pipeline] { (Branch: 构建前端镜像)
[Pipeline] { (Branch: 构建后端镜像)
[Pipeline] stage
[Pipeline] { (构建前端镜像)
[Pipeline] stage
[Pipeline] { (构建后端镜像)
[Pipeline] echo
🐳 构建前端Docker镜像...
[Pipeline] dir
Running in /var/jenkins_home/workspace/product-catalog-pipeline/frontend
[Pipeline] {
[Pipeline] echo
🐳 构建后端Docker镜像...
[Pipeline] dir
Running in /var/jenkins_home/workspace/product-catalog-pipeline/backend
[Pipeline] {
[Pipeline] script
[Pipeline] {
[Pipeline] script
[Pipeline] {
[Pipeline] isUnix
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh
[Pipeline] sh
+ docker build -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:3-6a16d0e .
+ docker build -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:3-6a16d0e .
#0 building with "default" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 605B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/nginx:alpine
#2 DONE 0.1s
#0 building with "default" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 719B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/node:18-alpine
#2 DONE 0.1s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [internal] load build context
#4 DONE 0.0s

#5 [1/4] FROM docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8
#5 resolve docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8

#3 [internal] load .dockerignore
#3 transferring context: 134B done
#3 DONE 0.0s

#4 [internal] load build context
#4 DONE 0.0s

#5 [1/8] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#5 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#5 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e 1.9s done
#5 DONE 1.9s

#4 [internal] load build context
#4 transferring context: 104.13kB 0.0s done
#4 DONE 0.0s

#6 [3/8] COPY package*.json ./
#6 CACHED

#7 [6/8] RUN addgroup -g 1001 -S nodejs
#7 CACHED

#8 [5/8] COPY . .
#8 CACHED

#9 [2/8] WORKDIR /app
#9 CACHED

#10 [4/8] RUN npm ci --only=production
#10 CACHED

#11 [7/8] RUN adduser -S nodejs -u 1001
#11 CACHED

#12 [8/8] RUN chown -R nodejs:nodejs /app
#12 CACHED

#13 exporting to image
#13 exporting layers done
#13 exporting manifest sha256:c1852f43c78d9b71c0f6e3b276d19404a6e0d211b91f3c92e5a42c495dcd1547 done
#13 exporting config sha256:04c86ee5b6f72ca36796920105cbd04ac66000b76cd8fbfee755c03bddae40f1 done
#13 exporting attestation manifest sha256:e3b1ec4b2acefe547d561048dfb60ee2445b09c4791a933b917ffd4677c38308 0.0s done
#13 exporting manifest list sha256:a0d51fdca25b78489a73f6f008489b79ed160f1e678d045907c19b69a41f71f7
#13 exporting manifest list sha256:a0d51fdca25b78489a73f6f008489b79ed160f1e678d045907c19b69a41f71f7 done
#13 naming to crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:3-6a16d0e done
#13 unpacking to crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:3-6a16d0e 0.0s done
#13 DONE 0.1s
#5 resolve docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8 1.9s done
#5 CACHED

#4 [internal] load build context
#4 transferring context: 41.47kB 0.0s done
#4 DONE 0.0s

#6 [2/4] COPY . /usr/share/nginx/html
#6 DONE 0.0s

#7 [3/4] COPY nginx.conf /etc/nginx/conf.d/default.conf
#7 DONE 0.0s

#8 [4/4] RUN adduser -S -u 1001 -G nginx nginx || true
[Pipeline] }
#8 0.181 adduser: user 'nginx' in use
#8 DONE 0.2s

#9 exporting to image
#9 exporting layers 0.1s done
#9 exporting manifest sha256:bc0e56030ad846f8dd9e2f1069e65b361eb9ea91e4a5e0ebefa576d4962e7426 done
#9 exporting config sha256:768188167bdc1b63e7f802a33b8ebf8f04fef4a45cd8e3f14fba588e309df643 done
#9 exporting attestation manifest sha256:38a70325d8ba2a18de892f6bf24c7dbe405d72039766c21d46c73eac8f106f18 done
#9 exporting manifest list sha256:d46097ca59fe312b051038245b185f9473a46c7ecacfbe65e674d518f2236669 done
#9 naming to crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:3-6a16d0e done
#9 unpacking to crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:3-6a16d0e 0.0s done
[Pipeline] // withEnv
#9 DONE 0.2s
[Pipeline] withEnv
[Pipeline] {
[Pipeline] }
[Pipeline] withDockerRegistry
$ docker login -u aliyun7971892098 -p ******** https://crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
[Pipeline] // withEnv
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withDockerRegistry
$ docker login -u aliyun7971892098 -p ******** https://crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com
WARNING! Using --password via the CLI is insecure. Use --password-stdin.

WARNING! Your credentials are stored unencrypted in '/var/jenkins_home/workspace/product-catalog-pipeline/backend@tmp/d79ccc36-64d3-420d-b1b6-4d004a9c45a2/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded
[Pipeline] {
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh

WARNING! Your credentials are stored unencrypted in '/var/jenkins_home/workspace/product-catalog-pipeline/frontend@tmp/cd145533-422a-45e4-8277-e5ad60b8c341/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded
[Pipeline] {
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh
+ docker tag crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:3-6a16d0e crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:3-6a16d0e
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
+ docker tag crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:3-6a16d0e crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:3-6a16d0e
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh
[Pipeline] sh
+ docker push crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:3-6a16d0e
The push refers to repository [crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend]
862be973539a: Waiting
8bfa36aa66ce: Waiting
6e771e15690e: Waiting
02bb84e9f341: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
aa6cbf411aed: Waiting
d84c815451ac: Waiting
8e4c1d8cb143: Waiting
381caa154c2f: Waiting
4f375db9b96e: Waiting
e6ab550ba291: Waiting
4f375db9b96e: Waiting
e6ab550ba291: Waiting
aa6cbf411aed: Waiting
d84c815451ac: Waiting
8e4c1d8cb143: Waiting
381caa154c2f: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
862be973539a: Waiting
8bfa36aa66ce: Waiting
6e771e15690e: Waiting
02bb84e9f341: Waiting
+ docker push crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:3-6a16d0e
The push refers to repository [crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend]
4f4fb700ef54: Waiting
0bc2f07fbf03: Waiting
6c2c01fdb094: Waiting
a925aa0b96ab: Waiting
1ca01bb14b4a: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
49f3b06c840f: Waiting
6156ecb6dfff: Waiting
04ba7957f9d2: Waiting
021cb5923c0e: Waiting
66ce170f7dd8: Waiting
1ca01bb14b4a: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
49f3b06c840f: Waiting
6156ecb6dfff: Waiting
04ba7957f9d2: Waiting
021cb5923c0e: Waiting
a925aa0b96ab: Waiting
66ce170f7dd8: Waiting
4f4fb700ef54: Waiting
0bc2f07fbf03: Waiting
6c2c01fdb094: Waiting
02bb84e9f341: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
862be973539a: Waiting
8bfa36aa66ce: Waiting
6e771e15690e: Waiting
381caa154c2f: Waiting
4f375db9b96e: Waiting
e6ab550ba291: Waiting
aa6cbf411aed: Waiting
d84c815451ac: Waiting
8e4c1d8cb143: Waiting
8bfa36aa66ce: Waiting
6e771e15690e: Waiting
02bb84e9f341: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
862be973539a: Waiting
d84c815451ac: Waiting
8e4c1d8cb143: Waiting
381caa154c2f: Waiting
4f375db9b96e: Waiting
e6ab550ba291: Waiting
aa6cbf411aed: Waiting
4f4fb700ef54: Waiting
0bc2f07fbf03: Waiting
6c2c01fdb094: Waiting
04ba7957f9d2: Waiting
021cb5923c0e: Waiting
a925aa0b96ab: Waiting
1ca01bb14b4a: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
49f3b06c840f: Waiting
6156ecb6dfff: Waiting
66ce170f7dd8: Waiting
4f4fb700ef54: Waiting
0bc2f07fbf03: Waiting
6c2c01fdb094: Waiting
021cb5923c0e: Waiting
a925aa0b96ab: Waiting
1ca01bb14b4a: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
49f3b06c840f: Waiting
6156ecb6dfff: Waiting
04ba7957f9d2: Waiting
66ce170f7dd8: Waiting
4f375db9b96e: Waiting
e6ab550ba291: Waiting
aa6cbf411aed: Waiting
d84c815451ac: Waiting
8e4c1d8cb143: Waiting
381caa154c2f: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
862be973539a: Waiting
8bfa36aa66ce: Waiting
6e771e15690e: Waiting
02bb84e9f341: Waiting
aa6cbf411aed: Waiting
d84c815451ac: Waiting
8e4c1d8cb143: Waiting
381caa154c2f: Waiting
4f375db9b96e: Waiting
e6ab550ba291: Waiting
862be973539a: Waiting
8bfa36aa66ce: Waiting
6e771e15690e: Waiting
02bb84e9f341: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
862be973539a: Waiting
8bfa36aa66ce: Waiting
6e771e15690e: Waiting
02bb84e9f341: Waiting
4f375db9b96e: Waiting
e6ab550ba291: Layer already exists
aa6cbf411aed: Waiting
d84c815451ac: Waiting
8e4c1d8cb143: Waiting
381caa154c2f: Waiting
4f4fb700ef54: Waiting
0bc2f07fbf03: Waiting
6c2c01fdb094: Waiting
021cb5923c0e: Waiting
a925aa0b96ab: Waiting
1ca01bb14b4a: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
49f3b06c840f: Waiting
6156ecb6dfff: Waiting
04ba7957f9d2: Waiting
66ce170f7dd8: Waiting
021cb5923c0e: Waiting
a925aa0b96ab: Waiting
1ca01bb14b4a: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
49f3b06c840f: Waiting
6156ecb6dfff: Waiting
04ba7957f9d2: Waiting
66ce170f7dd8: Waiting
4f4fb700ef54: Waiting
0bc2f07fbf03: Waiting
6c2c01fdb094: Waiting
4f4fb700ef54: Waiting
0bc2f07fbf03: Waiting
6c2c01fdb094: Waiting
021cb5923c0e: Waiting
a925aa0b96ab: Waiting
1ca01bb14b4a: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
49f3b06c840f: Waiting
6156ecb6dfff: Waiting
04ba7957f9d2: Waiting
66ce170f7dd8: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
862be973539a: Waiting
8bfa36aa66ce: Layer already exists
6e771e15690e: Waiting
02bb84e9f341: Waiting
4f375db9b96e: Waiting
aa6cbf411aed: Waiting
d84c815451ac: Waiting
8e4c1d8cb143: Waiting
381caa154c2f: Waiting
381caa154c2f: Layer already exists
4f375db9b96e: Waiting
aa6cbf411aed: Waiting
d84c815451ac: Layer already exists
8e4c1d8cb143: Waiting
02bb84e9f341: Layer already exists
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
862be973539a: Waiting
6e771e15690e: Waiting
6156ecb6dfff: Waiting
04ba7957f9d2: Waiting
021cb5923c0e: Waiting
a925aa0b96ab: Waiting
1ca01bb14b4a: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
49f3b06c840f: Waiting
66ce170f7dd8: Waiting
6c2c01fdb094: Waiting
4f4fb700ef54: Waiting
0bc2f07fbf03: Waiting
11a12d441f27: Waiting
04ba7957f9d2: Waiting
021cb5923c0e: Waiting
a925aa0b96ab: Waiting
66ce170f7dd8: Waiting
0bc2f07fbf03: Waiting
6c2c01fdb094: Waiting
8e4c1d8cb143: Layer already exists
4f375db9b96e: Layer already exists
aa6cbf411aed: Waiting
6e771e15690e: Layer already exists
d2c2de1dcc1e: Layer already exists
b99cae132c95: Layer already exists
862be973539a: Layer already exists
4f4fb700ef54: Pushed
0bc2f07fbf03: Pushed
6156ecb6dfff: Pushed
04ba7957f9d2: Pushed
1ca01bb14b4a: Pushed
66ce170f7dd8: Pushed
aa6cbf411aed: Pushed
6c2c01fdb094: Pushed
a925aa0b96ab: Pushed
11a12d441f27: Pushed
49f3b06c840f: Pushed
3-6a16d0e: digest: sha256:a0d51fdca25b78489a73f6f008489b79ed160f1e678d045907c19b69a41f71f7 size: 856
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh
+ docker tag crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:3-6a16d0e crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:latest
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh
+ docker push crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:latest
The push refers to repository [crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend]
8e4c1d8cb143: Waiting
4f375db9b96e: Waiting
381caa154c2f: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
02bb84e9f341: Waiting
aa6cbf411aed: Waiting
862be973539a: Waiting
8bfa36aa66ce: Waiting
d84c815451ac: Waiting
e6ab550ba291: Waiting
6e771e15690e: Waiting
02bb84e9f341: Waiting
aa6cbf411aed: Waiting
862be973539a: Waiting
8e4c1d8cb143: Waiting
4f375db9b96e: Waiting
381caa154c2f: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
8bfa36aa66ce: Waiting
e6ab550ba291: Waiting
6e771e15690e: Waiting
d84c815451ac: Waiting
6e771e15690e: Waiting
d84c815451ac: Waiting
e6ab550ba291: Waiting
862be973539a: Waiting
8e4c1d8cb143: Waiting
4f375db9b96e: Waiting
381caa154c2f: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
02bb84e9f341: Waiting
aa6cbf411aed: Waiting
8bfa36aa66ce: Waiting
6e771e15690e: Waiting
d84c815451ac: Waiting
e6ab550ba291: Waiting
862be973539a: Waiting
8e4c1d8cb143: Waiting
4f375db9b96e: Waiting
381caa154c2f: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
02bb84e9f341: Waiting
aa6cbf411aed: Waiting
8bfa36aa66ce: Waiting
381caa154c2f: Waiting
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
02bb84e9f341: Waiting
aa6cbf411aed: Waiting
862be973539a: Waiting
8e4c1d8cb143: Waiting
4f375db9b96e: Layer already exists
8bfa36aa66ce: Waiting
e6ab550ba291: Waiting
6e771e15690e: Waiting
d84c815451ac: Layer already exists
02bb84e9f341: Layer already exists
aa6cbf411aed: Already exists
862be973539a: Waiting
8e4c1d8cb143: Waiting
381caa154c2f: Layer already exists
d2c2de1dcc1e: Waiting
b99cae132c95: Waiting
8bfa36aa66ce: Waiting
e6ab550ba291: Waiting
6e771e15690e: Layer already exists
e6ab550ba291: Layer already exists
8e4c1d8cb143: Layer already exists
d2c2de1dcc1e: Layer already exists
b99cae132c95: Layer already exists
862be973539a: Layer already exists
8bfa36aa66ce: Layer already exists
latest: digest: sha256:a0d51fdca25b78489a73f6f008489b79ed160f1e678d045907c19b69a41f71f7 size: 856
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withDockerRegistry
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
021cb5923c0e: Pushed
[Pipeline] // script
[Pipeline] }
[Pipeline] // dir
6e174226ea69: Pushed
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
3-6a16d0e: digest: sha256:d46097ca59fe312b051038245b185f9473a46c7ecacfbe65e674d518f2236669 size: 856
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh
+ docker tag crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:3-6a16d0e crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:latest
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh
+ docker push crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:latest
The push refers to repository [crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend]
6e174226ea69: Waiting
11a12d441f27: Waiting
4f4fb700ef54: Waiting
6c2c01fdb094: Waiting
021cb5923c0e: Waiting
6156ecb6dfff: Waiting
04ba7957f9d2: Waiting
0bc2f07fbf03: Waiting
49f3b06c840f: Waiting
a925aa0b96ab: Waiting
66ce170f7dd8: Waiting
1ca01bb14b4a: Waiting
49f3b06c840f: Waiting
a925aa0b96ab: Waiting
66ce170f7dd8: Waiting
1ca01bb14b4a: Waiting
04ba7957f9d2: Waiting
0bc2f07fbf03: Waiting
4f4fb700ef54: Waiting
6c2c01fdb094: Waiting
021cb5923c0e: Waiting
6156ecb6dfff: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
6156ecb6dfff: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
4f4fb700ef54: Waiting
6c2c01fdb094: Waiting
021cb5923c0e: Waiting
1ca01bb14b4a: Waiting
04ba7957f9d2: Waiting
0bc2f07fbf03: Waiting
49f3b06c840f: Waiting
a925aa0b96ab: Waiting
66ce170f7dd8: Waiting
021cb5923c0e: Waiting
6156ecb6dfff: Waiting
6e174226ea69: Waiting
11a12d441f27: Waiting
4f4fb700ef54: Waiting
6c2c01fdb094: Waiting
66ce170f7dd8: Waiting
1ca01bb14b4a: Waiting
04ba7957f9d2: Waiting
0bc2f07fbf03: Waiting
49f3b06c840f: Waiting
a925aa0b96ab: Waiting
a925aa0b96ab: Waiting
66ce170f7dd8: Waiting
1ca01bb14b4a: Waiting
04ba7957f9d2: Waiting
0bc2f07fbf03: Waiting
49f3b06c840f: Waiting
6c2c01fdb094: Waiting
021cb5923c0e: Waiting
6156ecb6dfff: Waiting
6e174226ea69: Waiting
11a12d441f27: Already exists
4f4fb700ef54: Waiting
021cb5923c0e: Waiting
6156ecb6dfff: Waiting
6e174226ea69: Waiting
4f4fb700ef54: Layer already exists
6c2c01fdb094: Waiting
66ce170f7dd8: Waiting
1ca01bb14b4a: Waiting
04ba7957f9d2: Layer already exists
0bc2f07fbf03: Layer already exists
49f3b06c840f: Waiting
a925aa0b96ab: Waiting
6c2c01fdb094: Layer already exists
021cb5923c0e: Layer already exists
6156ecb6dfff: Layer already exists
6e174226ea69: Layer already exists
49f3b06c840f: Layer already exists
a925aa0b96ab: Layer already exists
66ce170f7dd8: Layer already exists
1ca01bb14b4a: Layer already exists
latest: digest: sha256:d46097ca59fe312b051038245b185f9473a46c7ecacfbe65e674d518f2236669 size: 856
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withDockerRegistry
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // parallel
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (部署确认)
[Pipeline] script
[Pipeline] {
[Pipeline] input
Input requested
Approved by admin

[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (部署到阿里云)
[Pipeline] echo
🚀 部署到阿里云服务器...
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ echo 复制配置文件到服务器...
复制配置文件到服务器...
+ scp -o StrictHostKeyChecking=no docker-compose.yml root@60.205.0.185:/opt/product-catalog/
+ scp -o StrictHostKeyChecking=no .env.docker root@60.205.0.185:/opt/product-catalog/.env
[Pipeline] sh
+ echo 开始rolling部署...
开始rolling部署...
+ ssh -o StrictHostKeyChecking=no root@60.205.0.185 
                            cd /opt/product-catalog
                            
                            # 创建备份
                            docker-compose ps > deployment_backup_$(date +%Y%m%d_%H%M%S).log || true
                            
                            # 拉取最新镜像
                            echo "拉取最新镜像..."
                            docker pull crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:latest
                            docker pull crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:latest
                            
                            # 根据部署策略执行部署
                            if [ "rolling" = "recreate" ]; then
                                echo "执行重建部署..."
                                docker-compose down
                                docker-compose up -d
                            else
                                echo "执行滚动部署..."
                                docker-compose up -d --force-recreate --no-deps backend
                                sleep 10
                                docker-compose up -d --force-recreate --no-deps frontend
                                docker-compose up -d --force-recreate --no-deps nginx
                            fi
                            
                            # 清理旧镜像
                            docker image prune -f
                            
                            echo "部署完成，等待服务启动..."
                            sleep 30
                        
拉取最新镜像...
bash: line 4: 509855 Segmentation fault      docker-compose ps > deployment_backup_$(date +%Y%m%d_%H%M%S).log
latest: Pulling from hanchanglin/product-catalog-frontend
no matching manifest for linux/amd64 in the manifest list entries
latest: Pulling from hanchanglin/product-catalog-backend
no matching manifest for linux/amd64 in the manifest list entries
执行滚动部署...
bash: line 22: 509870 Segmentation fault      docker-compose up -d --force-recreate --no-deps backend
bash: line 22: 509872 Segmentation fault      docker-compose up -d --force-recreate --no-deps frontend
bash: line 22: 509873 Segmentation fault      docker-compose up -d --force-recreate --no-deps nginx
Deleted Images:
deleted: sha256:75de0bae00a203222091b4a226cf1e43864969282c63798c2523a4f0f81b3044

Total reclaimed space: 0B
部署完成，等待服务启动...
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (健康检查)
[Pipeline] echo
🏥 执行健康检查...
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ echo 健康检查尝试 1/5...
健康检查尝试 1/5...
+ curl -f http://60.205.0.185:8081/api/health --max-time 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:04 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:06 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0
curl: (7) Failed to connect to 60.205.0.185 port 8081 after 7833 ms: Couldn't connect to server
[Pipeline] echo
❌ 健康检查失败，30秒后重试...
[Pipeline] sleep
Sleeping for 30 sec
[Pipeline] sh
+ echo 健康检查尝试 2/5...
健康检查尝试 2/5...
+ curl -f http://60.205.0.185:8081/api/health --max-time 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:04 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:06 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0
curl: (7) Failed to connect to 60.205.0.185 port 8081 after 7857 ms: Couldn't connect to server
[Pipeline] echo
❌ 健康检查失败，30秒后重试...
[Pipeline] sleep
Sleeping for 30 sec
[Pipeline] sh
+ echo 健康检查尝试 3/5...
健康检查尝试 3/5...
+ curl -f http://60.205.0.185:8081/api/health --max-time 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:04 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:06 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0
curl: (7) Failed to connect to 60.205.0.185 port 8081 after 7891 ms: Couldn't connect to server
[Pipeline] echo
❌ 健康检查失败，30秒后重试...
[Pipeline] sleep
Sleeping for 30 sec
[Pipeline] sh
+ echo 健康检查尝试 4/5...
健康检查尝试 4/5...
+ curl -f http://60.205.0.185:8081/api/health --max-time 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:04 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:06 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0
curl: (7) Failed to connect to 60.205.0.185 port 8081 after 7837 ms: Couldn't connect to server
[Pipeline] echo
❌ 健康检查失败，30秒后重试...
[Pipeline] sleep
Sleeping for 30 sec
[Pipeline] sh
+ echo 健康检查尝试 5/5...
健康检查尝试 5/5...
+ curl -f http://60.205.0.185:8081/api/health --max-time 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:04 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:06 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0
curl: (7) Failed to connect to 60.205.0.185 port 8081 after 7855 ms: Couldn't connect to server
[Pipeline] error
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (部署验证)
Stage "部署验证" skipped due to earlier failure(s)
[Pipeline] getContext
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Declarative: Post Actions)
[Pipeline] echo
🧹 清理工作空间...
[Pipeline] cleanWs
[WS-CLEANUP] Deleting project workspace...
[WS-CLEANUP] Deferred wipeout is used...
[WS-CLEANUP] done
[Pipeline] echo
❌ 构建部署失败！
[Pipeline] script
[Pipeline] {
[Pipeline] echo

                ❌ Product-Catalog 部署失败！
                
                📅 失败时间: Tue Oct 07 05:56:20 CST 2025
                🌿 Git分支: origin/main
                📝 提交ID: 6a16d0e
                🔍 请检查构建日志获取详细信息
                
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
ERROR: ❌ 健康检查失败，部署可能存在问题！
Finished: FAILURE
