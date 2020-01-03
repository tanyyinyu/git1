#! /bin/bash
	pkill mysql
	rm -rf /data/mysql
        rm -rf /usr/local/mysql
cd /usr/local/src
if [ -f mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz ]
  then
	tar -zxf mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
  else 
	echo "there is no mysql.tar file"
	exit 1
fi
mv mysql-5.6.46-linux-glibc2.12-x86_64 ../mysql
    cd ../mysql
#     useradd mysql
     mkdir -p /data/mysql
    chown mysql:mysql /data/mysql
    ./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
sleep 1
    /usr/bin/cp support-files/mysql.server /etc/init.d/mysqld
     chkconfig --add mysqld
#yum install -y git
cd /root/
if [ ! -r git1 ]
  then
	git clone https://github.com/tanyyinyu/git1.git
fi
while :
  do
	read -p "please input to choose a cnf from (small,medium,large,huge):" n
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
	  *)    
                continue
                ;;
	esac
  done
/usr/bin/cp git1/$n/my.cnf /etc/my.cnf      
#echo "PATH=$PATH:/usr/local/mysql/bin/" >>/etc/profile
service mysqld start
        if [ $? -eq 0 ]; then
        echo "mysqld start successfully"
        else
        echo "fault"
        fi
