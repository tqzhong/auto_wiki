# LLM Wiki — Schema / Operating Manual

This document defines how the LLM agent maintains and operates on this personal wiki.
Read it carefully before every session. All conventions, workflows, and file formats are specified here.

---

## Project Overview

This is a **personal knowledge wiki** — a persistent, compounding collection of interlinked Markdown pages.
The LLM reads raw sources, extracts key information, and integrates it into the wiki.
The wiki is the artifact; the human curates sources and asks questions; the LLM does all the bookkeeping.

## Directory Structure

```
auto_wiki/
├── CLAUDE.md          # This schema file — the LLM's operating manual
├── raw/               # Immutable raw sources (articles, notes, transcripts, images)
│   └── assets/        # Downloaded images and attachments
├── wiki/              # LLM-generated and LLM-maintained wiki pages
│   ├── index.md       # Content-oriented catalog of all wiki pages
│   ├── log.md         # Chronological append-only activity log
│   ├── overview.md    # High-level overview / synthesis page
│   ├── entities/      # Entity pages (people, organizations, products, etc.)
│   ├── concepts/      # Concept pages (ideas, theories, methods, frameworks)
│   ├── sources/       # One summary page per ingested source
│   └── comparisons/   # Comparison pages, analyses, and Q&A artifacts
├── tools/             # Optional CLI tools and scripts
└── README.md          # Project README
```

## Three Layers

1. **Raw sources (`raw/`)** — Immutable. The LLM reads from them but never modifies them.
2. **The wiki (`wiki/`)** — The LLM owns this entirely. Creates, updates, cross-references, maintains consistency.
3. **The schema (`CLAUDE.md`)** — This file. Defines conventions and workflows. Co-evolved by human and LLM.

---

## Wiki Page Format

Every wiki page MUST follow this format:

```markdown
---
type: entity | concept | source | comparison | overview
tags: [tag1, tag2, tag3]
created: YYYY-MM-DD
updated: YYYY-MM-DD
related: [path/to/other/page.md]
sources: [path/to/raw/source.md]
summary: "One-line summary of this page"
---

# Page Title

## Overview
Brief overview paragraph.

## Key Points
- Point 1
- Point 2

## Details
...

## Connections
Links to related wiki pages. Explain how this page relates to others.

## Open Questions
- Things that are uncertain or need further research.
```

### Page Naming Conventions
- Use lowercase, hyphenated names: `transformer-architecture.md`, `sam-altman.md`
- Entity pages: `wiki/entities/{name}.md`
- Concept pages: `wiki/concepts/{name}.md`
- Source pages: `wiki/sources/{source-slug}.md`
- Comparison pages: `wiki/comparisons/{topic}.md`

---

## Workflow 1: Ingest

When the human drops a new source into `raw/` and asks to ingest it:

1. **Read** the source carefully. If it's a URL, fetch it and save as markdown in `raw/`.
2. **Discuss** key takeaways with the human (brief summary, notable insights).
3. **Create a source page** in `wiki/sources/` with a structured summary.
4. **Update `wiki/index.md`** — add the new source page.
5. **Update existing pages** — for each entity, concept, or topic mentioned in the source that already has a wiki page:
   - Add new information, cross-references, and citations.
   - Flag contradictions with existing claims.
   - Update the `updated` date in frontmatter.
6. **Create new pages** if the source introduces significant new entities or concepts not yet in the wiki.
7. **Update `wiki/overview.md`** if the source meaningfully changes the big picture.
8. **Append to `wiki/log.md`** with the ingest entry.

### Ingest Log Entry Format
```
## [YYYY-MM-DD] ingest | Source Title
- Source: `raw/filename.md`
- Pages created: list
- Pages updated: list
- Key insight: one-line summary
```

---

## Workflow 2: Query

When the human asks a question:

1. **Read `wiki/index.md`** to identify relevant pages.
2. **Read those pages** to gather context.
3. **Synthesize an answer** with citations to wiki pages (e.g., `see [Transformer Architecture](wiki/concepts/transformer-architecture.md)`).
4. **Offer to file the answer** — if the query produced a valuable synthesis, comparison, or analysis, offer to save it as a new wiki page (e.g., in `wiki/comparisons/`).
5. **Append to `wiki/log.md`** with the query entry.

### Query Log Entry Format
```
## [YYYY-MM-DD] query | Brief question summary
- Pages consulted: list
- Result: filed as `wiki/comparisons/topic.md` | or | answered inline
```

---

## Workflow 3: Lint (Health Check)

When the human asks to lint or health-check the wiki:

1. **Read all wiki pages** (or a subset if the wiki is large).
2. **Check for:**
   - Contradictions between pages
   - Stale claims superseded by newer sources
   - Orphan pages with no inbound links
   - Important concepts mentioned but lacking their own page
   - Missing cross-references
   - Data gaps that could be filled with web search
   - Inconsistent frontmatter (missing dates, tags, etc.)
3. **Report findings** to the human with suggested fixes.
4. **Apply fixes** if the human approves.
5. **Append to `wiki/log.md`** with the lint entry.

### Lint Log Entry Format
```
## [YYYY-MM-DD] lint | Summary of findings
- Issues found: N
- Fixed: list of fixes
- Deferred: list of items needing human input
```

---

## Workflow 4: Evolve the Schema

As the wiki grows, the human and LLM may discover better conventions. Update this `CLAUDE.md` file to reflect:
- New page types or categories
- Changed naming conventions
- New frontmatter fields
- Refined workflows
- Tooling changes

Document what changed and why in the log.

---

## Indexing: `wiki/index.md`

The index is the LLM's navigation aid. It MUST be kept up to date after every operation.

Format:
```markdown
# Wiki Index

## Entities
- [Sam Altman](entities/sam-altman.md) — CEO of OpenAI. | Updated: 2026-04-01

## Concepts
- [Transformer Architecture](concepts/transformer-architecture.md) | Updated: 2026-03-28

## Sources
- [Attention Is All You Need (2017)](sources/attention-is-all-you-need.md) | Ingested: 2026-03-20

## Comparisons
- [GPT vs Claude vs Gemini](comparisons/gpt-claude-gemini.md) | Updated: 2026-04-01
```

---

## Logging: `wiki/log.md`

Append-only. Each entry is a level-2 heading with a date prefix. Format:
```markdown
# Wiki Activity Log

## [2026-04-01] ingest | Article Title
- Source: `raw/article.md`
- Pages created: ...
- Pages updated: ...
- Key insight: ...

## [2026-04-02] query | Question about X
- Pages consulted: ...
- Result: ...
```

Parseable with unix tools: `grep "^## \[" wiki/log.md | tail -5`

---

## Rules and Conventions

1. **Never modify files in `raw/`.** They are immutable source of truth.
2. **Always update frontmatter** `updated` date when modifying a wiki page.
3. **Always maintain cross-references.** Every wiki page should link to related pages.
4. **Always update `wiki/index.md`** after creating or significantly modifying pages.
5. **Always append to `wiki/log.md`** after ingest, query, or lint operations.
6. **Use Obsidian-compatible markdown** — wiki links with `[[page name]]` are welcome alongside standard `[text](path)` links.
7. **Cite sources.** When adding claims from raw sources, reference the source file.
8. **Flag uncertainty.** Use the "Open Questions" section rather than presenting speculation as fact.
9. **Prefer incremental updates** over rewriting pages from scratch.
10. **When in doubt, ask the human** rather than making assumptions about what to emphasize.

---

## Tips for the Human

- **Obsidian** works great as a viewer — open `wiki/` as an Obsidian vault.
- **Graph view** shows the shape of your knowledge — what's connected, what's isolated.
- **Obsidian Web Clipper** is great for quickly saving web articles to `raw/`.
- **Dataview plugin** can query frontmatter across all pages.
- **The wiki is a git repo** — you get full version history for free.

---

*This schema is a living document. It evolves as the wiki grows.*
