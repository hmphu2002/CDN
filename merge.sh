#!/bin/bash

# Thư mục chứa các file dữ liệu CSV mới
DATA_DIR="data/log"

# Thư mục lưu trữ các file đã xử lý
OLD_DIR="data/old_log"

# Tên file tổng hợp
OUTPUT_FILE="data/data.csv"

# Hàm kiểm tra và thêm header nếu OUTPUT_FILE không tồn tại hoặc bị xóa
check_and_add_header() {
    if [ ! -f "$OUTPUT_FILE" ]; then
        # Tìm file đầu tiên trong thư mục data/log và lấy header
        FIRST_FILE=$(find "$DATA_DIR" -name "bw_*.csv" | sort | head -n 1)
        if [ -n "$FIRST_FILE" ]; then
            head -n 1 "$FIRST_FILE" > "$OUTPUT_FILE"
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Recreated $OUTPUT_FILE with header from $FIRST_FILE"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - No CSV files found in $DATA_DIR. Waiting for new files..."
        fi
    fi
}

# Hàm kiểm tra và thêm các file CSV mới vào data.csv
check_new_files() {
    # Tìm các file CSV mới trong thư mục data/log, sắp xếp theo thời gian tạo
    csv_files=$(find "$DATA_DIR" -name "bw_*.csv" -printf "%T@ %p\n" | sort -n | awk '{print $2}')

    # Nếu không tìm thấy file nào, đợi tiếp
    if [ -z "$csv_files" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - No new CSV files found. Waiting for new files..."
        return
    fi

    for file in $csv_files; do
        echo "$(date '+%Y-%m-%d %H:%M:%S') - New file detected: $file"
        # Bỏ qua dòng header và thêm phần còn lại vào file tổng hợp
        tail -n +2 "$file" >> "$OUTPUT_FILE"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Appended $file to $OUTPUT_FILE"
        # Di chuyển file đã xử lý sang thư mục data/old_log
        mv "$file" "$OLD_DIR/"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Moved $file to $OLD_DIR"
    done
}

# Chạy kiểm tra liên tục mỗi 30 giây
while true; do
    check_and_add_header
    check_new_files
    sleep 30
done
