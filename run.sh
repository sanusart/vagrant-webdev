#!/bin/bash

# Update package source list
sudo apt-get update

# install essential packages
sudo apt-get install -y wget ruby1.9.1 ruby1.9.1-dev curl openssh-server unzip python-software-properties build-essential
sudo ln -svf /usr/bin/ruby1.9.1 /etc/alternatives/ruby

# git (newer)
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get -y install git

# apache
sudo apt-get install -y apache2
sudo a2enmod rewrite
sudo find /etc/apache2/envvars -type f -exec sed -i 's/www-data/vagrant/g' {} \;
sudo service apache2 reload

# php
sudo apt-get install -y php5 php5-curl php5-mcrypt php5-memcache php5-memcached php5-mongo php5-mysqlnd php5-gd php5-xdebug php-apc
sudo rm /var/www/index.html
sudo echo '<?php phpinfo(); ?>' > /var/www/index.php

# mysql
echo 'mysql-server- mysql-server/root_password password vagrant' | sudo debconf-set-selections
echo 'mysql-server- mysql-server/root_password_again password vagrant' | sudo debconf-set-selections
sudo apt-get install -y mysql-server

# phpmyadmin
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password vagrant' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password vagrant' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password vagrant' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | sudo debconf-set-selections
sudo apt-get install -y phpmyadmin

# postfix
echo "postfix postfix/mailname string lamp" | sudo debconf-set-selections
echo "postfix postfix/main_mailer_type select Internet Site" | sudo debconf-set-selections
echo "postfix postfix/recipient_delim string +" | sudo debconf-set-selections
sudo apt-get install -y postfix

# node.js
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs
sudo npm install -g yo grunt-cli bower

# gems
sudo gem install compass sass jekyll

# .bashrc and a-like
cp /vagrant/conf/bash/.* /home/vagrant/
source /home/vagrant/.bashrc

# clone git repo's
mkdir /vagrant/conf/git/clones && cd /vagrant/conf/git/clones
cp /vagrant/conf/git/git.sh .
sh ./git.sh && rm ./git.sh
sudo mv * /var/www/
cd .. && rm -rf /vagrant/conf/git/clones

sudo chown -R vagrant:vagrant /var/www

cat <<End-of-msg




============================================
 GREAT! ALL DONE
============================================


 Installed LAMP:
============================================

http://localhost:3000

MySQL:
USER: root
PASS: vagrant

Apache:
Document root: /var/www/
user/group: vagrant/vagrant

phpMyAdmin:
USER: root
PASS: vagrant


 Also installed:
============================================

node.js
grunt
jekyll
yeoman
bower
ruby 1.9.1
sass
compass

============================================

 Git repos are cloned and moved to /var/www/

============================================
 BYE!
============================================

End-of-msg
