#!/bin/bash

active=$(systemctl status postgresql | grep -w "active" | wc -l )
ipok=$(netstat -plntu | grep -e "tcp.*5432.*postgres" | wc -l)

if [ $active -eq 0 ]; then
	echo "$(date) - PostgreSQL down. Trying to restart." >> /etc/keepalived/log/psql_check.log
	systemctl start postgresql
	active=$(systemctl status postgresql | grep -w "active" | wc -l)

	if [  $active -eq 0 ]; then
	echo "$(date) "+"promoting standby. Check postgresql logs.">> /etc/keepalived/log/psql_check.log 
		if [ $ipok -eq 0 ]; then
		echo "Network inactive. Check postgresql logs for informations about the crash." >> /etc/keepalived/psql_check.log
		sudo systemctl stop keepalived 2> /tmp/error.txt 
		fi
	fi
fi
