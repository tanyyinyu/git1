#! /bin/bash

#definations
DATE=`date +%Y-%m-%d`
LOG=/root/"$DATE"sysbench.log

### need to be updated;
#mysql
SQL_ID=root
SQL_PW=password
SQL_HOST=localhost
SQL_PORT=3306

#sysbench
# choose from oltp_read_only.lua, oltp_read_write.lua, oltp_write_only.lua, select_random_points.lua select_random_ranges.lua
# test/test_run.sh
TEST_LUA=/usr/share/sysbench/oltp_read_write.lua
TIME=60
T_NUM=4
T_SIZE=10000
THREADS=50

#t2 run times
T2=1

info () {
  lscpu |grep "CPU(s):" >> $LOG ;lscpu |grep "Thread" >> $LOG; lscpu |grep "GHz" >> $LOG
  head -1 /proc/meminfo >> $LOG
  echo "--time=$TIME --tables=$T_NUM --table-size=$T_SIZE --threads=$THREADS $TEST_LUA $T2 times" >> $LOG
}

check_sysbench () {
  if which sysbench
    then 
	echo "ok"
    else
  	curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.rpm.sh | sudo bash
	sudo yum -y install sysbench	
  fi
}

check_mysql () {
  if which mysql
    then
	echo "ok"
    else
	echo "there is no mysql or no links for it"
        exit
  fi
}

#prepare
prepare () {
  mysql -u$SQL_ID -p$SQL_PW -h$SQL_HOST -P$SQL_PORT -e "drop database testdb"
  mysql -u$SQL_ID -p$SQL_PW -h$SQL_HOST -P$SQL_PORT -e "create database testdb" 
}

clean () {
  mysql -u$SQL_ID -p$SQL_PW -h$SQL_HOST -P$SQL_PORT -e "drop database testdb"
  sync 
  service mysqld restart
}

show () {
  tail $LOG
}

average () {
    for TRANS in `tail -$(($T2*8)) $LOG |grep "transaction"|awk '{print $2}'`
	do
	  SUM=$((SUM+TRANS)) 
 	 done
    echo $SUM
    echo "average Transaction is $(($SUM/$T2))"
    echo "average Transaction is $(($SUM/$T2))" >> $LOG
}

for i in `seq 1 $T2`
do
  info
  check_sysbench
  check_mysql
  prepare
  sysbench --mysql-host=$SQL_HOST --mysql-port=$SQL_PORT --mysql-user=$SQL_ID --mysql-password=$SQL_PW --mysql-db=testdb --report-interval=10  --time=$TIME --tables=$T_NUM --table-size=$T_SIZE --threads=$THREADS     $TEST_LUA prepare
  sysbench --mysql-host=$SQL_HOST --mysql-port=$SQL_PORT --mysql-user=$SQL_ID --mysql-password=$SQL_PW --mysql-db=testdb --report-interval=10  --time=$TIME --tables=$T_NUM --table-size=$T_SIZE --threads=$THREADS     $TEST_LUA run |egrep "transactions|queries" >> $LOG
  sysbench --mysql-host=$SQL_HOST --mysql-port=$SQL_PORT --mysql-user=$SQL_ID --mysql-password=$SQL_PW --mysql-db=testdb --report-interval=10  --time=$TIME --tables=$T_NUM --table-size=$T_SIZE --threads=$THREADS     $TEST_LUA cleanup
  clean
  show
done
average
