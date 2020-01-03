pkill mysql
rm -rf /data/mysql
/usr/bin/cp -r /data/mysql.bak/ /data/mysql
sync 
service mysqld start
#echo 3 >/proc/sys/vm/drop_cache #云机器不能清除缓存;

