function obsync -d "Stage all and commit Obsidian vault state with today's date"
    if not set -q OBSIDIAN_DEFAULT_VAULT
        logirl error "OBSIDIAN_DEFAULT_VAULT is not set"
        return 1
    end

    if not test -d "$OBSIDIAN_DEFAULT_VAULT/.git"
        logirl error "$OBSIDIAN_DEFAULT_VAULT is not a git repo"
        return 1
    end

    set -l today (date +%Y-%m-%d)
    set -l msg "sync: vault state $today"

    git -C "$OBSIDIAN_DEFAULT_VAULT" add -A; or return $status

    if git -C "$OBSIDIAN_DEFAULT_VAULT" diff --cached --quiet
        logirl info "Vault clean — nothing to commit"
        return 0
    end

    git -C "$OBSIDIAN_DEFAULT_VAULT" commit -m "$msg"
end
