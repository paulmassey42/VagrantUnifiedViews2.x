#!/usr/bin/env bashA
#################################################################
# Install the necessary components for building and installing
# the unifiedviews system from the github.
#
# This is the LATEST, 2.0.1 version (not a specific branch).
#
# Standard System Updates.
apt-get install -y xinit xterm iceweasel gnome-terminal gnome-shell
apt-get install -y dkms virtualbox-guest-dkms virtualbox-guest-x11
apt-get install -y gdm3 apache2 libapache2-mod-auth-cas debconf-utils dpkg-dev build-essential quilt gdebi
dpkg-reconfigure gdm3

# Now start to setup for building unified views, etc.
apt-get install -y openjdk-7-jre openjdk-7-jdk
apt-get install -y tomcat7 git maven bash emacs nano vim
echo "JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> /etc/default/tomcat7

echo "deb http://packages.comsode.eu/debian wheezy main" > /etc/apt/sources.list.d/odn.list
wget -O - http://packages.comsode.eu/key/odn.gpg.key | apt-key add -
apt-get update -y --force-yes

###############################################################
# http://www.oracle.com/technetwork/database/features/jdbc/default-2280470.html
# should be in this directory
mvn install:install-file -Dfile=/vagrant/ojdbc7.jar -DgroupId=com.oracle -DartifactId=ojdbc7 -Dversion=12.1.0.2.0 -Dpackaging=jar

###############################################################
# Set the default values for the debconf questions
#
echo "mysql-server-5.5 mysql-server/root_password_again password root" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server-5.5 mysql-server-5.5/root_password_again password root" | debconf-set-selections
echo "mysql-server-5.5 mysql-server-5.5/root_password password root" | debconf-set-selections

echo "virtuoso-opensource-7.2 virtuoso-opensource-7.2/dba-password-again password root" | debconf-set-selections
echo "virtuoso-opensource-7.2 virtuoso-opensource-7.2/dba-password password root" | debconf-set-selections

echo "virtuoso-opensource-7.1 virtuoso-opensource-7.1/dba-password-again password root" | debconf-set-selections
echo "virtuoso-opensource-7.1 virtuoso-opensource-7.1/dba-password password root" | debconf-set-selections

echo "virtuoso-opensource-7 virtuoso-opensource-7/dba-password-again password root" | debconf-set-selections
echo "virtuoso-opensource-7 virtuoso-opensource-7/dba-password password root" | debconf-set-selections

echo "virtuoso-opensource-6.1 virtuoso-opensource-6.1/dba-password-again password root" | debconf-set-selections
echo "virtuoso-opensource-6.1 virtuoso-opensource-6.1/dba-password password root" | debconf-set-selections
echo "virtuoso-opensource-6 virtuoso-opensource-6/dba-password-again password root" | debconf-set-selections
echo "virtuoso-opensource-6 virtuoso-opensource-6/dba-password password root" | debconf-set-selections

echo "unifiedviews-webapp-mysql       frontend/mysql_db_password password root"| debconf-set-selections
echo "unifiedviews-webapp-shared	frontend/mysql_dba_user	string	root" | debconf-set-selections
echo "unifiedviews-webapp-shared      frontend/mysql_dba_password password root"| debconf-set-selections
echo "unifiedviews-webapp-mysql       frontend/mysql_db_user string root" | debconf-set-selections
echo "unifiedviews-webapp-mysql       frontend/mysql_db_password password root"| debconf-set-selections
echo "unifiedviews-webapp-mysql       frontend/mysql_db_user string root"| debconf-set-selections
echo "unifiedviews-backend-mysql      backend/mysql_root password root"| debconf-set-selections
echo "unifiedviews-backend-mysql      backend/mysql_db_password password root"| debconf-set-selections
echo "unifiedviews-backend-mysql      backend/mysql_db_user string root"| debconf-set-selections

##############################################################
# DB installations, etc which have customised values.

apt-get install -y virtuoso-opensource mysql-server iceweasel
apt-get update -y --force-yes

###############################################################
# Unified views pulling, packaging and hopefully the installation.
apt-get -y install unifiedviews-mysql
apt-get -y install unifiedviews-plugins

# Change the env (language changed to english :-))
sed -iBAC -e 's/sk/en/g' /etc/unifiedviews/*.properties
# Make sure that the DPU's are in
bash /usr/share/unifiedviews/dist/plugins/deploy-dpus.sh

# Make sure nothing missing ...
apt-get -f -y install 

###############################################################
# Setup other services
# update-rc.d unifiedviews-backend defaults
# Allows login without password
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant

###############################################################
# Change the default homepage
echo "user_pref(\"browser.startup.homepage\", \"http://localhost:28080/unifiedviews\");" >> /etc/iceweasel/pref/iceweasel.js
echo "_user_pref(\"browser.startup.homepage\", \"http://localhost:28080/unifiedviews\");" >> /etc/iceweasel/profile/prefs.js
 
( cd /vagrant ; git clone https://github.com/UnifiedViews/Plugin-DevEnv.git )
( cd /vagrant/Plugin-DevEnv ; mvn install )
( cd /vagrant ; git clone https://github.com/tenforce/unifiedviews-dpus.git )

###############################################################
apt-get autoclean
echo "****** done with bootstrap"
###############################################################

