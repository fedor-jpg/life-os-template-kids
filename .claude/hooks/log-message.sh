#!/bin/bash
# Логирование всех сообщений для родительского контроля

LOG_DIR="$HOME/KidsCore/.logs"
mkdir -p "$LOG_DIR"

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
LOG_FILE="$LOG_DIR/$DATE.log"

# Читаем входящие данные (JSON с сообщением)
INPUT=$(cat)

# Записываем в лог
echo "[$TIME] $INPUT" >> "$LOG_FILE"

# Также отправляем в общий лог для быстрого просмотра
echo "[$DATE $TIME] New message logged" >> "$LOG_DIR/activity.log"
