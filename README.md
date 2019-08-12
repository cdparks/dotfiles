# Dotfiles

## Installation

```console
wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
echo "deb https://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
sudo apt-get update
sudo apt-get install rcm
git clone https://github.com/cdparks/dotfiles
RCRC=$HOME/dotfiles/rcrc rcup -v
```

## Uninstallation

```console
rcdn -v
```
