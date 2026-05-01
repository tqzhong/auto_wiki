---
type: session
date: 2026-05-01
created: 2026-05-01
updated: 2026-05-01
title: "Claude Code 使用 Xiaomi API 代理配置"
platform: Codex (GPT-5)
topic: "claude-code-proxy, xiaomi-api, proxy-config"
tags: [claude-code, proxy, xiaomi, api-gateway, network-config]
related:
  - ../entities/claude-code-proxy.md
  - ../entities/xiaomi-mimo-api.md
  - ../concepts/claude-code-third-party-api-setup.md
sources: []
summary: "通过 claude-code-proxy 让 Claude Code 使用 Xiaomi mimo-v2.5-pro API，解决了环境变量冲突和代理链路问题，最终固化为 xclaude 命令"
---

# Session: Claude Code 使用 Xiaomi API 代理配置

## Context

想让 Claude Code 绕过默认 Anthropic API，改用个人持有的 Xiaomi mimo-v2.5-pro API。已 clone 了 `fuergaosi233/claude-code-proxy` 到 `~/Desktop/claude-code-proxy/`，但初始尝试不成功——请求没有走到 `.env` 配置的模型。

## Key Takeaways

### 1. 核心机制

Claude Code 通过 `ANTHROPIC_BASE_URL` 环境变量指向兼容 Anthropic Messages API 的网关。`claude-code-proxy` 项目就是这个网关：接收 Anthropic 格式请求 → 转成 OpenAI-compatible 格式 → 发给目标厂商 API。

### 2. 环境变量陷阱（最重要的经验）

`.env` 里的 `OPENAI_API_KEY` 不是 OpenAI 的 key，而是**目标厂商**的 key（本例中是 Xiaomi 的 key）。变量名沿用是因为 proxy 把所有目标都当作 OpenAI-compatible API 调用。

启动 proxy 的 shell 不能提前有 `ANTHROPIC_API_KEY`，否则 `python-dotenv` 不会覆盖，proxy 会开启客户端 key 校验，Claude Code 发的请求会被拒掉。

### 3. 代理链路问题

本机有 ClashX 代理（端口 7890），但设置了 `HTTP_PROXY=127.0.0.1:7897`（错误端口）。这导致：
- Claude Code 访问本地 8082 proxy 被转给 7897 → 连不上
- proxy 进程访问 Xiaomi API 也被 7897 干扰 → 500 Internal Server Error

### 4. 最终验证通过的架构

```
Claude Code (ANTHROPIC_BASE_URL=http://127.0.0.1:8082)
    ↓ NO_PROXY=localhost,127.0.0.1 （不走 Clash）
claude-code-proxy (干净环境，无 HTTP_PROXY)
    ↓ 直连
Xiaomi mimo-v2.5-pro API

Claude Code 的 Bash 工具 (git/curl)
    ↓ HTTP_PROXY=http://127.0.0.1:7890 （ClashX）
GitHub / 外网
```

### 5. 固化的工具

- `~/bin/claude-proxy-start` — 启动后台 proxy（tmux，干净环境）
- `~/bin/xclaude` — 启动 Claude Code（自动检测 Clash、设 NO_PROXY）
- `~/.zshrc` 中有 `alias xclaude` 和 `alias claude-proxy-start`

### 6. 关于 sk- 前缀

proxy 的 `/health` 显示 `api_key_valid: false` 是因为代码里写了 `startswith("sk-")`。这只影响健康检查展示，**不影响实际请求**。Xiaomi key 不以 sk- 开头没有问题。

## Decisions Made

- 选择 `claude-code-proxy` 方案而非直接配置（Claude Code 原生只认 Anthropic API 格式）
- 用 tmux 后台持久化 proxy，而非每次手动启动
- 写 `xclaude` wrapper 脚本处理环境变量，而非每次手动 export
- ClashX 代理仅用于 Claude Code 的 Bash 工具访问外网，proxy → Xiaomi 的链路保持干净

## Open Questions

- clash 端口变化时是否需要自动检测
- 是否有比 claude-code-proxy 更稳定的方案（如 LiteLLM）
- mimo-v2.5-pro 作为 Claude Code 底座模型的能力边界

---

*Session: 2026-05-01, Platform: Codex (GPT-5)*
