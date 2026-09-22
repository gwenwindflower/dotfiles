function skillsave -d "Copy a deployed skill from ~/.agents/skills back into the dotfiles skills/ source tree"
    argparse h/help n/dry-run -- $argv
    or return 2

    if set -q _flag_help; or test (count $argv) -eq 0
        printf "Copy one or more deployed skills back into the dotfiles skills/ source tree,\n"
        printf "stripping the metadata block gh skill injects into SKILL.md frontmatter.\n\n"
        printf "Usage: skillsave [OPTIONS] <skill>...\n\n"
        printf "Options:\n"
        printf "  -n, --dry-run  Show what rsync would change without writing\n"
        printf "  -h, --help     Show this help\n"
        set -q _flag_help; and return 0
        return 2
    end

    set -l source_root (command chezmoi source-path)
    if test $status -ne 0; or test -z "$source_root"
        printf "skillsave: could not resolve the chezmoi source directory\n" >&2
        return 1
    end

    set -l deployed_root ~/.agents/skills
    set -l rsync_flags -rlt --delete --exclude .DS_Store
    set -q _flag_dry_run; and set -a rsync_flags -n -v

    set -l failed 0
    for name in $argv
        set -l deployed $deployed_root/$name
        set -l saved $source_root/skills/$name
        if not test -f $deployed/SKILL.md
            printf "skillsave: %s is not a deployed skill (no %s/SKILL.md)\n" $name $deployed >&2
            set failed 1
            continue
        end

        mkdir -p $saved
        command rsync $rsync_flags $deployed/ $saved/
        or begin
            printf "skillsave: rsync failed for %s\n" $name >&2
            set failed 1
            continue
        end
        set -q _flag_dry_run; and continue

        set -l stripped (mktemp)
        command awk '
            NR == 1 && $0 == "---" { in_frontmatter = 1; print; next }
            in_frontmatter && $0 == "---" { in_frontmatter = 0; print; next }
            in_frontmatter && /^metadata:/ { skipping = 1; next }
            in_frontmatter && skipping && /^[ \t]/ { next }
            { skipping = 0; print }
        ' $saved/SKILL.md >$stripped
        and command mv $stripped $saved/SKILL.md
        or begin
            printf "skillsave: could not strip gh metadata from %s/SKILL.md\n" $name >&2
            set failed 1
            continue
        end

        printf "skillsave: saved %s to %s\n" $name (string replace $source_root/ '' $saved)
    end

    return $failed
end
