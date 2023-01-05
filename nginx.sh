#!/bin/bash 	
apt update
apt install nginx -y
cat <<EOT > test
upstream test {
 server app01:8080;
}
server {
  listen 80;
location / {
  proxy_pass http://test;
 }
}
EOT

mv test /etc/nginx/sites-available/test
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/test

#starting nginx service and firewall
systemctl start nginx
systemctl enable nginx
systemctl restart nginx
