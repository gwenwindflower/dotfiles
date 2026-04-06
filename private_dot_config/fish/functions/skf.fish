function skf -d "Browse Agent Skills with fzf"
    argparse h/help a/all -- $argv
    or return

    if set -q _flag_help
        echo "Browse and search Agent Skills from the shared skills directory."
        logirl help_usage "skf [OPTIONS] [QUERY]"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag a/all "Include deactivated skills"
        logirl help_header Keybindings
        printf "  enter      View the SKILL.md with bat\n"
        printf "  ctrl-y     Copy skill name to clipboard\n"
        printf "  ctrl-t     Copy skill directory path to clipboard\n"
        logirl help_header Examples
        printf "  skf\n"
        printf "  skf neovim\n"
        printf "  skf --all\n"
        return 0
    end

    if not type -q fzf
        logirl error "fzf not found in PATH"
        logirl info "Install with: brew install fzf"
        return 127
    end

    set -l skills_dir "$HOME/.agents/skills"

    if not test -d "$skills_dir"
        logirl error "Skills directory not found: $skills_dir"
        return 1
    end

    # Collect skill entries as "name\tdescription\tpath"
    set -l entries

    # Build list of SKILL.md files to scan
    set -l skill_files $skills_dir/*/SKILL.md
    if set -q _flag_all
        set -a skill_files $skills_dir/_deactivated/*/SKILL.md
    end

    for skill_file in $skill_files
        set -l skill_dir (path dirname $skill_file)
        set -l dir_name (path basename $skill_dir)
        set -l parent_name (path basename (path dirname $skill_dir))

        # Skip internal dirs (_, but not _deactivated which is handled above)
        if string match -q '_*' $dir_name
            continue
        end

        # Tag deactivated skills
        set -l tag ""
        if test "$parent_name" = _deactivated
            set tag " [off]"
        end

        # Parse YAML frontmatter for name and description
        set -l name ""
        set -l desc ""
        set -l in_frontmatter 0
        set -l desc_multiline 0

        while read -l line
            if test "$line" = ---
                if test $in_frontmatter -eq 0
                    set in_frontmatter 1
                    continue
                else
                    break
                end
            end

            if test $in_frontmatter -eq 0
                continue
            end

            # Handle multiline description continuation
            if test $desc_multiline -eq 1
                # Continuation lines are indented
                if string match -rq '^\s+' $line
                    set -l continuation (string trim -- $line)
                    set desc "$desc $continuation"
                    continue
                else
                    set desc_multiline 0
                end
            end

            if string match -rq '^name:\s*(.+)' $line
                set name (string match -r '^name:\s*(.+)' $line)[2]
            else if string match -rq '^description:\s*[>|]' $line
                # Multiline description (> or |), read continuation lines
                set desc_multiline 1
            else if string match -rq '^description:\s*(.+)' $line
                set desc (string match -r '^description:\s*(.+)' $line)[2]
            end
        end <$skill_file

        # Strip surrounding quotes if present
        set name (string trim -c '"' -- (string trim -c "'" -- $name))
        set desc (string trim -c '"' -- (string trim -c "'" -- $desc))

        if test -n "$name"
            set -a entries "$name$tag\t$desc\t$skill_dir"
        end
    end

    if test (count $entries) -eq 0
        logirl info "No skills found"
        return 0
    end

    # Build initial query from positional args
    set -l query ""
    if test (count $argv) -gt 0
        set query (string join " " $argv)
    end

    # Run fzf with preview and keybindings
    set -l selection (
        printf '%b\n' $entries | \
        sort | \
        fzf \
            --query="$query" \
            --delimiter='\t' \
            --with-nth=1,2 \
            --tabstop=24 \
            --header="enter: view  ctrl-y: copy name  ctrl-t: copy path" \
            --preview='bat --color=always --style=plain {3}/SKILL.md' \
            --preview-window=right:60%:wrap \
            --bind='ctrl-y:execute-silent(echo -n {1} | pbcopy)+abort' \
            --bind='ctrl-t:execute-silent(echo -n {3} | pbcopy)+abort'
    )

    # Enter was pressed — bat the SKILL.md
    if test -n "$selection"
        set -l selected_path (string split \t -- $selection)[3]
        bat --style=plain "$selected_path/SKILL.md"
    end
end
