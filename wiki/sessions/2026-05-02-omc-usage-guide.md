---
type: session
date: 2026-05-02
created: 2026-05-02
updated: 2026-05-02
title: "OMC 多智能体编排工具使用指南"
platform: Claude Code
topic: "omc, multi-agent, orchestration, team, teleport"
tags: [omc, multi-agent, cli, tmux, git-worktree, orchestration]
related:
  - ../entities/omc.md
  - ../concepts/multi-agent-orchestration.md
  - ../entities/claude-code-proxy.md
sources: []
summary: "系统性了解 OMC CLI 的全部功能：多 Agent 团队编排、tmux 集成、git worktree 隔离开发、双面板模式、首次设置流程"
---

# Session: OMC 多智能体编排工具使用指南

## Context

在工作区中发现已安装的 `omc` CLI 工具（v4.13.5），但不确定其完整功能和用法。通过 `omc --help` 和各子命令帮助文档，系统性地梳理了 OMC 的全部能力。

## Key Takeaways

### 1. OMC 定位

OMC 是基于 Claude Agent SDK 的多智能体编排系统。核心价值是让多个 AI Agent（Claude Code、Codex、Gemini）分角色协作完成复杂任务，而不是依赖单个全能 Agent。

### 2. 最核心功能：`omc team`

语法：`omc team N:provider[:role] "<task description>"`

- N = Agent 数量
- provider = claude / codex / gemini（可混合，如 `1:codex,1:gemini`）
- role = 可选角色（architect、executor、reviewer 等 13 种）

高级选项：
- `--new-window`：在新 tmux 窗口打开
- `--auto-merge`：每提交自动合并（需 `OMC_RUNTIME_V2=1`，leader 不能是 main/master）

### 3. Git Worktree 隔离：`omc teleport`

为 issue/PR/功能分支创建隔离的 git worktree，避免直接在主分支上开发。默认路径 `~/Workspace/omc-worktrees/`。

### 4. 首次使用流程

```
npm install -g omc → omc setup → omc doctor → omc launch
```

`omc setup` 会将 agents、skills、hooks 安装到 `~/.claude/` 目录。

### 5. 已安装的 Skills

OMC 在 `~/.claude/skills/` 下安装了多个技能模块：
- `omc-reference`：参考文档
- `omc-setup`：安装设置
- `omc-teams`：团队管理
- `omc-doctor`：诊断工具
- `omc-plan`：计划相关

### 6. 与现有 Claude Code 代理架构的关系

OMC 启动的 Claude Code 实例同样会受环境变量影响。如果已有 `claude-code-proxy` + `xclaude` 的配置，OMC 的 Claude agent 也会走代理链路。需要确认 OMC 是否支持自定义 `ANTHROPIC_BASE_URL`。

## Decisions Made

- 将 OMC 知识结构化沉淀到 wiki，包括 entity 页面、concept 页面和 session 页面
- 创建 "多智能体编排" 作为独立概念页面，而非只放在 OMC entity 中

## Open Questions

- OMC 如何配置 `ANTHROPIC_BASE_URL`（是否支持通过环境变量传入）
- `omc ralphthon` 的自主 hackathon 流程具体是怎样的
- OMC 是否开源，license 是什么
- `omc wait` 的速率限制机制细节
- OMC 与 Claude Code 原生 sub-agent 能力的差异

---

*Session: 2026-05-02, Platform: Claude Code*
