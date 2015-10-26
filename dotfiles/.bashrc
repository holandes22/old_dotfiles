[[ $- != *i* ]] && return

function short_pwd {
    echo $PWD | sed "s:${HOME}:~:" | sed "s:/\(.\)[^/]*:/\1:g" | sed "s:/[^/]*$:/$(basename $PWD):"
}

PS1='\[\033[01;32m\]\u@\[\033[01;34m\]\h\[\033[00m\]:$(short_pwd)$(__git_ps1 "\[\e[32m\][%s]\[\e[0m\]")$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#==================
# Personal settings
#==================

export EDITOR=vim
export TERM=screen-256color

# Aliases
# =======

alias ..='cd .. '

# Completion
# ==========
for completion_script in tmux vagrant tmuxinator; do
    source /usr/share/bash-completion/completions/$completion_script
done

if [ -e "/etc/arch-release" ]; then
    source /usr/share/git/completion/git-completion.bash
    source /usr/share/git/completion/git-prompt.sh
elif [ -e "/etc/redhat-release" ]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

# virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
