function frg -d "Launch fzf as a live UX for ripgrep, with or without an initial query"
    set -l rg_cmd "rg --column --line-number --no-heading --color=always --smart-case "
    set -l init_query (string join " " $argv)
    fzf --ansi --disabled --query "$init_query" \
        --bind "start:reload:$rg_cmd {q}" \
        --bind "change:reload:sleep 0.25; $rg_cmd {q} || true" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(vim {1} +{2})'
end
