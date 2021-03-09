#!/bin/bash
#
# Author: bwangel<bwangel.me@gmail.com>
# Date:2月,18,2021 07:55


######################################
#  安装 Redis
######################################

yum install -y redis
redis-cli -v
systemctl enable redis

sed -i -e 's/appendonly no/appendonly yes/g' /etc/redis.conf


######################################
#  配置 Linux 系统
######################################

# 关闭 selinux
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
yum clean all
yum makecache
yum install -y wget


########################################
## 安装 Java 和 perl
########################################

cd /usr/local/
files=$(find . | wc -l)
[[ $files != "1" ]] &&  rm -r *

egrep "JAVA_HOME" /home/vagrant/.bashrc >& /dev/null
if [ $? -ne 0 ]
then
  rpm -ivh /vagrant/jdk-7u65-linux-x64.rpm
  echo "=================== Setting JAVA_HOME Variable ==================="
  echo 'export JAVA_HOME=/usr/java/latest' >> /home/vagrant/.bashrc
  echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /home/vagrant/.bashrc
  echo 'export LC_ALL="en_US.UTF-8"' >> /home/vagrant/.bashrc
fi

/usr/java/latest/java -version

yum install -y perl
perl -v


######################################
#  配置 主机名
######################################

records=$(egrep 'eshop-cache' /etc/hosts | wc -l)
if [[ $records != "5" ]]; then
  echo "=================== Setting Hostname ==================="
  echo '172.17.8.101 eshop-cache1 eshop-cache1' >> /etc/hosts
  echo '172.17.8.102 eshop-cache2 eshop-cache2' >> /etc/hosts
  echo '172.17.8.103 eshop-cache3 eshop-cache3' >> /etc/hosts
  echo '172.17.8.104 eshop-cache4 eshop-cache4' >> /etc/hosts
fi
