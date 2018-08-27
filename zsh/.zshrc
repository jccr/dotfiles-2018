PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

# ==> ENV VARS & PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
export ANDROID_HOME="$HOME/Android/Sdk"
# <==

# ==> CUSTOM STUFF
export EDITOR=vim
alias cat=ccat

# Pre-prompt new line
precmd() { print "" }
# <==

# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Load rbenv
eval "$(command rbenv init - --no-rehash)"

# == ZGEN BEGIN == #
 
# fix prompt
export LC_CTYPE=en_US.UTF-

# Load zgen only if a user types a zgen command
zgen () {
	if [[ ! -s ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh ]]; then
		git clone --recursive https://github.com/tarjoilija/zgen.git ${ZDOTDIR:-${HOME}}/.zgen
	fi
	source ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh
	zgen "$@"
}

# if the init scipt doesn't exist
if ! zgen saved; then

  zgen oh-my-zsh

  # plugins
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/shrink-path
  zgen load zdharma/fast-syntax-highlighting  
  zgen load jccr/materialshell materialshell

  # completions
  zgen load zsh-users/zsh-completions src

  # generate the init script from plugins above
  zgen save
fi

# Post init for nvm
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# == ZGEN END == #

test -e "${HOME}/.config.zsh" && source "${HOME}/.config.zsh"

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi

