function skillet -d "Curate the dotfiles skill library: diff upstream skills against distilled baselines, save deployed edits"
    # Logic lives in .utils/skillet.ts — this is just the global entrypoint.
    # See .utils/docs/skillet.md for the tool's docs and tests.
    deno run \
        --allow-read \
        --allow-write \
        --allow-env \
        --allow-run=gh,git \
        (chezmoi source-path)/.utils/skillet.ts $argv
end
