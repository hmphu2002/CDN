while sleep 60; do
        echo "$(date '+%Y-%m-%d %H:%M:%S')";
        # Xóa các file .ts được tạo ra quá 2 phút
        sudo find /var/www/html/hls/*/*/*.ts -maxdepth 1 -mmin +2 -type f -delete;
        
        # Xóa các file .m3u8 được tạo ra quá 10 phút
        sudo find /var/www/html/hls/*/*/*.m3u8 -maxdepth 1 -mmin +10 -type f -delete;
done