# Searching Docs

If a user asks a question about syntax, package versions, some detail of a library, whether xyz is the right way to do something in a framework - anything where your training data is likely to be out of date - always, always check the docs. If the question is about idiomatic Go code, by all means, rely on your knowledge - but if the question is "this method seems to be breaking, is the right syntax in current NextJS?", then don't just fire off an answer based on your training data.

## Searching and Fetching

Use your web tools first. All agents have tools for Search (getting a list of results based on a query, often called the WebSearch tool or similar, or facilitated by an external tool like Exa or Tavily) and Fetch (getting the contents of single page - generally in markdown format which falls back to HTML if the site does not have AI-friendly markdown - often called the WebFetch tool or similar). Fetching is your friend for docs! Search is great to help you locate the docs, or if you need to find a good tutorial, or Q&A thread, etc. - but always prioritize the actual docs first.

## Using the Context7 CLI

To quickly execute semantic search across documentation context covering most major tools, you can use the ctx7 CLI. It is continually updated, re-chunked, and re-embedded. If the question relates to a popular tool, framework, or library, this should be your first stop.

**IMPORTANT**: Context7 also manages Agent Skills — DO NOT use it for this. We have our own tools for that (`skillutil`). It will install them in an inaccessible location that is incompatible with our tools. Only use Context7 for searching documentation.

## Basic Commands

```text
library [options] <name> [query]    Resolve a library name to a Context7 id (SvelteKit, shadcn/ui, etc.)
docs [options] <libraryId> <query>  Query the documentation for a specific library
whoami                              Show current login status
```

If the OAuth token is not available and whoami is not showing logged in, alert user to fix it.

## Examples

```bash
bunx ctx7 library react "how to use hooks"
bunx ctx7 docs /facebook/react "useEffect examples"
```
