# A0-test环境快照

## 基本环境信息
- **创建时间**: 2025-10-05 23:40
- **操作系统**: macOS (M2处理器)
- **项目路径**: /Users/hanchanglin/AI编程代码库/jenkins-service

## 依赖版本信息
### Node.js环境
- **Node.js版本**: v22.17.1
- **npm版本**: 11.5.2

### Docker环境
- **Docker版本**: Docker version 28.1.1, build 4eba377
- **Docker Compose版本**: Docker Compose version v2.35.1-desktop.1

### 项目依赖
```json
/Users/hanchanglin/AI编程代码库/jenkins-service
└── (empty)
```
**注意**: 当前项目目录没有package.json，这是一个Jenkins服务配置项目

## 环境变量配置
### 本地环境变量
```bash
发现以下环境配置文件:
- .env.local (807 bytes, 2024-10-04) 
- .env.production (754 bytes, 2024-10-05)
- .env.public (636 bytes, 2024-10-03)
```

### 生产环境变量
```bash
[阿里云ECS环境变量 - 待收集]
```

## 构建/运行命令
### 本地开发命令
```bash
[记录特殊的构建/运行命令 - 待收集]
```

### 生产部署命令
```bash
[Jenkins部署命令 - 待收集]
```

## 错误堆栈信息
### 完整错误堆栈（stack trace）
```
[获取完整的错误堆栈 - 待收集]
```

## 关键框架/库版本
- **Express**: [待收集]
- **Docker**: [待收集]
- **Jenkins**: [待收集]
- **其他关键依赖**: [待收集]

## 依赖锁定文件
- **package-lock.json**: [检查是否存在]
- **其他锁定文件**: [待收集]

## 网络配置
### Docker网络配置
```bash
NETWORK ID     NAME                                     DRIVER    SCOPE
9c7d8ba7b736   bridge                                   bridge    local
83a5fe93fba7   host                                     host      local
13bb1ecf17f0   jenkins-service_jenkins-network          bridge    local
be86e5305a25   jenkins-service_tbk-production-network   bridge    local
21b47034d5a2   none                                     null      local
40db5fd6fa91   tbk_app-network                          bridge    local
```
**重要发现**: tbk_app-network 在本地环境中已存在！

### 阿里云ECS服务器
- **IP地址**: 60.205.0.185 ⚠️ **重要**: 这是正确的生产服务器IP，不是47.115.209.46
- **操作系统**: Linux (具体版本待确认)
- **Docker版本**: 待确认
- **用户**: root
- **密码**: han0419/
- **网络状态**: tbk_app-network已创建 (ID: d1a7b01d3972, 子网: 172.21.0.0/16)

### 阿里云ECS网络配置
```bash
[ECS网络配置信息 - 待收集]
```

## 🔍 重要发现
- `tbk_app-network` 在本地环境已存在
- 这表明本地和生产环境存在差异

## 🚨 ECS生产环境信息 (2025-01-26)

### ECS连接信息
- **IP地址**: 60.205.0.185
- **用户**: root
- **部署路径**: /root/tbk-deploy/

### ECS Docker环境
- **Docker版本**: 26.1.3, build b72abbb
- **Docker Compose版本**: v2.27.0

### ECS网络状态
```
NETWORK ID     NAME                         DRIVER    SCOPE
20b109d0976f   bridge                       bridge    local (172.17.0.0/16)
a364890954dc   host                         host      local
e6f5a5b92863   none                         null      local
26038b242bd8   tbk-manual-net               bridge    local (172.22.0.0/16) ⚠️
fead972525b6   tbk_tbk-production-network   bridge    local (172.20.0.0/16)
```

### 🎯 关键发现
1. **ensure_network.sh脚本不存在**: `/root/tbk-deploy/ensure_network.sh` 文件不存在
2. **网络子网冲突**: `tbk-manual-net` 已占用 `172.22.0.0/16` 子网
3. **网络创建失败**: 尝试创建 `tbk_app-network` 时报错 "Pool overlaps with other one on this address space"

---
*此文档将在收集完整信息后提供给诊断分析使用*