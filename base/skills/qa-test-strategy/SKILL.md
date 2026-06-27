---
name: qa-test-strategy
description: "Use when: тестирование Flutter (flutter test), тестирование backend (pytest), unit/integration/e2e, smoke-скрипты, Flutter driver, coverage, регрессия"
---

# QA Test Strategy

## Источник знаний
- `client/flutter/app_odds_new/test/` — Flutter тесты
- `server/tests/` — pytest тесты backend
- `server/conftest.py` — конфигурация pytest
- `server/pytest.ini` — настройки pytest
- `scripts/` — smoke-скрипты
- `docs/server_docs/development_progress.md` — прогресс покрытия

## Когда применять
- написание новых тестов (unit/integration)
- запуск регрессии после изменений
- проверка coverage после рефакторинга
- smoke-тестирование API endpoints
- E2E тестирование Flutter через Flutter driver

## Flutter тесты

### Запуск
```bash
cd client/flutter/app_odds_new
flutter test test/<path>    # таргетный запуск
flutter test                 # все тесты
```

### Что тестировать
- `EventCache`: updateCache, patchEvent, pruneStale, clearCacheByFeedId
- `FeedFieldMappingRegistry`: resolve для разных feed_id
- `MobileInitResponseV2`: uiMode, toClientStacPayload, _buildAppShellPayload
- `RssNewsService._tryParseDate`: разные форматы дат
- `AppShellData.fromJson`: tabs, menuPlacement, feedTransportMode

## Backend тесты

### Запуск
```bash
cd server
$env:ODDS_SKIP_INIT_DB=1
pytest server/tests/<path> -v   # таргетный
pytest server/tests/ -v          # все
```

### Что тестировать
- Route: статус-коды, валидация, error cases
- Service: бизнес-логика, граничные случаи
- Infrastructure: Repository запросы, фильтрация
- API контракты: соответствие response схеме

## Smoke-скрипты
- `scripts/mobile_init_cloaking_check.py` — проверка init + cloaking
- `scripts/mobile_offers_feed_check.py` — проверка offers feed
- `scripts/perf_smoke_targeting.py` — performance smoke

## Flutter Driver (E2E)
```bash
flutter drive --driver=test_driver/integration_test.dart test/<e2e_test>.dart
```
- Использовать через `mcp_dart_and_flut_flutter_driver` MCP

## Инварианты
- Backend: `ODDS_SKIP_INIT_DB=1` обязателен при локальном запуске
- Flutter: `flutter analyze` перед коммитом
- Smoke-скрипты запускать с `python scripts/<name>.py`
