# Form: Article

The article form is a standalone technical piece for a public-ish reader: blog post, research-synthesis explainer, deep-dive write-up, conference-talk companion. The reader arrives without prior context and expects a thesis, supporting evidence, and a resolution. Unlike the audit form, no action is expected — the deliverable is read, not executed against.

## Structural conventions

- **Open with the thesis.** First paragraph states the claim or the question the article answers. No throat-clearing, no "in this article we'll discuss...", no autobiographical setup unless directly load-bearing.
- **Each section advances the thesis.** Section headers preview the claim they'll support, not the topic they cover. Sections that don't advance the thesis are cut, even if interesting.
- **Supporting examples carry concrete specifics.** Real datasets, real models, real numbers, real code. Generic ("imagine a scenario where...") is a smell — pull a real one from the source material.
- **Resolution lands the thesis.** Closing states what the evidence adds up to. Not a summary of what the article covered ("we've seen that..."), an assertion of what the reader should now believe.
- **Standalone.** The reader didn't read your previous post and doesn't have your context. Background load needed for the thesis to land goes inline; cross-references to outside material are footnotes or external links, not assumed knowledge.

## Form-specific anti-patterns

- "In this article we'll discuss / cover / explore..." opening
- Autobiographical preamble unrelated to the thesis ("I was sitting at my desk last Tuesday...")
- Throat-clearing transitions ("Before we get into that, let's first...")
- A summary section restating what was just covered
- "Hopefully this was useful" sign-offs and similar reader-pleasing tics
- Section titles that name a topic rather than preview a claim ("On embeddings" vs. "Dense embeddings alone miss exact-token matches")
- Tangents preserved because they were interesting during research but don't advance the thesis
- A call-to-action tacked on the end of an article that wasn't selling anything

## Short exemplar

Fictional snippet — opening of a research-synthesis article on hybrid search for code retrieval:

````markdown
# Dense embeddings miss exact-token matches; BM25 catches them; combine the two

Dense vector search dominates the retrieval conversation, but applied to code it has a structural blind spot: function and identifier names lose their token-level identity in the embedding. A query for `useEffect` returns code semantically near React state management — not always the file that calls `useEffect`. BM25, the unfashionable lexical baseline, gets this right by construction.

The fix is hybrid search: combine BM25 and dense scores per document, then re-rank. The MTEB code-retrieval benchmark shows the hybrid approach beating either method alone on every public code corpus tested in the last six months. The mechanism is unglamorous and the implementation is two requests plus a weighted sum.

## Why dense-only fails on identifiers

`sentence-transformers/all-MiniLM-L6-v2` tokenizes `useEffect` as `use` + `##effect` — two subword pieces that contribute to a semantic centroid alongside whatever else surrounds them. A function definition for `useEffect` produces a vector indistinguishable from a paragraph *about* `useEffect`, because both encode the same subword identity in roughly the same context.

A representative miss from the CodeSearchNet eval set: the query `function to debounce a callback` retrieves three blog-post-style markdown files explaining debounce before it surfaces the actual `debounce.ts` in `lodash`. The markdown is denser in conceptual vocabulary; the implementation is denser in the noun being queried.

## BM25 catches what dense misses

BM25 scores documents by exact term frequency, scaled by inverse document frequency across the corpus. The `debounce` query against the same corpus surfaces `lodash/debounce.ts` first — the file with the highest local frequency of the exact token. The cost is the symmetric failure: BM25 alone misses paraphrased queries where the lexical overlap is low.

## The combination is a weighted sum

A reciprocal rank fusion (RRF) over the two ranked lists, with `k=60`, recovers both behaviors. The Pyserini and Vespa documentation both treat this as the default; production code-search systems at Sourcegraph and GitHub use variants on the same idea. Re-ranking with a small cross-encoder closes most of the remaining gap.
````

## Form-specific self-check

- [ ] Thesis stated in the first paragraph; no throat-clearing or autobiographical preamble
- [ ] Each section advances the thesis; topic-headers replaced with claim-headers
- [ ] Supporting examples carry real specifics (datasets, models, numbers, code) — no "imagine a scenario where..."
- [ ] Closing lands the thesis as an assertion, not a recap of what the article covered
- [ ] Reader can pick this up cold — required background loads inline, not assumed
- [ ] No reader-pleasing sign-offs ("hopefully this helps", etc.) or vestigial calls-to-action
