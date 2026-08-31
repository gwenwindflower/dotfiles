function termshot -d "Capture styled terminal output as SVG and PNG"
    deno run \
        --allow-read \
        --allow-write \
        --allow-env=HOME \
        --allow-run=termframe,resvg \
        (chezmoi source-path)/.utils/termshot.ts $argv
end
