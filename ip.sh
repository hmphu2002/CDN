#!/bin/bash
CONFIG_FILE="/home/ubuntu/CDN/telegram.ini"
SECTION="default"
IP_FILE="/home/ubuntu/CDN/ip.txt"
HOSTNAME=$(hostname)
get_config_value() {
    local section=$1
    local key=$2
    awk -F ' *= *' -v section="[$section]" -v key="$key" '
        $0 == section { in_section=1; next }
        /^\[/ { in_section=0 }
        in_section && $1 == key { print $2; exit }
    ' "$CONFIG_FILE"
}

TOKEN=$(get_config_value "$SECTION" "bot_token")
CHAT_ID=$(get_config_value "$SECTION" "chat_id")

send_telegram_message() {
    local message=$1
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$message"
}
current_ip=$(curl -s https://api.ipify.org)

if [ ! -f "$IP_FILE" ] || [ ! -s "$IP_FILE" ]; then
    echo "$current_ip" > "$IP_FILE"
    echo "File ip.txt được tạo với IP hiện tại: $current_ip"
else
    saved_ip=$(cat "$IP_FILE")
    if [ "$current_ip" != "$saved_ip" ]; then
        # Nếu IP thay đổi, gửi thông báo và cập nhật file
        echo "$current_ip" > "$IP_FILE"
        send_telegram_message "$HOSTNAME: IP public đã thay đổi từ $saved_ip thành $current_ip"
        echo "Đã cập nhật file ip.txt với IP mới: $current_ip"
    else
        echo "IP không thay đổi."
    fi
fi

