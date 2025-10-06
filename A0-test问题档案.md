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
Checking out Revision 7c63f3aaa83fb87f736ae5c2ee600e31190e6ba3 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 7c63f3aaa83fb87f736ae5c2ee600e31190e6ba3 # timeout=10
Commit message: "修复商品图册构建失败"
 > git rev-list --no-walk 6a16d0e9aa77027ddb0b6ebd2b2f2522f13e0658 # timeout=10
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
提交ID: 7c63f3a
[Pipeline] echo
构建号: 4
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
Checking out Revision 7c63f3aaa83fb87f736ae5c2ee600e31190e6ba3 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 7c63f3aaa83fb87f736ae5c2ee600e31190e6ba3 # timeout=10
Commit message: "修复商品图册构建失败"
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ ls -la
total 292
drwxr-xr-x 36 jenkins jenkins  1152 Oct  7 06:46 .
drwxr-xr-x  6 jenkins jenkins   192 Oct  7 06:46 ..
-rw-r--r--  1 jenkins jenkins    88 Oct  7 06:46 .dockerignore
-rw-r--r--  1 jenkins jenkins   447 Oct  7 06:46 .env.docker
-rw-r--r--  1 jenkins jenkins   110 Oct  7 06:46 .env.local
-rw-r--r--  1 jenkins jenkins   342 Oct  7 06:46 .env.production
drwxr-xr-x 13 jenkins jenkins   416 Oct  7 06:46 .git
-rw-r--r--  1 jenkins jenkins   669 Oct  7 06:46 .gitignore
-rw-r--r--  1 jenkins jenkins  6170 Oct  7 06:46 JENKINS_DEPLOY_GUIDE.md
-rw-r--r--  1 jenkins jenkins 14234 Oct  7 06:46 Jenkinsfile
-rw-r--r--  1 jenkins jenkins 29657 Oct  7 06:46 Jenkinsfile.aliyun
-rw-r--r--  1 jenkins jenkins 26091 Oct  7 06:46 Jenkinsfile.aliyun.backup.20251006_163630
-rw-r--r--  1 jenkins jenkins 26091 Oct  7 06:46 Jenkinsfile.aliyun.backup.20251006_164809
-rw-r--r--  1 jenkins jenkins 26204 Oct  7 06:46 Jenkinsfile.aliyun.backup.20251006_174928
-rw-r--r--  1 jenkins jenkins 26204 Oct  7 06:46 Jenkinsfile.aliyun.backup.20251006_175804
-rw-r--r--  1 jenkins jenkins  4811 Oct  7 06:46 README.md
-rw-r--r--  1 jenkins jenkins  1945 Oct  7 06:46 aliyun-ecs-deploy.yml
drwxr-xr-x 14 jenkins jenkins   448 Oct  7 06:46 backend
-rw-r--r--  1 jenkins jenkins  4770 Oct  7 06:46 database.js
-rwxr-xr-x  1 jenkins jenkins  6933 Oct  7 06:46 deploy.sh
-rwxr-xr-x  1 jenkins jenkins  1735 Oct  7 06:46 docker-build.sh
-rw-r--r--  1 jenkins jenkins  1838 Oct  7 06:46 docker-compose.prod.yml
-rw-r--r--  1 jenkins jenkins  2507 Oct  7 06:46 docker-compose.yml
drwxr-xr-x  7 jenkins jenkins   224 Oct  7 06:46 frontend
-rw-r--r--  1 jenkins jenkins  8207 Oct  7 06:46 init_data.sql
-rw-r--r--  1 jenkins jenkins  5573 Oct  7 06:46 init_database.sql
drwxr-xr-x  3 jenkins jenkins    96 Oct  7 06:46 migrations
-rw-r--r--  1 jenkins jenkins  1386 Oct  7 06:46 multi-project-config.json
drwxr-xr-x 16 jenkins jenkins   512 Oct  7 06:46 node_modules
-rw-r--r--  1 jenkins jenkins  5279 Oct  7 06:46 package-lock.json
-rw-r--r--  1 jenkins jenkins   559 Oct  7 06:46 package.json
-rw-r--r--  1 jenkins jenkins  6186 Oct  7 06:46 run_migration.js
drwxr-xr-x  5 jenkins jenkins   160 Oct  7 06:46 scripts
-rw-r--r--  1 jenkins jenkins  7434 Oct  7 06:46 setup_database.js
-rw-r--r--  1 jenkins jenkins  4340 Oct  7 06:46 test_database.js
-rwxr-xr-x  1 jenkins jenkins   937 Oct  7 06:46 verify-deployment-fix.sh
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
npm error A complete log of this run can be found in: /var/jenkins_home/.npm/_logs/2025-10-06T22_46_22_480Z-debug-0.log
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
🐳 构建前端Docker镜像 (多架构支持)...
[Pipeline] dir
Running in /var/jenkins_home/workspace/product-catalog-pipeline/frontend
[Pipeline] {
[Pipeline] echo
🐳 构建后端Docker镜像 (多架构支持)...
[Pipeline] dir
Running in /var/jenkins_home/workspace/product-catalog-pipeline/backend
[Pipeline] {
[Pipeline] script
[Pipeline] {
[Pipeline] script
[Pipeline] {
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withDockerRegistry
$ docker login -u aliyun7971892098 -p ******** https://crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com
[Pipeline] withDockerRegistry
$ docker login -u aliyun7971892098 -p ******** https://crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
WARNING! Using --password via the CLI is insecure. Use --password-stdin.

WARNING! Your credentials are stored unencrypted in '/var/jenkins_home/workspace/product-catalog-pipeline/frontend@tmp/618b817a-bc6c-4de2-9001-108dfa41e041/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded

WARNING! Your credentials are stored unencrypted in '/var/jenkins_home/workspace/product-catalog-pipeline/backend@tmp/4c9cab95-a117-42dc-8ed6-98758f814e91/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded
[Pipeline] {
[Pipeline] {
[Pipeline] sh
[Pipeline] sh
+ docker buildx create --use --name multiarch-builder
multiarch-builder
+ docker buildx build --platform linux/amd64,linux/arm64 -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:4-7c63f3a -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:latest --push .
+ docker buildx create --use --name multiarch-builder
multiarch-builder
+ docker buildx build --platform linux/amd64,linux/arm64 -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:4-7c63f3a -t crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:latest --push .
#0 building with "multiarch-builder" instance using docker-container driver

#1 [internal] booting buildkit
#0 building with "multiarch-builder" instance using docker-container driver

#1 [internal] booting buildkit
#1 pulling image moby/buildkit:buildx-stable-1
#1 pulling image moby/buildkit:buildx-stable-1
#1 pulling image moby/buildkit:buildx-stable-1 2.0s done
#1 pulling image moby/buildkit:buildx-stable-1 1.9s done
#1 creating container buildx_buildkit_multiarch-builder0
#1 creating container buildx_buildkit_multiarch-builder0
#1 creating container buildx_buildkit_multiarch-builder0 0.9s done
#1 creating container buildx_buildkit_multiarch-builder0 0.9s done
#1 DONE 2.8s
#1 DONE 2.9s

#2 [internal] load build definition from Dockerfile
#2 transferring dockerfile: 605B done
#2 DONE 0.0s

#3 [linux/amd64 internal] load metadata for docker.io/library/nginx:alpine

#2 [internal] load build definition from Dockerfile
#2 transferring dockerfile: 719B done
#2 DONE 0.0s

#3 [linux/amd64 internal] load metadata for docker.io/library/node:18-alpine
#3 ...

#4 [linux/arm64 internal] load metadata for docker.io/library/node:18-alpine
#4 DONE 3.5s

#5 [internal] load .dockerignore
#5 transferring context: 134B 0.0s done
#5 DONE 0.1s

#3 [linux/amd64 internal] load metadata for docker.io/library/node:18-alpine
#3 DONE 3.7s

#6 [internal] load build context
#6 transferring context: 104.13kB 0.0s done
#6 DONE 0.1s

#7 [linux/amd64 1/8] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#7 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e done
#7 DONE 0.1s

#8 [linux/arm64 1/8] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#8 resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e done
#3 DONE 3.4s

#4 [linux/arm64 internal] load metadata for docker.io/library/nginx:alpine
#4 DONE 3.5s

#5 [internal] load .dockerignore
#5 transferring context: 2B done
#5 DONE 0.0s

#6 [internal] load build context
#6 transferring context: 41.49kB done
#6 DONE 0.0s

#7 [linux/arm64 1/4] FROM docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8
#7 resolve docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8 done
#7 DONE 0.1s

#8 [linux/amd64 1/4] FROM docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8
#8 resolve docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8 done
#8 sha256:cb1ff4086f82493a4b8b02ec71bfed092cad25bd5bf302aec78d4979895350cb 0B / 16.84MB 0.2s
#8 sha256:a992fbc61ecc9d8291c27f9add7b8a07d374c06a435d4734519b634762cf1c51 0B / 1.40kB 0.2s
#8 sha256:7a8a46741e18ed98437271669138116163f14596f411c1948fd7836e39f1afea 0B / 405B 0.2s
#8 sha256:c9ebe2ff2d2cd981811cefb6df49a116da6074c770c07ee86a6ae2ebe7eee926 0B / 1.21kB 0.2s
#8 sha256:a992fbc61ecc9d8291c27f9add7b8a07d374c06a435d4734519b634762cf1c51 1.40kB / 1.40kB 0.5s done
#8 sha256:7a8a46741e18ed98437271669138116163f14596f411c1948fd7836e39f1afea 405B / 405B 0.5s done
#8 sha256:c9ebe2ff2d2cd981811cefb6df49a116da6074c770c07ee86a6ae2ebe7eee926 1.21kB / 1.21kB 0.5s done
#8 sha256:9adfbae99cb79774fdc14ca03a0a0154b8c199a69f69316bcfce64b07f80719f 0B / 955B 0.2s
#8 sha256:403e3f251637881bbdc5fb06df8da55c149c00ccb0addbcb7839fa4ad60dfd04 0B / 628B 0.2s
#8 sha256:9824c27679d3b27c5e1cb00a73adb6f4f8d556994111c12db3c5d61a0c843df8 0B / 3.80MB 0.2s
#8 sha256:9adfbae99cb79774fdc14ca03a0a0154b8c199a69f69316bcfce64b07f80719f 955B / 955B 0.5s done
#8 sha256:403e3f251637881bbdc5fb06df8da55c149c00ccb0addbcb7839fa4ad60dfd04 628B / 628B 0.6s done
#8 sha256:6bc572a340ecbc60aca0c624f76b32de0b073d5efa4fa1e0b6d9da6405976946 0B / 1.81MB 0.2s
#8 sha256:cb1ff4086f82493a4b8b02ec71bfed092cad25bd5bf302aec78d4979895350cb 2.10MB / 16.84MB 1.7s
#8 sha256:cb1ff4086f82493a4b8b02ec71bfed092cad25bd5bf302aec78d4979895350cb 4.19MB / 16.84MB 1.8s
#8 sha256:cb1ff4086f82493a4b8b02ec71bfed092cad25bd5bf302aec78d4979895350cb 9.58MB / 16.84MB 2.0s
#8 sha256:9824c27679d3b27c5e1cb00a73adb6f4f8d556994111c12db3c5d61a0c843df8 3.80MB / 3.80MB 1.5s done
#8 sha256:cb1ff4086f82493a4b8b02ec71bfed092cad25bd5bf302aec78d4979895350cb 14.68MB / 16.84MB 2.1s
#8 extracting sha256:9824c27679d3b27c5e1cb00a73adb6f4f8d556994111c12db3c5d61a0c843df8 0.1s done
#8 sha256:cb1ff4086f82493a4b8b02ec71bfed092cad25bd5bf302aec78d4979895350cb 16.84MB / 16.84MB 2.2s done
#8 sha256:6bc572a340ecbc60aca0c624f76b32de0b073d5efa4fa1e0b6d9da6405976946 1.05MB / 1.81MB 1.4s
#8 sha256:6bc572a340ecbc60aca0c624f76b32de0b073d5efa4fa1e0b6d9da6405976946 1.81MB / 1.81MB 1.4s done
#8 extracting sha256:6bc572a340ecbc60aca0c624f76b32de0b073d5efa4fa1e0b6d9da6405976946 0.1s done
#8 DONE 2.6s

#7 [linux/arm64 1/4] FROM docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8
#7 sha256:021cb5923c0e90937539b3bc922d668109e6fa19b27d1e67bf0d6cb84cbc94d8 2.10MB / 16.99MB 1.4s
#7 sha256:66ce170f7dd87f4ee563e53b9f099a4e295f5e52cd580b4b84df4d3879c41486 0B / 1.40kB 0.5s
#7 sha256:6c2c01fdb0949fef1a50f981f1c837eb1076c7731fbbcc3382fe699c33f232c6 0B / 1.21kB 0.3s
#7 sha256:66ce170f7dd87f4ee563e53b9f099a4e295f5e52cd580b4b84df4d3879c41486 1.40kB / 1.40kB 0.5s done
#7 sha256:0bc2f07fbf03f53f2569fbdf75ab4c409fbde0d5ab4b4a6d49e8bfbd41577b76 0B / 403B 0.2s
#7 sha256:021cb5923c0e90937539b3bc922d668109e6fa19b27d1e67bf0d6cb84cbc94d8 5.24MB / 16.99MB 1.5s
#7 sha256:6156ecb6dfff3c433e78d41dab6d6dd7d2c5c759f6faebb49c0b6bc04874509b 0B / 953B 0.2s
#7 ...

#8 [linux/amd64 1/4] FROM docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8
#8 extracting sha256:403e3f251637881bbdc5fb06df8da55c149c00ccb0addbcb7839fa4ad60dfd04 done
#8 extracting sha256:9adfbae99cb79774fdc14ca03a0a0154b8c199a69f69316bcfce64b07f80719f done
#8 extracting sha256:7a8a46741e18ed98437271669138116163f14596f411c1948fd7836e39f1afea done
#8 extracting sha256:c9ebe2ff2d2cd981811cefb6df49a116da6074c770c07ee86a6ae2ebe7eee926 done
#8 extracting sha256:a992fbc61ecc9d8291c27f9add7b8a07d374c06a435d4734519b634762cf1c51 done
#8 extracting sha256:cb1ff4086f82493a4b8b02ec71bfed092cad25bd5bf302aec78d4979895350cb 0.3s done
#8 DONE 2.9s

#7 [linux/arm64 1/4] FROM docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8
#7 sha256:021cb5923c0e90937539b3bc922d668109e6fa19b27d1e67bf0d6cb84cbc94d8 12.58MB / 16.99MB 1.7s
#7 ...

#9 [linux/amd64 2/4] COPY . /usr/share/nginx/html
#9 DONE 0.1s

#10 [linux/amd64 3/4] COPY nginx.conf /etc/nginx/conf.d/default.conf
#10 DONE 0.0s

#7 [linux/arm64 1/4] FROM docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8
#7 sha256:021cb5923c0e90937539b3bc922d668109e6fa19b27d1e67bf0d6cb84cbc94d8 16.99MB / 16.99MB 1.8s done
#7 sha256:0bc2f07fbf03f53f2569fbdf75ab4c409fbde0d5ab4b4a6d49e8bfbd41577b76 403B / 403B 0.5s done
#7 sha256:6156ecb6dfff3c433e78d41dab6d6dd7d2c5c759f6faebb49c0b6bc04874509b 953B / 953B 0.5s done
#7 sha256:6c2c01fdb0949fef1a50f981f1c837eb1076c7731fbbcc3382fe699c33f232c6 1.21kB / 1.21kB 0.9s done
#7 sha256:04ba7957f9d23b5a6073e2690367274e07226e16229a3874c65e854a457ca4d2 0B / 627B 0.2s
#7 sha256:49f3b06c840fcb4c48cf9bfe1da039269b88c682942434e2bf8b266d3acdd4fd 0B / 1.80MB 0.2s
#8 sha256:02bb84e9f3412827f177bc6c020812249b32a8425d2c1858e9d71bd4c015f031 0B / 443B 0.2s
#7 ...

#11 [linux/amd64 4/4] RUN adduser -S -u 1001 -G nginx nginx || true
#11 0.192 adduser: user 'nginx' in use
#11 DONE 0.2s

#7 [linux/arm64 1/4] FROM docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8
#7 sha256:04ba7957f9d23b5a6073e2690367274e07226e16229a3874c65e854a457ca4d2 627B / 627B 0.4s done
#7 sha256:6e174226ea690ced550e5641249a412cdbefd2d09871f3e64ab52137a54ba606 0B / 4.13MB 0.2s
#8 sha256:8bfa36aa66ce614f6da68a16fb71f875da8d623310f0cb80ae1ecfa092f587f6 0B / 1.26MB 0.2s
#8 sha256:02bb84e9f3412827f177bc6c020812249b32a8425d2c1858e9d71bd4c015f031 443B / 443B 0.6s done
#8 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 0B / 39.66MB 0.2s
#7 sha256:6e174226ea690ced550e5641249a412cdbefd2d09871f3e64ab52137a54ba606 2.10MB / 4.13MB 0.8s
#7 sha256:6e174226ea690ced550e5641249a412cdbefd2d09871f3e64ab52137a54ba606 4.13MB / 4.13MB 0.8s done
#7 extracting sha256:6e174226ea690ced550e5641249a412cdbefd2d09871f3e64ab52137a54ba606 0.1s done
#8 sha256:8bfa36aa66ce614f6da68a16fb71f875da8d623310f0cb80ae1ecfa092f587f6 1.26MB / 1.26MB 0.6s done
#8 sha256:6e771e15690e2fabf2332d3a3b744495411d6e0b00b2aea64419b58b0066cf81 0B / 3.99MB 0.2s
#7 sha256:49f3b06c840fcb4c48cf9bfe1da039269b88c682942434e2bf8b266d3acdd4fd 1.05MB / 1.80MB 1.4s
#8 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 8.39MB / 39.66MB 0.6s
#7 sha256:49f3b06c840fcb4c48cf9bfe1da039269b88c682942434e2bf8b266d3acdd4fd 1.80MB / 1.80MB 1.9s done
#8 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 16.78MB / 39.66MB 0.9s
#8 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 25.17MB / 39.66MB 1.2s
#7 extracting sha256:49f3b06c840fcb4c48cf9bfe1da039269b88c682942434e2bf8b266d3acdd4fd 0.1s done
#7 extracting sha256:04ba7957f9d23b5a6073e2690367274e07226e16229a3874c65e854a457ca4d2 done
#7 extracting sha256:6156ecb6dfff3c433e78d41dab6d6dd7d2c5c759f6faebb49c0b6bc04874509b done
#7 extracting sha256:0bc2f07fbf03f53f2569fbdf75ab4c409fbde0d5ab4b4a6d49e8bfbd41577b76 done
#7 extracting sha256:6c2c01fdb0949fef1a50f981f1c837eb1076c7731fbbcc3382fe699c33f232c6 done
#7 DONE 5.1s
#8 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 27.26MB / 39.66MB 1.4s

#7 [linux/arm64 1/4] FROM docker.io/library/nginx:alpine@sha256:42a516af16b852e33b7682d5ef8acbd5d13fe08fecadc7ed98605ba5e3b26ab8
#7 extracting sha256:66ce170f7dd87f4ee563e53b9f099a4e295f5e52cd580b4b84df4d3879c41486 done
#7 extracting sha256:021cb5923c0e90937539b3bc922d668109e6fa19b27d1e67bf0d6cb84cbc94d8
#7 extracting sha256:021cb5923c0e90937539b3bc922d668109e6fa19b27d1e67bf0d6cb84cbc94d8 0.3s done
#7 DONE 5.4s
#8 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 34.60MB / 39.66MB 1.5s
#8 sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 39.66MB / 39.66MB 1.7s done

#12 [linux/arm64 2/4] COPY . /usr/share/nginx/html
#12 DONE 0.1s

#13 [linux/arm64 3/4] COPY nginx.conf /etc/nginx/conf.d/default.conf
#13 DONE 0.0s

#14 [linux/arm64 4/4] RUN adduser -S -u 1001 -G nginx nginx || true
#14 0.042 adduser: user 'nginx' in use
#14 DONE 0.1s

#15 exporting to image
#15 exporting layers
#15 exporting layers 0.2s done
#8 sha256:6e771e15690e2fabf2332d3a3b744495411d6e0b00b2aea64419b58b0066cf81 3.99MB / 3.99MB 1.5s done
#8 extracting sha256:6e771e15690e2fabf2332d3a3b744495411d6e0b00b2aea64419b58b0066cf81
#8 extracting sha256:6e771e15690e2fabf2332d3a3b744495411d6e0b00b2aea64419b58b0066cf81 0.1s done
#8 extracting sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a
#15 exporting manifest sha256:36ccd2b25b3e9f934f29b714518627fb5482fc1a4da44f0aff37f8b1aeab0d2e done
#15 exporting config sha256:7340b9d679a5b5e59266ee94efe1f361854b8b407c719bb0dab563cc5b0bef5d done
#15 exporting attestation manifest sha256:b44ca3b08b861feb1f12e2b13e9abeaca1addf970c10ed6b47558be150f3d2d6 0.0s done
#15 exporting manifest sha256:7abc2d402e73ace721756ee7534db39a731a73abc3cc96518d3f61fa97feae1b done
#15 exporting config sha256:a0da45a3ec1e28251c5c58b35e0ec7732dce6cf2873e07fdda331715b92f4187 done
#15 exporting attestation manifest sha256:a8e0d6def008a7a019636fcc14f44d2510ea634861d1b70c03565792ba90e306 0.0s done
#15 exporting manifest list sha256:9f9fc514ebddc9fcbc441c0dcd3215c2cb25de74da835a0e43fd8b52d4510d40 done
#15 pushing layers
#15 ...

#16 [auth] hanchanglin/product-catalog-frontend:pull,push token for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com
#16 DONE 0.0s
#8 extracting sha256:d84c815451acbca96b6e6bdb479929222bec57121dfe10cc5b128c5c2dbaf10a 0.9s done
#8 extracting sha256:8bfa36aa66ce614f6da68a16fb71f875da8d623310f0cb80ae1ecfa092f587f6 0.1s done
#8 extracting sha256:02bb84e9f3412827f177bc6c020812249b32a8425d2c1858e9d71bd4c015f031 done
#8 DONE 6.5s

#7 [linux/amd64 1/8] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#7 sha256:25ff2da83641908f65c3a74d80409d6b1b62ccfaab220b9ea70b80df5a2e0549 446B / 446B 0.7s done
#7 sha256:1e5a4c89cee5c0826c540ab06d4b6b491c96eda01837f430bd47f0d26702d6e3 0B / 1.26MB 1.8s
#7 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 25.17MB / 40.01MB 1.7s
#7 sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870 3.64MB / 3.64MB 0.8s done
#7 extracting sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870 0.1s done

#15 exporting to image
#7 sha256:1e5a4c89cee5c0826c540ab06d4b6b491c96eda01837f430bd47f0d26702d6e3 1.05MB / 1.26MB 2.0s
#7 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 27.51MB / 40.01MB 1.8s
#7 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 32.01MB / 40.01MB 2.0s
#7 sha256:1e5a4c89cee5c0826c540ab06d4b6b491c96eda01837f430bd47f0d26702d6e3 1.26MB / 1.26MB 2.3s
#7 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 35.67MB / 40.01MB 2.1s
#7 ...

#9 [linux/arm64 2/8] WORKDIR /app
#9 DONE 0.4s

#10 [linux/arm64 3/8] COPY package*.json ./
#10 DONE 0.0s

#7 [linux/amd64 1/8] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#7 sha256:1e5a4c89cee5c0826c540ab06d4b6b491c96eda01837f430bd47f0d26702d6e3 1.26MB / 1.26MB 2.3s done
#7 sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 40.01MB / 40.01MB 2.2s done
#7 ...

#11 [linux/arm64 4/8] RUN npm ci --only=production
#11 0.377 npm warn config only Use `--omit=dev` to omit dev dependencies from the install.
#11 ...

#7 [linux/amd64 1/8] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#7 extracting sha256:dd71dde834b5c203d162902e6b8994cb2309ae049a0eabc4efea161b2b5a3d0e 1.4s done
#7 DONE 8.5s

#7 [linux/amd64 1/8] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#7 extracting sha256:1e5a4c89cee5c0826c540ab06d4b6b491c96eda01837f430bd47f0d26702d6e3 0.0s done
#7 extracting sha256:25ff2da83641908f65c3a74d80409d6b1b62ccfaab220b9ea70b80df5a2e0549 done
#7 DONE 8.5s

#12 [linux/amd64 2/8] WORKDIR /app
#12 DONE 0.1s

#11 [linux/arm64 4/8] RUN npm ci --only=production
#11 ...

#13 [linux/amd64 3/8] COPY package*.json ./
#13 DONE 0.0s

#14 [linux/amd64 4/8] RUN npm ci --only=production
#15 pushing layers 3.2s done
#15 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:4-7c63f3a@sha256:9f9fc514ebddc9fcbc441c0dcd3215c2cb25de74da835a0e43fd8b52d4510d40
#14 1.104 npm warn config only Use `--omit=dev` to omit dev dependencies from the install.
#15 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:4-7c63f3a@sha256:9f9fc514ebddc9fcbc441c0dcd3215c2cb25de74da835a0e43fd8b52d4510d40 1.2s done
#15 pushing layers 0.5s done
#15 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:latest@sha256:9f9fc514ebddc9fcbc441c0dcd3215c2cb25de74da835a0e43fd8b52d4510d40
#14 ...

#11 [linux/arm64 4/8] RUN npm ci --only=production
#11 3.601 
#11 3.601 added 90 packages, and audited 91 packages in 3s
#11 3.601 
#11 3.601 17 packages are looking for funding
#11 3.601   run `npm fund` for details
#11 3.602 
#11 3.602 found 0 vulnerabilities
#11 3.603 npm notice
#11 3.603 npm notice New major version of npm available! 10.8.2 -> 11.6.1
#11 3.603 npm notice Changelog: https://github.com/npm/cli/releases/tag/v11.6.1
#11 3.603 npm notice To update run: npm install -g npm@11.6.1
#11 3.603 npm notice
#11 DONE 3.7s

#15 [linux/arm64 5/8] COPY . .
#15 DONE 0.0s

#16 [linux/arm64 6/8] RUN addgroup -g 1001 -S nodejs
#16 DONE 0.0s

#17 [linux/arm64 7/8] RUN adduser -S nodejs -u 1001
#17 DONE 0.1s

#14 [linux/amd64 4/8] RUN npm ci --only=production
#15 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:latest@sha256:9f9fc514ebddc9fcbc441c0dcd3215c2cb25de74da835a0e43fd8b52d4510d40 0.7s done
#15 DONE 5.9s
[Pipeline] }
[Pipeline] // withDockerRegistry
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
#14 ...

#18 [linux/arm64 8/8] RUN chown -R nodejs:nodejs /app
#18 DONE 1.2s

#14 [linux/amd64 4/8] RUN npm ci --only=production
[Pipeline] // stage
[Pipeline] }
#14 5.243 
#14 5.243 added 90 packages, and audited 91 packages in 4s
#14 5.243 
#14 5.243 17 packages are looking for funding
#14 5.243   run `npm fund` for details
#14 5.245 
#14 5.245 found 0 vulnerabilities
#14 5.249 npm notice
#14 5.249 npm notice New major version of npm available! 10.8.2 -> 11.6.1
#14 5.249 npm notice Changelog: https://github.com/npm/cli/releases/tag/v11.6.1
#14 5.249 npm notice To update run: npm install -g npm@11.6.1
#14 5.249 npm notice
#14 DONE 5.3s

#19 [linux/amd64 5/8] COPY . .
#19 DONE 0.0s

#20 [linux/amd64 6/8] RUN addgroup -g 1001 -S nodejs
#20 DONE 0.1s

#21 [linux/amd64 7/8] RUN adduser -S nodejs -u 1001
#21 DONE 0.1s

#22 [linux/amd64 8/8] RUN chown -R nodejs:nodejs /app
#22 DONE 1.0s

#23 exporting to image
#23 exporting layers
#23 exporting layers 0.8s done
#23 ...

#24 [auth] hanchanglin/product-catalog-backend:pull,push token for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com
#24 DONE 0.0s

#23 exporting to image
#23 exporting manifest sha256:d4e84a598fbe042e7265bca7a5a860bbcfdd2935f8bbaad6c8f90401d5092c18 done
#23 exporting config sha256:8d6fafaaac4a1ef25a269c130eff85859ca5a842c2a1c69676648e4bd2983f22 done
#23 exporting attestation manifest sha256:c4d68818e2df93b7e04ec46b397695324f4dd1634c32b7f87ed3cb6505a7ed35 done
#23 exporting manifest sha256:2351e242fa4eb7cf4761fbb31e49560250ae0a5e5f721e2e35c34a0abf85565f done
#23 exporting config sha256:5e57aa9f231decbadca79a5279e166ccad230923018036376eb18487276fc7f8 done
#23 exporting attestation manifest sha256:af4476ffae7b47aa3e02e24eb00b92dcd46f901e25f21b69661aad130f0cf7d4 done
#23 exporting manifest list sha256:f46675a3732790e4e42d5acf5840181d9c3e17c32ca7a76d95088304b4065c14 done
#23 pushing layers
#23 pushing layers 12.2s done
#23 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:4-7c63f3a@sha256:f46675a3732790e4e42d5acf5840181d9c3e17c32ca7a76d95088304b4065c14
#23 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:4-7c63f3a@sha256:f46675a3732790e4e42d5acf5840181d9c3e17c32ca7a76d95088304b4065c14 1.2s done
#23 pushing layers 0.5s done
#23 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:latest@sha256:f46675a3732790e4e42d5acf5840181d9c3e17c32ca7a76d95088304b4065c14
#23 pushing manifest for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:latest@sha256:f46675a3732790e4e42d5acf5840181d9c3e17c32ca7a76d95088304b4065c14 0.7s done
#23 DONE 15.5s
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
                            set -e  # 遇到错误立即退出
                            cd /opt/product-catalog
                            
                            # 检查系统资源
                            echo "检查系统资源..."
                            free -h
                            df -h
                            
                            # 检查Docker状态
                            echo "检查Docker服务状态..."
                            systemctl is-active docker || (echo "Docker服务未运行，尝试启动..." && systemctl start docker)
                            
                            # 创建备份
                            echo "创建部署备份..."
                            docker-compose ps > deployment_backup_$(date +%Y%m%d_%H%M%S).log 2>/dev/null || echo "无现有服务需要备份"
                            
                            # 清理可能损坏的容器和网络
                            echo "清理可能损坏的资源..."
                            docker container prune -f || true
                            docker network prune -f || true
                            
                            # 拉取最新镜像
                            echo "拉取最新镜像..."
                            docker pull crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:latest || exit 1
                            docker pull crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:latest || exit 1
                            
                            # 根据部署策略执行部署
                            if [ "rolling" = "recreate" ]; then
                                echo "执行重建部署..."
                                docker-compose down --remove-orphans || true
                                sleep 5
                                docker-compose up -d --remove-orphans
                            else
                                echo "执行滚动部署..."
                                # 先停止可能有问题的服务
                                docker-compose stop backend frontend || true
                                sleep 5
                                
                                # 启动MySQL（如果未运行）
                                docker-compose up -d mysql
                                sleep 20
                                
                                # 启动后端
                                docker-compose up -d backend
                                sleep 15
                                
                                # 启动前端
                                docker-compose up -d frontend
                                sleep 10
                            fi
                            
                            # 检查服务状态
                            echo "检查服务状态..."
                            docker-compose ps
                            
                            # 清理旧镜像
                            docker image prune -f || true
                            
                            echo "部署完成，等待服务启动..."
                            sleep 30
                        
检查系统资源...
              total        used        free      shared  buff/cache   available
Mem:          1.8Gi       1.4Gi       350Mi       2.0Mi       285Mi       486Mi
Swap:            0B          0B          0B
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        916M     0  916M   0% /dev
tmpfs           936M     0  936M   0% /dev/shm
tmpfs           936M  928K  935M   1% /run
tmpfs           936M     0  936M   0% /sys/fs/cgroup
/dev/vda3        40G  7.8G   30G  21% /
/dev/vda2       200M  5.8M  194M   3% /boot/efi
tmpfs           188M     0  188M   0% /run/user/0
overlay          40G  7.8G   30G  21% /var/lib/docker/overlay2/7644f02ff6b9fec34b259741a5c688d3d59e4c2644e65554c27497dc2b9258cc/merged
overlay          40G  7.8G   30G  21% /var/lib/docker/overlay2/08d3c10a5427df141e391cec22e7c32241546a3ac2c5f2877541e04fd3e0ead1/merged
overlay          40G  7.8G   30G  21% /var/lib/docker/overlay2/dd7ceb0a71983435458b1d5424790c2d216510c4da0a2ae1026696714a81a32e/merged
overlay          40G  7.8G   30G  21% /var/lib/docker/overlay2/27bce4e5fef2c903e19e92c09ccafac261d51d1a5790a0b2a6177e81921281d1/merged
检查Docker服务状态...
active
创建部署备份...
无现有服务需要备份
清理可能损坏的资源...
bash: line 15: 523141 Segmentation fault      docker-compose ps > deployment_backup_$(date +%Y%m%d_%H%M%S).log 2> /dev/null
Total reclaimed space: 0B
拉取最新镜像...
latest: Pulling from hanchanglin/product-catalog-frontend
9824c27679d3: Already exists
6bc572a340ec: Already exists
403e3f251637: Already exists
9adfbae99cb7: Already exists
7a8a46741e18: Already exists
c9ebe2ff2d2c: Already exists
a992fbc61ecc: Already exists
cb1ff4086f82: Already exists
13a44da67bc3: Pulling fs layer
5e79186c3506: Pulling fs layer
8aa35cf6bde3: Pulling fs layer
5e79186c3506: Verifying Checksum
5e79186c3506: Download complete
8aa35cf6bde3: Verifying Checksum
8aa35cf6bde3: Download complete
13a44da67bc3: Download complete
13a44da67bc3: Pull complete
5e79186c3506: Pull complete
8aa35cf6bde3: Pull complete
Digest: sha256:9f9fc514ebddc9fcbc441c0dcd3215c2cb25de74da835a0e43fd8b52d4510d40
Status: Downloaded newer image for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:latest
crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-frontend:latest
latest: Pulling from hanchanglin/product-catalog-backend
f18232174bc9: Already exists
dd71dde834b5: Already exists
1e5a4c89cee5: Already exists
25ff2da83641: Already exists
93f9f0d16b32: Pulling fs layer
d8d40057adbc: Pulling fs layer
d7ca967066df: Pulling fs layer
1a378347b579: Pulling fs layer
d208fc506ada: Pulling fs layer
2dbf49de32cb: Pulling fs layer
1d66ba3855d6: Pulling fs layer
1a378347b579: Waiting
d208fc506ada: Waiting
2dbf49de32cb: Waiting
1d66ba3855d6: Waiting
d8d40057adbc: Download complete
93f9f0d16b32: Verifying Checksum
93f9f0d16b32: Download complete
93f9f0d16b32: Pull complete
d8d40057adbc: Pull complete
1a378347b579: Download complete
d208fc506ada: Verifying Checksum
d208fc506ada: Download complete
2dbf49de32cb: Verifying Checksum
2dbf49de32cb: Download complete
d7ca967066df: Verifying Checksum
d7ca967066df: Download complete
1d66ba3855d6: Verifying Checksum
1d66ba3855d6: Download complete
d7ca967066df: Pull complete
1a378347b579: Pull complete
d208fc506ada: Pull complete
2dbf49de32cb: Pull complete
1d66ba3855d6: Pull complete
Digest: sha256:f46675a3732790e4e42d5acf5840181d9c3e17c32ca7a76d95088304b4065c14
Status: Downloaded newer image for crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:latest
crpi-p6joc7xl4atpiic8.cn-hangzhou.personal.cr.aliyuncs.com/hanchanglin/product-catalog-backend:latest
执行滚动部署...
bash: line 50: 523254 Segmentation fault      docker-compose stop backend frontend
bash: line 50: 523256 Segmentation fault      docker-compose up -d mysql
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (健康检查)
Stage "健康检查" skipped due to earlier failure(s)
[Pipeline] getContext
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
                
                📅 失败时间: Tue Oct 07 06:51:48 CST 2025
                🌿 Git分支: origin/main
                📝 提交ID: 7c63f3a
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
ERROR: script returned exit code 139
Finished: FAILURE
