# 🧠 Auto Wiki — LLM-Maintained Personal Knowledge Base

A personal knowledge wiki maintained by LLM agents, following Andrej Karpathy's [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

## The Idea

Instead of using RAG (retrieval-augmented generation) where the LLM rediscovers knowledge from scratch on every query, this wiki **compiles knowledge incrementally** into structured, interlinked Markdown pages. The wiki is a **persistent, compounding artifact** — it gets richer with every source you add and every question you ask.

**You curate sources and ask questions. The LLM does all the bookkeeping.**

## Quick Start

```bash
# Clone the repo
git clone https://github.com/tqzhong/auto_wiki.git
cd auto_wiki

# Open with Obsidian (recommended) or any Markdown editor
# Point Obsidian at the wiki/ directory as your vault

# Or view stats
./tools/wiki_stats.sh

# Search the wiki
./tools/search_wiki.sh "search term"
```

## Directory Structure

```
auto_wiki/
├── CLAUDE.md              # Schema / operating manual for the LLM agent
├── README.md              # This file
├── raw/                   # Immutable raw sources
│   └── assets/            # Downloaded images and attachments
├── wiki/                  # LLM-maintained wiki pages
│   ├── index.md           # Master index of all pages
│   ├── log.md             # Chronological activity log
│   ├── overview.md        # Big-picture synthesis
│   ├── entities/          # People, organizations, products
│   ├── concepts/          # Ideas, theories, methods, frameworks
│   ├── sources/           # One summary per ingested source
│   └── comparisons/       # Analyses, comparisons, Q&A artifacts
└── tools/                 # CLI utilities
    ├── search_wiki.sh     # Text search across wiki pages
    └── wiki_stats.sh      # Wiki statistics
```

## How It Works

### 1. Ingest
Drop a source into `raw/` and tell the LLM to ingest it. The LLM reads the source, creates a summary page, updates relevant entity/concept pages, maintains cross-references, and logs the activity.

### 2. Query
Ask questions against the wiki. The LLM finds relevant pages, synthesizes answers with citations, and can file valuable answers back as new wiki pages.

### 3. Lint
Periodically ask the LLM to health-check the wiki for contradictions, orphan pages, stale claims, and missing cross-references.

## Using with LLM Agents

This wiki is designed to work with LLM coding agents like:

- **Claude Code** — The `CLAUDE.md` file serves as the operating manual
- **OpenAI Codex** — Rename to `AGENTS.md`
- **Cursor** — Use as project context
- **Any file-editing AI agent** — The conventions are documented in `CLAUDE.md`

## Recommended Setup

1. **Obsidian** as the viewer — open `wiki/` as a vault for graph view, links, and Dataview
2. **Obsidian Web Clipper** for quickly saving web articles to `raw/`
3. **Git** for version history (you get this for free since it's a repo)
4. **qmd** (optional) for hybrid BM25/vector search as the wiki grows

## Philosophy

> "The tedious part of maintaining a knowledge base is the bookkeeping. Humans abandon wikis because the maintenance burden grows faster than the value. LLMs don't get bored, don't forget to update a cross-reference, and can touch 15 files in one pass." — Andrej Karpathy

---

*This project is inspired by [Karpathy's LLM Wiki Gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).*
