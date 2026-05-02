---
type: entity
tags: [api, xiaomi, mimo, llm-provider]
created: 2026-05-01
updated: 2026-05-02
related:
  - ../concepts/claude-code-third-party-api-setup.md
  - claude-code-proxy.md
  - ../sessions/2026-05-01-claude-code-proxy-setup.md
  - omc.md
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
| 已配置 context window | `1,000,000` tokens |

## 使用方式

通过 claude-code-proxy 转发，Claude Code 的请求会经过：

```
Claude Code → claude-code-proxy → Xiaomi mimo API
```

## 已验证能力

- 基础对话 ✅
- 代码生成 ✅
- 长上下文（作为 Claude Code 底座）✅

## Claude Code 适配注意

Claude Code 的 `/context` 不会自动使用 OpenAI-compatible 后端模型的真实上下文窗口。实测在 Claude Code v2.1.126 中，`/context` 的窗口判断主要来自客户端内置模型名逻辑：未知模型默认按 `200k` 处理。

对 Xiaomi `mimo-v2.5-pro`，需要让 wrapper 传入带 1M 标记的模型名：

```bash
claude --model 'mimo-v2.5-pro[1m]'
```

Claude Code 会把 `[1m]` 用作本地 1M context 标记；发 API 请求时会去掉该后缀。当前 `xclaude` 默认模型已设为 `mimo-v2.5-pro[1m]`，执行 `/context` 已验证显示 `1m`。

补充：proxy 暴露 `/v1/models` 并返回 `max_input_tokens=1000000` 是合理的兼容增强，但本次排查显示它不会改变 Claude Code v2.1.126 的 `/context` 显示。

## 已知限制

- 作为 Claude Code 底座时，复杂的多步推理能力可能弱于原生 Anthropic 模型
- 需要网络可达 Xiaomi API 端点

## Connections

- 通过 [[claude-code-proxy]] 接入
- 配置方法详见 [[claude-code-third-party-api-setup]]
- [[omc]] 启动的多 Agent 团队中，Claude agent 也会通过 proxy 使用此 API

## Open Questions

- 在 coding agent 场景下与 Claude 原生模型的能力差距
