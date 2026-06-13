function uvping -d "Pin the global uv-managed Python version and install it as the default"
    argparse h/help -- $argv
    if set -q _flag_help
        echo "Pin the global uv-managed Python version and install it as the default"
        logirl help_usage "uvping <version>"
        logirl help_header Examples
        logirl help_cmd "uvping 3.13" "Pin a major.minor version"
        logirl help_cmd "uvping '>=3.13,<3.14'" "Pin a version constraint"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        return 0
    end
    if test (count $argv) -ne 1
        logirl error "uvping takes exactly one <version> argument"
        logirl info "Run `uvping --help` for usage"
        return 1
    end
    uv python pin --global $argv[1]; or return $status
    uv python install --default
end
