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
│   ├── assets/        # Downloaded images and attachments
│   └── sessions/      # Raw conversation exports (immutable once saved)
├── wiki/              # LLM-generated and LLM-maintained wiki pages
│   ├── index.md       # Content-oriented catalog of all wiki pages
│   ├── log.md         # Chronological append-only activity log
│   ├── overview.md    # High-level overview / synthesis page
│   ├── entities/      # Entity pages (people, organizations, products, etc.)
│   ├── concepts/      # Concept pages (ideas, theories, methods, frameworks)
│   ├── sources/       # One summary page per ingested source
│   ├── sessions/      # Distilled session summaries (conversation → knowledge)
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
type: entity | concept | source | session | comparison | overview
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
- Session pages: `wiki/sessions/{YYYY-MM-DD}-{topic-slug}.md`

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

## Workflow 4: Distill (对话蒸馏)

当人类完成一次有价值的 AI 对话后，将对话内容提炼沉淀到 wiki 中。这是最常用的工作流之一。

### 触发方式

- 人类说："把这次对话蒸馏到 wiki" / "沉淀一下这次对话"
- 人类提供对话记录文件（从 `raw/sessions/` 或其他来源）
- 人类粘贴对话内容并请求蒸馏

### 蒸馏流程

1. **阅读对话内容**。完整理解对话的主题、讨论过程和结论。
2. **提取核心知识**。从对话中识别：
   - 关键概念和定义
   - 重要结论和洞察
   - 人物、工具、产品等实体
   - 可执行的建议或方法
   - 遗留的未解决问题
3. **保存对话摘要**。在 `wiki/sessions/` 创建 session 页面：
   ```markdown
   ---
   type: session
   date: YYYY-MM-DD
   title: "对话主题"
   platform: "Claude Code | ChatGPT | Claude.ai | other"
   topic: "主题关键词"
   tags: [tag1, tag2]
   related: [wiki/pages/that/were/created/or/updated.md]
   sources: [../../raw/sessions/filename.md]
   summary: "一句话概括这次对话的核心收获"
   ---

   # Session: 对话主题

   ## Context
   这次对话的背景和动机。

   ## Key Takeaways
   - 结论 1
   - 结论 2

   ## Decisions Made
   - 做出了什么决定，为什么

   ## Open Questions
   - 留下来需要继续探索的问题

   ## Wiki Impact
   - 创建/更新了哪些 wiki 页面（与蒸馏过程中实际创建/更新的页面对应）
   ```
4. **创建或更新 wiki 页面**。将提取的知识分散到对应的 wiki 页面：
   - 新概念 → `wiki/concepts/` 中创建页面
   - 新人物/工具/产品 → `wiki/entities/` 中创建页面
   - 新分析/对比 → `wiki/comparisons/` 中创建页面
   - 已有页面的新信息 → 增量更新现有页面
   - **关键原则**：对话中的知识要结构化到对应的主题页面，而不是全部堆在 session 摘要里
5. **更新 `wiki/index.md`** — 添加新页面。
6. **更新 `wiki/overview.md`** — 如果对话产出了重要新视角。
7. **追加 `wiki/log.md`** — 记录蒸馏活动。

### 蒸馏的粒度指导

| 对话类型 | 蒸馏策略 |
|---------|---------|
| **学习新领域** | 创建概念页面为主，建立领域知识框架 |
| **技术调试/问题排查** | 创建 session 摘要 + 提取可复用的 troubleshooting 概念 |
| **头脑风暴/创意讨论** | 创建 session 摘要 + 提取决策和待办 |
| **深度研究讨论** | 大量创建/更新 entity + concept 页面，session 作为 source 引用 |
| **日常闲聊/低信息密度** | 可跳过蒸馏，或只记录 session 摘要 |

### 蒸馏 vs 收录的区别

| | Ingest（收录） | Distill（蒸馏） |
|--|---------------|----------------|
| **输入** | 外部文章、论文、资料 | 与 AI 的对话记录 |
| **来源** | 通常是已发表的内容 | 你和 AI 共同生成的内容 |
| **知识密度** | 通常较高，结构化 | 不均匀，需要筛选提炼 |
| **核心价值** | 信息提取和整合 | 思考过程的结晶和决策记录 |
| **session 页面** | 不需要 | 需要，作为对话的结构化摘要 |

### Distill Log Entry Format
```
## [YYYY-MM-DD] distill | 对话主题
- Source: `raw/sessions/filename.md` 或 current session
- Platform: Claude Code | ChatGPT | other
- Pages created: list
- Pages updated: list
- Session page: `wiki/sessions/YYYY-MM-DD-topic.md`
- Key insight: one-line summary
```

---

## Workflow 5: Evolve the Schema

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
11. **蒸馏时要筛选，不要全录。** 对话中的废话、重复、探索性试错不需要沉淀。只提取有价值的知识、结论和决策。
12. **蒸馏的目标是结构化。** 对话中散落的知识点要整理到对应的主题页面，session 页面只保留摘要和索引，不要成为另一个信息垃圾场。
13. **保留思考过程。** 对话中"为什么选择 A 而不是 B"这类决策推理，比最终结论更有价值。

---

## 蒸馏快捷提示

当你想在对话结束时蒸馏当前对话，可以直接对 LLM 说以下任意一句：

- **"把这次对话蒸馏到 wiki"** — 全面蒸馏
- **"沉淀一下这次对话的关键结论"** — 轻量蒸馏
- **"这次对话里关于 X 的讨论很有价值，沉淀一下"** — 聚焦蒸馏

LLM 会自动执行 Workflow 4。

---

## Tips for the Human

- **Obsidian** works great as a viewer — open `wiki/` as an Obsidian vault.
- **Graph view** shows the shape of your knowledge — what's connected, what's isolated.
- **Obsidian Web Clipper** is great for quickly saving web articles to `raw/`.
- **Dataview plugin** can query frontmatter across all pages.
- **The wiki is a git repo** — you get full version history for free.

---

*This schema is a living document. It evolves as the wiki grows.*
