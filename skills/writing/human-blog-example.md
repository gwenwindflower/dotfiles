# Human Blog Examples

Annotated excerpts for blog posts, essays, and long-form product writing. Use these patterns to calibrate structure, voice, and code framing. Do not reuse the fictional company, product, or claims unless the user asks for placeholder copy.

## Fictional Setup

- Company: Keystone Tools
- Product: Driftcheck, a CLI that captures failed CI runs into replayable workspaces
- Audience: senior engineers, platform leads, and founders evaluating developer tools
- Core claim: review gets faster when failures preserve enough context for the next person to inspect them without reconstructing the run from logs

The setup is deliberately generic. It gives examples enough technical shape to be useful without anchoring the skill to a real company, contract, or launch.

## Intro

Good intros start from pressure the reader recognizes, then narrow to the product. They do not open with market weather, a grand claim about the industry, or a tour of the post.

```text
Review slows down when the reviewer has to reconstruct the world around a change. A failing test tells you something broke; it rarely tells you what the author had open, which data set they used, or whether the fix still passes after the branch moves.

Driftcheck is a small CLI from Keystone Tools that captures those missing pieces when CI fails and turns them into a replayable workspace. The useful part is the handoff: the next person can inspect the same failure without rebuilding the story from logs and guesswork.
```

What to copy:

- Concrete friction before product language
- Product named only after the reader understands the problem
- One specific value claim, grounded in the workflow

What to avoid:

- "In today's fast-moving software landscape..."
- "The future of developer productivity is here."
- "This is not just a CLI. It is a new way to ship."

## Structure

A strong post moves from friction to mechanism to consequence. The outline should show the reader's path through the idea, not a list of features.

| Section job | Example title | What it delivers |
| --- | --- | --- |
| Open on the bottleneck | `Review loses time to missing context` | Names the operational pain without exaggerating it |
| Show the failure mode | `CI logs compress too much state` | Explains why the current artifact is insufficient |
| Introduce the mechanism | `Capture the run before the runner disappears` | Shows what the tool records and when |
| Prove it with code | `Replay the failed job from one command` | Gives the reader a concrete workflow |
| Set adoption boundaries | `Start with flaky suites and release branches` | Says where the tool fits first |
| Close with consequence | `Make the next reviewer start from evidence` | Returns to the review bottleneck with a practical next step |

The important move is sequencing. If the product appears before the pain is clear, the post reads like a pitch. If the mechanism appears before the failure mode, the code has no reason to exist.

## Section Titles

Headings should state a finding or promise a useful turn. Topic labels make the post feel like internal documentation.

| Weak | Stronger |
| --- | --- |
| `Overview` | `Review loses time to missing context` |
| `Architecture` | `Capture the run before the runner disappears` |
| `Usage` | `Replay the failed job from one command` |
| `Integrations` | `Keep the workflow inside CI` |
| `Conclusion` | `Make the next reviewer start from evidence` |

Use the stronger shape even in technical sections. The reader should understand why the section exists before reading the first paragraph.

## Flow

Each section needs one job. The transition should move the argument forward rather than summarize the previous section.

```text
CI already has most of the state reviewers ask for later: commit SHA, runner image, dependency cache, environment variables, logs, and test artifacts. The problem is retention. By the time the reviewer asks "can I replay this?", the runner is gone and the surviving logs have flattened the run into text.

Driftcheck captures the run at the point of failure. It stores the environment manifest, selected artifacts, and the exact command that failed, then writes a replay ID back to the pull request.
```

What to copy:

- The first paragraph makes the gap concrete
- The second paragraph introduces the mechanism as a response to that gap
- The product language stays attached to a specific behavior

Cut transitions that only narrate structure:

- "Now that we understand the problem, let's look at the solution."
- "Before we dive into the implementation, it is worth stepping back."
- "This next section will explain how it works."

## Code Examples

Code should prove one claim at a time. Frame the code before the block, then explain the consequence after it. Do not dump config and hope the reader infers the point.

```text
The smallest useful capture happens after the test command fails. Driftcheck does not replace the CI job; it preserves enough of the failed run for the next person to replay it.
```

```yaml
name: CI
on: [pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: pnpm install --frozen-lockfile
      - run: pnpm test
      - if: failure()
        run: driftcheck capture --upload
```

```text
The pull request now has a replay ID tied to the failed job. A reviewer can run `driftcheck replay dc_9f42` and inspect the same failing command without asking the author to reproduce it.
```

Good code examples:

- show the smallest complete mechanism
- keep real complexity out unless the section is about that complexity
- use surrounding prose to say what changed in the reader's workflow

Weak code examples:

- include unrelated setup because it was in the source file
- annotate every line of code
- follow the block with "as you can see"

## Product Claims

Claims should be narrow enough to be believed. Prefer a specific operational improvement over a broad productivity promise.

| Inflated | Better |
| --- | --- |
| `Driftcheck transforms how teams ship software.` | `Driftcheck gives reviewers a replayable failure instead of a log transcript.` |
| `Your CI becomes a collaborative debugging platform.` | `The failed run stays inspectable after the runner exits.` |
| `Teams can finally move at agent speed.` | `Agents and humans can debug against the same captured run.` |

The stronger version can still be ambitious. It earns ambition through a mechanism the reader can evaluate.

## Conclusion

Good conclusions return to the opening pressure and leave the reader with a concrete next action. They do not recap every section or broaden into a manifesto.

```text
Build failures already contain the evidence reviewers need; most teams discard it when the runner exits. Driftcheck keeps that evidence close enough to use.

Start with one flaky suite. Capture its next failure, replay it from another machine, and decide whether the review got smaller.
```

What to copy:

- Returns to the evidence thread from the intro
- Names a first adoption step
- Ends on an action the reader can evaluate

What to avoid:

- "The future is replayable."
- "This is only the beginning."
- "If you're ready to revolutionize your workflow..."
