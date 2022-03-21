# set prompt
PROMPT=$'\n%F{cyan}%n%f in %B%~%b%(2j. %F{red}[%j jobs]%f.%(1j. %F{red}[%j job]%f.))\n %(!.#.+) '

# case-insensitive globbing
setopt NO_CASE_GLOB
# allow tab to actually complete commands
setopt GLOB_COMPLETE

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

# paths
add_to_path=(
  '/usr/local/bin'
  '/opt/homebrew/bin'
  "$HOME/.local/bin"
)

for new_path in "${add_to_path[@]}"; do
  if [ -d "$new_path" ]; then
    export PATH="$new_path:$PATH"
  else
    printf 'missing path %s\n' "$new_path"
  fi
done

source ~/.zsh_aliases

# FZF
[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"

# Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ghcup
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
