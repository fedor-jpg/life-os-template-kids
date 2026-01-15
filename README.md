# Kids Mode — Claude с родительским контролем

Безопасный шаблон Claude Code для детей с ограничениями и логированием.

## Что включено

- Ограниченные права (без интернета, без bash)
- Автоматическое логирование всех сессий
- Правила поведения для Claude
- Инструкция для родителей

## Быстрый старт

```bash
git clone https://github.com/fedor-jpg/life-os-template-kids.git ~/KidsCore
chmod +x ~/KidsCore/.claude/hooks/log-message.sh
```

Открой `~/KidsCore` в VS Code.

## Для родителей

См. [PARENT-SETUP.md](PARENT-SETUP.md) — настройка логирования и мониторинга.

## Структура

```
~/KidsCore/
├── CLAUDE.md           ← правила для Claude
├── PARENT-SETUP.md     ← инструкция для родителей
├── notes/              ← заметки ребёнка
├── projects/           ← учебные проекты
└── .claude/
    ├── settings.json   ← ограничения
    └── hooks/          ← логирование
```

---

*Template by Fedor @ Chatfuel • Январь 2026*
