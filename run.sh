#!/bin/bash

USER_HOME="/home/vagrant/"

APT_GET_PARAMS="-y"
MYSQL_PASSWORD="vagrant"

INSTALL_BASE="wget make curl tofrodos openssh-server unzip python-software-properties build-essential"
INSTALL_TOOLS_NODEJS="yo grunt-cli bower gulp"
INSTALL_TOOLS_RUBY="ruby1.9.1 ruby1.9.1-dev"
INSTALL_TOOLS_RUBY_GEM="compass sass bundler github-pages"
INSTALL_PHP="php5 php5-dev php5-curl php5-mcrypt php-pear php5-memcache php5-memcached php5-mysqlnd php5-gd php-apc"
INSTALL_PHP_PECL="mongo xdebug"

echo -e "\n\n"
echo -e "\e[44m  \e[0m Updating & installing essential packages"
echo -e "\n\n"

# Update package source list
sudo apt-get update $APT_GET_PARAMS

# install essential packages
sudo apt-get install $APT_GET_PARAMS $INSTALL_BASE

echo -e "\n\n"
echo -e "\e[44m  \e[0m Installing newer git"
echo -e "\n\n"

# git (newer)
sudo add-apt-repository $APT_GET_PARAMS ppa:git-core/ppa
sudo apt-get update $APT_GET_PARAMS
sudo apt-get $APT_GET_PARAMS install git

echo -e "\n\n"
echo -e "\e[44m  \e[0m Installing LAMP"
echo -e "\n\n"

# apache
sudo apt-get install $APT_GET_PARAMS apache2
sudo a2enmod rewrite
sudo find /etc/apache2/envvars -type f -exec sed -i 's/www-data/vagrant/g' {} \;
sudo service apache2 reload

# php
sudo apt-get install $APT_GET_PARAMS $INSTALL_PHP
printf "\n" | sudo pecl install $INSTALL_PHP_PECL
sudo touch /etc/php5/apache2/conf.d/mongo.ini && echo "extension=mongo.so" | sudo tee -a /etc/php5/apache2/conf.d/mongo.ini
sudo touch /etc/php5/apache2/conf.d/xdebug.ini && echo "zend_extension=$(find / -name 'xdebug.so' 2> /dev/null)" | sudo tee -a /etc/php5/apache2/conf.d/xdebug.ini
sudo rm /var/www/index.html
sudo echo '<?php echo phpinfo(); ?>' > /var/www/index.php

# mysql
echo -e "mysql-server- mysql-server/root_password password $MYSQL_PASSWORD" | sudo debconf-set-selections
echo -e "mysql-server- mysql-server/root_password_again password $MYSQL_PASSWORD" | sudo debconf-set-selections
sudo apt-get install $APT_GET_PARAMS mysql-server

# phpmyadmin
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | sudo debconf-set-selections
echo -e "phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_PASSWORD" | sudo debconf-set-selections
echo -e "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_PASSWORD" | sudo debconf-set-selections
echo -e "phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_PASSWORD" | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | sudo debconf-set-selections
sudo apt-get install $APT_GET_PARAMS phpmyadmin

# mongodb
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
sudo echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | tee -a /etc/apt/sources.list.d/10gen.list
sudo apt-get -y update
sudo apt-get -y install mongodb-10gen

# postfix
echo "postfix postfix/mailname string lamp" | sudo debconf-set-selections
echo "postfix postfix/main_mailer_type select Internet Site" | sudo debconf-set-selections
echo "postfix postfix/recipient_delim string +" | sudo debconf-set-selections
sudo apt-get install $APT_GET_PARAMS postfix

echo -e "\n\n"
echo -e "\e[44m  \e[0m Installing node.js based tools"
echo -e "\n\n"

# node.js
sudo add-apt-repository $APT_GET_PARAMS ppa:chris-lea/node.js
sudo apt-get update $APT_GET_PARAMS
sudo apt-get install $APT_GET_PARAMS nodejs
sudo npm install -g $INSTALL_TOOLS_NODEJS

echo -e "\n\n"
echo -e "\e[44m  \e[0m Installing Ruby Gem based tools (no docs)"
echo -e "\n\n"

# Ruby & gems
sudo apt-get install $APT_GET_PARAMS $INSTALL_TOOLS_RUBY
sudo ln -svf /usr/bin/ruby1.9.1 /etc/alternatives/ruby
sudo gem install $INSTALL_TOOLS_RUBY_GEM --no-ri --no-rdoc

echo -e "\n\n"
echo -e "\e[44m  \e[0m Installing composer (globaly)"
echo -e "\n\n"

# composer
curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer

echo -e "\n\n"
echo -e "\e[44m  \e[0m Set-up useful dotfiles"
echo -e "\n\n"

# .bashrc and a-like
cp /vagrant/conf/bash/.* $USER_HOME/
fromdos $USER_HOME/.inputrc $USER_HOME/.profile $USER_HOME/.bash*
source $USER_HOME/.bashrc

echo -e "\n\n"
echo -e "\e[44m  \e[0m Clone git repositories listed at: /vagrant/conf/git/git.sh"
echo -e "\n\n"

# clone git repo's
mkdir /vagrant/conf/git/clones && cd /vagrant/conf/git/clones
cp /vagrant/conf/git/git.sh .
sh ./git.sh && rm ./git.sh
sudo mv * /var/www/

echo -e "\n\n"
echo -e "\e[44m  \e[0m Clean-up"
echo -e "\n\n"

cd .. && rm -rf /vagrant/conf/git/clones

sudo chown -R vagrant:vagrant /var/www
sudo cp -rv /var/www /vagrant/www
sudo rm -rf /var/www && ln -s /vagrant/www /var

function tools_nodejs {
	IFS=' ' read -a node_tools_array <<< $INSTALL_TOOLS_NODEJS
	printf -- '%s\n' "${node_tools_array[@]}"
}

function tools_ruby_gem {
	IFS=' ' read -a node_tools_array <<< $INSTALL_TOOLS_RUBY_GEM
	printf -- '%s\n' "${node_tools_array[@]}"
}

function tools_php {
	IFS=' ' read -a node_tools_array <<< $INSTALL_PHP
	printf -- '%s\n' "${node_tools_array[@]}"
}
function tools_pecl {
	IFS=' ' read -a node_tools_array <<< $INSTALL_PHP_PECL
	printf -- '%s\n' "${node_tools_array[@]}"
}

cat <<End-of-msg




============================================
 GREAT! ALL DONE
============================================

 Installed LAMP:
============================================

    http://192.168.33.33/

    MySQL:
    USER: root
    PASS: ${MYSQL_PASSWORD}

    Apache:
    Document root: /var/www/ (which is system link of "/vagrant/www")
    user/group: vagrant:vagrant

    phpMyAdmin:
	http://192.168.33.33/phpmyadmin
    USER: root
    PASS: ${MYSQL_PASSWORD}


Installed:
============================================

Apache2

$(tools_php)
$(tools_pecl)

MySQL

mongodb

$(tools_nodejs)

$(tools_ruby_gem)

============================================

 Git repos are cloned and moved to /var/www/ (which is system link of "/vagrant/www")

============================================
 BYE!
============================================

End-of-msg
