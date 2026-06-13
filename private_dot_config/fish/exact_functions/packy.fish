function packy -d "Snapshot, diff, check, or upgrade package managers tracked in packages.yaml"
    # Logic lives in .utils/packy.ts — this is just the global entrypoint.
    # See .utils/AGENTS.md for the tool's docs and tests.
    deno run \
        --allow-read \
        --allow-write \
        --allow-env \
        --allow-run=chezmoi,brew,uv \
        (chezmoi source-path)/.utils/packy.ts $argv
end
