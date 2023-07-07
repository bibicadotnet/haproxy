sudo wget --no-check-certificate https://raw.githubusercontent.com/bibicadotnet/Oracle-VM-Standard-A1-Flex-Webinoly/main/setup.sh -O setup.sh && sudo chmod +x setup.sh && sudo ./setup.sh
# setup bypass Oracle 15% RAM
sudo wget --no-check-certificate https://raw.githubusercontent.com/bibicadotnet/bibica.net/main/bypass_oracle.sh -O /usr/local/bin/bypass_oracle.sh
chmod +x /usr/local/bin/bypass_oracle.sh
nohup /usr/local/bin/bypass_oracle.sh >> ./out 2>&1 <&- &

# setup wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# setup rclone
sudo -v ; curl https://rclone.org/install.sh | sudo bash

# setup crontab
crontab -l > simply-static
echo "*/1 * * * * curl https://haproxy.tech/wp-cron.php?doing_wp_cron > /dev/null 2>&1" >> simply-static
echo "@reboot nohup /usr/local/bin/bypass_oracle.sh >> ./out 2>&1 <&- &" >> simply-static
crontab simply-static

# tao 2 trang haproxy.tech và api.haproxy.tech
sudo site haproxy.tech -wp
sudo site api.haproxy.tech -proxy=[https://i0.wp.com/haproxy.tech/wp-content/uploads/] -dedicated-reverse-proxy=simple

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
