# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Navigation
alias ..='cd ..; ls'

# More ways to ls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Copy/paste
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias pbcopy='xclip -i -selection clipboard'
  alias pbpaste='xclip -o -selection clipboard'
fi

# Switch to neovim
alias vim='nvim'
export EDITOR=nvim
export PSQL_EDITOR="/usr/bin/nvim"

# Databases
# Change this to temporarily use psql
export PSQL=pgcli

authdb() {
  RAILS_ENV="$1" USE_RDS_IAM_AUTH="$2" ~/code/megarepo/sql/scripts/run-command-ssh-tunnel.sh $PSQL
}

localdb() {
  PGPASSWORD=password PGHOST=localhost PGUSER=postgres $PSQL -d "$1"
}

dbprod() {
  authdb production ''
}

dbstaging() {
  authdb staging x
}

dbdemo() {
  authdb demo x
}

dbanalytics() {
  authdb production_engineer_readonly x
}

dbdev() {
  localdb classroom_dev
}

dbtest() {
  localdb classroom_test
}

# Broadcast my mistakes
__sl() {
  if [[ ! -e /tmp/trombone.ogg ]]; then
    curl -s https://wompwompwomp.com/audio/sad-trombone.ogg > /tmp/trombone.ogg
  fi;
  canberra-gtk-play --file="/tmp/trombone.ogg"
}

sl() {
  (__sl &)
}
