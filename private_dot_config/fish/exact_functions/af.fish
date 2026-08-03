function af -d "Search Fish commands and amoxide aliases with fzf"
    if test (count $argv) -gt 1
        printf 'Usage: af [search_term]\n' >&2
        return 2
    end

    if not type -q fzf
        printf 'af: fzf not found in PATH\n' >&2
        return 127
    end

    set -l results
    set -l amoxide_active_names

    if type -q am
        set -lx NO_COLOR 1
        set -l amoxide_scope
        set -l amoxide_state

        for line in (am ls)
            if string match -q '*→*' -- $line
                set -l alias_line (string replace -r '^[│[:space:]├╰─]*' '' -- $line)
                set -l alias_fields (string split -m 1 ' → ' -- $alias_line)

                if test (count $alias_fields) -eq 2; and test -n "$amoxide_scope"
                    set -l name (string trim -- $alias_fields[1])
                    set -l command (string trim -- $alias_fields[2])
                    set -a results (string join \t -- amoxide $name $amoxide_scope $amoxide_state $command)

                    if test "$amoxide_state" = active
                        set -a amoxide_active_names $name
                    end
                end
                continue
            end

            if string match -rq 'global$' -- $line
                set amoxide_scope global
                set amoxide_state active
            else if string match -rq '● .+ \(active: [0-9]+\)$' -- $line
                set -l profile (string replace -r '^.*● (.+) \(active: [0-9]+\)$' '$1' -- $line)
                set amoxide_scope "profile:$profile"
                set amoxide_state active
            else if string match -rq '○ .+$' -- $line
                set -l profile (string replace -r '^.*○ (.+)$' '$1' -- $line)
                set amoxide_scope "profile:$profile"
                set amoxide_state inactive
            else if string match -rq 'project \(.+\)$' -- $line
                set -l project (string replace -r '^.*project \((.+)\)$' '$1' -- $line)
                set amoxide_scope "project:$project"
                set amoxide_state active
            end
        end
    end

    for line in (abbr --show --color never)
        echo $line | read --tokenize -a tokens
        set -l separator_index (contains -i -- -- $tokens)
        test -n "$separator_index"; or continue

        set -l name $tokens[(math $separator_index + 1)]
        contains -- $name $amoxide_active_names; and continue
        set -a results (string join \t -- abbr $name fish "" $line)
    end

    set -l fish_alias_names
    for line in (alias)
        echo $line | read --tokenize -a tokens
        test (count $tokens) -ge 3; or continue

        set -l name $tokens[2]
        set -a fish_alias_names $name
        set -a results (string join \t -- alias $name fish "" $line)
    end

    for name in (functions --all | string match -v '_*')
        contains -- $name $fish_alias_names; and continue

        set -l details (functions --details --verbose $name)
        set -l source $details[1]
        set -l origin

        switch $source
            case 'embedded:*'
                set origin fish
            case -
                set origin session
            case "$HOME/.config/fish/*"
                set origin user
            case '*'
                set origin (string replace "$HOME" '~' -- $source)
        end

        set -l description ""
        if test (count $details) -ge 5
            set description $details[5]
        end

        set -a results (string join \t -- function $name $origin "" $description)
    end

    set -l preview '
set fields (string split \t -- {})
set kind $fields[1]
set name $fields[2]
printf "%s: %s\n" (string upper -- $kind) $name
test -n "$fields[3]"; and printf "scope: %s\n" $fields[3]
test -n "$fields[4]"; and printf "state: %s\n" $fields[4]
echo
if contains -- $kind function alias
    functions $name
else
    printf "%s\n" $fields[5]
end
'
    set -l delimiter (printf '\t')
    set -l fzf_args \
        "--delimiter=$delimiter" \
        --with-nth=1..5 \
        --header='type  name  scope  state  content' \
        --preview="$preview" \
        --preview-window=right,60%,wrap

    if test (count $argv) -eq 1
        set -a fzf_args --query="$argv[1]"
    end

    printf '%s\n' $results | fzf $fzf_args
end
