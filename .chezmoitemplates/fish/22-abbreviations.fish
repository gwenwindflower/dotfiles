# =============================================================================
# 22 — Abbreviations
# =============================================================================

# print, copy, paste
abbr --add p echo
abbr --add pp bat
abbr --add cat bat
abbr --add pcp fish_clipboard_copy
abbr --add ppp fish_clipboard_paste
# shell
abbr --add r fresh -r
abbr --add rr fresh
abbr --add rrh fresh -g
abbr --add fun functions
abbr --add cmd command
# processes
abbr --add top btm
abbr --add pps procs
# dir and file management
abbr --add cp. "pwd | fish_clipboard_copy"
abbr --add mkd mkdir -p
abbr --add rmd rmdir
abbr --add mkt mktemp
abbr --add mac macchina
abbr --add cmx chmod +x
abbr --add cmme chmod 700
# editor
abbr --add v nvim
abbr --add vi nvim
# ssh (kitten ssh — macOS only, kitty terminal)
abbr --add sshk kitten ssh -A
# tmux
abbr --add tm tmux
abbr --add tm? tstat
abbr --add tmls tmux list-sessions
abbr --add tmn tmux new-session
abbr --add tma tmux attach-session
abbr --add tmd tmux detach-client
abbr --add tmw twin (basename "$PWD") --cmd
abbr --add tmh tmux_hint
abbr --add tmhspark 'tmux_hint -d ""'
# shell snippets
abbr --add --position anywhere -- --help '--help | bat -plhelp'
abbr --add --position anywhere -- -h '-h | bat -plhelp'
abbr --add --position anywhere -- qq '>/dev/null'
abbr --add --position anywhere -- qqq '>/dev/null 2>&1'
# dotfiles
abbr --add moi chezmoi
abbr --add moid chezmoi cd
abbr --add moie chezmoi edit
abbr --add moia chezmoi apply
# runners
abbr --add t task
abbr --add mk make
# 'lazy' TUIs
abbr --add lgt lazygit
abbr --add ldr lazydocker
# file search/view/explore
abbr --add f fzf
abbr --add fdf "fd . --color always --hidden --ignore | fzf --preview '_fzf_preview_file {}'"
abbr --add fzfopts "echo \$FZF_DEFAULT_OPTS | sed 's/^--//; s/ --/\n/g' | bat"
# listing
abbr --add l lsd -lAg
abbr --add ls lsd --classic
abbr --add ll lsd -l
abbr --add lg lsd -lg
abbr --add la lsd -A
abbr --add lla lsd -lA
abbr --add lt lsd --tree
# navigation
abbr --add s z
abbr --add dots "ee -e $DOTFILES_HOME"
abbr --add conf "ee $XDG_CONFIG_HOME"
abbr --add proj "ee $PROJECTS"
abbr --add keeb "ee -e $PROJECTS_UTILS/tinybabykeeb"
# Homebrew
abbr --add brx brewdo
abbr --add bri "brew update; brew install"
abbr --add brrm brew uninstall
abbr --add brup brew upgrade
abbr --add brcup "brew update; brew upgrade; brew cleanup"
abbr --add brs brew search
abbr --add brc brew cleanup
abbr --add brcl brew cleanup
abbr --add brl brew list
abbr --add brlf brew list --installed-on-request
abbr --add brli brew list --installed-on-request
abbr --add brlc brew list --cask
abbr --add brls brew list
abbr --add brlsf brew list --installed-on-request
abbr --add brlsi brew list --installed-on-request
abbr --add brlsc brew list --cask
abbr --add br? brew info
abbr --add brin brew info
abbr --add brd brew deps
abbr --add brdt brew deps --tree
abbr --add bruse brew uses --installed
abbr --add bruise brew uses --installed
abbr --add brbg brew services
abbr --add brsrv brew services
# ai
abbr --add oc opencode
abbr --add occf ee $HOME/.config/opencode
abbr --add co copilot
abbr --add cl claude
abbr --add clcf ee $HOME/.claude
abbr --add ccu bunx ccusage@latest
abbr --add clyj yj $DOTFILES_HOME/agents/claude/settings.yaml --force
abbr --add notes "ee ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents"
abbr --add ob notesmd-cli
abbr --add obf "fd . --color always --hidden --ignore --extension md | fzf --preview '_fzf_preview_file {}'"
abbr --add obs notesmd-cli search
abbr --add obse notesmd-cli search -e
abbr --add obg notesmd-cli search-content
abbr --add obge notesmd-cli search-content -e
abbr --add oba notesmd-cli create
abbr --add obrm notesmd-cli delete
abbr --add obday notesmd-cli daily
abbr --add obfm notesmd-cli frontmatter
abbr --add ob? notesmd-cli help
abbr --add obls notesmd-cli list
abbr --add oblsv notesmd-cli list-vaults
abbr --add obmv notesmd-cli move
abbr --add obo notesmd-cli open
abbr --add obp notesmd-cli print
abbr --add obdv notesmd-cli print-default
abbr --add obfmp "fd . --color always --hidden --ignore --extension md | fzf --preview '_fzf_preview_file {}' --bind 'enter:execute(notesmd-cli frontmatter {} --print)+abort'"
# security and network
abbr --add opg "op run --env-file=$OP_ENV_DIR/global.env --no-masking -- "
abbr --add opi "op run --no-masking -- "
abbr --add opr "op run -- "
abbr --add openv ee $OP_ENV_DIR
abbr --add keys security
abbr -a 'prx?' prx status
abbr -a mp mitmproxy
# data
abbr --add dbx databricks
abbr --add ddb duckdb
abbr --add pg pgcli
abbr --add sqli sqlite3
abbr --add dbbs dbtf build -s
abbr --add dbba dbtf build
abbr --add dbts dbtf test -s
abbr --add dbta dbtf test
abbr --add dbrs dbtf run -s
abbr --add dbra dbtf run
abbr --add dbtpo nvim ~/.dbt/profiles.yml
abbr --add dbtpp bat ~/.dbt/profiles.yml
# languages
abbr --add mi mise
abbr --add mia "mise activate fish | source"
abbr --add mida mise deactivate
abbr --add miu mise use
abbr --add mii mise install
abbr --add mir mise run
abbr --add mic mise config
abbr --add micl mise config list
abbr --add mics mise config set
abbr --add mipth $HOME/.local/share/mise/installs/
abbr --add py python
abbr --add pym python main.py
abbr --add ip ipython
abbr --add pyt pytest
abbr --add uvpy uv python
abbr --add uvpyh "cd (uv python dir)"
abbr --add uvpyi uv python install
abbr --add uvpyls uv python list
abbr --add uvpyu uv python upgrade
abbr --add uvt uv tool
abbr --add uvti uv tool install
abbr --add uvtid uv tool install . --reinstall
abbr --add uvtu uv tool upgrade
abbr --add uvr uv run
abbr --add uvrt uv run pytest
abbr --add uvp uv pip
abbr --add uvpi uv pip install
abbr --add uvpir "uv pip install -r requirements.txt"
abbr --add uva uv add
abbr --add uvs uv sync
abbr --add uvi uv init
abbr --add uvb uv build
abbr --add va source .venv/bin/activate.fish
abbr --add da deactivate
abbr --add gor go run main.go
abbr --add gord go run .
abbr --add got go test
abbr --add gotv go test -v
abbr --add gob go build
abbr --add ruu rustup up
abbr --add n npm
abbr --add nx npx
abbr --add ni npm install
abbr --add nu npm update
abbr --add nd npm run dev
abbr --add nb npm run build
abbr --add pn pnpm
abbr --add pnx pnpm dlx
abbr --add pni pnpm install
abbr --add pnrm pnpm remove
abbr --add pna pnpm add
abbr --add pnu pnpm update
abbr --add pnd pnpm dev
abbr --add pnb pnpm build
abbr --add pnl pnpm lint
abbr --add pnf pnpm fix
abbr --add b bun
abbr --add bi bun install
abbr --add ba bun add
abbr --add bu bun upgrade
abbr --add bs bun start
abbr --add br bun run
abbr --add bt bun test
abbr --add bx bunx
abbr --add d deno
abbr --add dig deno install -grAf --root $DENO_HOME
abbr --add dt deno task
# git
abbr --add g git
abbr --add gcfg git config --global
abbr --add gho gh repo view -w
abbr --add ghd gh dash
abbr --add ghrcd gh repo create --push --public --source .
abbr --add gui lazygit
abbr --add gcmm meteor
abbr --add gfgii "git forgit ignore >> .gitignore"
abbr --add gfg git forgit
abbr --add gfga git forgit add
abbr --add gfglo git forgit log
abbr --add gfgd git forgit diff
abbr --add gfgi git forgit ignore
abbr --add gfgbl git forgit blame
abbr --add gfgrb git forgit rebase
abbr --add gfgbd git forgit branch_delete
abbr --add gfgb git forgit checkout_branch
abbr --add gfgct git forgit checkout_tag
abbr --add gfgcf git forgit checkout_file
abbr --add gfgcc git forgit checkout_commit
abbr --add gfgrc git forgit revert_commit
abbr --add gfgcl git forgit clean
abbr --add gfgrh git forgit reset_head
abbr --add gfgss git forgit stash_show
abbr --add gfgsp git forgit stash_push
abbr --add gfgcp git forgit cherry_pick
abbr --add gfgcpb git forgit cherry_pick_from_branch
abbr --add wtsw wt switch
abbr --add wtswc wt switch -c
abbr --add wtm wt merge
abbr --add spotify spotify_player
abbr --add spt spotify_player
abbr --add ytdl yt-dlp
abbr --add gdl gallery-dl
