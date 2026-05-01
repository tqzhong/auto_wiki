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
