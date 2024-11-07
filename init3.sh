#!/bin/bash

# Tạo phiên tmux với tên là "my_session"
session="CDN"

# Khởi tạo phiên tmux mới
tmux new-session -d -s $session

# Tạo và chạy lệnh trong từng cửa sổ
tmux rename-window -t $session:0 'cms'
tmux send-keys -t $session:0 'python3 cms.py' C-m

tmux new-window -t $session:1 -n 'delete'
tmux send-keys -t $session:1 'bash delete_old_data.sh' C-m

tmux new-window -t $session:2 -n 'log_processor'
tmux send-keys -t $session:2 'python3 log_processor.py' C-m

tmux new-window -t $session:3 -n 'merge'
tmux send-keys -t $session:3 'bash merge.sh' C-m

tmux new-window -t $session:4 -n 'update_db'
tmux send-keys -t $session:4 'python3 update_db.py' C-m

# Đưa người dùng vào phiên tmux mới tạo
tmux attach -t $session
