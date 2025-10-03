# 简化部署配置说明

## 修改概述

根据用户需求，已撤回之前的条件部署配置，简化为默认直接部署到生产环境的模式。

## 主要变更

### 1. 移除部署确认参数

- **移除参数**：`CONFIRM_PRODUCTION_DEPLOY`
- **保留参数**：`BRANCH_INFO` (构建分支信息)

### 2. 简化 Pipeline 流程

新的 Pipeline 流程将按顺序执行所有阶段，无条件判断：

1. **构建阶段**：
   - ✅ 代码检出 (Checkout)
   - ✅ 环境设置 (Environment Setup)
   - ✅ 依赖安装 (Install Dependencies)
   - ✅ 代码分析 (Code Analysis)
   - ✅ 单元测试 (Unit Tests)
   - ✅ Docker镜像构建 (Build Docker Image)
   - ✅ 推送到阿里云ACR (Push to Aliyun ACR)

2. **部署阶段**：
   - ✅ 数据库迁移 (Database Migration)
   - ✅ 部署到阿里云ECS (Deploy to Aliyun ECS)
   - ✅ 部署后测试 (Post-Deploy Tests)

3. **总结阶段**：
   - ✅ 部署完成摘要 (Deployment Summary)

### 3. 配置文件变更

#### config.xml 变更
```xml
<!-- 移除了以下参数配置 -->
<hudson.model.BooleanParameterDefinition>
  <name>CONFIRM_PRODUCTION_DEPLOY</name>
  <description>构建后直接部署到生产环境</description>
  <defaultValue>true</defaultValue>
</hudson.model.BooleanParameterDefinition>
```

#### Jenkinsfile 变更
- 移除所有 `when` 条件判断
- 移除 `Build Only Summary` 阶段
- 所有部署阶段无条件执行
- 添加 `Deployment Summary` 阶段显示完整部署信息

## 用户界面变化

### 构建参数页面
- **之前**：显示两个参数
  - `BRANCH_INFO`: 构建分支信息
  - `CONFIRM_PRODUCTION_DEPLOY`: 构建后直接部署到生产环境 (复选框)

- **现在**：只显示一个参数
  - `BRANCH_INFO`: 构建分支信息

### 构建流程
- **之前**：根据 `CONFIRM_PRODUCTION_DEPLOY` 参数决定是否执行部署阶段
- **现在**：每次构建都会自动执行完整的构建和部署流程

## 实施文件

1. **简化版 Jenkinsfile**：`Jenkinsfile.aliyun.simplified`
2. **更新的配置文件**：`jenkins_home/jobs/tbk-pipeline/config.xml`
3. **说明文档**：本文档

## 部署流程说明

每次触发构建时，系统将：

1. **自动执行所有构建步骤**
2. **自动执行数据库迁移**
3. **自动部署到生产环境**
4. **自动运行部署后测试**
5. **显示部署完成摘要**

## 注意事项

- ⚠️ **重要**：每次构建都会直接部署到生产环境
- 🔄 **自动化**：无需手动确认，完全自动化流程
- 📊 **监控**：建议密切监控部署后的应用状态
- 🚨 **回滚**：如需回滚，请准备相应的回滚策略

## 相关文件

- `Jenkinsfile.aliyun.simplified` - 简化版 Pipeline 文件
- `jenkins_home/jobs/tbk-pipeline/config.xml` - 更新的 Jenkins 作业配置
- `CONDITIONAL_DEPLOYMENT_FIX.md` - 之前的条件部署修复文档（已废弃）