# set prompt
PROMPT=$'\n%F{cyan}%n%f in %B%~%b%(2j. %F{red}[%j jobs]%f.%(1j. %F{red}[%j job]%f.))\n %(!.#.+) '

# case-insensitive globbing
setopt NO_CASE_GLOB
# allow tab to actually complete commands
setopt GLOB_COMPLETE

# emacs line-editing controls (ctrl-A, ctrl-E, etc.)
bindkey -e

# allow comments at interactive prompt
setopt interactivecomments

# if a directory is used like a command, cd into that directory
# setopt AUTO_CD

# share history across multiple zsh sessions
setopt SHARE_HISTORY

# append to history
setopt APPEND_HISTORY

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=5000
HISTSIZE=2000

# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY

# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS

# verify command copied from !!
setopt HIST_VERIFY

# auto-correct mistyped commands
setopt CORRECT
setopt CORRECT_ALL

# sources
sources=(
  "$HOME/.zsh_aliases"
  "$HOME/.fzf.zsh"
  "$HOME/.cargo/env"
  "$HOME/.ghcup/env"
)

for new_source in "${sources[@]}"; do
  if [ -f "$new_source" ]; then
    source "$new_source"
  else
    printf 'missing source %s\n' "$new_source"
  fi
done

# ssh agent
[ -f "$HOME/.ssh" ] && ssh-add -A

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# more llvm
if [ -d "/opt/homebrew/opt/llvm@12" ]; then
  export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"
fi

# add paths to control priority
add_to_path=(
  '/usr/local/bin'
  '/usr/local/homebrew/bin'
  '/opt/homebrew/bin'
  "$HOME/.local/bin"
  '/opt/homebrew/opt/llvm@12/bin'
)

for new_path in "${add_to_path[@]}"; do
  if [ -d "$new_path" ]; then
    export PATH="$new_path:$PATH"
  else
    printf 'missing path %s\n' "$new_path"
  fi
done

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
