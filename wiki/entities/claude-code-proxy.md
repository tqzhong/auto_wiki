---
type: entity
tags: [tool, proxy, claude-code, open-source]
created: 2026-05-01
updated: 2026-05-02
related:
  - ../concepts/claude-code-third-party-api-setup.md
  - xiaomi-mimo-api.md
  - ../sessions/2026-05-01-claude-code-proxy-setup.md
  - omc.md
sources: []
summary: "Anthropic Messages API → OpenAI-compatible API 的协议转换代理，让 Claude Code 可以使用第三方 API"
---

# claude-code-proxy

## Overview

[claude-code-proxy](https://github.com/fuergaosi233/claude-code-proxy) 是一个 Python 代理服务，接收 Claude Code 发出的 Anthropic Messages API 格式请求，转换成 OpenAI-compatible 格式，转发给目标厂商 API。

## 核心信息

| 项目 | 值 |
|------|-----|
| GitHub | https://github.com/fuergaosi233/claude-code-proxy |
| 本地路径 | `~/Desktop/claude-code-proxy/` |
| 语言 | Python |
| 启动方式 | `python start_proxy.py` |
| 默认端口 | 8082 |

## 配置（.env 文件）

```env
OPENAI_API_KEY=<目标厂商的 API key>
OPENAI_BASE_URL=<目标厂商的 API 地址>
BIG_MODEL=<模型名>
MIDDLE_MODEL=<模型名>
SMALL_MODEL=<模型名>
```

注意：`OPENAI_API_KEY` 这个变量名是沿用的，实际含义是"目标厂商的 API key"，不是 OpenAI 的 key。

## 已知问题

- `/health` 端点的 `api_key_valid` 检查写死了 `startswith("sk-")`，第三方 key 不以 sk- 开头会显示 false，但不影响实际请求
- 进程继承环境变量的行为（`python-dotenv` 不覆盖已有变量）容易导致意外行为
- 需要在干净环境下启动（清除 `ANTHROPIC_API_KEY`、`HTTP_PROXY` 等）

## 本地启动脚本

持久化启动：`~/bin/claude-proxy-start`（tmux 后台运行，自动清理环境变量）

## Connections

- 配合 [[xiaomi-mimo-api]] 使用
- 配置方法详见 [[claude-code-third-party-api-setup]]
- 完整调试记录在 [[2026-05-01-claude-code-proxy-setup]]
- [[omc]] 启动的 Claude Code 实例也会走此代理链路（需确保环境变量一致）

## Open Questions

- 是否有更稳定的替代方案（如 LiteLLM）
- 流式响应的兼容性是否有边界情况
