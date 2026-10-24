function uvpyc -d "Check uv-managed Python minor versions for patch upgrades and cleanup"
    argparse --exclusive only-upgrade,only-clean h/help only-upgrade only-clean fix -- $argv
    or return

    if set -q _flag_help
        echo "Check uv-managed CPython installs against uv's latest available GA patches."
        logirl help_usage 'uvpyc [OPTIONS]'
        logirl help_header Options
        logirl help_flag only-upgrade 'Check for missing latest patches only'
        logirl help_flag only-clean 'Check for older patches behind an installed latest only'
        logirl help_flag fix 'Install upgrades, then uninstall superseded patches'
        logirl help_flag h/help 'Show this help message'
        echo 'Only installed Python 3 minor lanes are checked; prereleases are never removed.'
        echo 'Build variants and architectures are checked separately. Latest follows uv’s download catalog.'
        echo 'Cleanup removes interpreters even if a virtual environment still refers to them.'
        return 0
    end

    if test (count $argv) -ne 0
        logirl error 'uvpyc takes no positional arguments; see uvpyc --help' >&2
        return 2
    end
    for dependency in uv jq
        if not type -q $dependency
            logirl error "$dependency is required for uvpyc" >&2
            return 127
        end
    end

    set -l findings 0
    for phase in upgrade clean
        if test $phase = upgrade; and set -q _flag_only_clean
            continue
        end
        if test $phase = clean; and set -q _flag_only_upgrade
            continue
        end

        set -l catalog (uv python list --managed-python --all-versions --output-format json)
        if test $status -ne 0
            logirl error 'Could not list uv-managed Python installations' >&2
            return 1
        end

        set -l actions (printf '%s\n' $catalog | jq -r --arg phase $phase '
            def stable: .version | test("^3[.][0-9]+[.][0-9]+$");
            map(select(.implementation == "cpython" and .version_parts.major == 3))
            | group_by([.version_parts.major, .version_parts.minor, .variant, .os, .arch, .libc])[]
            | . as $lane
            | map(select(.path != null)) | unique_by(.key) | select(length > 0) as $installed
            | ($lane | map(select(stable)) | max_by(.version_parts.patch)) as $latest
            | select($latest != null)
            | ($latest.version_parts | "\(.major).\(.minor)") as $minor
            | if $phase == "upgrade" then
                select(all($installed[]; .key != $latest.key))
                | [$latest.key, $minor, $latest.version] | @tsv
              else
                select(any($installed[]; .key == $latest.key))
                | $installed[] | select(stable and .version_parts.patch < $latest.version_parts.patch)
                | [.key, $minor, .version] | @tsv
              end')
        if test $status -ne 0
            logirl error 'Could not parse the uv Python catalog' >&2
            return 1
        end

        for action in $actions
            set -l fields (string split \t -- $action)
            set -l target $fields[1]
            set findings (math $findings + 1)
            if test $phase = upgrade
                logirl warning "Upgrade Python $fields[2] to $fields[3] ($target)"
                if set -q _flag_fix
                    uv python install --upgrade $target
                    or return 1
                end
            else
                logirl warning "Clean Python $fields[3] ($target)"
                if set -q _flag_fix
                    uv python uninstall $target
                    or return 1
                end
            end
        end
    end

    if test $findings -eq 0
        logirl success 'No Python patch upgrades or cleanup needed for the selected checks'
    end
    return 0
end
