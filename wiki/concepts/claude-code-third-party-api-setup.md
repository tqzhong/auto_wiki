---
type: concept
tags: [claude-code, api-gateway, proxy, third-party-api, environment-variables]
created: 2026-05-01
updated: 2026-05-01
related:
  - ../entities/claude-code-proxy.md
  - ../entities/xiaomi-mimo-api.md
  - ../sessions/2026-05-01-claude-code-proxy-setup.md
sources: []
summary: "通过代理网关让 Claude Code 使用非 Anthropic API 的完整方法，包括环境变量、代理链路、常见陷阱"
---

# Claude Code 使用第三方 API 的配置方法

## Overview

Claude Code 原生只支持 Anthropic Messages API 格式。要使用其他厂商 API（如 Xiaomi mimo），需要一个**中间代理**把 Anthropic 格式请求转换成 OpenAI-compatible 格式，转发给目标 API。

## 架构

```
Claude Code → ANTHROPIC_BASE_URL → 本地代理 (localhost:8082) → 第三方 API
```

Claude Code 通过 `ANTHROPIC_BASE_URL` 环境变量指定代理地址，代理负责协议转换。

## 环境变量配置

### Claude Code 侧（启动时设置）

| 变量 | 值 | 说明 |
|------|-----|------|
| `ANTHROPIC_BASE_URL` | `http://127.0.0.1:8082` | 指向本地代理 |
| `ANTHROPIC_API_KEY` | 任意值（如 `any-value`） | 必须有值，但代理不校验 |
| `NO_PROXY` | `localhost,127.0.0.1,::1` | 防止本地代理请求被系统代理拦截 |

### 代理侧（.env 文件）

| 变量 | 值 | 说明 |
|------|-----|------|
| `OPENAI_API_KEY` | 第三方厂商的 API key | 不是 OpenAI 的 key，是目标厂商的 |
| `OPENAI_BASE_URL` | 第三方厂商的 API 地址 | |
| `BIG_MODEL` / `MIDDLE_MODEL` / `SMALL_MODEL` | 目标模型名 | Claude Code 的不同请求级别映射 |

## 常见陷阱

### 1. 环境变量继承污染

**问题**：如果启动代理的 shell 里已有 `ANTHROPIC_API_KEY`，`python-dotenv` 默认不会覆盖已有变量，代理会开启客户端 key 校验，Claude Code 的请求可能被拒。

**解决**：用 `env -u ANTHROPIC_API_KEY` 清掉后再启动代理。

### 2. 系统代理拦截本地请求

**问题**：如果系统设了 `HTTP_PROXY` 但没设 `NO_PROXY=localhost`，Claude Code 访问 `127.0.0.1:8082` 的请求会被转给系统代理，导致本地代理看不到任何请求。

**解决**：启动 Claude Code 时显式设置 `NO_PROXY=localhost,127.0.0.1,::1`。

### 3. 代理进程自身也被系统代理污染

**问题**：代理进程继承了 `HTTP_PROXY`，导致它转发请求给第三方 API 时也被系统代理干扰，产生 500 错误。

**解决**：启动代理时清除所有代理变量：`env -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY ...`

### 4. API Key 格式校验

**问题**：某些代理代码会校验 key 是否以 `sk-` 开头，第三方 key 不符合就显示 invalid。

**影响**：只影响 `/health` 展示，**不影响实际请求**。这是已验证的。

## 最佳实践

用一个 wrapper 脚本固化所有环境变量，避免每次手动设置：

```bash
# xclaude wrapper 的核心逻辑
NO_PROXY=localhost,127.0.0.1,::1 \
ANTHROPIC_BASE_URL=http://127.0.0.1:8082 \
ANTHROPIC_API_KEY=any-value \
# 如果检测到系统代理可用，给 Claude 的 Bash 工具也配上（用于 git clone 等）
HTTP_PROXY=http://127.0.0.1:7890 \
HTTPS_PROXY=http://127.0.0.1:7890 \
claude "$@"
```

## Connections

- 实现依赖 [[claude-code-proxy]] 作为协议转换网关
- 目标 API 为 [[xiaomi-mimo-api]]
- 完整调试过程记录在 [[2026-05-01-claude-code-proxy-setup]]

## Open Questions

- LiteLLM 是否是更稳定的替代方案
- 多模型切换（不同请求用不同模型）的最佳配置
