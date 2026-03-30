function brewshot -d "Snapshot, diff, or lint Homebrew packages in chezmoi"
    # Parse arguments
    argparse h/help d/dry-run v/verbose 'f/file=' -- $argv
    or return

    # Handle --help
    if set -q _flag_help
        echo "Manage Homebrew package state in chezmoi's packages.yaml."
        logirl help_usage "brewshot [OPTIONS] [SUBCOMMAND]"
        logirl help_header Subcommands
        logirl help_cmd save "Capture current Homebrew state into packages.yaml darwin section"
        logirl help_cmd diff "Compare current state against packages.yaml darwin section"
        logirl help_cmd lint "Validate linux packages are a subset of darwin packages"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag d/dry-run "Show what would be written without writing"
        logirl help_flag v/verbose "Print full package lists"
        logirl help_flag f/file PATH "packages.yaml path (default: chezmoi source)"
        logirl help_header Examples
        printf "  brewshot                   # Save darwin state, then lint\n"
        printf "  brewshot diff              # Show what changed since last save\n"
        printf "  brewshot lint              # Check linux is subset of darwin\n"
        printf "  brewshot -d -v             # Dry-run verbose save\n"
        return 0
    end

    # Check dependencies
    if not type -q brew
        logirl error "Homebrew not found in PATH"
        return 127
    end

    if not type -q yq
        logirl error "yq not found in PATH"
        logirl info "Install with: brew install yq"
        return 127
    end

    # Determine subcommand (default: save)
    set -l subcommand save
    if test (count $argv) -ge 1
        set subcommand $argv[1]
    end

    set -l valid_subcommands save diff lint
    if not contains $subcommand $valid_subcommands
        logirl error "Unknown subcommand: $subcommand"
        printf "  Supported: %s\n" (string join ", " $valid_subcommands)
        printf "Try: brewshot --help\n"
        return 2
    end

    # Packages file path
    set -l packages_file ~/.local/share/chezmoi/.chezmoidata/packages.yaml
    if set -q _flag_file
        set packages_file $_flag_file
    end

    if not test -f "$packages_file"
        logirl error "packages.yaml not found at: $packages_file"
        return 1
    end

    # --- LINT subcommand ---
    if test "$subcommand" = lint
        _brewshot_lint $packages_file
        return $status
    end

    # Capture current Homebrew state (shared by save and diff)
    logirl info "Capturing Homebrew state..."
    set -l cur_taps (brew tap 2>/dev/null | sort)
    set -l cur_formulae (brew list -1 --installed-on-request 2>/dev/null | sort)
    set -l cur_casks (brew list --cask -1 2>/dev/null | sort)

    logirl info "Current: "(count $cur_taps)" taps, "(count $cur_formulae)" formulae, "(count $cur_casks)" casks"

    # --- DIFF subcommand ---
    if test "$subcommand" = diff
        _brewshot_diff $packages_file $cur_taps -- $cur_formulae -- $cur_casks
        return $status
    end

    # --- SAVE subcommand ---
    _brewshot_save $packages_file $cur_taps -- $cur_formulae -- $cur_casks
    set -l save_status $status

    if test $save_status -ne 0
        return $save_status
    end

    # Auto-lint after save
    echo ""
    logirl special "Running lint check..."
    _brewshot_lint $packages_file
    return $status
end

# --- Helper: lint ---
function _brewshot_lint -d "Validate linux packages are a subset of darwin"
    set -l packages_file $argv[1]

    # Load darwin lists
    set -l darwin_taps (yq eval '.packages.darwin.homebrew.taps[]' "$packages_file" 2>/dev/null)
    set -l darwin_formulae (yq eval '.packages.darwin.homebrew.formulae[]' "$packages_file" 2>/dev/null)

    # Load linux lists
    set -l linux_taps (yq eval '.packages.linux.homebrew.taps[]' "$packages_file" 2>/dev/null)
    set -l linux_formulae (yq eval '.packages.linux.homebrew.formulae[]' "$packages_file" 2>/dev/null)

    set -l missing_taps
    set -l missing_formulae

    # Check taps
    for tap in $linux_taps
        if not contains $tap $darwin_taps
            set -a missing_taps $tap
        end
    end

    # Check formulae
    for f in $linux_formulae
        if not contains $f $darwin_formulae
            set -a missing_formulae $f
        end
    end

    set -l total_missing (math (count $missing_taps) + (count $missing_formulae))

    if test $total_missing -eq 0
        logirl success "Lint passed — all "(count $linux_formulae)" linux formulae and "(count $linux_taps)" linux taps exist in darwin"
        return 0
    end

    # Report problems
    logirl warning "Linux packages not found in darwin ($total_missing issue(s))"
    echo ""

    if test (count $missing_taps) -gt 0
        printf "%sTaps on linux but not darwin:%s\n" (set_color --bold) (set_color normal)
        for t in $missing_taps
            printf "  %s! %s%s\n" (set_color yellow) $t (set_color normal)
        end
        echo ""
    end

    if test (count $missing_formulae) -gt 0
        printf "%sFormulae on linux but not darwin:%s\n" (set_color --bold) (set_color normal)
        for f in $missing_formulae
            printf "  %s! %s%s\n" (set_color yellow) $f (set_color normal)
        end
        echo ""
    end

    logirl info "For each, either:"
    printf "  1. Reinstall on darwin and run %sbrewshot save%s\n" (set_color --bold) (set_color normal)
    printf "  2. Remove from the linux section of packages.yaml\n"
    return 1
end

# --- Helper: diff ---
function _brewshot_diff -d "Compare current brew state against packages.yaml"
    set -l packages_file $argv[1]

    # Parse the delimiter-separated lists from argv
    # Format: file taps... -- formulae... -- casks...
    set -l taps
    set -l formulae
    set -l casks
    set -l section taps

    for i in (seq 2 (count $argv))
        if test "$argv[$i]" = --
            if test "$section" = taps
                set section formulae
            else if test "$section" = formulae
                set section casks
            end
            continue
        end
        switch $section
            case taps
                set -a taps $argv[$i]
            case formulae
                set -a formulae $argv[$i]
            case casks
                set -a casks $argv[$i]
        end
    end

    logirl info "Comparing against: $packages_file"

    # Load saved darwin state
    set -l saved_taps (yq eval '.packages.darwin.homebrew.taps[]' "$packages_file" 2>/dev/null)
    set -l saved_formulae (yq eval '.packages.darwin.homebrew.formulae[]' "$packages_file" 2>/dev/null)
    set -l saved_casks (yq eval '.packages.darwin.homebrew.casks[]' "$packages_file" 2>/dev/null)

    # Compute diffs
    set -l added_taps
    set -l removed_taps
    set -l added_formulae
    set -l removed_formulae
    set -l added_casks
    set -l removed_casks

    for tap in $taps
        if not contains $tap $saved_taps
            set -a added_taps $tap
        end
    end
    for tap in $saved_taps
        if not contains $tap $taps
            set -a removed_taps $tap
        end
    end

    for f in $formulae
        if not contains $f $saved_formulae
            set -a added_formulae $f
        end
    end
    for f in $saved_formulae
        if not contains $f $formulae
            set -a removed_formulae $f
        end
    end

    for c in $casks
        if not contains $c $saved_casks
            set -a added_casks $c
        end
    end
    for c in $saved_casks
        if not contains $c $casks
            set -a removed_casks $c
        end
    end

    set -l total_changes (math \
        (count $added_taps) + (count $removed_taps) + \
        (count $added_formulae) + (count $removed_formulae) + \
        (count $added_casks) + (count $removed_casks))

    if test $total_changes -eq 0
        logirl success "No differences — current state matches packages.yaml"
        return 0
    end

    echo ""

    if test (count $added_taps) -gt 0; or test (count $removed_taps) -gt 0
        printf "%sTaps:%s\n" (set_color --bold) (set_color normal)
        for t in $added_taps
            printf "  %s+ %s%s\n" (set_color green) $t (set_color normal)
        end
        for t in $removed_taps
            printf "  %s- %s%s\n" (set_color red) $t (set_color normal)
        end
        echo ""
    end

    if test (count $added_formulae) -gt 0; or test (count $removed_formulae) -gt 0
        printf "%sFormulae:%s\n" (set_color --bold) (set_color normal)
        for f in $added_formulae
            printf "  %s+ %s%s\n" (set_color green) $f (set_color normal)
        end
        for f in $removed_formulae
            printf "  %s- %s%s\n" (set_color red) $f (set_color normal)
        end
        echo ""
    end

    if test (count $added_casks) -gt 0; or test (count $removed_casks) -gt 0
        printf "%sCasks:%s\n" (set_color --bold) (set_color normal)
        for c in $added_casks
            printf "  %s+ %s%s\n" (set_color green) $c (set_color normal)
        end
        for c in $removed_casks
            printf "  %s- %s%s\n" (set_color red) $c (set_color normal)
        end
        echo ""
    end

    logirl info "$total_changes change(s) vs packages.yaml"
    return 0
end

# --- Helper: save ---
function _brewshot_save -d "Write current brew state to packages.yaml darwin section"
    set -l packages_file $argv[1]

    # Parse the delimiter-separated lists from argv
    set -l taps
    set -l formulae
    set -l casks
    set -l section taps

    for i in (seq 2 (count $argv))
        if test "$argv[$i]" = --
            if test "$section" = taps
                set section formulae
            else if test "$section" = formulae
                set section casks
            end
            continue
        end
        switch $section
            case taps
                set -a taps $argv[$i]
            case formulae
                set -a formulae $argv[$i]
            case casks
                set -a casks $argv[$i]
        end
    end

    # Work on a temp copy to avoid partial writes
    set -l temp_file (mktemp)
    cp "$packages_file" $temp_file

    # Clear darwin homebrew lists, then repopulate
    yq eval '.packages.darwin.homebrew.taps = []' -i $temp_file
    yq eval '.packages.darwin.homebrew.formulae = []' -i $temp_file
    yq eval '.packages.darwin.homebrew.casks = []' -i $temp_file

    for tap in $taps
        yq eval ".packages.darwin.homebrew.taps += [\"$tap\"]" -i $temp_file
    end

    for formula in $formulae
        yq eval ".packages.darwin.homebrew.formulae += [\"$formula\"]" -i $temp_file
    end

    for cask in $casks
        yq eval ".packages.darwin.homebrew.casks += [\"$cask\"]" -i $temp_file
    end

    # Dry-run: show but don't write
    if set -q _flag_dry_run
        if set -q _flag_verbose
            echo ""
            bat --plain $temp_file 2>/dev/null; or cat $temp_file
            echo ""
        end
        rip $temp_file 2>/dev/null; or rm $temp_file
        echo "$(set_color -b magenta)[DRY RUN]$(set_color normal) $(set_color brgreen)complete$(set_color cyan) — packages.yaml not updated$(set_color normal)"
        return 0
    end

    # Write the file
    mv $temp_file "$packages_file"

    if set -q _flag_verbose
        echo ""
        bat --plain "$packages_file" 2>/dev/null; or cat "$packages_file"
        echo ""
    end

    logirl success "Updated darwin section in $packages_file"
    logirl info "Saved "(count $taps)" taps, "(count $formulae)" formulae, "(count $casks)" casks"
end
