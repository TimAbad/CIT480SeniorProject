#!/bin/bash
apt-get install apache2
echo "This is coming from Terraform" >> /var/www/html/index.html
service apache2 start
