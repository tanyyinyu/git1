pkill mysql
sync 
service mysqld restart
mysql -uroot < /root/newdump.sql

#echo 3 >/proc/sys/vm/drop_cache #云机器不能清除缓存;

