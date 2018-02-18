PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

# == ENV VARS & PATH == #

export PATH=~/.local/bin:~/.rbenv/bin:$PATH
export ANDROID_HOME=/Users/juanc/Library/Android/sdk
export JAVA_HOME=$(/usr/libexec/java_home)

# == CUSTOM STUFF == #
# TODO: move to .zprofile

export EDITOR=vim

# Pre-prompt new line
precmd() { print "" }

. /usr/local/etc/profile.d/z.sh

eval "$(command rbenv init - --no-rehash)"

# == ZGEN BEGIN == #

# fix prompt
export LC_CTYPE=en_US.UTF-8

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

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi

