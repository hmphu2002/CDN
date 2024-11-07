#!/bin/bash

# Đọc thông tin từ file cấu hình
source mysql.ini

# Kiểm tra xem các biến đã được đặt hay chưa
if [ -z "$user" ] || [ -z "$password" ] || [ -z "$database" ]; then
  echo "Please ensure mysql.conf contains database user, password, and database name."
  exit 1
fi

# Hiển thị menu lựa chọn
echo "Choose an option:"
echo "1. Add new user"
echo "2. Delete a user"
echo "3. Change password"
echo "4. List users"
read -p "Enter your choice (1/2/3/4): " choice

case $choice in
  1)  # Add new user
    read -p "Enter username to add: " new_username
    read -sp "Enter password for new user: " new_password
    echo
    # Mã hóa mật khẩu sử dụng MD5
    hashed_password=$(echo -n "$new_password" | md5sum | awk '{print $1}')
    # Câu lệnh SQL để thêm user
    sql_statement="INSERT INTO users (username, hashed_password) VALUES ('$new_username', '$hashed_password');"
    ;;

  2)  # Delete a user
    read -p "Enter username to delete: " del_username
    # Câu lệnh SQL để xóa user
    sql_statement="DELETE FROM users WHERE username = '$del_username';"
    ;;

  3)  # Change password
    read -p "Enter username to change password: " change_username
    read -sp "Enter new password: " new_password
    echo
    # Mã hóa mật khẩu sử dụng MD5
    hashed_password=$(echo -n "$new_password" | md5sum | awk '{print $1}')
    # Câu lệnh SQL để đổi mật khẩu user
    sql_statement="UPDATE users SET hashed_password = '$hashed_password' WHERE username = '$change_username';"
    ;;

  4)  # List users
    # Câu lệnh SQL để liệt kê user
    sql_statement="SELECT username FROM users;"
    ;;

  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

# Thực thi câu lệnh SQL
if [ "$choice" -eq 4 ]; then
  mysql -u "$user" -p"$password" -D "$database" -e "$sql_statement"
else
  mysql -u "$user" -p"$password" -D "$database" -e "$sql_statement"

  # Kiểm tra kết quả
  if [ $? -eq 0 ]; then
    case $choice in
      1) echo "User $new_username has been added successfully." ;;
      2) echo "User $del_username has been deleted successfully." ;;
      3) echo "Password for user $change_username has been changed successfully." ;;
    esac
  else
    echo "Operation failed. Please check your database settings or permissions."
  fi
fi
