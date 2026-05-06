function packy -d "Snapshot, diff, lint, or update package managers tracked in packages.yaml"
    argparse h/help d/dry-run v/verbose 'f/file=' 'm/manager=' -- $argv
    or return

    if set -q _flag_help
        echo "Manage multi-tool package state in chezmoi's packages.yaml."
        logirl help_usage "packy [OPTIONS] [SUBCOMMAND]"
        logirl help_header Subcommands
        logirl help_cmd save "Capture current package state into packages.yaml (current OS section)"
        logirl help_cmd diff "Compare current state against packages.yaml"
        logirl help_cmd lint "Validate linux package lists are a subset of darwin"
        logirl help_cmd update "Run upgrades for each manager, then save the new state"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag d/dry-run "Show what would happen without writing or upgrading"
        logirl help_flag v/verbose "Print full package lists / extra detail"
        logirl help_flag f/file PATH "packages.yaml path (default: chezmoi source)"
        logirl help_flag m/manager NAME "Limit to one manager: homebrew, pnpm, uv"
        logirl help_header Managers
        printf "  homebrew    taps, formulae, casks (casks darwin-only)\n"
        printf "  pnpm        global packages\n"
        printf "  uv          tools (darwin-only)\n"
        logirl help_header Examples
        printf "  packy                       # Save all managers, then lint\n"
        printf "  packy diff                  # Show every change vs packages.yaml\n"
        printf "  packy update                # Upgrade all, snapshot result, lint\n"
        printf "  packy update -m pnpm        # Just upgrade pnpm globals + save\n"
        printf "  packy save -m homebrew      # Equivalent to brewshot save\n"
        printf "  packy diff -m uv -v         # Verbose diff for uv tools only\n"
        logirl help_header Adding a manager
        printf "  Define _packy_<name>_check / _save / _diff / _update (and optional _lint)\n"
        printf "  in this file, then add <name> to the all_managers list below.\n"
        printf "  Each op takes positional args: FILE OS DRY VERBOSE.\n"
        return 0
    end

    # Capture flag presence as plain locals and pass them as explicit args to
    # helpers. NEVER promote `_flag_*` to global scope — fish keeps globals alive
    # for the whole session, so every subsequent function call would inherit them
    # (e.g. `logirl` would see `_flag_help` set and self-print). Same rule for
    # any transient state shared between functions: pass it, don't globalize it.
    set -l dry_run ""
    set -l verbose ""
    if set -q _flag_dry_run
        set dry_run 1
    end
    if set -q _flag_verbose
        set verbose 1
    end

    # yq is the universal dependency
    if not type -q yq
        logirl error "yq not found in PATH"
        logirl info "Install with: brew install yq"
        return 127
    end

    # Determine current OS section
    set -l os_section
    switch (uname)
        case Darwin
            set os_section darwin
        case Linux
            set os_section linux
        case '*'
            logirl error "Unsupported OS: "(uname)
            return 1
    end

    # packages.yaml location
    set -l packages_file ~/.local/share/chezmoi/.chezmoidata/packages.yaml
    if set -q _flag_file
        set packages_file $_flag_file
    end
    if not test -f "$packages_file"
        logirl error "packages.yaml not found at: $packages_file"
        return 1
    end

    # Manager registry — to add a new package manager:
    #   1. Implement _packy_<mgr>_check / _save / _diff / _update (lint optional)
    #   2. Add <mgr> here
    #   3. Update _packy_applicable if it doesn't apply on every OS
    set -l all_managers homebrew pnpm uv

    set -l managers
    if set -q _flag_manager
        if not contains $_flag_manager $all_managers
            logirl error "Unknown manager: $_flag_manager"
            printf "  Supported: %s\n" (string join ", " $all_managers)
            return 2
        end
        set managers $_flag_manager
    else
        set managers $all_managers
    end

    # Subcommand (default: save)
    set -l subcommand save
    if test (count $argv) -ge 1
        set subcommand $argv[1]
    end
    set -l valid_subcommands save diff lint update
    if not contains $subcommand $valid_subcommands
        logirl error "Unknown subcommand: $subcommand"
        printf "  Supported: %s\n" (string join ", " $valid_subcommands)
        printf "Try: packy --help\n"
        return 2
    end

    # ── lint is its own pass: walk every manager that implements *_lint ─────
    if test "$subcommand" = lint
        set -l overall 0
        set -l ran 0
        for m in $managers
            set -l fn _packy_{$m}_lint
            if functions -q $fn
                set ran (math $ran + 1)
                $fn $packages_file
                if test $status -ne 0
                    set overall 1
                end
            end
        end
        if test $ran -eq 0
            logirl info "No lint checks defined for selected manager(s)"
        end
        return $overall
    end

    # ── save / diff / update: dispatch per applicable manager ───────────────
    # Every op helper receives the same positional args: FILE OS DRY VERBOSE.
    # Helpers can ignore args they don't need.
    set -l overall 0
    for m in $managers
        if not _packy_applicable $m $os_section
            if test -n "$verbose"
                logirl info "Skipping $m (no $os_section section)"
            end
            continue
        end

        set -l check_fn _packy_{$m}_check
        if functions -q $check_fn
            if not $check_fn
                logirl warning "Skipping $m (dependency check failed)"
                set overall 1
                continue
            end
        end

        set -l op_fn _packy_{$m}_$subcommand
        if not functions -q $op_fn
            logirl warning "$m does not implement '$subcommand'"
            continue
        end

        echo ""
        logirl special "── $m: $subcommand ──"
        $op_fn $packages_file $os_section $dry_run $verbose
        if test $status -ne 0
            set overall 1
        end
    end

    # After update, snapshot the new state so packages.yaml reflects upgrades
    if test "$subcommand" = update
        echo ""
        logirl special "Snapshotting post-update state..."
        for m in $managers
            if not _packy_applicable $m $os_section
                continue
            end
            set -l save_fn _packy_{$m}_save
            if functions -q $save_fn
                echo ""
                logirl special "── $m: save ──"
                $save_fn $packages_file $os_section $dry_run $verbose
            end
        end
    end

    # Auto-lint after any state-changing op
    if test "$subcommand" = save; or test "$subcommand" = update
        echo ""
        logirl special "Running lint check..."
        for m in $all_managers
            set -l fn _packy_{$m}_lint
            if functions -q $fn
                $fn $packages_file
            end
        end
    end

    return $overall
end

# ── Applicability: does <manager> have a section on <os>? ───────────────────
function _packy_applicable -d "Whether a manager applies to the given OS"
    set -l mgr $argv[1]
    set -l os $argv[2]
    switch $mgr
        case homebrew pnpm
            return 0
        case uv
            test "$os" = darwin
            return $status
    end
    return 1
end

# ── Generic helpers ─────────────────────────────────────────────────────────
function _packy_yq_set_list -d "Replace a yaml list at PATH with given items (file path items...)"
    set -l file $argv[1]
    set -l path $argv[2]
    set -l items $argv[3..-1]
    yq eval "$path = []" -i $file
    for item in $items
        yq eval "$path += [\"$item\"]" -i $file
    end
end

# `_packy_diff_count` and `_packy_diff_print` deliberately don't share state via
# globals — they just both walk the args. Lists are tiny (dozens of items), the
# extra iteration is free, and we avoid leaking state between calls.
function _packy_diff_count -d "Echo the total +/- count for a current/saved pair (current... -- saved...)"
    set -l current
    set -l saved
    set -l section current
    for i in (seq 1 (count $argv))
        if test "$argv[$i]" = --
            set section saved
            continue
        end
        switch $section
            case current
                set -a current $argv[$i]
            case saved
                set -a saved $argv[$i]
        end
    end
    set -l n 0
    for x in $current
        if not contains $x $saved
            set n (math $n + 1)
        end
    end
    for x in $saved
        if not contains $x $current
            set n (math $n + 1)
        end
    end
    echo $n
end

function _packy_diff_print -d "Print +added/-removed for a list (label current... -- saved...)"
    set -l label $argv[1]
    set -l current
    set -l saved
    set -l section current
    for i in (seq 2 (count $argv))
        if test "$argv[$i]" = --
            set section saved
            continue
        end
        switch $section
            case current
                set -a current $argv[$i]
            case saved
                set -a saved $argv[$i]
        end
    end

    set -l added
    set -l removed
    for x in $current
        if not contains $x $saved
            set -a added $x
        end
    end
    for x in $saved
        if not contains $x $current
            set -a removed $x
        end
    end

    if test (count $added) -eq 0; and test (count $removed) -eq 0
        return 0
    end
    printf "%s%s:%s\n" (set_color --bold) $label (set_color normal)
    for x in $added
        printf "  %s+ %s%s\n" (set_color green) $x (set_color normal)
    end
    for x in $removed
        printf "  %s- %s%s\n" (set_color red) $x (set_color normal)
    end
    echo ""
end

function _packy_finalize_write -d "Move temp file into place or report dry-run (temp_file target label dry verbose)"
    set -l temp_file $argv[1]
    set -l target $argv[2]
    set -l label $argv[3]
    set -l dry $argv[4]
    set -l verbose $argv[5]

    if test -n "$verbose"
        echo ""
        bat --plain "$temp_file" 2>/dev/null; or cat "$temp_file"
        echo ""
    end

    if test -n "$dry"
        rip $temp_file 2>/dev/null; or rm $temp_file
        printf "%s󰐪 [DRY RUN]%s %s%s%s — packages.yaml not updated\n" \
            (set_color -o cyan) (set_color normal) (set_color -o brgreen) $label (set_color normal)
        return 0
    end

    mv $temp_file "$target"
    logirl success "Updated $label in $target"
end

# ─── homebrew ────────────────────────────────────────────────────────────────
function _packy_homebrew_check
    if not type -q brew
        logirl error "Homebrew not found in PATH"
        return 127
    end
    return 0
end

# Per-list capture helpers print to stdout — caller pulls into a local with
# command substitution. No globals, no leakage.
function _packy_homebrew_taps
    brew tap 2>/dev/null | sort
end
function _packy_homebrew_formulae
    brew list -1 --installed-on-request 2>/dev/null | sort
end
function _packy_homebrew_casks
    brew list --cask -1 2>/dev/null | sort
end

function _packy_homebrew_save
    set -l file $argv[1]
    set -l os $argv[2]
    set -l dry $argv[3]
    set -l verbose $argv[4]

    set -l taps (_packy_homebrew_taps)
    set -l formulae (_packy_homebrew_formulae)
    set -l casks (_packy_homebrew_casks)
    logirl info "homebrew: "(count $taps)" taps, "(count $formulae)" formulae, "(count $casks)" casks"

    set -l temp_file (mktemp)
    cp "$file" $temp_file
    _packy_yq_set_list $temp_file ".packages.$os.homebrew.taps" $taps
    _packy_yq_set_list $temp_file ".packages.$os.homebrew.formulae" $formulae
    if test "$os" = darwin
        _packy_yq_set_list $temp_file ".packages.$os.homebrew.casks" $casks
    end

    _packy_finalize_write $temp_file "$file" "$os.homebrew" "$dry" "$verbose"
end

function _packy_homebrew_diff
    set -l file $argv[1]
    set -l os $argv[2]

    set -l taps (_packy_homebrew_taps)
    set -l formulae (_packy_homebrew_formulae)
    set -l casks (_packy_homebrew_casks)
    logirl info "homebrew: "(count $taps)" taps, "(count $formulae)" formulae, "(count $casks)" casks"

    set -l saved_taps (yq eval ".packages.$os.homebrew.taps[]" "$file" 2>/dev/null)
    set -l saved_formulae (yq eval ".packages.$os.homebrew.formulae[]" "$file" 2>/dev/null)
    set -l saved_casks
    if test "$os" = darwin
        set saved_casks (yq eval ".packages.$os.homebrew.casks[]" "$file" 2>/dev/null)
    end

    _packy_diff_print Taps $taps -- $saved_taps
    _packy_diff_print Formulae $formulae -- $saved_formulae
    set -l total (math (_packy_diff_count $taps -- $saved_taps) + (_packy_diff_count $formulae -- $saved_formulae))
    if test "$os" = darwin
        _packy_diff_print Casks $casks -- $saved_casks
        set total (math $total + (_packy_diff_count $casks -- $saved_casks))
    end

    if test $total -eq 0
        logirl success "homebrew: no differences"
    else
        logirl info "homebrew: $total change(s)"
    end
end

function _packy_homebrew_update
    set -l dry $argv[3]
    if test -n "$dry"
        logirl info "[DRY RUN] would run: brew update; brew upgrade; brew upgrade --cask; brew autoremove; brew cleanup"
        return 0
    end
    logirl info "brew update..."
    brew update; or return $status
    logirl info "brew upgrade..."
    brew upgrade
    if test (uname) = Darwin
        logirl info "brew upgrade --cask..."
        brew upgrade --cask
    end
    logirl info "brew autoremove..."
    brew autoremove
    logirl info "brew cleanup..."
    brew cleanup
    return 0
end

function _packy_homebrew_lint -d "Validate linux homebrew lists are a subset of darwin"
    set -l file $argv[1]
    set -l darwin_taps (yq eval '.packages.darwin.homebrew.taps[]' "$file" 2>/dev/null)
    set -l darwin_formulae (yq eval '.packages.darwin.homebrew.formulae[]' "$file" 2>/dev/null)
    set -l linux_taps (yq eval '.packages.linux.homebrew.taps[]' "$file" 2>/dev/null)
    set -l linux_formulae (yq eval '.packages.linux.homebrew.formulae[]' "$file" 2>/dev/null)

    set -l missing_taps
    set -l missing_formulae
    for tap in $linux_taps
        if not contains $tap $darwin_taps
            set -a missing_taps $tap
        end
    end
    for f in $linux_formulae
        if not contains $f $darwin_formulae
            set -a missing_formulae $f
        end
    end

    set -l total (math (count $missing_taps) + (count $missing_formulae))
    if test $total -eq 0
        logirl success "homebrew lint passed — "(count $linux_formulae)" linux formulae and "(count $linux_taps)" linux taps all present in darwin"
        return 0
    end

    logirl warning "homebrew: linux packages not found in darwin ($total issue(s))"
    if test (count $missing_taps) -gt 0
        printf "%sTaps on linux but not darwin:%s\n" (set_color --bold) (set_color normal)
        for t in $missing_taps
            printf "  %s! %s%s\n" (set_color yellow) $t (set_color normal)
        end
    end
    if test (count $missing_formulae) -gt 0
        printf "%sFormulae on linux but not darwin:%s\n" (set_color --bold) (set_color normal)
        for f in $missing_formulae
            printf "  %s! %s%s\n" (set_color yellow) $f (set_color normal)
        end
    end
    logirl info "Either reinstall on darwin and re-run save, or remove from linux section"
    return 1
end

# ─── pnpm ────────────────────────────────────────────────────────────────────
function _packy_pnpm_check
    if not type -q pnpm
        logirl error "pnpm not found in PATH"
        return 127
    end
    if not type -q jq
        logirl error "jq not found in PATH (needed to parse pnpm output)"
        return 127
    end
    return 0
end

function _packy_pnpm_globals
    pnpm ls -g --depth=0 --json 2>/dev/null \
        | jq -r '.[0].dependencies // {} | keys[]' 2>/dev/null \
        | sort
end

function _packy_pnpm_save
    set -l file $argv[1]
    set -l os $argv[2]
    set -l dry $argv[3]
    set -l verbose $argv[4]

    set -l globals (_packy_pnpm_globals)
    logirl info "pnpm: "(count $globals)" globals"

    set -l temp_file (mktemp)
    cp "$file" $temp_file
    _packy_yq_set_list $temp_file ".packages.$os.pnpm.globals" $globals

    _packy_finalize_write $temp_file "$file" "$os.pnpm" "$dry" "$verbose"
end

function _packy_pnpm_diff
    set -l file $argv[1]
    set -l os $argv[2]

    set -l globals (_packy_pnpm_globals)
    logirl info "pnpm: "(count $globals)" globals"

    set -l saved (yq eval ".packages.$os.pnpm.globals[]" "$file" 2>/dev/null)
    _packy_diff_print "pnpm globals" $globals -- $saved
    set -l total (_packy_diff_count $globals -- $saved)
    if test $total -eq 0
        logirl success "pnpm: no differences"
    else
        logirl info "pnpm: $total change(s)"
    end
end

function _packy_pnpm_update
    set -l dry $argv[3]
    if test -n "$dry"
        logirl info "[DRY RUN] would run: pnpm update -g"
        return 0
    end
    logirl info "pnpm update -g..."
    pnpm update -g
end

function _packy_pnpm_lint -d "Validate linux pnpm globals are a subset of darwin"
    set -l file $argv[1]
    set -l darwin (yq eval '.packages.darwin.pnpm.globals[]' "$file" 2>/dev/null)
    set -l linux (yq eval '.packages.linux.pnpm.globals[]' "$file" 2>/dev/null)
    set -l missing
    for g in $linux
        if not contains $g $darwin
            set -a missing $g
        end
    end
    if test (count $missing) -eq 0
        logirl success "pnpm lint passed — "(count $linux)" linux globals all present in darwin"
        return 0
    end
    logirl warning "pnpm: linux globals not found in darwin ("(count $missing)" issue(s))"
    for g in $missing
        printf "  %s! %s%s\n" (set_color yellow) $g (set_color normal)
    end
    return 1
end

# ─── uv ──────────────────────────────────────────────────────────────────────
function _packy_uv_check
    if not type -q uv
        logirl error "uv not found in PATH"
        return 127
    end
    return 0
end

function _packy_uv_tools
    # `uv tool list` formats tool lines starting with the name and bin lines starting with "- "
    uv tool list 2>/dev/null \
        | string match -er '^[a-zA-Z0-9]' \
        | string replace -r ' .*' '' \
        | sort -u
end

function _packy_uv_save
    set -l file $argv[1]
    set -l os $argv[2]
    set -l dry $argv[3]
    set -l verbose $argv[4]

    set -l tools (_packy_uv_tools)
    logirl info "uv: "(count $tools)" tools"

    set -l temp_file (mktemp)
    cp "$file" $temp_file
    _packy_yq_set_list $temp_file ".packages.$os.uv.tools" $tools

    _packy_finalize_write $temp_file "$file" "$os.uv" "$dry" "$verbose"
end

function _packy_uv_diff
    set -l file $argv[1]
    set -l os $argv[2]

    set -l tools (_packy_uv_tools)
    logirl info "uv: "(count $tools)" tools"

    set -l saved (yq eval ".packages.$os.uv.tools[]" "$file" 2>/dev/null)
    _packy_diff_print "uv tools" $tools -- $saved
    set -l total (_packy_diff_count $tools -- $saved)
    if test $total -eq 0
        logirl success "uv: no differences"
    else
        logirl info "uv: $total change(s)"
    end
end

function _packy_uv_update
    set -l dry $argv[3]
    if test -n "$dry"
        logirl info "[DRY RUN] would run: uv tool upgrade --all"
        return 0
    end
    logirl info "uv tool upgrade --all..."
    uv tool upgrade --all
end
