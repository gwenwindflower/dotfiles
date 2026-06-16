#### Sandbox Failures

Inside a sandbox, blocked paths, hosts, env vars, caches, logs, and lockfiles are configuration signals. Surface the block; do not route around it.

Do not:

- Invent one-off flags/env vars such as `--cache-dir`, `--log-file`, `TMPDIR`, `HOME`, or `XDG_CACHE_HOME` just to pass.
- Move global stores, caches, or state directories.
- Disable logging, telemetry, checksums, signatures, or safety features.
- Retry the same blocked operation hoping it slips through.
- Switch to offline mode, alternate registries, vendored mirrors, or cache rebuilds to dodge network blocks.

Instead, identify the exact blocked path/host/env var and the tool that needed it. Offer the user two options: update the sandbox allowlist, or run the exact command outside the sandbox and share results.

First-class project-local knobs can be legitimate, such as checked-in tool config or conventional per-project cache dirs. Use them only with explicit buy-in.

Package managers are high stakes. Always stop before changing global package-manager settings, rebuilding global stores, relocating caches, or bypassing checksum/signature verification.
