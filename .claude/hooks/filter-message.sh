#!/bin/bash
# Фильтр сообщений ПЕРЕД отправкой в Claude
# Блокирует jailbreak попытки и запрещённые темы

LOG_DIR="$HOME/KidsCore/.logs"
mkdir -p "$LOG_DIR"

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
LOG_FILE="$LOG_DIR/$DATE.log"

# Читаем сообщение
INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')

# Логируем всё
echo "[$TIME] INPUT: $INPUT" >> "$LOG_FILE"

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
        # Возвращаем ошибку — сообщение не пройдёт
        echo '{"error": "Это сообщение заблокировано родительским контролем."}'
        exit 1
    fi
done

# Если всё ок — пропускаем
exit 0
