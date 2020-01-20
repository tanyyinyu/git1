#! /bin/bash
tt=`date`
read -p "please input test config (small,medium,large,huge):" con
read -p "please input test table numbers:" tn
read -p "please input test table size:" ts
read -p "please input test threads numbers:" tr
read -p "please input test time(120 or other):" t1
read -p "other comment (serve config):" other
echo "test of $con config,$tn tables, size:$ts, threads:$tr, $t1 second at $other from network $tt" >> ~/mysql.log
mysql -h172.18.13.148 -uroot -ppassword -e "create database testdb"
sysbench --mysql-host=172.18.13.148 --mysql-user=root --mysql-password=password --mysql-db=testdb --report-interval=10 --time=$t1 --tables=$tn --table-size=$ts --threads=$tr /usr/share/sysbench/oltp_read_write.lua prepare
sysbench --mysql-host=172.18.13.148 --mysql-user=root --mysql-password=password --mysql-db=testdb --report-interval=10 --time=$t1 --tables=$tn --table-size=$ts --threads=$tr /usr/share/sysbench/oltp_read_write.lua run |egrep "transactions|queries" >> ~/mysql.log
sysbench --mysql-host=172.18.13.148 --mysql-user=root --mysql-password=password --mysql-db=testdb --report-interval=10 --time=$t1 --tables=$tn --table-size=$ts --threads=$tr /usr/share/sysbench/oltp_read_write.lua cleanup
mysql -h172.18.13.148 -uroot -ppassword -e "drop database testdb"
tail -5  ~/mysql.log
