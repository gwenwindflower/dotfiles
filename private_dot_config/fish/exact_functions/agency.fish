function agency -d "Probe the agent permission configs: Codex sandbox grants and execution rules"
    # Logic lives in .utils/agency.ts and .utils/agency.toml; see .utils/docs/agency.md.
    # Probes the dotfiles checkout you're in (a worktree tests its own configs), else the chezmoi source.
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if not test -f "$root/.utils/agency.toml"
        set root (chezmoi source-path)
    end

    pushd "$root/.utils"
    AGENCY_REQUIRE_HOST=1 deno task test agency $argv
    set -l code $status
    popd
    return $code
end
