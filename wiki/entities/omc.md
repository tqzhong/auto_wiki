---
type: entity
tags: [tool, cli, multi-agent, orchestration, claude-code, tmux]
created: 2026-05-02
updated: 2026-05-02
related:
  - ../concepts/multi-agent-orchestration.md
  - claude-code-proxy.md
  - ../sessions/2026-05-02-omc-usage-guide.md
sources: []
summary: "基于 Claude Agent SDK 的多智能体编排 CLI 工具，支持多 Agent 团队协作、tmux 集成、git worktree 隔离开发"
---

# OMC (Orchestrate Multi-agent Claude)

## Overview

OMC 是一个基于 **Claude Agent SDK** 的多智能体编排系统，以 CLI 形式提供。它允许用户启动和管理多个 AI Agent（Claude Code、Codex、Gemini 等）协作完成复杂任务，深度集成 tmux、git worktree 和通知系统。

## 核心信息

| 项目 | 值 |
|------|-----|
| 安装方式 | `npm install -g omc`（Node.js CLI） |
| 当前版本 | v4.13.5 |
| 可执行路径 | `~/.nvm/versions/node/v22.17.0/bin/omc` |
| 状态目录 | `./.omc/state/`（per-workspace） |
| HUD 缓存 | `~/.claude/hud/omc-hud.mjs` |
| Skills | `~/.claude/skills/omc-*`（reference、setup、teams、doctor、plan） |

## 核心功能

### 1. 启动 Claude Code（`omc launch`）

最基础的用法，启动带 tmux 集成的 Claude Code：

```bash
omc                    # 等同于 omc launch
omc launch --madmax    # 跳过权限确认（YOLO 模式）
omc launch --notify false  # 禁用通知
```

### 2. 多 Agent 团队协作（`omc team`）— 最强大

指定 Agent 数量、provider 和角色，组成协作团队：

```bash
omc team 3:claude "fix failing tests"              # 3 个 Claude agent
omc team 2:codex:architect "design auth system"    # 2 个 Codex agent，角色为 architect
omc team 1:gemini:executor "implement feature"     # 1 个 Gemini agent，角色为 executor
omc team 1:codex,1:gemini "compare approaches"     # 混合 provider
omc team 2:codex "review auth flow" --new-window   # 在新窗口打开
omc team 3:claude "refactor DB" --auto-merge       # 启用自动合并
```

**支持的 Provider**：claude、codex、gemini

**支持的角色**：architect、executor、planner、analyst、critic、debugger、verifier、code-reviewer、security-reviewer、test-engineer、designer、writer、scientist

**团队管理**：

```bash
omc team status <team-name>       # 查看团队状态
omc team shutdown <team-name>     # 关闭团队
omc team shutdown <team-name> --force  # 强制关闭
omc team api <operation> --input '<json>' --json  # 团队 API 操作
```

**Worktree 模式**：设置 `OMC_TEAM_WORKTREE_MODE=detached|branch` 可让每个 worker 在独立 git worktree 中工作。

**Auto-merge 模式**（v2-only）：`--auto-merge` 启用每提交自动合并到 leader 并 rebase fanout。要求 `OMC_RUNTIME_V2=1`，leader 分支不能是 `main` 或 `master`。

### 3. Git Worktree 隔离开发（`omc teleport`）

```bash
omc teleport '#42'          # 为 issue/PR #42 创建 worktree
omc teleport add-auth       # 为功能分支创建 worktree
omc teleport list           # 列出所有 worktree
omc teleport remove ./path  # 删除 worktree
```

默认 worktree 路径：`~/Workspace/omc-worktrees/`

### 4. 双面板模式（`omc interop`）

```bash
omc interop    # 启动 tmux 分屏，同时运行 Claude Code (OMC) 和 Codex (OMX)
```

### 5. 其他命令

```bash
omc setup           # 安装/同步所有组件（hooks、agents、skills）
omc setup --force   # 强制重新安装
omc doctor          # 诊断安装问题
omc doctor conflicts  # 检查插件冲突
omc info            # 查看系统和 agent 信息
omc config          # 查看当前配置
omc version         # 查看详细版本信息
omc sessions        # 查看历史 session 记录
omc wait            # 速率限制等待 + 自动恢复
omc update          # 检查并安装更新
omc hud             # 运行 HUD 状态栏渲染器
omc mission-board   # 渲染 mission board 快照
omc ask             # 运行 provider advisor prompt，写入 ask artifact
omc ralphthon       # 自主 hackathon 生命周期：interview → execute → harden → done
omc test-prompt <prompt>  # 测试 prompt 增强效果
```

## 首次使用

```bash
# 1. 安装
npm install -g omc

# 2. 初始化设置（安装 hooks、agents、skills 到 ~/.claude/）
omc setup

# 3. 检查安装是否正常
omc doctor

# 4. 启动
omc launch
```

## 典型工作流

```bash
# 启动多 Agent 团队完成任务
omc team 3:claude "implement user authentication with tests"

# 为 PR 创建隔离环境开发
omc teleport '#123'

# 查看团队状态
omc team status implement-user-authentication-with-tests

# 完成后关闭团队
omc team shutdown implement-user-authentication-with-tests
```

## Connections

- OMC 的核心理念与 [[multi-agent-orchestration]] 一致：多个专长各异的 Agent 协作优于单一全能 Agent
- 与 [[claude-code-proxy]] 配合时，OMC 启动的 Claude Code 实例也会走代理链路
- 可与 Codex、Gemini 等其他 provider 组合使用

## Open Questions

- OMC 的团队通信协议细节（worker 之间如何交换信息）
- `--auto-merge` 模式的实际冲突解决策略
- 与 Claude Code 原生的 `--multi-turn` / sub-agent 能力的关系
- `omc ralphthon` 的自主 hackathon 具体流程和适用场景
- OMC 的 license 和开源状态
