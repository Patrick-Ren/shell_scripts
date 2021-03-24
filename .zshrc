#!/bin/zsh

# zsh is not supported by shellcheck, force it: shellcheck --shell=bash ~/.zshrc

# print error to stderr
err() {
	echo "$1" >&2
}

# print distro
distro() {
	# linux has /etc/os-release 
	if [[ -e /etc/os-release ]]; then
		# shellcheck disable=SC1091
		source /etc/os-release
	 	# /etc/os-release when sourced, give us the NAME variable	
		if grep -i debian "$NAME" &>/dev/null; then
			echo "Debian"
		elif grep -i ubuntu "$NAME" &>/dev/null; then
			echo "Ubuntu"
		else
			echo "$NAME"
		fi
	else
		# use uname, print Darwin on mac
		if uname | grep -i darwin &>/dev/null; then
			echo "macOS"
		else
			echo uname
		fi
	fi
}

# set zsh to use vi mode & remap escape key to jk
bindkey -v
bindkey jk vi-cmd-mode

# nice simple colored prompt
export PS1="%10F%m%f:%11F%1~%f \$ "

# set terminal tab-width to be 4 columns 
tabs -4

# locale setting
export LC_ALL="en_US.UTF-8"
export LANG="zh_CN.UTF-8"

# set vim as default editor
if [[ $(distro) == "Debian" || $(distro) == "Ubuntu" ]]; then
	update-alternatives --set editor /usr/bin/vim.basic
else
	# export EDITOR as environment variable
	# this will set vim as default editor on macOS
	EDITOR=$(which vim)
	export EDITOR
fi

# ---- below are handy aliases and functions ----

# edit/source zsh config
alias zc='vim ~/.zshrc'
alias sz="source ~/.zshrc"
# edit vim config
alias vc="vim ~/.vimrc"

alias b="cd .."
alias c='clear'
alias v='vim'
alias h='history'
alias w='which'
alias bye='exit'

# long formated ls sort by file size
alias lls="ls -alhS"

# gh for go home
alias gh="cd ~"

# p5 for ping 5 times
alias p5="ping -c 5"

# pubip & myip for public ip address
# ifconfig.me & ident.me both provide this type of service
alias pubip="curl ifconfig.me"
alias myip="curl ident.me"

# -------- git related ---------
# sac: stage all changes and commit
alias sac="git add . && git commit -m"

# gs: git status
alias gs="git fetch && git status"
# -------- end of git related ------

# mcd for mkdir && cd
mcd() {
	mkdir "$1" && cd "$1" || return
}

# today in format "YYYY-MM-DD"
today () {
	if [[ $(distro) == "macOS" ]]; then
		date "+%Y-%m-%d"
	else
		date --rfc-3339=date
	fi
}

# how much disk space is left
space () {
	if [[ $(distro) == "macOS" ]]; then
		err "macOS is not supported"
	else
		df -h | awk '($6=="/"){print $5, "of", $2, "is used"}'
	fi
}

# sop: scan open port
sop () {
	# netstat works very differently in Linux & BSD based systems such as macOS
	if [[ $(distro) == "macOS" ]]; then
		netstat -n -f inet -p tcp | awk 'NR>2{print $4}' | awk -F'.' '{print $NF}' | sort -n | uniq
	elif [[ $(distro) == "Debian" || $(distro) == "Ubuntu" ]]; then
		netstat -tln | awk '(NR>2) {print $4}' | awk -F':' '{print $NF}' | sort -n | uniq
	else
		err "you system is not supported"
		# dont't use exit here, cause it quit the current shell
	fi
}

# 3p: program, pid, port
alias 3p="bash <(curl -sL http://realrz.com/shell-scripts/3p.sh)"

# print file as binary string
binary () {
	xxd -b -c 1 "$1" \
	| awk '{print $2}' \
 	| tr -d '\n' && echo	
}

# print file as hex string
hex () {
	xxd -c 1 "$1" \
	| awk '{print $2}' \
	| tr -d '\n' && echo
}

# print out cool emoji 
cool () {
	# f09f988e is utf-8 hex code for emoji(smiling face with sunglasses)
	# 0a is ascii/utf-8 for line feed
	echo -n "f09f988e0a" | xxd -r -p
}

# source mac specific zsh setting
# .zshrc_mac_specific should remain private since it contains sensitive info such as IP address
if [[ -e ~/.zshrc_mac_specific ]]; then
	source ~/.zshrc_mac_specific
fi
