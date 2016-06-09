#!/bin/zsh

try() {
$* || (echo "\nfailed" 1>&2 && exit 1)
}

spit_msg() {
echo "\n[x] $1"
}

spit_msg "Updating babun and changing mirror to australia"
try pact update -m http://mirror.internode.on.net/pub/cygwin/

spit_msg "Installing tree..."
try pact install tree

spit_msg "Installing tmux..."
try pact install tmux

spit_msg "Install lua (Required for vim lua support)"
pact install lua

spit_msg "Installing the_silver_searcher (ag)"
try pact install the_silver_searcher

spit_msg "Setting up config for Git"
try git config --global user.name "Swoorup Joshi"
try git config --global core.autocrlf input # fix issues with crlf and lf on unix and windows 
#try git config --global user.email "mail@swoorup.me"

spit_msg "Grabbing fatty terminal from source..."
try pact install gcc-core gcc-g++
try git clone https://github.com/juho-p/fatty.git
try cd fatty

spit_msg "Building fatty..."
try make
spit_msg "Replacing mintty with fatty..."
pact remove mintty
try cp src/fatty.exe /bin
try ln -s /bin/fatty /bin/mintty
spit_msg "Making changes to babun.bat"
try sed -i s/mintty/fatty/g $BABUN_HOME/babun.bat

spit_msg "Using vimrc from https://github.com/Swoorup/archlinux-dotfiles"
try curl https://raw.githubusercontent.com/Swoorup/archlinux-dotfiles/master/neovim/.config/nvim/init.vim -o ~/.vimrc

spit_msg "Using tmux configs from https://github.com/gpakosz/.tmux"
try curl https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf -o ~/.tmux.conf
try curl https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf.local -o ~/.tmux.conf.local

spit_msg "Using color mappings from https://github.com/trapd00r/LS_COLORS"
try curl https://raw.githubusercontent.com/trapd00r/LS_COLORS/master/LS_COLORS -o ~/.dircolors
try echo 'eval $( dircolors -b $HOME/.dircolors )' >> ~/.zshrc

spit_msg "Adding useful aliases and exports to zshrc"
cat <<EOF >> ~/.zshrc
alias tree='tree -C'
export EDITOR=vim
export PAGER=less
export LESS='-R'
EOF

spit_msg "Using solarized dark theme and powerconsolas for mintty"
try curl https://gist.githubusercontent.com/Swoorup/b63d372f9d94253f5ab80d8b53ab15b5/raw/.minttyrc -o ~/.minttyrc

source ~/.zshrc
