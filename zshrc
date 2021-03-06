# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/zshrc.pre.zsh"
zmodload zsh/zprof
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/grant/.oh-my-zsh"

ZSH_CUSTOM="/Users/grant/.dotfiles/oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages sudo python pip brew zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

autoload -U zmv

setopt extendedglob
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# For a full list of active aliases, run `alias`.

alias vi="nvim"
alias vim="nvim"
alias zc="vi ~/.dotfiles/zshrc"
alias zr="exec $SHELL"
alias ohmyzsh="cd ~/.oh-my-zsh && vi"
alias vimconfig="vi ~/.vim-config"
alias dbtprof="vi ~/.dbt/profiles.yml"
alias dbtdoc="dbt docs generate && dbt docs serve"
alias sc="sc-im"
alias wthr="curl wttr.in/chicago"
alias dotz="cd ~/.dotfiles && vi"
alias cl="gcalcli"
alias cla="gcalcli agenda"
alias gch="omz plugin info git"
export ORGDIR="~/Documents/orgfiles"
alias ob="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/main && vi"
alias org="cd ${ORGDIR}&& vi"
alias orgdir="cd ${ORGDIR}"
alias pu="cmus-remote --pause"
alias l="colorls --dark"
alias ll="colorls -l --dark"
alias la="colorls -a --dark"
alias lla="colorls -la --dark"
alias kb="cd /Users/grant/qmk_firmware/keyboards/splitkb/kyria/keymaps/gwenwindflower && vi"
alias spotify="spotifyd --config-path /Users/grant/.config/spotifyd/spotify.conf && spt"

export EDITOR=nvim
export TERM="xterm-256color"

# run and test dbt selection
function dbtmrt () { dbt run -m $1 && dbt test -m $1 }

#wrapper functions around dbt codegen for scaffolding boiler plate dbt models 
function dbtsrc() {
    database_name=$1
    schema_name=$2
    echo 'building source yaml for '"$database_name"''
    mkdir -p ./models/staging/"$schema_name"
    touch ./models/staging/"$schema_name"/_source.yml 
    dbt --log-format json \
    run-operation generate_source \
    --args '{"schema_name": '"$schema_name"', "database_name": '"$database_name"'}' \
    | jq -r 'select(.message | contains ("version") ) | .message' \
    > ./models/staging/"$schema_name"/_source.yml
}

function dbtstg() {
    source_name=$1
    table_name=$2
    echo 'building staging model for '"$table_name"' in source '"$source_name"''
    mkdir -p ./models/staging/"$source_name"
    touch ./models/staging/"$source_name"/stg_"$source_name"_"$table_name".sql
    dbt --log-format json \
    run-operation generate_base_model \
    --args '{"source_name": '"$source_name"', "table_name": '"$table_name"'}' \
    | jq -r 'select(.message | startswith ("with") ) | .message' \
    > ./models/staging/"$source_name"/stg_"$source_name"_"$table_name".sql
}

function dbtstb() {
    database_name=$1
    schema_name=$2
    dbtsrc "$database_name" "$schema_name"
    length=$(cat ./models/staging/"$schema_name"/_source.yml | shyaml get-length sources.0.tables)
    length=$((length-1))
    for i in {0.."$length"}
    do
        table_name=$(cat ./models/staging/"$schema_name"/_source.yml | shyaml get-value sources.0.tables."$i".name)
        dbtstg "$schema_name" "$table_name"
    done
}

# Bookmark note in journal and edit
function ne() {
    URL=$(osascript -e 'tell application "Google Chrome" to get URL of active tab of first window')
    TITLE=$(osascript -e 'tell application "Google Chrome" to get Title of active tab of first window')
    cd ~/dev/personal/blog
    FILE=$(neuron new)
    echo "# $TITLE
    [$TITLE]($URL)" > "$FILE"
    echo "Bookmarked $FILE in journal"
    vi $FILE
}

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# z
. /usr/local/etc/profile.d/z.sh

export BAT_THEME="ansi-dark"

# Not currently doing much JS work and nvm is very slow -- look into lazy loading if you need to add it back -> https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load/
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/grant/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/grant/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/grant/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/grant/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"

# The next line updates PATH for Postgres.app CLI
PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# 
# crazy haskell stuff for tidalcycles
[ -f "/Users/grant/.ghcup/env" ] && source "/Users/grant/.ghcup/env" # ghcup-env

# initialize pyenv autocomplete, rehashes shims, and installs pyenv as a shell function
eval "$(pyenv init -)"

# initialize rbenv
eval "$(rbenv init - zsh)"

# enable starship theme
eval "$(starship init zsh)"

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/zshrc.post.zsh"
