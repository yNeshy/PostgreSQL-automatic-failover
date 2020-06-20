has_vip=$(ip -brief address show | grep "10.0.3.200" | wc -l)
if [ "$has_vip" -eq "1"  ]
then
	is_slave=$(ls /var/lib/postgresql/11/main/* | grep -w "recovery.conf" | wc -l )
	if [ "$is_slave" -eq "1" ]
	then
		echo "$(date)"+" - Master is down. Waiting for reconnection (2sec)." >> /etc/keepalived/log/psql_check.log
		sleep 2
		has_vip=$(ip -brief address show | grep "10.0.3.200" | wc -l)
		if [ "$has_vip" -eq "1" ]
		then
			echo "$(date)"+" - Master did not reconnect." >> /etc/keepalived/log/psql_check.log
			echo "$(date)"+" transitioning to Master" >> /etc/keepalived/log/psql_check.log
			PATH=$PATH:/usr/lib/postgresql/11/bin
			export PATH

			pg_ctlcluster 11 main promote 2 >> /etc/keepalived/log/psql_check.log
			systemctl restart postgresql
			tail -n 5 /var/log/postgresql/postgresql-11-main.log >> /etc/keepalived/log/psql_check.log
			is_slave=$(ls /var/lib/postgresql/11/main/* | grep -w "recovery.conf" | wc -l )
			if [ "$is_slave" -eq "0" ];
			then
				echo "Failover completed. Ready to acception write requests." >> /etc/keepalived/log/psql_check.log
			else
				echo "Failover FAILED. Examin postgresql logs" >> /etc/keepalived/log/psql_check.log
			fi
		fi
	fi
fi
