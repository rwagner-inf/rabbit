#!bin/bash

#Install erlang
rpm -ivh http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
yum install erlang -y



#Install rabbitmq
#Import key
rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc

#Create repo
cat <<EOT >> /etc/yum.repos.d/rabbitmq.repo
[bintray-rabbitmq-server]
name=bintray-rabbitmq-rpm
baseurl=https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.7.x/el/7/
gpgcheck=0
repo_gpgcheck=0
enabled=1
EOT

#Install
sudo yum install rabbitmq-server -y

#Enable and start
sudo systemctl enable rabbitmq-server && sudo systemctl start rabbitmq-server

#Add and Configure admin user and permition
sudo rabbitmqctl add_user admin admin && sudo rabbitmqctl set_user_tags admin administrator && sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

#Firewall Rules
sudo firewall-cmd --zone=public --permanent --add-port=4369/tcp --add-port=25672/tcp --add-port=5671-5672/tcp --add-port=15672/tcp --add-port=61613-61614/tcp --add-port=1883/tcp --add-port=8883/tcp
sudo firewall-cmd --reload

#Enable plugin 
sudo rabbitmq-plugins enable rabbitmq_management