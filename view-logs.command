#!/bin/bash
# Двойной клик чтобы посмотреть логи
# Для родителя

echo "====== ЛОГИ ЗА СЕГОДНЯ ======"
echo ""
DATE=$(date +%Y-%m-%d)
LOG_FILE="$HOME/KidsCore/.logs/$DATE.log"

if [ -f "$LOG_FILE" ]; then
    cat "$LOG_FILE"
else
    echo "Логов за сегодня нет"
fi

echo ""
echo "====== ПОСЛЕДНИЕ 50 СООБЩЕНИЙ ======"
echo ""

# Последние записи из Claude сессий
find ~/.claude/projects -name "*.jsonl" -exec tail -50 {} \; 2>/dev/null | grep -o '"content":"[^"]*"' | head -50

echo ""
echo "Нажми Enter чтобы закрыть..."
read
