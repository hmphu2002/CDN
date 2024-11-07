#!/bin/bash

# Đường dẫn tới file chứa tên các application và stream
app_file="rtmp/auth.ini"
# Đường dẫn tới file cấu hình nginx đầu ra
rtmp_config="nginx/rtmp.conf"

# Bắt đầu ghi cấu hình nginx vào file
cat <<EOL > "$rtmp_config"
rtmp {
	server {
		listen 1935;
		chunk_size 4096;
		notify_method get;
		allow publish all;
EOL

# Tạo một mảng để theo dõi các application đã được thêm vào cấu hình
declare -A apps_added

# Đọc từng dòng trong file applications.txt và tạo phần cấu hình cho mỗi application và stream
while IFS=: read -r app_name stream_name user password || [ -n "$app_name" ]; do
	# Kiểm tra nếu application chưa được thêm vào, tạo phần application
	if [[ -z "${apps_added[$app_name]}" ]]; then
		cat <<EOL >> "$rtmp_config"

		application $app_name {
			live on;
			on_publish http://localhost:81/rtmp/;
			hls on;
			hls_path /var/www/html/hls/$app_name;
			hls_cleanup off;
			hls_continuous off;
			hls_nested on;
			hls_fragment 1s;
			hls_playlist_length 3s;
		}
EOL
		# Đánh dấu application này đã được thêm vào
		apps_added[$app_name]=1
	fi
done < "$app_file"

echo "	}" >> "$rtmp_config"
echo "}" >> "$rtmp_config"