#! /bin/bash
cd /usr/local/src
yum install -y wget  #normally get the mysql.tar from other computer;
wget -c https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
if [ -f mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz ]
  then
	tar -zxvf mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
  else 
	echo "there is no mysql.tar file"
	exit 1
fi
mv mysql-5.6.46-linux-glibc2.12-x86_64 ../mysql
    cd ../mysql
     useradd mysql
     mkdir -p /data/mysql
    chown mysql:mysql /data/mysql
     yum install -y perl-5.16.3-294.el7_6.x86_64
   yum install -y perl-Data-Dumper
    yum install -y libaio-devel
    ./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
sleep 1
    cp support-files/mysql.server /etc/init.d/mysqld
     chkconfig --add mysqld
cd /root/
if [ ! -d mysql-sysbench-test ]
  then
	echo "there is no config dir"
	exit 1
fi
while :
  do
	read -p "please input to choose a cnf from (small,medium,large,huge,websetfor4G,webset2for2G):" n
	case "$n" in
	  'small')
		break
		;;
	  'medium')
		break
		;;
	  'large')    
                break
                ;;
	  'huge')    
                break
                ;;
	  'websetfor4G')
		break
		;;
	  'webset2for2G')
		break
		;;
	  *)    
                continue
                ;;
	esac
  done
/usr/bin/cp mysql-sysbench-test/$n/my.cnf /etc/my.cnf      
echo "export PATH=$PATH:/usr/local/mysql/bin/" >>/etc/bashrc
source /etc/bashrc
sleep 1
service mysqld start
        if [ $? -eq 0 ]; then
        echo "mysqld start successfully"
        else
        echo "fault"
        fi
ln -s /tmp/mysql.sock /var/lib/mysql/mysql.sock  #sysbench 自动使用后面的sock文件；
/usr/local/mysql/bin/mysqldump -uroot -A > /root/newdump.sql
yum install -y sysbench
