# Project Knowledge Wiki — Schema

LLM-maintained wiki (Karpathy "LLM Wiki" pattern). Also an Obsidian vault: open `knowledge/` (not the repo root) in Obsidian.

## Layers
- `raw/` — sources. **Immutable: never edit, rename or delete anything in raw/.**
  - `raw/specs/` client specs, change requests
  - `raw/meetings/` meeting notes / transcripts, named `YYYY-MM-DD_topic.md`
  - `raw/client-comms/` emails, chat exports, client feedback
  - `raw/extracts/` text extracts of binary sources (xlsx/pdf/docx): generated, dated, never hand-edited
  - `raw/assets/` images and attachments
- `wiki/` — owned and written by the LLM. The human reads it.
- The project itself (`../client`, `../server`, `../TASKS.md`, `../docs/BRIEF.md`) is also a source:
  read it, never modify it from a wiki operation.

## Wiki layout
- `wiki/index.md` — catalog of every page: `- [[path/page]] — one-line summary`, grouped by folder. Read it first on every operation.
- `wiki/log.md` — append-only. Each entry starts `## [YYYY-MM-DD] <op> | <title>` (op = ingest, query, lint, sync, decision).
- `wiki/overview.md` — project at a glance + current status. Keep under ~150 lines.
- `wiki/sources/` — one page per ingested source: what it is, key takeaways, which pages it touched.
- `wiki/modules/` — one page per functional module (requirements, rules, screens, tables, status).
- `wiki/concepts/` — cross-cutting ideas (state machines, numbering, approvals, ...).
- `wiki/architecture/` — tech stack, data model, frontend, dev workflow.
- `wiki/decisions/` — open items, decisions (ADR-style), known gaps and contradictions.

## Page conventions
- Start every page with YAML frontmatter:
  ```
  ---
  type: module | concept | architecture | decision | source | overview
  tags: [..]
  reqs: [..]                  # requirement IDs covered, if the project uses them
  sources: [[sources/...]]    # where the facts came from
  updated: YYYY-MM-DD
  ---
  ```
- Link liberally with `[[wikilinks]]` (path without .md). Every page links to at least one other page and is listed in index.md.
- TASKS.md tasks are `T-nnn`. If another task list uses clashing IDs (e.g. a spreadsheet), prefix it (`XT-nnn`) and always disambiguate.
- Refer to code by repo-relative path in backticks, e.g. `server/migrations/0001_init.sql`.
- Cite the source for non-obvious facts: `(src: [[sources/<name>]])`.
- Flag conflicts inline: `> [!warning] Contradiction: ...` and add them to `decisions/known-gaps.md`.
- Mark things not yet confirmed by the client: `> [!question] Open: ...` and link `decisions/open-items.md`.
- Facts over prose. Tables for requirements, fields and rules. No filler.

## Operations

### Ingest  (`/wiki-ingest <path>`)
1. Read the source fully. If binary (xlsx/pdf/docx), first write a text extract to `raw/extracts/YYYY-MM-DD_<name>.md`.
2. Tell the human the 3-7 key takeaways and anything that contradicts the wiki; wait for their input unless told to proceed.
3. Create `wiki/sources/<name>.md`.
4. Update every affected module/concept/decision page. Create new pages where a topic has no home.
5. Update `index.md`, `overview.md` (if status changed) and `decisions/*` (resolved/new open items, contradictions).
6. Append to `log.md`, listing the pages touched.

### Query  (`/wiki-query <question>`)
Read index.md -> relevant pages -> (only if needed) raw sources or code. Answer with `[[links]]`.
If the answer is reusable (comparison, analysis, plan), offer to file it as a new wiki page; log the query.

### Sync with code  (`/wiki-sync`)
After TASKS.md tasks finish or code changes: diff the repo against what the wiki says
(`git log`, `git diff`, TASKS.md, migrations, client routes, server routes). Update status, architecture and module pages; log it.

### Lint  (`/wiki-lint`)
Check: contradictions between pages or vs. code; stale status; orphan pages; pages missing from index;
broken wikilinks; requirements with no module page; open items that are now resolved; gaps worth asking the client about.
Report findings first, then fix the ones that don't need a human decision. Log it.

## Don'ts
- Don't edit `raw/`, project code or `TASKS.md` during wiki operations.
- Don't invent requirements or decisions. Unknown = open question.
- Don't delete wiki pages; merge and leave a redirect line instead.
