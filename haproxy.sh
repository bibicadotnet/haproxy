#!/bin/bash
# setup Webinoly php 7.4
sudo wget --no-check-certificate https://raw.githubusercontent.com/bibicadotnet/Oracle-VM-Standard-A1-Flex-Webinoly/main/setup.sh -O setup.sh && sudo chmod +x setup.sh && sudo ./setup.sh

# setup wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# setup rclone
sudo -v ; curl https://rclone.org/install.sh | sudo bash

# Bypass Oracle VM.Standard.A1.Flex
sudo wget --no-check-certificate https://raw.githubusercontent.com/bibicadotnet/NeverIdle-Oracle/master/VM.Standard.A1.Flex.4GB.RAM.sh -O /usr/local/bin/bypass_oracle.sh
chmod +x /usr/local/bin/bypass_oracle.sh
nohup /usr/local/bin/bypass_oracle.sh >> ./out 2>&1 <&- &

# setup crontab cho wp_cron and simply-static
mkdir -p /var/www/haproxy.tech/static-files-temp
chmod 777 /var/www/haproxy.tech/static-files-temp
crontab -l > simply-static
echo "0 3 * * * /usr/local/bin/wp --path='/var/www/haproxy.tech/htdocs' simply-static run --allow-root" >> simply-static
echo "*/1 * * * * curl https://haproxy.tech/wp-cron.php?doing_wp_cron > /dev/null 2>&1" >> simply-static
echo "@reboot nohup /usr/local/bin/bypass_oracle.sh >> ./out 2>&1 <&- &" >> simply-static
crontab simply-static

# Monitor and restart php, mysql, nginx
sudo wget --no-check-certificate https://raw.githubusercontent.com/bibicadotnet/monitor-service-status/main/setup_monitor_service_restart.sh -O setup_monitor_service_restart.sh && sudo chmod +x setup_monitor_service_restart.sh && sudo ./setup_monitor_service_restart.sh

# tao 2 trang haproxy.tech và api.haproxy.tech
sudo site haproxy.tech -wp
sudo site api.haproxy.tech -proxy=[https://res.cloudinary.com/haproxy-tech/] -dedicated-reverse-proxy=simple

# setup ssl
mkdir -p /root/ssl
sudo wget --no-check-certificate https://raw.githubusercontent.com/bibicadotnet/haproxy/main/haproxy.tech.pem -O /root/ssl/haproxy.tech.pem
sudo wget --no-check-certificate https://raw.githubusercontent.com/bibicadotnet/haproxy/main/haproxy.tech.key -O /root/ssl/haproxy.tech.key


# setup ssl haproxy.tech và api.haproxy.tech
sudo wget --no-check-certificate https://raw.githubusercontent.com/bibicadotnet/haproxy/main/haproxy.tech -O /etc/nginx/sites-available/haproxy.tech
sudo wget --no-check-certificate https://raw.githubusercontent.com/bibicadotnet/haproxy/main/api.haproxy.tech -O /etc/nginx/sites-available/api.haproxy.tech

# nginx reload
nginx -t
sudo service nginx reload

cd /var/www/haproxy.tech/htdocs
rm -rf *

sudo webinoly -verify
sudo webinoly -info
