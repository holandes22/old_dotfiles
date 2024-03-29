[[ $- != *i* ]] && return

function short_pwd {
    echo $PWD | sed "s:${HOME}:~:" | sed "s:/\(.\)[^/]*:/\1:g" | sed "s:/[^/]*$:/$(basename "$PWD"):"
}

function git_branch {
    color="32"
    # if it is a git controlled folder, check for staged or modified files
    if git rev-parse --resolve-git-dir .git/ > /dev/null 2> /dev/null; then
        if [[ $(git status -s --untracked-files=no) ]]; then
            color="0;31"
        fi
    fi
    echo `__git_ps1 "\e[${color}m[git:%s]\e[0m"`
}

PS1='\[\033[01;32m\]\u@\[\033[01;34m\]\h\[\033[00m\]:$(short_pwd)$(git_branch)\n$ '

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


#========
# Helpers
#========

source_file() {
    if [ -f "$1" ]; then
        source $1
    fi
}

#==================
# Personal settings
#==================

export EDITOR=vim

# Aliases
# =======

alias ..='cd .. '

# Tools
# =====

export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7

# Completion
# ==========
if [ -e "/etc/arch-release" ]; then
    source /usr/share/git/completion/git-completion.bash
    source /usr/share/git/completion/git-prompt.sh
    source /usr/bin/virtualenvwrapper.sh
    for completion_script in vagrant tmuxinator; do
        source /usr/share/bash-completion/completions/$completion_script
    done
elif [ -e "/etc/lsb-release" ]; then
    source /usr/local/bin/virtualenvwrapper.sh
    source_file /usr/share/doc/tmux/examples/bash_completion_tmux.sh
elif [ -e "/etc/redhat-release" ]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

# Ruby
# ====
export PATH="$PATH:$HOME/otto:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


# direnv
# ======
eval "$(direnv hook bash)"
