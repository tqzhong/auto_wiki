---
type: concept
tags: [multi-agent, orchestration, ai-collaboration, claude-code, tmux, architecture]
created: 2026-05-02
updated: 2026-05-02
related:
  - ../entities/omc.md
  - llm-wiki-pattern.md
  - human-llm-collaboration.md
  - ../sessions/2026-05-02-omc-usage-guide.md
sources: []
summary: "多个专长各异的 AI Agent 分角色协作完成复杂任务，通过 tmux/git worktree 实现隔离与并行"
---

# 多智能体编排 (Multi-Agent Orchestration)

## Overview

多智能体编排是一种 AI 工程模式：不依赖单个全能 Agent，而是启动多个 Agent 实例，给每个 Agent 分配特定角色（如架构师、执行者、审查者），让它们并行或串行协作完成复杂任务。OMC 是这一模式的具体实现。

## 核心思想

### 为什么需要多 Agent？

单一 Agent 的局限：
- **上下文窗口限制**：一个 Agent 的上下文有限，复杂任务容易丢失信息
- **角色冲突**：同一 Agent 既写代码又审查代码，难以保持客观
- **串行瓶颈**：一个 Agent 一次只能做一件事
- **缺乏多样性**：单一视角容易产生盲点

多 Agent 的优势：
- **角色分离**：architect 做设计，executor 写代码，reviewer 做审查
- **并行执行**：多个 worker 同时处理不同模块
- **多 provider 交叉验证**：Claude 和 Codex 对同一问题给出不同方案
- **专业化分工**：每个 Agent 被 prompt 引导到擅长的领域

### 角色分工模型

典型的多 Agent 角色：

| 角色 | 职责 |
|------|------|
| architect | 系统设计、架构决策、技术选型 |
| executor | 编码实现、写测试、执行具体任务 |
| planner | 任务分解、优先级排序、制定计划 |
| analyst | 代码分析、数据研究、方案评估 |
| critic | 代码审查、发现缺陷、提出改进建议 |
| debugger | 问题定位、错误排查、修复验证 |
| verifier | 最终验证、回归测试、一致性检查 |
| code-reviewer | PR 审查、代码质量把关 |
| security-reviewer | 安全审计、漏洞检测 |
| test-engineer | 测试策略、覆盖率、边界用例 |
| designer | UI/UX 设计、API 设计 |
| writer | 文档编写、API 文档、README |
| scientist | 研究调研、实验设计、数据分析 |

## 实现架构（OMC 方案）

```
┌─────────────────────────────────────────┐
│           tmux session                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│  │ Worker 1 │ │ Worker 2 │ │ Worker 3 │ │
│  │ architect│ │ executor │ │ reviewer │ │
│  │ (Claude) │ │ (Codex)  │ │ (Claude) │ │
│  └──────────┘ └──────────┘ └──────────┘ │
│       ↑            ↑            ↑        │
│       └────────┬───┴────────────┘        │
│           Leader / Coordinator           │
│        (消息传递 + 任务分配)              │
└─────────────────────────────────────────┘
```

### 隔离机制

- **tmux pane 隔离**：每个 worker 在独立的 tmux pane 中运行
- **git worktree 隔离**：`--auto-merge` 模式下每个 worker 在独立 worktree 中工作，避免文件冲突
- **分支策略**：worker 在 `omc-team/{team}/{worker}` 分支上工作，合并到 leader 分支

### 通信机制

- Worker 之间通过 `omc team api send-message` 交换消息
- Leader 负责协调和最终合并
- Auto-merge 模式下，每次 commit 自动合并到 leader 并 rebase fanout

## 与其他模式的关系

### vs RAG (Retrieval-Augmented Generation)

- RAG 是**信息检索**增强——Agent 需要时去查
- 多 Agent 是**任务分工**增强——多个 Agent 各司其职
- 两者可以结合：每个 Agent 有自己的 RAG 管道

### vs Human-LLM Collaboration

- Human-LLM 协作（见 [[human-llm-collaboration]]）是人和 AI 的分工
- 多 Agent 编排是 AI 和 AI 的分工
- 但最终仍由人类设定目标、审查结果
- OMC 的设计理念是：**人类设定任务 → 多 Agent 执行 → 人类审查**

### vs Single Agent + Tools

- 单 Agent + Tools：一个 Agent 使用各种工具（shell、browser、搜索）
- 多 Agent：多个 Agent 各自有工具，协作完成任务
- 多 Agent 更适合大型、可并行的任务；单 Agent 更适合简单、线性的任务

## 适用场景

| 场景 | 推荐方式 |
|------|---------|
| 修复测试失败 | `omc team 3:claude "fix failing tests"` |
| 设计新系统 | `omc team 2:codex:architect "design auth system"` |
| 代码审查 | `omc team 1:claude:code-reviewer "review PR"` |
| 对比方案 | `omc team 1:codex,1:gemini "compare approaches"` |
| 简单 bug 修复 | 单 Agent 即可，无需编排 |
| 文档编写 | 单 Agent 或 `omc team 1:claude:writer` |

## Connections

- OMC 是多 Agent 编排的 CLI 实现，见 [[omc]]
- 多 Agent 编排中的人类角色与 [[human-llm-collaboration]] 一致：人类是决策者，Agent 是执行者
- 每个 Agent 可以维护自己的知识库，类似于 [[llm-wiki-pattern]] 的变体

## Open Questions

- 多 Agent 之间的 token 成本如何优化（避免重复上下文）
- 冲突解决策略：当两个 worker 修改同一文件时的最佳实践
- 角色路由的最优策略（哪个 provider 最适合哪个角色）
- 大规模编排（10+ Agent）的可行性
- 多 Agent 输出质量如何评估和保证
