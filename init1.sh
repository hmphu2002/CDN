sudo timedatectl set-timezone Asia/Ho_Chi_Minh
sudo apt update -y
sudo apt upgrade -y
sudo apt install bmon net-tools libnginx-mod-rtmp php-fpm php  mysql-server python3 python3-watchdog python3-mysql.connector libssl-dev python3-flask-sqlalchemy python3-flask-bcrypt python3-pandas python3-python-flask-jwt-extended -y
sudo apt remove apache2
bash mysql.sh