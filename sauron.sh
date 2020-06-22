#!/bin/bash
MSG="General Error - Fatal Error"
_funEXIT() {
exit $1& exit $1& exit $1
}
_funERR() {
if [ "$1" == "" ];then
	MSG=$MSG
else
	$MSG=$1
echo -e "$(basename $0):\n\t$MSG:\n\t\t\tExiting in Error State Code: 2"
}
#SSH Jump Function Accepts No Arguments / Returns Exit Status
_funJMP() {
	returnCode=""
	if [ "$HUB" == "gw-residential" ];then
        	ssh -J $JMP_USER@172.28.50.11 de-iotcore@$GW_TARGET
		returnCode=$?
		if [ $returnCode -eq 0 ]; then
			_funEXIT 1
		elif [$returnCode -ne 0; then
			ssh -J $JMP_USER@172.28.50.11 degw-admin@$GW_TARGET
			returnCode=$?
			if [ $returnCode -eq 0 ]; then
				_funEXIT 1
			elif [ $returnCode -ne 0 ];then
				_funERR "Unable to establish SSH connection."
				_funEXIT 2
			fi
		fi
	elif [ "$HUB" == "gw-default-prov" ];then
		ssh -J $JMP_USER@172.28.50.11 de-iotcore@$GW_TARGET
		if [ $? -eq 0 ]; then
			_funEXIT 1
		elif [ $? -ne 0 ]; then
			ssh -J $JMP_USER@172.28.50.11 degw-admin@$GW_TARGET
			if [ $? -eq 0 ]; then
				_funEXIT 1
			elif [ $? -ne 0 ]
			_funERR "Unable to establish SSH connection."
			fi
#	elif [ "$HUB" == "gw-template-future ];then
#		ssh -J $JMP_USER@172.28.50.11 de-iotcore@$GW_TARGET
#		if [ $? -eq 0 ]; then
#			_funEXIT 1
#		elif [ $? -ne 0 ]; then
#			ssh -J $JMP_USER@172.28.50.11 degw-admin@$GW_TARGET
#			if [ $? -eq 0 ]; then
#				_funEXIT 1
#			elif [ $? -ne 0 ]
#			_funERR "Unable to establish SSH connection."
#			fi
		
	elif [ "$HUB" == "" ] || [ -z $HUB ];then
		_funERR "Not A Valid Hub: Cannot Use Target Information Provided"
		_funEXIT 2
	else
		_funERR "Invalid Target Information or No Target Information Provided"
		_funEXIT 2
	fi

}
GW_TARGET="$IP_ADDR"
JMP_USER="term"
if [ "$JMP_USER" == "" ] || [ "$GW_TARGET" == ""  ] ;then
        _funERR "Invalid Target Information or No Target Information Provided"
	_funEXIT 2
else
	_funJMP	
fi
