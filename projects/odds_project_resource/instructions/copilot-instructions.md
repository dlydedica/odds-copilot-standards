# Инструкции для GitHub Copilot — проект odds_project_resource

Библиотека скилов доступна через submodule: `.github/standards/`

- **Базовые скилы** (общие): `.github/standards/base/skills/`
- **Проектные скилы** (odds_project_resource): `.github/standards/projects/odds_project_resource/skills/`
- **Агенты**: `.github/standards/projects/odds_project_resource/agents/`
- **Обновление**: `git submodule update --remote .github/standards`

## О проекте
Этот репозиторий содержит Server-Driven UI (SDUI) JSON-ресурсы для Flutter-приложения odds_project.

## Структура
- `app/assets/ui_resources/init_response.json` — контракты и транспорт
- `app/assets/ui_resources/{locale}/` — ресурсы для каждой локали:
  - `feeds/` — конфигурация источников данных
  - `menu_items/` — пункты меню
  - `structure/` — shell-структура приложения
  - `theme/` — дизайн-токены (Material 3 color scheme)
  - `ui/` — UI-описания экранов (home, matches, news, offers)

## Локали
- `en/` — английский
- `ru/` — русский
- `mx/` — мексиканский испанский

**Важно:** всегда синхронизируй изменения между всеми тремя локалями.

## Деплой
- Автоматический при пуше в `main` (GitHub Actions)
- Целевой сервер: `141.105.64.214:/www/parser_project/resours/app/lg/v2/ui_resources/`
- Вручную: SCP с ключом `id_ed25519_hostkey_141_105_64_214`

## Flutter-фреймворк
Приложение использует **Stac** (Server-Driven UI for Flutter).
- GitHub: https://github.com/StacDev/stac
- Pub.dev: https://pub.dev/packages/stac
- Документация: https://docs.stac.dev

## Доступные скилы
- `sdui-json-schema` — SDUI JSON формат и виджеты
- `sdui-deployment` — деплой на сервер
- `stac-framework` — официальный Stac SDK (виджеты, парсеры, рендеринг, инициализация)

## Правила
- Всегда применяй контракты и схемы из документации проекта.
- Соблюдай требования валидации SDUI JSON.
- Пиши комментарии на русском языке.
- JSON-файлы — на английском (контент для пользователей).
