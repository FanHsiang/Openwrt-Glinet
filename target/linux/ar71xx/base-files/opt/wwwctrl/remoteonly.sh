#!/bin/sh
basedir=/opt/wwwctrl/remote_only_scripts
user=$1
echo ""
echo "Welcome [$user] login ONT!"
#show help
$basedir/help $user

while read -p '$ ' proginput args; do
	prog=`basename $proginput` 2> /dev/null
    if [ ! -x "$basedir/$prog" ]; then
        echo "Invalid program: $proginput"
		read -n1 -r -p "Press any key to Exit..." key
		exit 0
    elif [ "$prog" == "monitor" -a "x$user" != "xcht" ]; then
		#Not "cht" can't exec monitor
        echo "Invalid program: $proginput"
		read -n1 -r -p "Press any key to Exit..." key
		exit 0
    else
        case "$prog $args" in
            *\**|*\?*|*\^*|*\&*|*\<*|*\>*|*\|*|*\;*|*\`*|*\[*|*\]*)
                echo "Invalid character in command"
				;;
            *)
                eval "$basedir/$prog $args $user" 2> /dev/null
                echo
				;; # force a trailing newline after the program
        esac
    fi
done
exit 0
