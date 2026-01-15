# Настройка родительского контроля

## Мониторинг в реальном времени (Telegram)

Каждое сообщение ребёнка приходит тебе в Telegram мгновенно.
Заблокированные попытки приходят с пометкой ⚠️ BLOCKED.

### Настройка:

1. Создай бота: напиши @BotFather → /newbot → получи токен
2. Узнай свой chat_id: напиши @userinfobot
3. На компе ребёнка отредактируй файл:
   ```
   ~/KidsCore/.claude/hooks/filter-message.sh
   ```
   Заполни строки 14-15:
   ```bash
   TELEGRAM_BOT_TOKEN="123456:ABC..."  # твой токен
   TELEGRAM_CHAT_ID="987654321"        # твой chat_id
   ```

Готово! Теперь все сообщения приходят тебе.

---

## Что включено

### Ограничения:
- Запрещён веб-поиск и открытие сайтов
- Запрещены bash команды (установка программ, удаление)
- Запрещены MCP интеграции (Slack, Calendar и т.д.)
- Разрешено только чтение и запись в папки notes/ и projects/

### Логирование:
- Все сессии сохраняются в `~/.claude/projects/`
- Дополнительный лог в `~/KidsCore/.logs/`

---

## Установка (на компьютере ребёнка)

### 1. Установи Claude Code
Следуй стандартной инструкции (VS Code + расширение Claude)

### 2. Склонируй детский шаблон
```bash
git clone https://github.com/fedor-jpg/life-os-template-kids.git ~/KidsCore
```

### 3. Настрой права доступа (ВАЖНО!)
```bash
# Сделай hooks исполняемыми
chmod +x ~/KidsCore/.claude/hooks/*.sh

# Защити настройки от изменения ребёнком
sudo chown root:wheel ~/KidsCore/CLAUDE.md
sudo chown -R root:wheel ~/KidsCore/.claude/
sudo chmod 444 ~/KidsCore/CLAUDE.md
sudo chmod -R 555 ~/KidsCore/.claude/
```

Теперь ребёнок НЕ сможет попросить Claude изменить правила.

### 4. Открой папку в VS Code
File → Open Folder → ~/KidsCore

---

## Просмотр логов (для родителя)

### Вариант 1: Локально на компьютере ребёнка
```bash
# Последние сообщения за сегодня
cat ~/KidsCore/.logs/$(date +%Y-%m-%d).log

# Вся активность
cat ~/KidsCore/.logs/activity.log
```

### Вариант 2: Полные транскрипты
```bash
# Все сессии Claude хранятся здесь:
ls ~/.claude/projects/

# Читать конкретную сессию:
cat ~/.claude/projects/-Users-*/latest.jsonl
```

### Вариант 3: Синхронизация к себе (рекомендуется)

Добавь в cron на компьютере ребёнка:
```bash
crontab -e
```

Добавь строку (синхронизация каждый час на iCloud/Dropbox):
```
0 * * * * cp -r ~/KidsCore/.logs ~/Library/Mobile\ Documents/com~apple~CloudDocs/KidsLogs/
```

Или через rsync на твой компьютер:
```
0 * * * * rsync -av ~/KidsCore/.logs/ parent@your-mac:/Users/parent/KidsLogs/
```

---

## Проверка что ограничения работают

Попроси ребёнка написать в Claude:
```
Открой google.com
```

Claude должен отказать (Bash запрещён).

```
Найди в интернете игры
```

Claude должен отказать (WebSearch запрещён).

---

## Если ребёнок пытается обойти ограничения

Claude обучен НЕ помогать обходить родительский контроль.
Но если увидишь попытки в логах — поговори с ребёнком.

---

## Дополнительно: Ограничение времени

macOS Screen Time:
1. System Preferences → Screen Time
2. App Limits → добавь VS Code
3. Установи лимит (например 2 часа в день)
