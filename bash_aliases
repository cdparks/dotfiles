# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Getting around
alias ..='cd ..; ls'

# More ways to ls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Copy/paste
alias pbcopy='xclip -i -selection clipboard'
alias pbpaste='xclip -o -selection clipboard'

# Databases
# Change this to temporarily use psql
export PSQL=pgcli
alias dbdev="PGPASSWORD=password $PSQL -h localhost -U postgres -d classroom_dev"
alias dbtest="PGPASSWORD=password $PSQL -h localhost -U postgres -d classroom_test"
alias dbscratch="$PSQL -h localhost -U postgres -d scratch"

# Switch to neovim
alias vim='nvim'
export EDITOR=nvim
