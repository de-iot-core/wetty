#!/bin/bash
GW_TARGET="$IP_ADDR"
JMP_USER="term"
if [ "$JMP_USER" == "" ] || [ "$GW_TARGET" == ""  ];then
        echo -e "$(basename $0):\n\tInvalid Target Information or No Target Inforamtion Provided:\n\t\t\tExiting in Error State Code: 2"
	exit 2
else
        ssh -J $JMP_USER@172.28.50.11 degw-admin@$GW_TARGET
fi
