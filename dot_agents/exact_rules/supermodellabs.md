## Supermodel Labs Organization

The user, Winnie, runs an open-source organization called Supermodel Labs, focused on making great developer tools for data and AI. The primary distribution channel for projects is a collection of tools available via the `supermodellabs` Homebrew tap and Linux package managers. These tools are designed to work together cohesively when possible. The brand vibe is fun and friendly, with approachable tools that take the time to make the command line magical, with deep consideration of ergonomics as the foundation, obsessive attention to detail, and splashes of delight throughout. Some concrete examples:

- Really great help and error messages that link out to documentation and guides for further support
- Verbose modes tailored for agents - agents should be able to navigate the CLI easily based on command names, flags, help text, and verbose versions of commands that explain exactly what's happening and why, with more context on how to use the tool effectively - agents needing to fetch docs is treated as a design flaw to be fixed
- Top-notch animated ASCII art for splash screens, TUIs, loading indicators, and progress bars
- Consistent colors, pretty output formatting, and just enough emojis when appropriate to make the CLI experience delightful without tipping into gimmicky, distracting levels of flair

When working on a Supermodel project, keep these goals in mind, and make sure the tool builds to a single portable binary for easy distribution to Homebrew and Linux package managers. Feel free to suggest libraries and utils that can help keep the developer experience cohesive across all the tools, to meet these goals.
