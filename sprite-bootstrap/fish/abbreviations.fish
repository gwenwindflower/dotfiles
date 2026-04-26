# Sprite-curated subset of ~/.chezmoitemplates/fish/22-abbreviations.fish.
# Only abbrs whose underlying tools are present on a Fly.io Sprite base
# image: fish, tmux, git, gh, claude, deno, bun, uv, python, go, rust.
# Workstation-only abbrs (brew, obsidian, lazygit, forgit, meteor, mise,
# kitten, lsd, procs, bat, etc.) are deliberately omitted.

# shell snippets
abbr --add --position anywhere -- qq '>/dev/null'
abbr --add --position anywhere -- qqq '>/dev/null 2>&1'

# dir/file management
abbr --add mkd mkdir -p
abbr --add rmd rmdir
abbr --add mkt mktemp
abbr --add chmx chmod +x
abbr --add chme chmod 700

# tmux
abbr --add tm tmux
abbr --add tmls tmux list-sessions
abbr --add tmn tmux new-session
abbr --add tma tmux attach-session
abbr --add tmd tmux detach-client

# git — curated subset of git-fish plugin abbrs (muscle-memory parity).
# Skipped: helper-dependent (current_branch/default_branch), git flow,
# submodules, svn, gitlab merge-request push opts.
abbr --add g git
abbr --add ga git add
abbr --add gaa git add --all
abbr --add gap git apply
abbr --add gb git branch -vv
abbr --add gba git branch -a -v
abbr --add gbd git branch -d
abbr --add gbD git branch -D
abbr --add gbl git blame -b -w
abbr --add gc git commit -v
abbr --add 'gc!' git commit -v --amend
abbr --add 'gcn!' git commit -v --no-edit --amend
abbr --add gca git commit -v -a
abbr --add gcm git commit -m
abbr --add gcam git commit -a -m
abbr --add gcv git commit -v --no-verify
abbr --add gcl git clone
abbr --add gclean git clean -di
abbr --add gcp git cherry-pick
abbr --add gco git checkout
abbr --add gcb git checkout -b
abbr --add gd git diff
abbr --add gdca git diff --cached
abbr --add gds git diff --stat
abbr --add gf git fetch
abbr --add gfa git fetch --all --prune
abbr --add gfo git fetch origin
abbr --add gl git pull
abbr --add glr git pull --rebase
abbr --add glg git log --stat
abbr --add glo git log --oneline --decorate --color
abbr --add glog git log --oneline --decorate --color --graph
abbr --add gloga git log --oneline --decorate --color --graph --all
abbr --add gm git merge
abbr --add gma git merge --abort
abbr --add gp git push
abbr --add 'gp!' git push --force-with-lease
abbr --add gpo git push origin
abbr --add gpv git push --no-verify
abbr --add gr git remote -vv
abbr --add gra git remote add
abbr --add grb git rebase
abbr --add grba git rebase --abort
abbr --add grbc git rebase --continue
abbr --add grbi git rebase --interactive
abbr --add grbs git rebase --skip
abbr --add grev git revert
abbr --add grh git reset
abbr --add grhh git reset --hard
abbr --add grm git rm
abbr --add grmc git rm --cached
abbr --add grs git restore
abbr --add grst git restore --staged
abbr --add gsh git show
abbr --add gsb git status -sb
abbr --add gss git status -s
abbr --add gst git status
abbr --add gsta git stash
abbr --add gstd git stash drop
abbr --add gstl git stash list
abbr --add gstp git stash pop
abbr --add gsts git stash show --text
abbr --add gsw git switch
abbr --add gswc git switch --create
abbr --add gup git pull --rebase
abbr --add gupa git pull --rebase --autostash
abbr --add gwt git worktree
abbr --add gwta git worktree add
abbr --add gwtls git worktree list
abbr --add gwtrm git worktree remove

# github
abbr --add ghro gh repo view -w
abbr --add ghrc gh repo create
abbr --add ghrcd gh repo create --push --private --source .
abbr --add ghpr gh pr create
abbr --add ghprv gh pr view -w
abbr --add ghprl gh pr list

# claude
abbr --add cl claude
abbr --add cl! claude --allow-dangerously-skip-permissions

# deno
abbr --add dn deno
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

# bun
abbr --add bui bun install
abbr --add bua bun add
abbr --add bur bun remove
abbr --add buup bun upgrade
abbr --add bus bun start
abbr --add but bun test
abbr --add buru bun run
abbr --add buc bun create

# uv / python
abbr --add py python
abbr --add pyt pytest
abbr --add uvr uv run
abbr --add uvrt uv run pytest
abbr --add uvp uv pip
abbr --add uvpi uv pip install
abbr --add uva uv add
abbr --add uvs uv sync
abbr --add uvi uv init
abbr --add uvb uv build
abbr --add va source .venv/bin/activate.fish
abbr --add da deactivate

# go
abbr --add gor go run main.go
abbr --add gord go run .
abbr --add got go test
abbr --add gotv go test -v
abbr --add gob go build

# rust
abbr --add ruu rustup up
