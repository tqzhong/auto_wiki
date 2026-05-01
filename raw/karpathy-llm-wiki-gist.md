# LLM Wiki

A pattern for building personal knowledge bases using LLMs.

Source: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
Author: Andrej Karpathy

---

This is an idea file, it is designed to be copy pasted to your own LLM Agent (e.g. OpenAI Codex, Claude Code, OpenCode / Pi, or etc.). Its goal is to communicate the high level idea, but your agent will build out the specifics in collaboration with you.

## The core idea

Most people's experience with LLMs and documents looks like RAG: you upload a collection of files, the LLM retrieves relevant chunks at query time, and generates an answer. This works, but the LLM is rediscovering knowledge from scratch on every question. There's no accumulation. Ask a subtle question that requires synthesizing five documents, and the LLM has to find and piece together the relevant fragments every time. Nothing is built up. NotebookLM, ChatGPT file uploads, and most RAG systems work this way.

The idea here is different. Instead of just retrieving from raw documents at query time, the LLM **incrementally builds and maintains a persistent wiki** — a structured, interlinked collection of markdown files that sits between you and the raw sources. When you add a new source, the LLM doesn't just index it for later retrieval. It reads it, extracts the key information, and integrates it into the existing wiki — updating entity pages, revising topic summaries, noting where new data contradicts old claims, strengthening or challenging the evolving synthesis. The knowledge is compiled once and then *kept current*, not re-derived on every query.

This is the key difference: **the wiki is a persistent, compounding artifact.** The cross-references are already there. The contradictions have already been flagged. The synthesis already reflects everything you've read. The wiki keeps getting richer with every source you add and every question you ask.

You never (or rarely) write the wiki yourself — the LLM writes and maintains all of it. You're in charge of sourcing, exploration, and asking the right questions. The LLM does all the grunt work — the summarizing, cross-referencing, filing, and bookkeeping that makes a knowledge base actually useful over time. In practice, I have the LLM agent open on one side and Obsidian open on the other. The LLM makes edits based on our conversation, and I browse the results in real time — following links, checking the graph view, reading the updated pages. Obsidian is the IDE; the LLM is the programmer; the wiki is the codebase.

This can apply to a lot of different contexts:
- **Personal**: tracking your own goals, health, psychology, self-improvement
- **Research**: going deep on a topic over weeks or months
- **Reading a book**: filing each chapter as you go
- **Business/team**: an internal wiki maintained by LLMs
- **Competitive analysis, due diligence, trip planning, course notes, hobby deep-dives**

## Architecture

Three layers:
1. **Raw sources** — immutable curated collection of source documents
2. **The wiki** — LLM-generated markdown files, interlinked and maintained by the LLM
3. **The schema** — document (e.g. CLAUDE.md) defining conventions and workflows

## Operations

- **Ingest**: Drop a new source, LLM reads and integrates it into the wiki
- **Query**: Ask questions, LLM searches wiki pages and synthesizes answers
- **Lint**: Periodic health-check for contradictions, orphan pages, stale claims

## Indexing and Logging

- **index.md**: Content-oriented catalog of everything in the wiki
- **log.md**: Chronological append-only record of operations

## Why This Works

The tedious part of maintaining a knowledge base is the bookkeeping. Humans abandon wikis because the maintenance burden grows faster than the value. LLMs don't get bored, don't forget to update a cross-reference, and can touch 15 files in one pass.

## Inspiration

Related to Vannevar Bush's Memex (1945) — a personal, curated knowledge store with associative trails between documents. Private, actively curated, with the connections between documents as valuable as the documents themselves.
