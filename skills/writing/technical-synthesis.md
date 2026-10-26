# Technical synthesis

Use this process when a codebase, system, data platform, or investigation is the input and clear technical writing is the output: an audit, review, explanatory map, or substantive feedback. Scale it to the document; a short explanation rarely needs separate artifacts.

## Build structure before prose

1. **Model the source.** Make compact working notes with concrete entities, relationships, data or control flow, constraints, and evidence locations. Separate observed behavior from inference and unknowns. A table, dependency list, pseudocode, or diagram can make relationships explicit without smoothing over gaps.
2. **Extract the points.** Identify what the audience needs to understand or decide. Connect evidence to each claim and its practical implication. Investigate missing support or qualify the claim; do not fill gaps with plausible prose.
3. **Outline the document.** Arrange those points in the order the reader needs them. Give each section one distinct contribution. Put evidence and recommendations beneath the claims they support, and merge overlap before drafting.
4. **Draft from the outline.** Expand each point into clear prose, examples, or tables. Add background only where this audience needs it. Return to source to verify details; do not let source-file order dictate the document's structure.
5. **Review structure, then voice.** Check whether the sections advance understanding, whether evidence supports the claims, and whether conclusions exceed what was verified. Structural feedback means revisiting the model or outline, not polishing sentences built on the wrong premise.

These are working stages, not mandatory user approval gates. Share the outline when a consequential framing choice needs agreement or the user wants to collaborate on structure. Otherwise proceed through the stages and deliver the requested artifact.

## Shape for the reader

- **Audits and reviews:** Keep findings, evidence, impact, and recommendations together. Group related findings by subject; prioritize actions by dependencies, risk, or impact when order matters. Describe problematic patterns without assigning personal blame.
- **Explanatory maps:** Organize around responsibilities, relationships, and concrete paths through the system. Show the connections a file inventory would miss. Define terms only when the audience needs them.
- **Articles and technical docs:** Build toward a clear claim or learning outcome. Use concrete examples to explain mechanisms. Distinguish illustrative examples from measured results; never invent benchmark results or production behavior.

Use actual model, repository, file, dataset, function, and service names. State sampling limits alongside findings. Keep research notes and drafting history out of the deliverable unless the method or decision history is itself relevant to the reader.
