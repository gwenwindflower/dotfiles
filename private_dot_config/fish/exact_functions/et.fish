function et -d "Create, bootstrap, clone, and shell into an exe.dev VM"
    argparse h/help c/cpu= m/memory= p/profile= -- $argv
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
        logirl help_flag p/profile=PROFILE "chezmoi machine profile: personal or work (default: work)"
        logirl help_header Examples
        printf "  et cool-project\n"
        printf "  et winnie-site gwenwindflower/winnie.sh\n"
        printf "  et side-project --profile personal gwenwindflower/dotfiles\n"
        return 0
    end

    if not type -q ssh
        logirl error "ssh not found in PATH"
        return 127
    end

    set -l machine_profile (_et_resolve_machine_profile $_flag_profile)
    or return

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
    set -l slug ""
    if test $argc -eq 2
        set repo $argv[2]
        if not string match -rq '^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$' -- $repo
            logirl error "repo must be in owner/repo form"
            return 1
        end
        set -l parts (string split -- / $repo)
        set slug (string lower -- $parts[2] | string replace -ra '[._]' -)
    end

    if test -n "$repo"
        _et_ensure_repository_integration $repo $slug
        or return
    end

    set -l new_args --name=$name
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
    ssh exe.dev new $new_args
    or return 1

    set -l vm_host $name.exe.xyz
    printf 'Host %s %s\n  HostName %s\n\n' $name $vm_host $vm_host >>~/.ssh/exe-hosts

    _et_wait_for_vm $vm_host
    or return

    if test -n "$repo"
        _et_test_repository_access $vm_host $repo
        or return
    end

    _et_bootstrap_chezmoi $vm_host $machine_profile
    or return

    if test -n "$repo"
        _et_clone_repository $vm_host $repo
        or return
    end

    logirl success "exe VM '$name' ready — opening shell"
    ssh -A $vm_host
end

function _et_resolve_machine_profile -d "Resolve and validate the chezmoi machine profile" --argument-names requested_profile
    set -l machine_profile work
    if test -n "$requested_profile"
        set machine_profile $requested_profile
    end

    if not contains -- $machine_profile personal work
        logirl error "profile must be personal or work (got '$machine_profile')"
        return 2
    end

    printf "%s\n" $machine_profile
end

function _et_ensure_repository_integration -d "Ensure an exe.dev GitHub integration targets a repository" --argument-names repo integration_name
    if not type -q jq
        logirl error "jq not found in PATH (needed to look up exe.dev integrations)"
        return 127
    end

    logirl special "Checking exe.dev integration for $repo"
    set -l integrations_json (ssh exe.dev integrations list --json)
    set -l list_status $status
    if test $list_status -ne 0
        logirl error "failed to list exe.dev integrations"
        return $list_status
    end

    set -l integration_state (
        printf '%s' $integrations_json |
            jq -r --arg name $integration_name --arg repo $repo '
                [.[] | select(.name == $name)][0] as $integration
                | if $integration == null then
                    "missing"
                  elif $integration.type == "github"
                    and any($integration.config.repositories[]?; . == $repo) then
                    "matching"
                  else
                    "conflicting"
                  end
            '
    )
    set -l query_status $pipestatus[2]
    if test $query_status -ne 0
        logirl error "failed to read exe.dev integration metadata"
        return $query_status
    end

    switch $integration_state
        case matching
            logirl info "  using existing integration '$integration_name'"
        case missing
            logirl info "  no integration named '$integration_name' — creating one"
            ssh exe.dev integrations add github --name=$integration_name --repository=$repo
            or begin
                logirl error "failed to create integration '$integration_name'"
                return 1
            end
        case conflicting
            logirl error "integration '$integration_name' does not target $repo"
            return 1
        case '*'
            logirl error "unexpected integration state for '$integration_name': $integration_state"
            return 1
    end
end

function _et_test_repository_access -d "Test repository access from an exe.dev VM" --argument-names vm_host repo
    logirl special "Testing repository access for $repo"
    ssh $vm_host "git ls-remote https://github.int.exe.xyz/$repo.git HEAD" >/dev/null
    or begin
        logirl error "cannot access $repo from $vm_host"
        return 1
    end
end

function _et_bootstrap_chezmoi -d "Bootstrap chezmoi on an exe.dev VM" --argument-names vm_host machine_profile
    # One-shot installs must materialize source-backed symlinks before chezmoi purges its source directory.
    logirl special "Bootstrapping chezmoi on $vm_host"
    set -l bootstrap_command 'export CHEZMOI_ONESHOT=1; sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot --promptChoice "Machine profile=PROFILE" gwenwindflower'
    set bootstrap_command (string replace PROFILE $machine_profile -- $bootstrap_command)
    ssh $vm_host $bootstrap_command
    or begin
        logirl error "chezmoi bootstrap failed on $vm_host"
        return 1
    end
end

function _et_clone_repository -d "Clone a GitHub repository onto an exe.dev VM" --argument-names vm_host repo
    logirl special "Cloning $repo"
    ssh $vm_host "git clone https://github.int.exe.xyz/$repo.git"
    or begin
        logirl error "failed to clone $repo on $vm_host"
        return 1
    end
end

function _et_wait_for_vm -d "Wait for a new exe.dev VM to accept SSH connections" --argument-names vm_host
    logirl special "Waiting for $vm_host"
    for attempt in (seq 1 60)
        if ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=accept-new $vm_host true 2>/dev/null
            return 0
        end
        sleep 2
    end

    logirl error "$vm_host did not accept SSH connections after ~2min"
    return 1
end
