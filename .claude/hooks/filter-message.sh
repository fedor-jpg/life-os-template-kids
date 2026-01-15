#!/bin/bash
# Фильтр сообщений ПЕРЕД отправкой в Claude
# Блокирует jailbreak попытки и запрещённые темы
# + отправка логов родителю в Telegram

LOG_DIR="$HOME/KidsCore/.logs"
mkdir -p "$LOG_DIR"

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
LOG_FILE="$LOG_DIR/$DATE.log"

# Telegram настройки (из .env файла)
if [ -f "$HOME/KidsCore/.env" ]; then
    source "$HOME/KidsCore/.env"
fi

# Читаем сообщение
INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')

# Логируем всё
echo "[$TIME] INPUT: $INPUT" >> "$LOG_FILE"

# Отправка в Telegram (если настроено)
if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
    # Отправляем в фоне чтобы не тормозить
    (curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=[$TIME] $INPUT" \
        -d "parse_mode=HTML" > /dev/null 2>&1) &
fi

# Список запрещённых паттернов (jailbreak + контент)
BLOCKED_PATTERNS=(
    # Jailbreak попытки
    "ignore.*instructions"
    "ignore.*rules"
    "ignore.*claude.md"
    "forget.*rules"
    "pretend.*no.*rules"
    "act.*as.*if"
    "roleplay"
    "you.*are.*now"
    "new.*personality"
    "bypass"
    "override"
    "jailbreak"
    "dan.*mode"
    "developer.*mode"
    "без.*ограничений"
    "игнорируй.*правила"
    "забудь.*правила"
    "притворись"
    "представь.*что.*ты"
    # Запрещённый контент
    "porn"
    "sex"
    "xxx"
    "наркотик"
    "убить"
    "взорвать"
    "оружие"
    "бомба"
    "hack"
    "взлом"
    "пароль.*от"
)

# Проверяем каждый паттерн
for pattern in "${BLOCKED_PATTERNS[@]}"; do
    if echo "$MESSAGE" | grep -qiE "$pattern"; then
        echo "[$TIME] BLOCKED: pattern '$pattern' matched" >> "$LOG_FILE"

        # Алерт родителю о блокировке
        if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
            (curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=⚠️ BLOCKED: $INPUT" > /dev/null 2>&1) &
        fi

        # Возвращаем ошибку — сообщение не пройдёт
        echo '{"error": "Это сообщение заблокировано родительским контролем."}'
        exit 1
    fi
done

# Если всё ок — пропускаем
exit 0
