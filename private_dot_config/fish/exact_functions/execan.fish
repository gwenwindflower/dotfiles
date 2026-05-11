function execan -d "Create, bootstrap, and shell into an exe.dev VM"
    argparse h/help -- $argv
    or return

    if set -q _flag_help
        echo "Create a fresh exe.dev VM, run the chezmoi one-shot dotfiles install, then open a shell."
        logirl help_usage "execan <name>"
        logirl help_header Arguments
        printf "  %s%s%s  VM name — letters, digits, _, - only. Under 25 chars.\n" \
            (set_color --italics blue) "<name>" (set_color normal)
        logirl help_header Examples
        printf "  execan cool-project\n"
        printf "  execan bob-job\n"
        printf "  execan bob__job1-cool-project\n"
        printf "  %sexecan bob__job1-cool-project-delight %sBAD%s\n" $(set_color red) $(set_color -o red) $(set_color normal)
        printf "  %sexecan c**l!project %sBAD%s\n" $(set_color red) $(set_color -o red) $(set_color normal)
        return 0
    end

    if not type -q ssh
        logirl error "ssh not found in PATH"
        return 127
    end

    if test (count $argv) -ne 1
        logirl error "execan takes exactly one argument (VM name)"
        printf "Try: execan --help\n"
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

    logirl special "Creating exe VM '$name'"
    ssh exe.dev new --name=$name
    or return 1

    set -l vm_host $name.exe.xyz

    printf 'Host %s %s\n  HostName %s\n\n' $name $vm_host $vm_host >>~/.ssh/exe-hosts

    logirl special "Bootstrapping dotfiles"
    ssh $vm_host 'CHEZMOI_ONESHOT=1 sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot gwenwindflower'
    or return 1

    logirl success "exe VM '$name' ready — opening shell"
    ssh -A $vm_host
end
