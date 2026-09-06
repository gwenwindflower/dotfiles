function rg --wraps rg -d "ripgrep with personal defaults, scoped to this shell"
    RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgrep.conf command rg $argv
end
