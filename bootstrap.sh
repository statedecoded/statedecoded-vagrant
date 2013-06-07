#!/usr/bin/env bash

apt-get update
apt-get install -y apache2
apt-get install -y php5
apt-get install -y php-pear
apt-get install -y mysql-client
apt-get install -y mysql-server
apt-get install -y php5-mysql
apt-get install -y php5-mysqlnd
apt-get install -y php5-tidy
apt-get install -y tidy
apt-get install zip
sudo a2enmod rewrite
rm -rf /var/www
ln -fs /vagrant/statedecoded/htdocs /var/www