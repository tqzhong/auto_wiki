---
type: entity
tags: [api, xiaomi, mimo, llm-provider]
created: 2026-05-01
updated: 2026-05-01
related:
  - ../concepts/claude-code-third-party-api-setup.md
  - claude-code-proxy.md
  - ../sessions/2026-05-01-claude-code-proxy-setup.md
sources: []
summary: "Xiaomi mimo-v2.5-pro API，OpenAI-compatible 格式，作为 Claude Code 的后端模型使用"
---

# Xiaomi mimo API

## Overview

Xiaomi 提供的 mimo 系列大模型 API，兼容 OpenAI API 格式。当前在本项目中作为 Claude Code 的后端模型，通过 claude-code-proxy 代理接入。

## 核心信息

| 项目 | 值 |
|------|-----|
| API 地址 | `https://token-plan-cn.xiaomimimo.com/v1` |
| 使用的模型 | `mimo-v2.5-pro` |
| API 格式 | OpenAI-compatible |
| API Key 格式 | 非 sk- 开头 |

## 使用方式

通过 claude-code-proxy 转发，Claude Code 的请求会经过：

```
Claude Code → claude-code-proxy → Xiaomi mimo API
```

## 已验证能力

- 基础对话 ✅
- 代码生成 ✅
- 长上下文（作为 Claude Code 底座）✅

## 已知限制

- 作为 Claude Code 底座时，复杂的多步推理能力可能弱于原生 Anthropic 模型
- 需要网络可达 Xiaomi API 端点

## Connections

- 通过 [[claude-code-proxy]] 接入
- 配置方法详见 [[claude-code-third-party-api-setup]]

## Open Questions

- mimo-v2.5-pro 的 context window 实际支持多大
- 在 coding agent 场景下与 Claude 原生模型的能力差距
