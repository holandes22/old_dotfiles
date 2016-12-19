# TODO
# - rm/create virtualenv functions
#

alias mux=tmuxinator
alias ovim=/usr/bin/vim
alias vim=/usr/bin/nvim

source $HOME/.config/omf/functions/fish_prompt.fish

set -g -x EDITOR vim
set -g -x VIRTUAL_ENV_DISABLE_PROMPT 1

function workon
  if [ (count $argv) -lt 1 ]
    echo "You need to specify a virtualenv"
    return 1
  end
  set -l venv $argv[1]
  set -l path $HOME/.virtualenvs/$venv/bin/activate.fish
  set -l project_path $HOME/projects/$venv

  ls $path > /dev/null 2>&1
  if test $status -eq 0
    source $HOME/.virtualenvs/$venv/bin/activate.fish
    ls $project_path > /dev/null 2>&1
    if test $status -eq 0
      cd $project_path
    end

  else
    echo "Cannot find virtualenv $venv"
    return 1
  end
end
