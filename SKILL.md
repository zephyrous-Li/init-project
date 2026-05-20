---
name: init-project
description: Use when starting a new project or when adding Claude Code configuration structure to an existing project. Generates CLAUDE.md, .claude/ directory with commands/, rules/, skills/, and agents/ subdirectories with detailed templates and best practices. Automatically detects and offers to install CodeGraph MCP service if missing, then initializes it.
---

# 项目初始化增强工具

## 概述

`init-project` 是 Claude Code `/init` 命令的增强工具，能够一键生成完整的项目配置结构，包含详细的模板内容、最佳实践指导和使用说明。

**核心原则**：
- **快速启动**：一键生成所有配置文件
- **详细文档**：每个文件都包含完整的说明和示例
- **交互友好**：尊重用户选择，逐个询问覆盖
- **易于维护**：模板集中管理，便于定制更新

## 何时使用

### 适用场景

- ✅ 启动新项目时，建立完整的 Claude Code 配置
- ✅ 为现有项目补充详细的配置文件
- ✅ 标准化团队的 Claude Code 项目配置
- ✅ 学习 Claude Code 最佳实践

### 不适用场景

- ❌ 已经有完整配置的项目
- ❌ 只需要基础配置（使用 `/init` 即可）

## 使用方式

### 方式 1：通过 Skill 工具调用

```
Skill("init-project")
```

### 方式 2：直接运行脚本

```bash
bash .claude/skills/init-project/generate.sh
```

## 生成的文件结构

```
project-root/
├── CLAUDE.md                   # 团队指令文件（提交到 Git）
├── CLAUDE.local.md             # 个人覆盖配置（.gitignore）
├── .codegraph/                 # CodeGraph MCP 索引（可选，.gitignore）
└── .claude/
    ├── settings.json           # 权限与配置（提交到 Git）
    ├── settings.local.json     # 个人权限配置（.gitignore）
    ├── commands/               # 自定义斜杠命令
    │   └── README.md
    ├── rules/                  # 模块化指令文件
    │   ├── README.md
    │   ├── code-style.md       # 代码风格规范
    │   ├── testing.md          # 测试规范
    │   └── api-conventions.md  # API 约定规范
    ├── skills/                 # 自动触发的工作流
    │   └── README.md
    └── agents/                 # 子智能体角色定义
        ├── README.md
        ├── code-reviewer.md    # 代码审查智能体
        └── security-auditor.md # 安全审计智能体
```

## 自定义

### 修改模板

模板文件位于 `templates/` 目录，可以直接修改：

```bash
# 编辑模板
vim .claude/skills/init-project/templates/CLAUDE.md.template
```

### 添加新模板

1. 在 `templates/` 创建新模板文件
2. 在 `generate.sh` 中添加映射关系
3. 更新此文档的文件结构部分

## 文件说明

### CodeGraph MCP 服务

- **.codegraph/**: CodeGraph 索引目录（可选）
  - 自动检测 `codegraph` 命令是否可用
  - 如未安装，可询问是否通过 `npx @colbymchenry/codegraph` 自动安装
  - 提供代码结构查询、符号搜索、调用图分析等功能
  - 初始化命令：`codegraph init -i`
  - 如不需要，可回答 `N` 跳过安装和初始化

### 核心配置文件

- **CLAUDE.md**：团队指令文件，定义项目级别的配置和约定
- **CLAUDE.local.md**：个人覆盖配置，用于个人定制
- **settings.json**：权限和钩子配置
- **settings.local.json**：个人权限配置

### 规范文件（rules/）

- **code-style.md**：详细的代码风格规范，包含命名约定、注释规范、代码组织
- **testing.md**：全面的测试规范，包含测试策略、单元测试、集成测试
- **api-conventions.md**：API 设计规范，包含 RESTful 约定、错误处理

### 智能体定义（agents/）

- **code-reviewer.md**：代码审查智能体，定义审查维度和流程
- **security-auditor.md**：安全审计智能体，定义安全检查清单

## 常见问题

### 文件覆盖策略

当文件已存在时，脚本会逐个询问是否覆盖：

```
⚠️  文件已存在: CLAUDE.md
是否覆盖？[y/N]
```

选择 `y` 覆盖，`N` 或直接回车跳过。

### CodeGraph 安装

当未检测到 `codegraph` 命令时：

```
⚠️  未检测到 codegraph 命令
是否安装 CodeGraph (npx @colbymchenry/codegraph)？[y/N]
```

- **安装方式**：通过 `npx @colbymchenry/codegraph` 安装（无需全局安装）
- **选择 `y`**：自动安装并询问是否初始化
- **选择 `N`**：跳过 CodeGraph 设置

安装成功后会询问是否初始化：

```
ℹ️  检测到 CodeGraph MCP 服务
是否初始化 CodeGraph？[y/N]
```

### Git 集成

脚本会自动更新 `.gitignore`，添加以下内容：

```
# Claude Code local configurations
CLAUDE.local.md
.claude/settings.local.json

# CodeGraph MCP index
.codegraph/
```

### 团队协作

- 将 `CLAUDE.md` 和 `.claude/settings.json` 提交到仓库
- 每个成员使用 `CLAUDE.local.md` 和 `.claude/settings.local.json` 进行个人定制
- 定期同步更新的模板文件

## 最佳实践

1. **先运行 `/init`**：先使用 Claude Code 的 `/init` 命令创建基础配置
2. **再运行此工具**：使用 `init-project` 补充详细的模板和规范
3. **定制模板**：根据团队需求修改模板内容
4. **版本控制**：将配置文件提交到 Git 仓库
5. **定期更新**：关注技能更新，获取最新的最佳实践

## 参考资源

- [Claude Code 文档](https://github.com/anthropics/claude-code)
- [writing-skills 技能](.claude/skills/writing-skills/SKILL.md)
- [项目配置最佳实践](.claude/rules/)
```