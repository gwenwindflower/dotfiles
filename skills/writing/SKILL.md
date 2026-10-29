---
name: writing
description: Writing for humans - messaging, posts, articles, technical docs, and fiction. Specific processes for editorial review and technical synthesis from codebases.
---

# Writing

Match the audience, medium, and purpose before choosing structure or tone. Infer these from the request and surrounding conversation; ask only when an unresolved choice changes the piece. Agent instructions belong to `context-engineering`.

## Voice and structure

Follow the intended author's voice and communication preferences from the brief or available user context. Match casing, informality, and formatting to the medium and audience.

Lead with what the reader needs. Keep paragraphs short, use lists for parallel items or steps, and emphasize actions and requests selectively. Preserve nuance and uncertainty that affect what the reader should believe or do. Cut repeated context and decorative emphasis; keep warmth, humor, and personality when they fit.

## Guidance by task

| Job | Doc |
| --- | --- |
| Turn a codebase, system, or investigation into clear technical writing | [technical synthesis](technical-synthesis.md) |
| Diagnose formulaic phrasing or repetition in substantial prose | [anti-patterns](anti-patterns.md) |
| Improve sentence rhythm, asides, and flow | [voice and flow](voice-and-flow.md) |
| Shape a blog post or essay using annotated examples | [human blog example](human-blog-example.md) |

Read the branch that serves the task. Apply prose references with the medium in mind: Slack shorthand and natural em dashes do not need formalizing.

## Drafting and revision

Draft short messages directly. For longer pieces, outline what each section contributes before drafting; merge sections that make the same point. When the source is a codebase, system, or data platform, use [technical synthesis](technical-synthesis.md) to build an evidence-backed structure before prose.

Revise structure before sentences. Cut content that does not change the reader's understanding or next action. Check that the request, practical implications, and any next steps are easy to find. Keep the level of explanation appropriate to what this audience already knows.

## Optional editor review

Use the `editor` subagent when the user requests it or an independent critique would help a substantial or difficult piece. Short replies and routine edits usually need only a direct revision pass.

Give the editor the brief, audience, medium, intended voice, and draft. Revise substantive issues; request another pass when the revision warrants it. Scores are diagnostic, not a mandatory delivery threshold. If no editor is available, review directly and do not imply independent review occurred.
