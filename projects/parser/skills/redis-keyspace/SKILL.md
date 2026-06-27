---
name: redis-keyspace
description: "Справка по Redis keyspace v4 проекта. Использовать для: работы с Redis ключами, TTL, key builders, namespace parser:v4, revision polling, health keys. Триггеры: redis, keyspace, ключи, TTL, key builder, parser:v4, revision, polling."
---

# Redis Keyspace v4 — Справочник

## Назначение

Быстрая справка по Redis keyspace активной архитектуры `parser:v4:*`.

## Основные группы ключей

### Raw events

| Паттерн | Тип | TTL | Назначение |
|---------|:---:|:---:|------------|
| `parser:v4:raw:event:{source}:{sport}:{source_event_id}` | String JSON | 7д | Snapshot: raw + normalized |
| `parser:v4:raw:event_hash:{source}:{sport}` | Hash | 7д | Fingerprint для dedup |
| `parser:v4:raw:event_idx:source:{source}` | Set | 7д | События источника |
| `parser:v4:raw:event_idx:sport:{sport}` | Set | 7д | Raw refs по спорту |
| `parser:v4:raw:event_idx:date:{date}` | Set | 7д | Raw refs по дате |
| `parser:v4:raw:event_meta:{source}` | Hash | 2д | Freshness и статистика |

### View (canonical events)

| Паттерн | Тип | TTL | Назначение |
|---------|:---:|:---:|------------|
| `parser:v4:canon:event:{event_uid}` | String JSON | 7д | Canonical событие |
| `parser:v4:canon:event_idx:source:{source}` | Set | 7д | Canonical refs по источнику |
| `parser:v4:canon:event_idx:sport:{sport}` | Set | 7д | Canonical refs по спорту |
| `parser:v4:canon:event_idx:date:{date}` | Set | 7д | Canonical refs по дате |

### Delta (revision-based polling)

| Паттерн | Тип | TTL | Назначение |
|---------|:---:|:---:|------------|
| `parser:v4:delta:event:{event_uid}` | String JSON | 7д | Дельта события |
| `parser:v4:delta:event_idx:{revision}` | Set | 7д | События по ревизии |
| `parser:v4:delta:revision:event` | String | ∞ | Текущий номер ревизии |

### Control / Leases

| Паттерн | Тип | TTL | Назначение |
|---------|:---:|:---:|------------|
| `parser:v4:control:browser_lease` | String | 60с | Browser slot |
| `parser:v4:control:page_lease` | String | 60с | Page slot |
| `parser:v4:control:lease:adapter:{source}` | String | 60с | Adapter lease |
| `parser:v4:control:feed_health:{source}` | Hash | 7д | Health фида |
| `parser:v4:entity:reindex_needed` | Set | 7д | Dirty-index для reindex |

### Image mirror

| Паттерн | Тип | TTL | Назначение |
|---------|:---:|:---:|------------|
| `parser:v4:image_mirror:url:{sha1(source_url)}` | Hash | по ENV | Статус зеркала |

## Важные правила

- **Никаких магических строк** `parser:v4:*` в runtime коде — только через `shared/redis_keys.py`
- TTL — только через `shared/redis_ttl.py`
- Канонический документ: `docs/server_docs/redis.md`

## Быстрые команды Redis CLI

```bash
# Все ключи v4
KEYS parser:v4:*
# Raw события конкретного источника
SMEMBERS parser:v4:raw:event_idx:source:1xbet
# Контрольные ключи
GET parser:v4:delta:revision:event
```
