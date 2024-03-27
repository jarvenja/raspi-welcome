#!/bin/bash
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
#                  My Raspberry Pi welcome script
#         Copyright (c) 2024 <janne.jarvenpaa@gmail.com>
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#

checkTemp () {
	local number temp
	temp=$(vcgencmd measure_temp 2>/dev/null)
 	if [ -n "$temp" ]; then
		number="${temp:5:-2}"
		if (( $(echo "$number > 65.0" | bc -l) )); then temp+=" is hot!"
		elif (( $(echo "$number > 40.0" | bc -l) )); then temp+=" is warm."
		else temp+=" is fine."
		fi
	else
		temp="(Temperature not available)"
	fi
	echo "CPU $temp"
}

displayArt () { # [txtFile]
	local art
	art="${1:-./$(hostname).txt}"
	[ -f "$art" ] && cat "$art" || echo "*** [$art] ***"
 	echo
}

displayCmdStatus () { # commands...
	local installed missing
	installed="Installed:"
	missing="- Missing:"
	for cmd in "$@"; do
		[ $(command -v "$cmd") ] && installed+=" ${cmd}" || missing+=" ${cmd}"
	done
	printf "${installed}\n${missing}\n"
}

displayConnection () {
	local conn resp
	if [[ $(pstree -s $$) = *sshd* ]]; then conn="remote (ssh)"
	else
		conn="local; "
		resp=$(curl -Is http://www.google.com | head -n 1)
 		[ -z "${resp}" ] && conn+="No internet connection" || conn+="${resp}"
 	fi
	echo "Connection -=- $conn"
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


# This kind of script should be quick but informative
ensureBash
displayArt
displayCmdStatus "bc" "curl" "gcc" "java" "jq" "ncal" "python3" "tree"
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
printf "Its $(date)\n"
echo "Screen size: $(tput cols) x $(tput lines)"
displayConnection
checkTemp
