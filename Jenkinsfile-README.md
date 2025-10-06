# Jenkinsfile 管理说明

## 概述

本文档说明 `jenkins-service` 项目中 Jenkinsfile 相关文件的用途和管理机制。

## 文件说明

### Jenkinsfile.aliyun.template

- **用途**: 多项目 CI/CD 部署模板
- **功能**: 
  - 支持多项目环境管理
  - 基于 `multi-project-config.json` 动态配置
  - 参数化部署（项目、环境、策略等）
  - 统一的构建和部署流程

- **设计特点**:
  - 使用 `PROJECT` 参数识别目标项目
  - 从 `multi-project-config.json` 读取项目配置
  - 支持本地和生产环境切换
  - 自动化 Docker 镜像构建和部署

### sync-jenkinsfiles.sh

- **用途**: 自动同步脚本
- **功能**: 将 `Jenkinsfile.aliyun.template` 同步到其他项目
- **特点**:
  - 自动备份现有文件
  - Git 自动提交
  - 彩色日志输出
  - 错误处理和统计

## 当前架构状态

### 现状
- `tbk-pipeline` Jenkins 任务直接从 `tbk` 项目的 GitHub 仓库拉取 `Jenkinsfile.aliyun`
- `jenkins-service` 中的 `Jenkinsfile.aliyun.template` 作为模板和修复参考
- 需要手动同步修复到各个项目

### 同步机制
1. 修改 `jenkins-service/Jenkinsfile.aliyun.template`
2. 运行 `./sync-jenkinsfiles.sh` 自动同步到所有项目
3. 脚本会自动提交更改到各项目的 Git 仓库

## 使用方法

### 推荐方式：编辑和同步一体化
为了避免忘记同步，推荐使用组合脚本：

```bash
# 在 jenkins-service 目录下执行
./edit-and-sync.sh
```

这个脚本会：
1. 自动打开编辑器编辑模板文件
2. 检测文件是否被修改
3. 显示修改内容预览
4. 询问是否立即同步
5. 执行同步操作

### 日常维护
```bash
# 1. 修改模板文件
vim Jenkinsfile.aliyun.template

# 2. 同步到所有项目
./sync-jenkinsfiles.sh

# 3. 查看同步结果
# 脚本会显示详细的同步日志和统计信息
```

### 同步提醒
如果担心忘记同步，可以运行提醒脚本：

```bash
# 显示同步提醒和状态
./remind-sync.sh
```

### 添加新项目
1. 在 `multi-project-config.json` 中添加项目配置
2. 运行同步脚本自动创建 `Jenkinsfile.aliyun`

### 故障修复
当某个项目的 Jenkins 构建失败时：
1. 在 `Jenkinsfile.aliyun.template` 中修复问题
2. 运行同步脚本应用修复到所有项目
3. 在 `构建日志.md` 中记录修复经验

## 长期架构规划

### 推荐方案：集中化 Jenkins 配置
1. **统一 CI/CD 管理**: 所有项目的 Jenkins 任务都从 `jenkins-service` 拉取配置
2. **参数化构建**: 通过 `TARGET_PROJECT` 参数指定要构建的项目
3. **动态项目检出**: 基于参数动态检出目标项目代码
4. **配置驱动**: 完全基于 `multi-project-config.json` 进行配置管理

### 迁移步骤
1. **短期**: 使用自动同步脚本解决当前同步问题
2. **中期**: 逐步迁移 Jenkins 任务配置到集中化模式
3. **长期**: 实现完全的多项目统一管理

## 配置文件

### multi-project-config.json
```json
{
  "projects": {
    "项目名": {
      "name": "显示名称",
      "path": "项目绝对路径",
      "environments": {
        "local": { "port": 端口, "database": "数据库" },
        "production": { "port": 端口, "database": "数据库" }
      }
    }
  }
}
```

## 注意事项

1. **路径配置**: 确保 `multi-project-config.json` 中的项目路径正确
2. **Git 仓库**: 同步脚本会自动提交到 Git，确保项目是 Git 仓库
3. **备份机制**: 现有文件会自动备份，文件名包含时间戳
4. **权限要求**: 确保脚本有执行权限 (`chmod +x sync-jenkinsfiles.sh`)

## 故障排除

### 常见问题
1. **jq 未安装**: `brew install jq`
2. **路径不存在**: 检查 `multi-project-config.json` 中的路径配置
3. **Git 提交失败**: 检查 Git 配置和权限

### 日志分析
脚本提供详细的彩色日志：
- 🔵 INFO: 信息提示
- 🟢 SUCCESS: 成功操作
- 🟡 WARNING: 警告信息
- 🔴 ERROR: 错误信息

## 更新历史

- **2025-10-06**: 创建自动同步脚本和说明文档
- **2025-10-06**: 修正 tbk 项目路径配置
- **2025-10-06**: 完成脚本测试和验证

---

*本文档随着架构演进持续更新*