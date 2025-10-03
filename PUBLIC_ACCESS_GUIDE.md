# TBK开发环境公网访问配置指南

## 概述

TBK开发环境现在支持公网访问，提供了多种部署方式和配置选项。本指南详细说明了如何配置和部署支持公网访问的开发环境。

## 🌐 公网访问方案

### 1. 本地公网访问（推荐用于开发测试）

**特点：**
- 在本地机器上运行，通过端口映射支持公网访问
- 使用Nginx反向代理提供负载均衡和SSL终止
- 包含完整的监控和管理工具

**部署命令：**
```bash
# 部署公网访问环境
./scripts/deploy-public.sh

# 停止公网访问环境
./scripts/stop-public.sh
```

**访问地址：**
- HTTP: http://localhost:8080
- HTTPS: https://localhost (需要配置SSL证书)
- 管理面板: http://localhost:9000 (Portainer)
- Nginx状态: http://localhost:8081/nginx_status

### 2. 阿里云ECS部署（推荐用于生产环境）

**特点：**
- 完全的云端部署解决方案
- 自动创建ECS实例、安全组和密钥对
- 包含完整的SSL证书配置和域名管理

**部署命令：**
```bash
# 创建阿里云ECS实例并配置环境
./scripts/deploy-aliyun.sh

# 配置SSL证书
./scripts/setup-ssl.sh yourdomain.com admin@yourdomain.com letsencrypt
```

## 📁 文件结构

```
jenkins-service/
├── docker-compose.public.yml      # 公网访问Docker配置
├── aliyun-ecs-deploy.yml          # 阿里云ECS部署配置
├── nginx/
│   ├── public.conf                # 本地公网访问Nginx配置
│   └── production.conf            # 生产环境Nginx配置
├── ssl/                           # SSL证书目录
├── scripts/
│   ├── deploy-public.sh           # 本地公网部署脚本
│   ├── stop-public.sh             # 停止公网环境脚本
│   ├── deploy-aliyun.sh           # 阿里云ECS部署脚本
│   └── setup-ssl.sh               # SSL证书配置脚本
└── PUBLIC_ACCESS_GUIDE.md         # 本文档
```

## 🔧 配置详情

### Docker Compose配置

#### 本地公网访问 (docker-compose.public.yml)

```yaml
services:
  tbk-dev-public:     # 主应用服务
  nginx-public:       # Nginx反向代理
  redis-public:       # Redis缓存
  mysql-public:       # MySQL数据库
  portainer:          # 容器管理工具
```

**端口映射：**
- 8080 → 应用HTTP端口
- 80/443 → Nginx HTTP/HTTPS端口
- 9000 → Portainer管理界面
- 6379 → Redis端口
- 3306 → MySQL端口

#### 阿里云ECS部署 (aliyun-ecs-deploy.yml)

```yaml
services:
  tbk-production:     # 生产应用服务
  nginx-production:   # 生产Nginx代理
  redis-production:   # 生产Redis缓存
  portainer:          # 容器管理
  fluentd:           # 日志收集
```

### Nginx配置

#### 功能特性

1. **SSL/TLS支持**
   - 支持HTTP到HTTPS自动重定向
   - 现代SSL配置（TLS 1.2+）
   - HSTS安全头

2. **安全防护**
   - 请求频率限制
   - 安全头配置
   - XSS和CSRF防护

3. **性能优化**
   - Gzip压缩
   - 静态文件缓存
   - 连接保持

4. **监控支持**
   - 访问日志
   - 错误日志
   - Nginx状态页面

### 环境变量配置

#### 公网访问环境变量 (.env.public)

```bash
# 应用配置
NODE_ENV=development
PUBLIC_PORT=8080
PUBLIC_ACCESS=true
TRUST_PROXY=true

# 数据库配置
DB_HOST=60.205.0.185
DB_USER=peach_wiki
DB_PASSWORD=han0419/
DB_NAME=peach_wiki

# 安全配置
CORS_ORIGIN=*
RATE_LIMIT_ENABLED=true
SSL_ENABLED=true
```

## 🚀 部署步骤

### 方案一：本地公网访问部署

1. **准备环境**
   ```bash
   cd jenkins-service
   ```

2. **配置SSL证书（可选）**
   ```bash
   # 生成自签名证书（开发用）
   ./scripts/setup-ssl.sh localhost admin@example.com self-signed
   
   # 或使用Let's Encrypt（需要真实域名）
   ./scripts/setup-ssl.sh yourdomain.com admin@yourdomain.com letsencrypt
   ```

3. **部署应用**
   ```bash
   ./scripts/deploy-public.sh
   ```

4. **配置防火墙**
   ```bash
   # macOS
   sudo pfctl -f /etc/pf.conf
   
   # Linux (Ubuntu)
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   sudo ufw allow 8080/tcp
   ```

5. **验证部署**
   ```bash
   curl http://localhost:8080/health
   curl -k https://localhost/health
   ```

### 方案二：阿里云ECS部署

1. **安装阿里云CLI**
   ```bash
   # macOS
   brew install aliyun-cli
   
   # 配置认证
   aliyun configure
   ```

2. **创建ECS实例**
   ```bash
   ./scripts/deploy-aliyun.sh
   ```

3. **连接到ECS实例**
   ```bash
   ssh -i tbk-dev-key.pem root@[PUBLIC_IP]
   ```

4. **在ECS上部署应用**
   ```bash
   # 上传文件
   scp -i tbk-dev-key.pem -r . root@[PUBLIC_IP]:/opt/tbk/
   
   # 在ECS上运行
   cd /opt/tbk
   docker-compose -f aliyun-ecs-deploy.yml up -d
   ```

## 🔒 SSL证书配置

### 证书类型

1. **自签名证书（开发环境）**
   ```bash
   ./scripts/setup-ssl.sh localhost admin@example.com self-signed
   ```

2. **Let's Encrypt证书（生产环境）**
   ```bash
   ./scripts/setup-ssl.sh yourdomain.com admin@yourdomain.com letsencrypt
   ```

3. **自定义证书**
   ```bash
   ./scripts/setup-ssl.sh yourdomain.com admin@yourdomain.com custom
   ```

### 证书续期

Let's Encrypt证书自动续期：
```bash
# 手动续期
./ssl/renew-cert.sh

# 添加到crontab自动续期
0 2 * * 0 /path/to/ssl/renew-cert.sh
```

## 🌍 域名配置

### DNS记录配置

为您的域名添加以下DNS记录：

```
类型    名称                值                   TTL
A       yourdomain.com     [服务器IP地址]        300
A       www.yourdomain.com [服务器IP地址]        300
CNAME   api.yourdomain.com yourdomain.com       300
```

### 域名验证

```bash
# 检查DNS解析
dig A yourdomain.com
nslookup yourdomain.com

# 测试SSL证书
openssl s_client -connect yourdomain.com:443 -servername yourdomain.com
```

## 📊 监控和管理

### 容器管理 - Portainer

访问地址：http://localhost:9000 或 http://[服务器IP]:9000

功能：
- 容器状态监控
- 日志查看
- 资源使用情况
- 容器操作（启动/停止/重启）

### 日志管理

```bash
# 查看应用日志
docker-compose -f docker-compose.public.yml logs tbk-dev-public

# 查看Nginx日志
docker-compose -f docker-compose.public.yml logs nginx-public

# 查看所有服务日志
docker-compose -f docker-compose.public.yml logs
```

### 性能监控

```bash
# 查看容器资源使用
docker stats

# 查看Nginx状态
curl http://localhost:8081/nginx_status

# 查看应用健康状态
curl http://localhost:8080/health
```

## 🔧 故障排除

### 常见问题

1. **端口冲突**
   ```bash
   # 检查端口占用
   lsof -i :8080
   netstat -tulpn | grep :8080
   
   # 修改端口配置
   vim .env.public
   ```

2. **SSL证书问题**
   ```bash
   # 验证证书
   openssl x509 -in ssl/cert.pem -text -noout
   
   # 检查证书和私钥匹配
   openssl x509 -noout -modulus -in ssl/cert.pem | openssl md5
   openssl rsa -noout -modulus -in ssl/key.pem | openssl md5
   ```

3. **数据库连接问题**
   ```bash
   # 测试数据库连接
   docker exec -it mysql-public mysql -u peach_wiki -p peach_wiki
   
   # 检查网络连接
   docker network ls
   docker network inspect tbk-public-network
   ```

4. **防火墙问题**
   ```bash
   # 检查防火墙状态
   sudo ufw status
   sudo firewall-cmd --list-all
   
   # 开放必要端口
   sudo ufw allow 80,443,8080/tcp
   ```

### 日志分析

```bash
# 应用错误日志
tail -f logs/app.log

# Nginx访问日志
tail -f logs/nginx/access.log

# Nginx错误日志
tail -f logs/nginx/error.log

# 系统日志
journalctl -u docker -f
```

## 🔐 安全建议

### 生产环境安全配置

1. **更改默认密码**
   ```bash
   # 数据库密码
   # Redis密码
   # 管理员密码
   ```

2. **限制访问来源**
   ```bash
   # 配置防火墙规则
   # 使用VPN或跳板机
   # 配置IP白名单
   ```

3. **启用HTTPS**
   ```bash
   # 使用有效SSL证书
   # 强制HTTPS重定向
   # 配置HSTS
   ```

4. **定期更新**
   ```bash
   # 更新Docker镜像
   # 更新系统补丁
   # 更新SSL证书
   ```

## 📞 技术支持

如果在配置过程中遇到问题，请检查：

1. **系统要求**
   - Docker 20.10+
   - Docker Compose 1.29+
   - 足够的系统资源（2GB+ RAM）

2. **网络要求**
   - 开放必要端口（80, 443, 8080）
   - 稳定的网络连接
   - 正确的DNS配置

3. **权限要求**
   - Docker运行权限
   - 文件读写权限
   - 端口绑定权限

---

**注意：** 本配置适用于开发和测试环境。生产环境部署时，请根据实际需求调整安全配置和性能参数。