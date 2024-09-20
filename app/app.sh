#! /bin/bash
sudo apt-get update -y
sudo apt install -y apache2
sudo chmod -R 777 /var/www/html
sudo echo "Welcome to the site $(hostname)" > /var/www/html/index.html