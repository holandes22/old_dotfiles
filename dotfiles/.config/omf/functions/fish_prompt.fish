# Theme based on Bira theme from oh-my-fish
# https://github.com/oh-my-fish/oh-my-fish/blob/master/docs/Themes.md#bira

function __user_host
  set -l content
  set -l hname (hostname|cut -d . -f 1)
  echo -n (set color --bold green) $USER@(set_color blue)$hname (set color normal)
end


function __current_path
  set -l path (echo -n (pwd) | sed "s:$HOME:~:" | sed "s:/\(.\)[^/]*:/\1:g" | sed "s:/[^/]*\$:/"(basename (pwd))":")
  echo -n (set_color green) $path (set color normal)
end


function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end


function _git_is_dirty
  echo (command git status -s --untracked-files=no)
end


function __git_status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)
    set -l git_info '[ git:'$git_branch']'
    set -l suffix ""
    if [ (_git_is_dirty) ]
      set suffix "±"
    end

    echo -n (set_color yellow)$git_info(set_color red)$suffix(set_color normal)
  end
end


function __virtualenv
  if test $VIRTUAL_ENV
    set -l venv (basename "$VIRTUAL_ENV")
    echo -n (set_color white)‹$venv›(set_color normal)
  end
end

function fish_prompt
  set -l prompt_symbol "\$"
  if [ (id -u) = "0" ];
    set prompt_symbol "#"
  end

  echo -n (set_color white)"┌"(set_color normal)
  __user_host
  __current_path
  __git_status
  __virtualenv
  echo -e ''
  echo (set_color white)"└"(set_color --bold white)$prompt_symbol (set_color normal)
end

function fish_right_prompt
  set -l st $status

  if [ $st != 0 ];
    echo (set_color red) ↵ $st(set_color normal)
  end
end
