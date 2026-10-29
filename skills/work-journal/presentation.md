# Editorial and presentation conventions

## Reporting period

Title shape: `Week of October 19–23 | Week 43 of 2026 | Q4`. The range is the Monday–Friday dates, the week is the ISO week and week-year, and the quarter is the calendar quarter (January–March is Q1); a week that crosses a quarter takes Monday's.

## Categories

| Heading | Contents |
| --- | --- |
| 🏰 Customers | 💸 Sales and 💜 Support subdivisions, then a subheading per customer |
| 🛠️ Product | 🐛 Bugs and ✨ Feature requests, with Scoped and Shipped subdivisions when populated, by Winnie's contribution |
| 📊 Data | Internal analytics systems, modeling, data quality, and the infrastructure and access that serve them |
| 🤖 Workflows | Internal tools, operations, CRM and GTM automation, support processes, community |
| 📚 Docs | Documentation |

Place work by the system it operates or the person it served, not the tool involved, and list each item once. A customer-requested product change is Product with the customer named; a direct session with that customer sits under the customer. GCP access granted so the analytics system can run is Data, while an Attio attribution fix is Workflows because it operates the CRM.

Nest only under a shared objective, never a shared tool or keyword: demo provisioning is a parent with the workflow improvement and each sandbox beneath it, each child keeping its own status.

## Wording and citations

Blurbs are short, outcome-first, and describe Winnie's actual contribution. A request is not delivery, an investigation is not a resolution, and a draft is not shipped. Winnie's corrections about ownership override anything inferred from authorship. Planning items state the goal and the concrete progress in the window, such as questions resolved or scope clarified.

Citations follow the blurb in parentheses: Linear IDs and PR or issue numbers, repository named only when ambiguous; Slack as `[Thread](permalink)`. Prefer the issue or PR that carries the result over the thread that started it, and include both when they support different parts of the claim. Shipped docs cite the PR and the live page.

A cut is not permanent; a customer or topic cut this week is judged fresh next week.

## Slack

Each item leads with a category emoji (📚 docs, 🤖 AI workflows, 📊 data, 💸 demos and prospects, 💜 paying-customer support and community, 🛠️ product and tools) and ends with status just before the citations. A parent can omit status when its children differ.

```markdown
**Week of October 19–23 | Week 43 of 2026 | Q4**

- 📊 Fixed the data-quality issue behind inflated and undercounted AI usage metrics. ✅ ([PR #123](https://github.com/example/repo/pull/123))
- 💸 Demo provisioning
  - 🤖 Shipped the provisioning workflow improvements. ✅ ([AE-123](https://linear.app/example/issue/AE-123))
  - 💸 Building the customer's sandbox. ⚡ ([Thread](https://example.com/thread))

[Full work journal](https://example.com/weeks/2026-43/)
```

The example shows structure only; its claims and URLs are placeholders. Check the sending tool's Markdown contract: this journal's connector takes standard Markdown with double-asterisk bold. Disable link unfurls when the tool supports it, and record the permalink after sending. A later change to Site presentation does not reopen a posted message.

## Site input Markdown

The Site renders differently from its input: category emojis move to headers and navigation while each task leads with its status emoji so filters stay legible, and links become platform icons with accessible names and a trailing ↗. Visible text includes Linear IDs, GitHub numbers, and docs paths stripped of the domain and anchor, such as `semantic-layer/parameters`; destinations retain their complete URLs. Write for the parser, not the rendered page. Inspect the builder's parser before editing, with the latest published week as a working example; current conventions:

- `## Customers`, `## Product`, `## Data`, `## Workflows`, `## Docs` as plain category names, all five present even when empty.
- `###` groups and `####` phases carry grouping metadata the app uses for Sales/Support and customer nesting; no other heading levels.
- Bullets start with a category emoji and end with a status immediately before the parenthesized citations, or at line end.
- Two-space indentation marks nested work.

Strip every `Winnie:` review note before publishing, and check the generated list against the reviewed draft.
