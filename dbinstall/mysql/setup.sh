#!/bin/bash

wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum update
yum install -y mysql-server
chown -R mysql:mysql /var/lib/mysql/
mysqld --initialize
systemctl start mysqld
mysqladmin -u root password "123456"