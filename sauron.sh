#!/bin/bash
GW_TARGET="$IP_ADDR"
JMP_USER="term"
if [ "$JMP_USER" == "" ] || [ "$GW_TARGET" == ""  ];then
        echo -e "$(basename $0):\n\tInvalid Target Information or No Target Information Provided:\n\t\t\tExiting in Error State Code: 2"
	exit 2& exit 2& logout
else
	if [ "$HUB" == "gw-residential" ];then
        	ssh -J $JMP_USER@172.28.50.11 de-iotcore@$GW_TARGET || ssh -J $JMP_USER@172.28.50.11 degw-admin@$GW_TARGET
	elif [ "$HUB" == "gw-default-prov" ];then
		ssh -J $JMP_USER@172.28.50.11 de-iotcore@$GW_TARGET
	elif [ "$HUB" == "" ] || [ -z $HUB ];then
		ssh -J $JMP_USER@172.28.50.11 de-iotcore@$GW_TARGET
	else
		echo -e "$(basename $0):\n\tInvalid Target Information or No Target Information Provided:\n\t\t\tExiting in Error State Code: 2"
		exit 2& exit 2& logout
	fi
		
fi
