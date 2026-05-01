# Wiki Activity Log

This is an append-only chronological record of all wiki operations.
Each entry is a level-2 heading with a date prefix for easy parsing.

**Useful commands:**
- Last 5 entries: `grep "^## \[" wiki/log.md | tail -5`
- All ingests: `grep "ingest" wiki/log.md`
- All queries: `grep "query" wiki/log.md`

---

## [2026-05-01] init | Project initialized
- Created directory structure: `raw/`, `wiki/`, `tools/`
- Created schema: `CLAUDE.md`
- Created index: `wiki/index.md`
- Created log: `wiki/log.md`
- Created overview: `wiki/overview.md`

## [2026-05-01] ingest | Karpathy's LLM Wiki Gist
- Source: `raw/karpathy-llm-wiki-gist.md`
- Pages created:
  - `wiki/sources/karpathy-llm-wiki-gist.md` — Source summary
  - `wiki/entities/andrej-karpathy.md` — Entity page for Andrej Karpathy
  - `wiki/concepts/llm-wiki-pattern.md` — The core LLM Wiki pattern
  - `wiki/concepts/persistent-compounding-artifact.md` — Compounding knowledge artifact
  - `wiki/concepts/incremental-compilation.md` — Compilation vs retrieval
  - `wiki/concepts/human-llm-collaboration.md` — Human-LLM division of labor
  - `wiki/concepts/memex-concept.md` — Vannevar Bush's Memex (1945)
- Pages updated:
  - `wiki/index.md` — Added all new pages
  - `wiki/overview.md` — Updated with initial themes and connection map
- Key insight: The wiki is not retrieval but compilation — knowledge is compiled once and kept current

## [2026-05-01] distill | Claude Code 使用 Xiaomi API 代理配置
- Source: Codex session `rollout-2026-05-01T11-16-50-019de189-fd55-7142-a677-c039d45d40ec.jsonl`
- Platform: Codex (GPT-5)
- Pages created:
  - `wiki/sessions/2026-05-01-claude-code-proxy-setup.md` — Session 摘要
  - `wiki/concepts/claude-code-third-party-api-setup.md` — Claude Code 第三方 API 配置方法
  - `wiki/entities/claude-code-proxy.md` — claude-code-proxy 工具
  - `wiki/entities/xiaomi-mimo-api.md` — Xiaomi mimo API
- Pages updated:
  - `wiki/index.md` — Added 4 new pages
- Key insight: 环境变量继承污染（ANTHROPIC_API_KEY、HTTP_PROXY）是代理不工作的首要原因，干净环境启动是关键
