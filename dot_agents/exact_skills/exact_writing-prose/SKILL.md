---
name: writing-prose
description: Write or edit narrative and expository prose for human readers — blog posts, articles, essays, fiction, marketing copy, human-facing docs. Skip agent context files (AGENTS.md, rules, skills, memory), READMEs, CLI help, and other structured/functional markdown.
---

# Writing Prose

Rules for generating or editing prose. Targets narrative and expository writing — blog posts, articles, essays, fiction, documentation aimed at human readers.

**Does NOT apply to:** AGENTS.md, rules, skills, memory files, READMEs, tool descriptions, CLI output, commit messages, or any functional/structured markdown.

## Core Principles

1. **Write directly** — active voice, clear word choices, no stacked adjectives or emphasis filler
2. **Trust the reader** — don't re-explain shared context, project mental states, or announce significance
3. **Avoid formulaic patterns** — no binary contrasts, predictable openers, or repetitive dramatic structures

## Workflow

1. Skim [anti-patterns](anti-patterns.md) before drafting if you haven't recently — the LLM tells it catalogs are the most common reason prose gets flagged. Read [human-blog-example](human-blog-example.md) when the piece is a blog post, essay, or other narrative-leaning form — it gives annotated excerpts for intro shape, section flow, code framing, claims, and conclusions.
2. Draft following the Core Principles.
3. **Subtractive pass.** Read each sentence and ask whether removing it changes the meaning. If not, cut. Reread the headings — does each state a finding or just label a topic? Pay extra attention to section openers and closers; rhetorical satisfaction tends to land at boundaries.
4. **Structural pass.** Sketch a conceptual outline — one phrase per section saying what that section actually delivers. Two sections collapsing to the same phrase means one was padding; cut or merge. Only intro and conclusion may legitimately echo each other.
5. Submit full prose to the `prose-editor` subagent. It scores across 8 dimensions (1-5 pts each, 40 max).
6. If score < 32/40, revise based on cited issues, repeat from step 5.
7. Present only after passing (≥ 32/40).

Do not self-score or bypass the editor.

## Reference Files

- [Anti-Patterns](anti-patterns.md) — hard-no list of LLM tells, intensifiers, jargon, and meta-voice. Start here.
- [Voice and Flow](voice-and-flow.md) — sentence-level rhythm, structure, and rhetorical patterns; includes the positive vision of strong prose.
- [Human Blog Example](human-blog-example.md) — annotated excerpts for blog posts and essays: intro shape, section flow, code framing, product claims, and conclusions. Read before drafting longer pieces; reread sections of it when a draft starts feeling generic.
