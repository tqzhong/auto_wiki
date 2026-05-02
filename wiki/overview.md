---
type: overview
tags: [meta, overview]
created: 2026-05-01
updated: 2026-05-02
related: [index.md]
summary: "High-level overview and synthesis of the entire wiki"
---

# Wiki Overview

This is the big-picture synthesis page. It ties together the most important threads across the wiki and evolves as the knowledge base grows.

## Current State

As of 2026-05-02, this wiki contains **16 pages** across 5 categories:

| Category | Count | Key Pages |
|----------|-------|-----------|
| Entities | 5 | Andrej Karpathy, claude-code-proxy, Xiaomi mimo API, OMC |
| Concepts | 7 | LLM Wiki Pattern, Multi-Agent Orchestration, Claude Code 第三方 API 配置 |
| Sources | 1 | Karpathy's LLM Wiki Gist |
| Sessions | 2 | Claude Code proxy setup, OMC usage guide |
| Comparisons | 0 | — |

Three knowledge domains have been captured:
1. **LLM Wiki 模式** — Karpathy 提出的个人知识管理范式（ingest 源头）
2. **Claude Code 代理架构** — 通过 proxy 网关让 Claude Code 使用第三方 API 的完整方案（distill 沉淀）
3. **多智能体编排** — OMC 工具和多 Agent 角色分工协作模式（distill 沉淀）

## Key Themes

- **Personal Knowledge Management** — 使用 LLM 维护持久、复利式增长的个人知识库
- **LLM-Driven Automation** — LLM 处理繁琐的知识整理工作，人类负责策展和决策
- **Multi-Agent Orchestration** — 多个专长各异的 AI Agent 分角色协作，而非依赖单个全能 Agent
- **Infrastructure for AI Coding** — Claude Code 的代理链路、第三方 API 接入、环境变量管理

## Connections Map

```
LLM Wiki Pattern (Karpathy)
├── Core Concepts
│   ├── Persistent Compounding Artifact ─── wiki grows richer over time
│   ├── Incremental Compilation ─── knowledge compiled once, kept current
│   ├── Human-LLM Collaboration ─── human curates, LLM maintains
│   └── Memex (Bush, 1945) ─── intellectual ancestor
├── Tools & Infrastructure
│   ├── claude-code-proxy ─── Anthropic→OpenAI protocol bridge
│   │   └── Xiaomi mimo API ─── backend model provider
│   ├── Claude Code 第三方 API 配置 ─── env vars, proxy chain, pitfalls
│   └── OMC ─── multi-agent orchestration CLI
│       └── Multi-Agent Orchestration ─── role-based Agent collaboration
└── Knowledge Sources
    └── Karpathy's LLM Wiki Gist ─── foundational source
```

## Open Questions

- 多智能体编排与 Claude Code 原生 sub-agent 能力的关系
- OMC + Claude Code proxy 代理链路的兼容性（OMC 是否支持自定义 ANTHROPIC_BASE_URL）
- Wiki 规模增长后的 lint 和维护策略
- 是否需要引入 Comparisons 类别的页面（如 Claude vs Codex vs Gemini 编排对比）

---

*This overview is updated when significant new information changes the big picture.*
