function et -d "Create, bootstrap, clone, and shell into an exe.dev VM"
    argparse h/help c/cpu= m/memory= -- $argv
    or return

    if set -q _flag_help
        echo "Create a fresh exe.dev VM, run chezmoi, optionally clone a repo, then open a shell."
        logirl help_usage "et [OPTIONS] <name> [owner/repo]"
        logirl help_header Arguments
        printf "  %s%s%s          VM name — letters, digits, _, - only. Under 25 chars.\n" \
            (set_color --italics blue) "<name>" (set_color normal)
        printf "  %s%s%s    GitHub repo to clone into ~/ on the VM. Private repos work\n" \
            (set_color --italics blue) "[owner/repo]" (set_color normal)
        printf "                   via an auto-created exe.dev GitHub integration.\n"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag c/cpu=N "CPUs to allocate (exe default: 2)"
        logirl help_flag m/memory=N "Memory in GB (exe default: 8)"
        logirl help_header Examples
        printf "  et cool-project\n"
        printf "  et winnie-site gwenwindflower/winnie.sh\n"
        printf "  et beefy --cpu 4 --memory 16 gwenwindflower/dotfiles\n"
        return 0
    end

    if not type -q ssh
        logirl error "ssh not found in PATH"
        return 127
    end

    set -l argc (count $argv)
    if test $argc -lt 1 -o $argc -gt 2
        logirl error "et takes 1 or 2 arguments (name, optional owner/repo)"
        printf "Try: et --help\n"
        return 2
    end

    set -l name $argv[1]
    set -l name_length (string length -- $name)
    if test $name_length -ge 25
        logirl error "name must be under 25 characters (got $name_length)"
        return 1
    end
    if not string match -rq '^[A-Za-z0-9_-]+$' -- $name
        logirl error "name may contain only letters, digits, underscores, and hyphens"
        return 1
    end

    set -l repo ""
    set -l owner ""
    set -l repo_basename ""
    set -l slug ""
    if test $argc -eq 2
        set repo $argv[2]
        if not string match -rq '^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$' -- $repo
            logirl error "repo must be in owner/repo form"
            return 1
        end
        set -l parts (string split -- / $repo)
        set owner $parts[1]
        set repo_basename $parts[2]
        # Integration slug: repo basename, lowercased, with . and _ → -
        # So gwenwindflower/winnie.sh → integration name "winnie-sh".
        set slug (string lower -- $repo_basename | string replace -ra '[._]' -)
    end

    # ── Ensure GitHub integration exists for the repo ──────────────────────
    if test -n "$repo"
        if not type -q jq
            logirl error "jq not found in PATH (needed to look up exe.dev integrations)"
            return 127
        end

        logirl special "Checking exe.dev integration for $repo"
        set -l int_json (ssh exe.dev integrations list --json)
        or begin
            logirl error "failed to list exe.dev integrations"
            return 1
        end

        set -l existing (printf '%s' $int_json | jq -r --arg n $slug '.[] | select(.name == $n) | .name')
        if test -z "$existing"
            logirl info "  no integration named '$slug' — creating one"
            ssh exe.dev integrations add github --name=$slug --repository=$repo
            or begin
                logirl error "failed to create integration '$slug'"
                return 1
            end
        else
            logirl info "  using existing integration '$slug'"
        end
    end

    # ── Build first-boot setup script (piped via stdin to dodge quoting) ───
    # CHEZMOI_ONESHOT=1 is required so the post-apply script materializes
    # symsource_* symlinks into real files before chezmoi purges the source.
    # See AGENTS.md → "--one-shot and ephemeral installs".
    set -l setup_lines \
        '#!/usr/bin/env sh' \
        'set -e' \
        'export CHEZMOI_ONESHOT=1' \
        'sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot gwenwindflower'
    if test -n "$repo"
        set -a setup_lines "git clone https://$slug.int.exe.xyz/$owner/$repo_basename.git ~/$repo_basename"
    end
    set -a setup_lines 'touch ~/.et-bootstrap-done'
    set -l setup_script (string join \n $setup_lines)

    set -l new_args --name=$name --setup-script=/dev/stdin
    if set -q _flag_cpu
        set -a new_args --cpu=$_flag_cpu
    end
    if set -q _flag_memory
        set -a new_args --memory=$_flag_memory
    end
    if test -n "$repo"
        set -a new_args --integration=$slug
    end

    logirl special "Creating exe VM '$name'"
    if test -n "$repo"
        logirl info "  with repo: $repo"
    end
    printf '%s\n' $setup_script | ssh exe.dev new $new_args
    or return 1

    set -l vm_host $name.exe.xyz
    printf 'Host %s %s\n  HostName %s\n\n' $name $vm_host $vm_host >>~/.ssh/exe-hosts

    # `--setup-script` may run async; poll for the sentinel before opening an
    # interactive shell so we don't land in a half-bootstrapped VM. ~2min cap.
    logirl special "Waiting for bootstrap to finish"
    set -l done 0
    # ignore _ iterator var
    # @fish-lsp-disable-next-line
    for _ in (seq 1 60)
        if ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=accept-new $vm_host 'test -f ~/.et-bootstrap-done' 2>/dev/null
            set done 1
            break
        end
        sleep 2
    end
    if test $done -eq 0
        logirl warning "bootstrap sentinel not found after ~2min — VM may still be setting up"
    end

    logirl success "exe VM '$name' ready — opening shell"
    ssh -A $vm_host
end
