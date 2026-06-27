---
name: flutter-feed-cache
description: "Use when: feed-кэш, EventCache, FeedRuntimeManager, OpenApiFeedDataService, дельтовый поллинг, snapshot-токены, пакетное обновление событий, stale-контроль, маппинг полей событий"
---

# Flutter Feed Cache System

## Источник знаний
- `lib/core/cache/event_cache.dart` — in-memory кэш событий
- `lib/core/cache/feed_snapshot_token_store.dart` — токены дельтового поллинга
- `lib/core/services/feed_runtime/feed_runtime_manager.dart` — менеджер фидов
- `lib/core/services/feed_runtime/feed_data_service.dart` — HTTP + кэш
- `lib/core/services/feed_runtime/feed_cache_batch_updater.dart` — пакетная запись
- `lib/core/services/feed_runtime/feed_data_transformer.dart` — нормализация событий
- `lib/core/mappings/feed_field_mapping_registry.dart` — маппинг полей (единственный источник)

## Когда применять
- загрузка матчей/офферов/новостей через OpenAPI
- дельтовый поллинг (delta polling) с next_cursor
- stale-контроль и прунинг кэша
- batch-update и patch-операции над событиями
- нормализация сырых API-ответов в единый формат

## Ключевые компоненты

### EventCache
- in-memory `Map<String, Map<String, dynamic>>` с лимитом `maxEntries` (500 по умолчанию)
- Автоматическое вытеснение LRU при переполнении (`_pruneOverflow`)
- Индекс `_eventIdsByFeedId` для быстрой выборки по feed_id
- Методы: `updateCache`, `updateCacheBatch`, `patchEvent`, `patchEventsBatch`, `removeEvent`, `pruneStale`, `pruneStaleByFeed`

### FeedSnapshotTokenStore
- Хранит `next_token` для каждого feed_id
- Используется для дельтового поллинга: `save → get → clear`

### FeedRuntimeManager
- Singleton, управляет состоянием всех feed-потоков
- `preloadFromInit()` — прогрев при старте (приоритетные vs отложенные фиды)
- `watchFeedRaw()` — стрим для UI-подписки
- Содержит таймер stale-контроля (`_staleControlTimer`)

### OpenApiFeedDataService
- `quickStart()` — быстрая загрузка первой порции данных
- `lazyPage()` — подгрузка следующей страницы
- `getFeedRaw()` — чтение из кэша или raw store

## Инварианты
- Маппинг полей — ТОЛЬКО через `FeedFieldMappingRegistry.resolve(feedId)`, не дублировать
- Все события хранятся с полем `feed_id` для индексной выборки
- `raw` поле в нормализованном событии содержит оригинальный ответ (для отладки)
- Stale-контроль: TTL из `FeedApiConfig.cacheTtl` или дефолт 15 минут
