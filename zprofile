# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/zprofile.pre.zsh"
# 
export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$HOME/.poetry/bin:$PATH"

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

# initialize pyenv shims dir in path per login session
eval "$(pyenv init --path)"

#

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/zprofile.post.zsh"
