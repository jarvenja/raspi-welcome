#!/bin/bash
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
#              My Raspberry Pi welcome script
#         Copyright (c) 2024 <jarvenja@gmail.com>
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#

checkBt () {
	local bt dev
	bt="Bluetooth"
  	dev=$(hcitool dev | tr -d '\n' | sed 's/\t/ /g' | sed "s/^Devices://g")
 	[ -z "$dev" ] && echo "$(dim $bt:) No adapter found." || echo -e "\e[94m$bt:\e[39m $dev"
 }

checkTemp () {
	local number temp
	temp=$(vcgencmd measure_temp 2>/dev/null)
 	if [ -n "$temp" ]; then
		number="${temp:5:-2}"
		if [ -z $(command -v "bc") ]; then temp+=" (bc required for comparison)"
		elif (( $(echo "$number > 65.0" | bc -l) )); then temp+=" is \e[33mhot!\e[39m"
		elif (( $(echo "$number > 40.0" | bc -l) )); then temp+=" is \e[38;5;208mwarm\e[39m."
		else temp+=" is \e[33mfine\e[39m."
		fi
	else
		temp=$(dim "temperature not available")
	fi
	echo -e "$(dim CPU) $temp"
}

defaultAscii () {
	cat << "***"
 '|| '||'  '|'         '||                                    
  '|. '|.  .'    ....   ||    ....    ...   .. .. ..     .... 
   ||  ||  |   .|...||  ||  .|   '' .|  '|.  || || ||  .|...||
    ||| |||    ||       ||  ||      ||   ||  || || ||  ||     
     |   |      '|...' .||.  '|...'  '|..|' .|| || ||.  '|...'
***
}

dim () { # str
	echo -e "\e[2m${1}\e[0m"
}

displayArt () { # [txtFile]
	local art
	art="${1:-./$(hostname).txt}"
	[ -f "$art" ] && cat "$art" || defaultAscii
	echo
}

displayCmdStatus () { # commands...
	local installed missing
	for cmd in "$@"; do
		[ $(command -v "$cmd") ] && installed+=" ${cmd}" || missing+=" ${cmd}"
	done
	echo -e "$(dim 'Commands:')" $(green "${installed}")
	echo -e "$(dim '-missing:')" $(red "${missing}")
}

displayConnection () {
	local conn resp
	if [[ $(pstree -s $$) = *sshd* ]]; then conn="remote (ssh)"
	else
		conn="local; "
		resp=$(curl -Is http://www.google.com | head -n 1)
 		[ -z "${resp}" ] && conn+="No internet connection" || conn+="${resp}"
 	fi
	echo "$(dim 'Connection -=-') $conn"
}

displayHw () {
	local rpi
	rpi="/proc/device-tree/model"
 	[ -f "$rpi" ] && echo "$(dim SBC:) $(tr -d '\0' <${rpi})" || inxi
}

displayOs () {
	local key os
	key="PRETTY_NAME"
	os=$(cat /etc/os-release | grep "$key")
	os=$(sed "s/${key}=\"/$(dim 'OS: ')/g" <<< "$os")
	echo -e "${os::-1}"
}

ensureBash () {
	local x
	x=$(getShellType)
	[ "$x" != "bash" ] && fatal "Must be run by bash instead of $x"
}

fatal () { # msg
	echo "Fatal Error: ${1}" >&2
	exit 1
}

getShellType () {
	local x
	x=$(ps -p $$)
	echo "${x##* }"
}

green () { # txt
	echo -e "\e[92m${1}\e[39m"
}

invalidArgs () { # args
	fatal "Invalid arguments $@"
}

red () { # txt
	echo -e "\e[91m${1}\e[39m"
}

separator () {
	for shade in {255..236}; do
		echo -en "\e[38;5;${shade}m><><"
	done
	echo -e "\e[39m"
}

usage () {
	echo "><><>< raspi-welcome $VERSION"
	echo "usage: $0 [ascii-art-file]" 
}

ensureBash
readonly VERSION="v0.2 beta"
if [ $# -gt 1 ]; then usage
else 
	clear
	displayArt "${1}"
	separator
	echo "$(dim 'Arch:') $(uname -m) ($(getconf LONG_BIT)-bit)"
	checkTemp
	displayHw
	checkBt
	separator
	displayOs
	displayCmdStatus "bc" "curl" "git" "inxi" "java" "python3" "tree" # <- list your mix here...
	separator
	echo -e "$(dim 'Its') $(date)"
	echo -e "$(dim 'Screen size:') $(tput cols) x $(tput lines)"
	displayConnection
	separator
fi