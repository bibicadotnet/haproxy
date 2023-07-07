# Oracle 24GB RAM cho haproxy.tech, api.haproxy.tech
Cập nhập OS và khởi động lại hệ thống
```shell
sudo apt update && sudo apt upgrade -y && sudo reboot
```
Cài đặt Webinoly và cấu hình cho domain haproxy.tech, api.haproxy.tech
```shell
sudo wget --no-check-certificate https://raw.githubusercontent.com/bibicadotnet/haproxy/main/haproxy.sh && sudo chmod +x haproxy.sh && sudo ./haproxy.sh
```
## Restore Bằng Duplicator Pro
Upload archive.zip và installer.php vào (có thể sử dụng wget cho nhanh)
```shell
/var/www/haproxy.tech/htdocs
```
## Đổi 3 domain bên dưới về IP mới
```shell
haproxy.tech
www.haproxy.tech
api.haproxy.tech
```
Chạy file installer.php để restore
