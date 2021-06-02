#!/bin/bash


#Install PHP, Apache, MySQL
sudo apt clean all
sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y mysql-server* apache2* php7.4-gd php7.4-bcmath php7.4-cgi php7.4-cli php7.4-opcache php7.4-common php7.4-sybase php7.4-bcmath php7.4-ctype php7.4-curl php7.4-dom php7.4-gd  php7.4-iconv php7.4-intl php7.4-mbstring  php7.4-simplexml php7.4-soap php7.4-xsl php7.4-zip php7.4-fpm

sudo systemctl restart php7.4-fpm mysql apache2


#Download Zabbix Repository
wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu20.04_all.deb 
sudo dpkg -i zabbix-release_5.4-1+ubuntu20.04_all.deb


# Installing Zabbix
sudo apt clean all
sudo apt update
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent 


# Creating Zabbix DB
sudo mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin"
sudo mysql -uroot -e "create user zabbix@localhost identified by 'password'"
sudo mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost"


#Configuring Zabbix
sudo zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | sudo mysql -uroot  zabbix 
sudo sed -i 's/# DBPassword=/DBPassword=password/g' /etc/zabbix/zabbix_server.conf
#sudo sed -i 's|# php_value date.timezone Europe/Riga|php_value date.timezone America/New_York|g' /etc/zabbix/apache.conf


# Restarting and Enabling the Server
sudo systemctl restart zabbix-server zabbix-agent apache2 php7.4-fpm mysql 
sudo systemctl enable zabbix-server zabbix-agent apache2 php7.4-fpm mysql
