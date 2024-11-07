config_file="/etc/mysql/mysql.conf.d/mysqld.cnf"
config_line="performance_schema = off"

# Kiểm tra xem dòng cấu hình đã tồn tại chưa
if grep -q -E "^[^#]*\s*performance_schema\s*=" "$config_file"; then
    echo "Dòng cấu hình đã tồn tại trong file, không cần thêm vào."
else
    # Kiểm tra xem dòng có bị comment (#) không và bỏ comment nếu có
    if grep -q "#\s*performance_schema\s*=" "$config_file"; then
        sudo sed -i 's/#\s*performance_schema\s*=.*/performance_schema = off/' "$config_file"
        echo "Đã bỏ comment và cập nhật cấu hình thành 'performance_schema = off'."
    else
        # Nếu dòng chưa tồn tại, thêm dòng vào cuối file
        echo "$config_line" | sudo tee -a "$config_file" > /dev/null
        echo "Đã thêm dòng 'performance_schema = off' vào file cấu hình."
    fi
fi

#!/bin/bash

# Thông tin kết nối MySQL
MYSQL_USER="root"         # Tên người dùng MySQL

# Thực thi các câu lệnh MySQL để tạo database, bảng, và người dùng
sudo mysql -u "$MYSQL_USER" <<EOF
CREATE DATABASE IF NOT EXISTS stream_data;

USE stream_data;

CREATE TABLE IF NOT EXISTS data (
  id INT AUTO_INCREMENT PRIMARY KEY,
  time DATETIME NOT NULL,
  app VARCHAR(50) NOT NULL,
  stream VARCHAR(50) NOT NULL,
  requests INT NOT NULL,
  unique_users INT NOT NULL,
  data_sent BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  hashed_password VARCHAR(255) NOT NULL
);

CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'stream';
GRANT ALL PRIVILEGES ON stream_data.* TO 'admin'@'localhost';

ALTER USER 'admin'@'localhost' IDENTIFIED WITH mysql_native_password BY 'stream';

FLUSH PRIVILEGES;
EOF

# Kiểm tra nếu các câu lệnh đã thực thi thành công
if [ $? -eq 0 ]; then
    echo "Database và bảng đã được tạo thành công, người dùng 'admin' đã được cấp quyền."
else
    echo "Đã xảy ra lỗi khi tạo database hoặc cấp quyền."
fi
