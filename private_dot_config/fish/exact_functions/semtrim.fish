function semtrim --description "Select contiguous components from a semantic version"
    argparse h/help use-v major minor patch -- $argv
    or return 2

    if set -q _flag_help
        echo "Select contiguous components from a semantic version."
        logirl help_usage "semtrim [OPTIONS] <version>"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag use-v "Prefix the output with v"
        logirl help_flag major "Preserve the major component"
        logirl help_flag minor "Preserve the minor component"
        logirl help_flag patch "Preserve the patch component"
        logirl help_header Examples
        printf "  semtrim 1.2.3                  # 1.2\n"
        printf "  semtrim --minor --patch v1.2.3 # 2.3\n"
        printf "  semtrim --use-v --patch 1.2.3  # v3\n"
        return 0
    end

    if test (count $argv) -ne 1
        logirl error "Expected exactly one semantic version"
        return 2
    end

    if set -q _flag_major; and set -q _flag_patch; and not set -q _flag_minor
        logirl error "Cannot preserve --major and --patch without --minor"
        return 2
    end

    set -l semver $argv[1]
    set -l parts (string match --groups-only -r '^v?([0-9]+)\.([0-9]+)\.([0-9]+)$' -- $semver)
    if test (count $parts) -ne 3
        logirl error "Invalid semantic version: $semver"
        return 1
    end

    set -l selected_parts
    if not set -q _flag_major; and not set -q _flag_minor; and not set -q _flag_patch
        set selected_parts $parts[1..2]
    else
        set -q _flag_major; and set -a selected_parts $parts[1]
        set -q _flag_minor; and set -a selected_parts $parts[2]
        set -q _flag_patch; and set -a selected_parts $parts[3]
    end

    set -l prefix
    set -q _flag_use_v; and set prefix v

    printf '%s%s\n' $prefix (string join . -- $selected_parts)
end
