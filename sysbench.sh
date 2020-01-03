tt=`date +%Y-%m-%d`
read -p "please input test config (small,medium,large,huge):" con
read -p "please input test table numbers:" tn
read -p "please input test table size:" ts 
read -p "please input test threads numbers:" tr
read -p "please input test time(120 or other):" t1
read -p "other comment (serve config):" other
echo "test of $con config,$tn tables, size:$ts, threads:$tr, $t1 second at $other $tt" >> ~/mysql.log 
mysql -uroot -e "create database testdb"
sysbench --mysql-host=127.0.0.1 --mysql-user=root  --mysql-db=testdb --report-interval=10 --time=$t1 --tables=$tn --table-size=$ts --threads=$tr /usr/share/sysbench/oltp_read_write.lua prepare
sysbench --mysql-host=127.0.0.1 --mysql-user=root  --mysql-db=testdb --report-interval=10 --time=$t1 --tables=$tn --table-size=$ts --threads=$tr /usr/share/sysbench/oltp_read_write.lua run |egrep "transactions|queries" >> ~/mysql.log
sysbench --mysql-host=127.0.0.1 --mysql-user=root  --mysql-db=testdb --report-interval=10 --time=$t1 --tables=$tn --table-size=$ts --threads=$tr /usr/share/sysbench/oltp_read_write.lua cleanup
tail  ~/mysql.log
