function spritecan -d "Create, bootstrap, and console into a Fly.io Sprite"
    argparse h/help -- $argv
    or return

    if set -q _flag_help
        echo "Create a fresh Fly.io Sprite, run the dotfiles bootstrap, then open the console."
        logirl help_usage "spritecan <name>"
        logirl help_header Arguments
        printf "  %s%s%s  Sprite name — letters, digits, _, - only. Under 25 chars.\n" \
            (set_color --italics blue) "<name>" (set_color normal)
        logirl help_header Examples
        printf "  spritecan bob\n"
        printf "  spritecan bob-job\n"
        printf "  spritecan bob__job1-cool\n"
        return 0
    end

    if not type -q sprite
        logirl error "sprite CLI not found in PATH"
        logirl info "See https://docs.sprites.dev for install instructions"
        return 127
    end

    if test (count $argv) -ne 1
        logirl error "spritecan takes exactly one argument (sprite name)"
        printf "Try: spritecan --help\n"
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

    set -l bootstrap_url 'https://raw.githubusercontent.com/gwenwindflower/dotfiles/main/.utils/sprite-bootstrap.ts'

    logirl special "Creating Sprite '$name'"
    sprite create $name --skip-console
    or return 1

    logirl special "Bootstrapping dotfiles"
    sprite exec -s $name -- sh -c "deno run -A $bootstrap_url"
    or return 1

    logirl success "Sprite '$name' ready — opening console"
    sprite console -s $name
end
