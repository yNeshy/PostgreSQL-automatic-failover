#!/bin/bash

active=$(systemctl status postgresql | grep -w "active" | wc -l )
ipok=$(netstat -plntu | grep -e "tcp.*5432.*postgres" | wc -l)

if [ $active -eq 0 ]; then
	echo "$(date) "+promoting standby. Check postgresql logs.">> /etc/keepalived/log/psql_check.log 
	if [ $ipok -eq 0 ]; then
		echo "Network inactive. Check postgresql logs for informations about the crash." >> /etc/keepalived/psql_check.log
	fi
	systemctl stop keepalived
fi
