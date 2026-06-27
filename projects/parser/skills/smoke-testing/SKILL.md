---
name: smoke-testing
description: "Запуск smoke-тестов проекта. Использовать для: проверки API endpoint-ов, запуска pytest тестов, валидации деплоя, быстрых проверок после изменений. Триггеры: тесты, smoke, pytest, проверка API, валидация, test."
---

# Smoke-тестирование проекта

## Назначение

Быстрая валидация ключевых сценариев работы сервиса.

## Набор тестов

Все smoke-тесты находятся в `tests/`:

| Файл | Назначение |
|------|-----------|
| `test_events_api_cache_smoke.py` | API кэш событий |
| `test_events_list_smoke.py` | Список событий |
| `test_events_live_hot_rank.py` | Live/hot rank |
| `test_events_polling_smoke.py` | Polling событий |
| `test_news_smoke.py` | Новости |
| `test_parser_xbet_images.py` | Зеркалирование изображений |
| `test_ingest_cleanup_modes.py` | Очистка ingest |
| `test_ingest_markets_guard.py` | Защита рынков |
| `test_materialize_markets_guard.py` | Materialize защита |
| `test_stage6_batch_smoke.py` | Batch обработка |
| `test_xbet_optional_enrichment_resilience.py` | Enrichment resilience |
| `test_redis_keys_variant2.py` | Redis keys |
| `test_proxy_alert_metrics.py` | Proxy alert метрики |
| `test_google_translate_provider_lang_aliases.py` | Переводы |

## Запуск

```bash
# Все smoke-тесты
pytest tests/ -v

# Конкретный тест
pytest tests/test_events_list_smoke.py -v

# С подробным выводом
pytest tests/ -v --tb=long

# Без инициализации БД (для локального запуска)
ODDS_SKIP_INIT_DB=1 pytest tests/ -v
```

## Smoke-проверки API

```bash
# Health
curl https://parser.pcom1.ru/health

# События
curl "https://parser.pcom1.ru/v4/events?sports=football&lang=ru&limit=5"

# Polling
curl "https://parser.pcom1.ru/v4/events/polling?last_revision=0&limit=10"
```

## Контекст

- API base URL (production): `https://parser.pcom1.ru`
- Для локального запуска тестов выставлять `ODDS_SKIP_INIT_DB=1`
- На Windows при печати API-ответов возможен UnicodeEncodeError — использовать `ensure_ascii=True`
