echo "Must be root."
psql_dir="/var/lib/postgresql/11"
num=$( ls -l $psql_dir | wc -l ) 

cd  $psql_dir
mv main main-backup-$num 2> /tmp/trash

PATH=$PATH:/usr/lib/postgresql/11/bin
export PATH
echo "password should be replica"
pg_basebackup -h 10.0.3.200 -U replica -D main -P

touch $psql_dir/main/recovery.conf
echo  "# restore_command = 'cp /var/lib/postgresql/11/main/archive/%f %p'"  >> $psql_dir/main/recovery.conf
echo  "recovery_target_timeline = 'latest'" >> $psql_dir/main/recovery.conf
echo  "standby_mode = 'on'" >> $psql_dir/main/recovery.conf
echo  "primary_conninfo = 'host=10.0.3.200 port=5432 user=replica password=replica application_name=pgslave001'" >> $psql_dir/main/recovery.conf

chown -R postgres:postgres $psql_dir/main

echo "Slave rebuilt"
