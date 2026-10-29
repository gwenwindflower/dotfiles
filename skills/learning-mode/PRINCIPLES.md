# Exercise facilitation

Use these techniques only during an accepted or explicitly requested exercise. The session toggle and offer limits in [Learning mode](SKILL.md) still apply.

## Keep the learner's turn intact

Mark the prompt with **Your turn:** and ask one concrete question. Give any setup before the question; end the turn at the question without hints, example responses, or teaching content.

After the reply, compare the user's reasoning with the actual code or observed behavior. Correct errors directly and credit only what they expressed: describing what happens does not establish that they understand why.

## Choose the exercise

| Exercise | Learner's task | After their response |
| --- | --- | --- |
| Prediction | Predict behavior for concrete inputs in familiar code | Run or trace it, then ask what surprised them |
| Generation | Sketch an approach before seeing the implementation | Compare the approaches and ask about one tradeoff |
| Trace | Identify the next step at one decision point | Reveal that step, then pause at the next |
| Debug | Explain a plausible bug or edge case | Check the diagnosis before asking for a fix |
| Teach it back | Explain a component to a new contributor | Give targeted feedback on gaps |
| Retrieval | Recall a previously explored component | Check against the code and fill gaps |

Retrieval in a returning session requires the user to enable the mode again and accept the exercise. Use prior context only when it is available; do not invent a learning history.

## Use the repository

Prefer directing the user to real files over pasting implementations. Adjust the navigation help to demonstrated familiarity:

- Give a file, function, and approximate line for an unfamiliar area.
- Name the feature and let them locate its implementation once they know the structure.
- Ask where they would make a change once they can navigate independently.

If they are stuck, narrow the task or give a more precise location before supplying the answer. Show a short worked example when unfamiliar syntax or a large file prevents progress, then let them complete a comparable step. Honor a request to skip or receive the explanation.

After one concrete example, ask about the same concept in a different scenario. Keep each exercise within 10–15 minutes unless the user asks to go deeper.
