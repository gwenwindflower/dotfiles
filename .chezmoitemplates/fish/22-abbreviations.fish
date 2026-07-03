# =============================================================================
# 22 — Abbreviations
# =============================================================================
#
# edit this file
abbr --add efab nvim ~/.local/share/chezmoi/.chezmoitemplates/fish/22-abbreviations.fish
#
# print, copy, paste
abbr --add p echo
abbr --add pp bat
abbr --add pcp fish_clipboard_copy
abbr --add ppp fish_clipboard_paste
abbr --add jmin "fish_clipboard_paste | jq -c | fish_clipboard_copy"
# shell
abbr --add r fresh -r
abbr --add rr fresh
abbr --add rrh fresh -g
abbr --add fun functions
abbr --add cmd command
abbr --add wa which -a
abbr --add hist history
# procs
abbr --add pps procs
abbr --add ppsm procs --sortd usagemem
abbr --add ppsc procs --sortd usagecpu
abbr --add pps procs
# dir and file management
abbr --add cp. "pwd | fish_clipboard_copy"
abbr --add cpwd "pwd | fish_clipboard_copy"
abbr --add mkd mkdir -p
abbr --add rmd rmdir
abbr --add mkt mktemp
abbr --add rm! rm -rf
abbr --add rmm rip
abbr --add mac macchina
abbr --add chmx chmod +x
abbr --add chme chmod 700
# editor
abbr --add v nvim
abbr --add vi nvim
abbr --add eee ee -e
# network
abbr --add ipext "curl https://api64.ipify.org | fish_clipboard_copy"
# cloud
abbr --add gauth "gcloud auth application-default login"
# ssh (kitten ssh — macOS only, kitty terminal)
abbr --add sshk kitten ssh -A
abbr --add ssha ssh -A
abbr --add exe ssh exe.dev
# tmux
abbr --add tm tmux
abbr --add tm? tstat
abbr --add tmls tmux list-sessions
abbr --add tmn tmux new-session
abbr --add tma tmux attach-session
abbr --add tmd tmux detach-client
abbr --add tmrm tmux kill-server
abbr --add tmw twin (basename "$PWD") --cmd
abbr --add tmh tmux_hint
# herdr
abbr --add hrd herdr
abbr --add hrdx herdr server
abbr --add hrdxx herdr server stop
abbr --add hrdii herdr integration install
abbr --add hrds herdr session
abbr --add hrdsa herdr session attach
abbr --add hrdsrm herdr session delete
abbr --add hrdsls herdr session ls
## herdr sessions
abbr --add hrdld herdr session attach lightdash
abbr --add hrdsm herdr session attach supermodel
abbr --add hrddf herdr session attach dotfiles
# shell snippets
abbr --add --position anywhere -- --help '--help | bat -plhelp'
abbr --add --position anywhere -- -h '--help | bat -plhelp'
abbr --add --position anywhere -- -hr '--help | bat -plhelp | rg'
abbr --add --position anywhere -- qq '>/dev/null'
abbr --add --position anywhere -- qqq '>/dev/null 2>&1'
# dotfiles
abbr --add cm chezmoi
abbr --add cmcd chezmoi cd
abbr --add cme chezmoi edit
abbr --add cmee ee -e ~/.local/share/chezmoi
abbr --add cma chezmoi add
abbr --add cmaa chezmoi re-add
abbr --add cmaf chezmoi add --follow
abbr --add cmx chezmoi apply
abbr --add cmxx chezmoi apply ~/.config/
abbr --add cmxf chezmoi apply ~/.config/fish/
abbr --add cmxv chezmoi apply ~/.config/nvim/
abbr --add cmxa chezmoi apply ~/.agents/
abbr --add cmxc chezmoi apply ~/.claude/
abbr --add cmc chezmoi cat
abbr --add cmd chezmoi diff
abbr --add cmd. 'chezmoi diff .'
# runners
abbr --add tk task
abbr --add mk make
# 'lazy' TUIs
abbr --add lgt lazygit
abbr --add ldr lazydocker
# file search/view/explore
abbr --add f fzf
abbr --add fw "fzf --preview= --preview-window=hidden --bind 'enter:accept'"
abbr --add fzfopts "echo \$FZF_DEFAULT_OPTS | sed 's/^--//; s/ --/\n/g' | bat"
# listing
abbr --add l lsd -lAg
abbr --add ls lsd --classic
abbr --add ll lsd -l
abbr --add la lsd -lA
abbr --add lg lsd -lg
abbr --add lt lsd --tree
# navigation
abbr --add s z
abbr --add dots "ee -e $DOTFILES"
abbr --add de "ee -e $DOTFILES"
abbr --add conf "ee $XDG_CONFIG_HOME"
abbr --add proj "ee $PROJECTS"
abbr --add keeb "ee -e $PROJECTS/05_utils/tinybabykeeb"
# brew
abbr --add brx brewdo
abbr --add bri "brew update; brew install"
abbr --add brrm brew uninstall
abbr --add brup brew upgrade
abbr --add brcup "brew update; brew upgrade --no-ask; brew cleanup"
abbr --add brs brew search
abbr --add brc brew cleanup
abbr --add brcl brew cleanup
abbr --add brls brew list
abbr --add brlsi brew list --installed-on-request
abbr --add brlsc brew list --cask
abbr --add brlsf "brew list --installed-on-request | fzf --multi --prompt='Filter brew packages: ' --preview='brew info {1}'"
abbr --add br? brew info
abbr --add brin brew info
abbr --add brd brew deps
abbr --add brdt brew deps --tree
abbr --add bruse brew uses --installed
abbr --add bruise brew uses --installed
abbr --add brbg brew services
abbr --add brsrv brew services
# containers
abbr --add dk docker
abbr --add dkcu docker compose up
# agents
abbr --add cx codex
abbr --add cxcf "ee $HOME/.codex"
abbr --add cxr codex resume
abbr --add cxc codex resume --last
abbr --add oc opencode
abbr --add occf "ee $HOME/.config/opencode"
abbr --add cl claude
abbr --add clr claude --resume
abbr --add clc claude -c
abbr --add cl! claude --allow-dangerously-skip-permissions
abbr --add clc! claude -c --allow-dangerously-skip-permissions
abbr --add clcf "ee $HOME/.claude"
abbr --add ccu bunx ccusage@latest
# obsiidian and notes
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
abbr --add ddb duckdb --cmd \'.read ~/dev/02_spellbook/pastel_duck_theme.sql\'
abbr --add pg pgcli
abbr --add sqli sqlite3
## lightdash
abbr --add ld lightdash
abbr --add ldc lightdash compile
abbr --add ldcf lightdash config
abbr --add ldp lightdash preview
abbr --add ldv lightdash validate
abbr --add ldg lightdash generate
abbr --add ldup lightdash upload
abbr --add lddl lightdash download
abbr --add ldd lightdash deploy
abbr --add ldl "lightdash deploy; and lightdash upload"
abbr --add lddb lightdash dbt
abbr --add lddbbs lightdash dbt build -s
abbr --add lddbba lightdash dbt build
abbr --add lddbts lightdash dbt test -s
abbr --add lddbta lightdash dbt test
abbr --add lddbrs lightdash dbt run -s
abbr --add lddbra lightdash dbt run
## dbt
### dbt core
abbr --add dbbs uv run dbt build -s
abbr --add dbba uv run dbt build
abbr --add dbts uv run dbt test -s
abbr --add dbta uv run dbt test
abbr --add dbrs uv run dbt run -s
abbr --add dbra uv run dbt run
### dbt Fusion
abbr --add dbfbs dbtf build -s
abbr --add dbfba dbtf build
abbr --add dbfts dbtf test -s
abbr --add dbfta dbtf test
abbr --add dbfrs dbtf run -s
abbr --add dbfra dbtf run
abbr --add dbtpe nvim ~/.dbt/profiles.yml
abbr --add dbtpp bat ~/.dbt/profiles.yml
alias wizard dbt-wizard
abbr --add wiz wizard
# languages
## python
abbr --add py python
abbr --add pym python main.py
abbr --add ip ipython
abbr --add pyt pytest
abbr --add uvpy uv python
abbr --add uvpyh "cd (uv python dir)"
abbr --add uvpyi uv python install
abbr --add uvpyls uv python list
abbr --add uvpyup uv python upgrade
abbr --add uvt uv tool
abbr --add uvti uv tool install
abbr --add uvtid uv tool install . --reinstall
abbr --add uvti. uv tool install . --reinstall
abbr --add uvtu uv tool upgrade
abbr --add uvr uv run
abbr --add uvrt uv run pytest
abbr --add uvp uv pip
abbr --add uvpi uv pip install
abbr --add uvpir "uv pip install -r requirements.txt"
abbr --add uva uv add
abbr --add uvs uv sync
abbr --add uvup uv lock --upgrade-package
abbr --add uvupg uv lock --upgrade-group
abbr --add uvupa uv lock --upgrade
abbr --add uvi uv init
abbr --add uvb uv build
abbr --add va source .venv/bin/activate.fish
abbr --add da deactivate
## go
abbr --add gor go run main.go
abbr --add gord go run .
abbr --add got go test
abbr --add gotv go test -v
abbr --add gob go build
## rust
abbr --add ruu rustup up
abbr --add cg cargo
abbr --add cgn cargo init
abbr --add cgi cargo install
abbr --add cgii cargo bininstall
abbr --add cga cargo add
abbr --add cgrm cargo remove
abbr --add cgx cargo run
abbr --add cgc cargo rustc
abbr --add cgch cargo check
abbr --add cgfm cargo fmt
abbr --add cgfx cargo fix
## typescript
### mise
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
### aube
abbr --add au aube
abbr --add aux aubx
abbr --add aui aube install
abbr --add aua aube add
abbr --add aurm aube remove
abbr --add auu aube update
abbr --add aud aubr dev
abbr --add aub aubr build
abbr --add auls aube ls
abbr --add aulsg aube ls -g
### node
abbr --add np npm
abbr --add npi npm install
abbr --add npu npm update
abbr --add npd npm run dev
abbr --add npb npm run build
### pnpm
abbr --add pn pnpm
abbr --add pnx pnpm dlx
abbr --add pni pnpm install
abbr --add pna pnpm add
abbr --add pnrm pnpm remove
abbr --add pnu pnpm update
abbr --add pnd pnpm dev
abbr --add pnb pnpm build
abbr --add pnl pnpm lint
abbr --add pnf pnpm fix
abbr --add pnls pnpm ls
abbr --add pnlsg pnpm ls -g
abbr --add pnsu pnpm self-update
### bun
abbr --add bni bun install
abbr --add bna bun add
abbr --add bnag bun add -g
abbr --add bnrm bun remove
abbr --add bnrmg bun remove -g
abbr --add bnup bun upgrade
abbr --add bnupg bun upgrade -g
abbr --add bns bun start
abbr --add bnt bun test
abbr --add bnr bun run
abbr --add bnc bun create
abbr --add bnlsg bun pm ls -g
### deno
abbr --add dn deno
abbr --add dncli deno install -grAf --root $DENO_HOME
abbr --add dnt deno task
abbr --add dntt deno task test
abbr --add dnti deno task install
abbr --add dnf deno fmt
abbr --add dnc deno check
abbr --add dni deno install
abbr --add dna deno add
abbr --add dnu deno remove
abbr --add dnq deno info
abbr --add dnsh deno repl
abbr --add dnru deno run
# git
## github
abbr --add ghro gh repo view -w
abbr --add ghrc gh repo create
abbr --add ghrcd gh repo create --push --private --source .
abbr --add ghrcl gh repo clone
abbr --add ghd gh dash
abbr --add ghdo opo gh dash
abbr --add ghs gh search
abbr --add ghsc gh search code
abbr --add ghscld "gh search code --repo lightdash/lightdash -- "
abbr --add ghscldw "gh search code --web --repo lightdash/lightdash -- "
## shortening my git aliases
abbr --add gmain git main
## critique
abbr --add gdpp critique
## degit
abbr --add degit aubx degit
### blacksmith
abbr --add bs blacksmith
abbr --add bsau blacksmith auth status
abbr --add bsal blacksmith auth login
abbr --add bst blacksmith testbox
abbr --add bstw blacksmith testbox warmup
abbr --add bstr blacksmith testbox run
## interactive tools
abbr --add gui lazygit
abbr --add gcmm meteor
### forgit
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
## difftastic
abbr --add gdd git diffd
abbr --add gshd git showd
abbr --add glod git logd
## worktrunk
abbr --add wtsw wt switch
abbr --add wtswc wt switch -c
abbr --add wtm wt merge
abbr --add wts wt step
abbr --add wtls wt list
abbr --add wtrm wt remove
abbr --add wtrm! wt remove --force
abbr --add wtrm!! wt remove --force -D
#  media
abbr --add spotify spotify_player
abbr --add spt spotify_player
abbr --add ytdl yt-dlp
abbr --add gdl gallery-dl
abbr --add cap termframe
# amoxide
abbr --add ama am add
abbr --add amrm am remove
abbr --add amls am ls
abbr --add amla am la
## this shadows an admin-level system testing command just fyi
abbr --add amt am trust
abbr --add amut am untrust
abbr --add amx am tui
abbr --add amu am use
abbr --add amp am profile
# mintlify
abbr --add mint mintlify
