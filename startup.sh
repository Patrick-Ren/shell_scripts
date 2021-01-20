#!/bin/bash

# install common softwares
apt update && yes Y | apt install zsh vim snapd curl tldr tree net-tools dnsutils language-pack-zh-hans

# chang shell to zsh
chsh -s "$(which zsh)" && echo "switched login shell to zsh, you may need to re-login for this to take effect"

# set timezone to Asia/Shanghai
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "timzone is set to Asia/Shanghai"

# custom vim config
curl -L https://raw.githubusercontent.com/librz/shell_scripts/main/.vimrc > ~/.vimrc
# custom zsh config
curl -L https://raw.githubusercontent.com/librz/shell_scripts/main/.zshrc > ~/.zshrc

echo "custom .vimrc and .zshrc is in place"

# change ssh listen port(sshd port) to 9000, set ClientAliveInterval to 5 seconds
sed -i 's/#Port 22/Port 9000/g' /etc/ssh/sshd_config
sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 5/g' /etc/ssh/sshd_config
echo "ssh listen port is set to 9000, ClientAliveInterval is set to 5"
echo "restarting sshd, you'll be disconnected if you are using ssh, wait for a minute and relogin"
service sshd restart
