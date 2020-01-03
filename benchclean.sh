pkill mysql
rm -rf /data/mysql
/usr/bin/cp -r /data/mysql.bak/ /data/mysql
shell>sync 
shell>echo 3 >/proc/sys/vm/drop_cache 

