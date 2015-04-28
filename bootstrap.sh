#!/usr/bin/env bash
#################################################################
# Install the necessary components for building and installing
# the unifiedviews system from the github.
#
# This is the LATEST, 2.0.1 version (not a specific branch).
#
echo "deb http://packages.comsode.eu/debian wheezy main" > /etc/apt/sources.list.d/odn.list
wget -O - http://packages.comsode.eu/key/odn.gpg.key | apt-key add -
apt-get update 
apt-get update -y --force-yes
apt-get install -y xinit xterm iceweasel
apt-get install -y gnome-terminal gnome-shell
apt-get install -y dkms virtualbox-guest-dkms virtualbox-guest-x11
apt-get install -y gdm3 apache2  libapache2-mod-auth-cas
dpkg-reconfigure gdm3

# Now start to setup for building unified views, etc.
apt-get install -y openjdk-7-jre openjdk-7-jdk
apt-get install -y tomcat7 git maven bash
apt-get install -y debconf-utils dpkg-dev build-essential quilt gdebi
echo "JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> /etc/default/tomcat7


###############################################################
# Set the default values for the debconf questions
#
echo "mysql-server-5.5 mysql-server/root_password_again password root" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server-5.5 mysql-server-5.5/root_password_again password root" | debconf-set-selections
echo "mysql-server-5.5 mysql-server-5.5/root_password password root" | debconf-set-selections
# echo "virtuoso-opensource-7.1 virtuoso-opensource-7.1/dba-password-again password root" | debconf-set-selections
# echo "virtuoso-opensource-7.1 virtuoso-opensource-7.1/dba-password password root" | debconf-set-selections
echo "virtuoso-opensource-7 virtuoso-opensource-7/dba-password-again password root" | debconf-set-selections
echo "virtuoso-opensource-7 virtuoso-opensource-7/dba-password password root" | debconf-set-selections
echo "unifiedviews-webapp-mysql       frontend/mysql_db_password password root"| debconf-set-selections
echo "unifiedviews-webapp-shared	frontend/mysql_dba_user	string	uv" | debconf-set-selections
echo "unifiedviews-webapp-shared      frontend/mysql_dba_password password root"| debconf-set-selections
echo "unifiedviews-webapp-mysql       frontend/mysql_db_user string root" | debconf-set-selections
echo "unifiedviews-webapp-mysql       frontend/mysql_db_password password uv"| debconf-set-selections
echo "unifiedviews-webapp-mysql       frontend/mysql_db_user string uv"| debconf-set-selections
echo "unifiedviews-backend-mysql      backend/mysql_root password root"| debconf-set-selections
echo "unifiedviews-backend-mysql      backend/mysql_db_password password uv"| debconf-set-selections
echo "unifiedviews-backend-mysql      backend/mysql_db_user string uv"| debconf-set-selections

##############################################################
# DB installations, etc which have customised values.

apt-get install -y virtuoso-opensource mysql-server
apt-get install -y iceweasel
apt-get update -y
apt-get upgrade -y

###############################################################
# Unified views pulling, packaging and hopefully the installation.

# cd ${HOME}
# if [ -d Packages ]
# then
#   cd Packages ; git pull
# else
#    git clone --branch UV_v2.0.1 https://github.com/UnifiedViews/Packages.git
# fi
# cd ${HOME}/Packages
# mvn package
# cd target
# cp ${HOME}/Packages/*/target/*.deb .
# echo "****** packages built - installing"
# apt-get install -y apt-get install unifiedviews-mysql
# dpkg -i unifiedviews-backend-shared*_all.deb  unifiedviews-webapp-shared*_all.deb unifiedviews-backend-mysql*_all.deb unifiedviews-backend-2*_all.deb unifiedviews-webapp-mysql*all.deb unifiedviews-webapp-2*all.deb unifiedviews-mysql*_all.deb
apt-get -y install unifiedviews-mysql
apt-get -y install unifiedviews-plugins
apt-get -f -y install 

###############################################################
# Setup other services
# update-rc.d unifiedviews-backend defaults
# Allows login without password
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant

###############################################################
# Change the default homepage
echo "user_pref(\"browser.startup.homepage\", \"http://localhost:8080/unifiedviews\");" >> /etc/iceweasel/pref/iceweasel.js
echo "_user_pref(\"browser.startup.homepage\", \"http://localhost:8080/unifiedviews\");" >> /etc/iceweasel/profile/prefs.js

###############################################################
apt-get autoclean
echo "****** done with bootstrap"
###############################################################
