# Bootstrap file

sudo usermod -aG vagrant nginx

# Update and install repos
sudo yum update -y
sudo yum -y install epel-release
rpm -Uvh https://centos7.iuscommunity.org/ius-release.rpm

# Install utilities.
sudo yum install -y wget git vim nano

# Install mysql 5.7
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo rpm -ivh mysql57-community-release-el7-11.noarch.rpm
sudo yum install -y mysql-server
sudo systemctl start mysqld
sudo systemctl status mysqld

# Capture the temp password
TEMP_PW="$(sudo grep 'temporary password' /var/log/mysqld.log | grep -o -P '([\s\S]{12})$')"
echo "TEMP PASSWORD: ${TEMP_PW}"

# Set the root password to rootroot
mysql --connect-expired-password -u root -p"${TEMP_PW}" -e "SET GLOBAL validate_password_policy=LOW;"
mysql --connect-expired-password -u root -p"$TEMP_PW" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$TEMP_PW';"
mysql --connect-expired-password -u root -p"$TEMP_PW" -e "UPDATE mysql.user SET authentication_string=PASSWORD('rootroot') WHERE User='root'"
mysql --connect-expired-password -u root -p"$TEMP_PW" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql --connect-expired-password -u root -p"$TEMP_PW" -e "DELETE FROM mysql.user WHERE User=''"
mysql --connect-expired-password -u root -p"$TEMP_PW" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql --connect-expired-password -u root -p"$TEMP_PW" -e "FLUSH PRIVILEGES"
mysql --connect-expired-password -u root -prootroot -e "CREATE DATABASE wordpress"

# PHP 7.1
sudo yum install -y php70u-fpm php70u-fpm-nginx php70u-mysqlnd php70u-xml php70u-curl php70u-cli php70u-common php70u-gd php70u-mbstring php70u-mcrypt php70u-json
sudo systemctl start php-fpm.service
sudo systemctl enable php-fpm.service

# Nginx
sudo yum -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo cp /vagrant/provision/nginx.conf /etc/nginx/
sudo systemctl reload-or-restart nginx

echo "Vagrant box is ready."