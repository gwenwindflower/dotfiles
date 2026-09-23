set -l skillet_commands check diff accept save

complete -c skillet -f
complete -c skillet -s h -l help -d "Show help"
complete -c skillet -n "not __fish_seen_subcommand_from $skillet_commands" -a check -d "List upstream skills changed since their baseline"
complete -c skillet -n "not __fish_seen_subcommand_from $skillet_commands" -a diff -d "Diff an upstream skill against its baseline"
complete -c skillet -n "not __fish_seen_subcommand_from $skillet_commands" -a accept -d "Record the distilled upstream version as baseline"
complete -c skillet -n "not __fish_seen_subcommand_from $skillet_commands" -a save -d "Copy deployed skills back into the dotfiles skills/ tree"
complete -c skillet -n "__fish_seen_subcommand_from diff accept" -a "(string replace -rf '^skill = \"(.*)\"\$' '\$1' < (chezmoi source-path)/skills/upstream.toml)" -d "Upstream skill"
complete -c skillet -n "__fish_seen_subcommand_from accept" -l commit -r -d "Commit printed by skillet diff"
complete -c skillet -n "__fish_seen_subcommand_from save" -a "(command ls ~/.agents/skills)" -d "Deployed skill"
complete -c skillet -n "__fish_seen_subcommand_from save" -s n -l dry-run -d "Show what would be replaced"
