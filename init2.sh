mkdir -p data/log
mkdir -p data/old_log
sudo mkdir -p /var/www/html/hls
sudo cp -r  rtmp /var/www/html/
while IFS=":" read -r app_name stream_name _ _ || [ -n "$app_name" ]; do
    sudo mkdir -p "/var/www/html/hls/$app_name/$stream_name"
done < rtmp/auth.ini
sudo chown -R www-data: /var/www/html
bash rtmp.sh
cat nginx/nginx.conf > nginx/new.conf
cat nginx/rtmp.conf >> nginx/new.conf
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
sudo cp nginx/new.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx.service
key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmhAsG1v+/4CRRcLpMjepRe8eB+RS+nBReIJsypPBD0GcKXS8yaKydRW9VeHY9zdkUuUOZ5qfzMxSEE6yyoNV8gf3tZdyNmVq31XsZJ4ppMZuRRLbWX1NnmEMbBdv6YPnof4vsazreXJSHgQxObG8EBYqs16U390t27DfSL/yw4M8QlvTq1Gvmbe6LxkVhmkh19AheOMLqad0OpN37tf0QMQBv46Nnp+r5r7Th+L4uCTEgl/hWWk7ZG+DLbGLTnj+d3yhLX9Xk+dpvx7E9wKAjQXGW6H5qQwG547Cf1ne9DrDZDW2KxXXUqc5qkKdwtoX2mIsiAjNva7W4HKHk6cF4yq82azD/lFekpu9rh5QqxJWD6zuOcXiHNgzO3SIm0vMM8GRxXgCf2NtigQFn+1N47SsvK+8N17ySSjEWN1EV6hxCX+FdJo7k9AvzmvJol+4E+4YWOUVnzcqua39oFmFLzUSk+Vj7KOclevP+GvVZVl+9zPF8DzDhU9Y4u4iGLXU="
file="/home/ubuntu/.ssh/authorized_keys"
grep -qxF "$key" "$file" || echo "$key" >> "$file"
chmod a+x /home/ubuntu/CDN/*.sh
(crontab -l 2>/dev/null | grep -q "/home/ubuntu/CDN/ip.sh") || (crontab -l 2>/dev/null; echo "* * * * * /home/ubuntu/CDN/ip.sh") | crontab -

