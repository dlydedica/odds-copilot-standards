# odds-copilot-standards

Библиотека агентов и скилов для GitHub Copilot.

**Проекты:** [line-game](https://github.com/dlydedica/odds_project) · [parser](https://github.com/dlydedica/parser_bet) · [odds_project_resource](https://github.com/dlydedica/odds_project_resource)

---

## Структура

```
.
├── base/                                    # Общие скилы (для всех проектов)
│   ├── agents/                              # Базовые определения агентов
│   ├── skills/                              # Скилы: архитектура, деплой, безопасность...
│   └── instructions/                        # copilot-instructions.md
│
├── projects/
│   ├── line-game/                           # Специфика line-game (Flutter + Backend)
│   │   ├── agents/
│   │   ├── skills/                          # Flutter-скилы: SDUi, виджеты, темизация...
│   │   └── instructions/
│   │
│   ├── parser/                              # Специфика parser (парсеры событий)
│   │   ├── agents/
│   │   ├── skills/                          # Парсер-скилы: деплой, smoke-тесты...
│   │   └── instructions/
│   │
│   └── odds_project_resource/               # Специфика odds_project_resource (SDUI JSON)
│       ├── agents/
│       │   └── sdui-ui-agent.agent.md       # SDUI UI/UX Agent
│       ├── skills/
│       │   ├── sdui-deployment/             # Деплой SDUI ресурсов
│       │   ├── sdui-json-schema/            # SDUI JSON формат и виджеты
│       │   └── stac-framework/              # Stac SDK (виджеты, парсеры, рендеринг)
│       └── instructions/
│           └── copilot-instructions.md
│
├── shared/                                  # Общие конфиги (gitignore, editorconfig...)
├── scripts/                                 # Скрипты синхронизации
└── README.md
```

## Подключение в проекте

```bash
# Добавить как submodule
git submodule add https://github.com/dlydedica/odds-copilot-standards.git .github/standards

# Слинковать базовые инструкции
ln -s .github/standards/base/instructions/copilot-instructions.md copilot-instructions.md

# Слинковать проектные инструкции (если есть)
ln -s .github/standards/projects/<project>/instructions/copilot-instructions.md copilot-instructions.project.md
```

## Обновление

```bash
# Подтянуть последние изменения из центрального репозитория
git submodule update --remote .github/standards
git add .github/standards && git commit -m "sync: обновление copilot-standards"
```

## Классификация скилов

| Префикс | Назначение | Пример |
|---------|-----------|--------|
| `base-`* | Общие для всех проектов | `backend-deploy`, `server-security` |
| `flutter-`* | Специфика Flutter (line-game) | `flutter-sdui-runtime` |
| `pm-`* | Project management | `pm-progress` |
| `qa-`* | Quality assurance | `qa-test-strategy` |
| `docker-`* | Docker специфика | `docker-deploy` (parser) |
| `sdui-`* | SDUI ресурсы (odds_project_resource) | `sdui-deployment` |
| `stac-`* | Stac Framework | `stac-framework` |

## Добавление нового скила

1. Создать директорию `base/skills/<name>/SKILL.md` (или в `projects/<project>/skills/`)
2. Заполнить YAML frontmatter:
   ```yaml
   ---
   name: <name>
   description: "Use when: ..."
   ---
   ```
3. Описать знания и правила использования
4. Закоммитить и запушить
5. В проектах: `git submodule update --remote .github/standards`
