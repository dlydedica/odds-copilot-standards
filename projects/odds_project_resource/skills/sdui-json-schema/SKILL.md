---
description: "SDUI JSON Schema — полное описание формата Server-Driven UI ресурсов проекта odds_project. Use when: работа с SDUI JSON, создание/редактирование UI-ресурсов, валидация виджетов, дизайн-токены, шаблонизация"
---

# SDUI JSON Schema — Server-Driven UI ресурсы

## Общее описание

SDUI (Server-Driven UI) — JSON-формат для декларативного описания Flutter-интерфейсов. Все ресурсы находятся в `app/assets/ui_resources/{locale}/`.

**Локали:** `en/` (английский), `ru/` (русский), `mx/` (мексиканский испанский).

## Структура директорий

```
app/assets/ui_resources/
├── init_response.json          # Контракты экшенов и транспорт
├── {locale}/
│   ├── feeds/                  # Конфигурация источников данных
│   │   ├── feeds.json
│   │   └── feeds_backup.json
│   ├── menu_items/             # Пункты меню
│   │   └── menu_items.json
│   ├── structure/              # Shell-структура приложения (табы, роутинг)
│   │   ├── with_offers.json
│   │   └── out_offerrs.json
│   ├── theme/                  # Дизайн-токены
│   │   └── color_sheme.json
│   └── ui/                     # UI-описания экранов
│       ├── home/
│       │   ├── home_response.json
│       │   └── event_card_styles.json
│       ├── matches_ui_response.json
│       ├── news_ui_response.json
│       └── offers_ui_response.json
```

## Базовые JSON-типы виджетов

Каждый виджет содержит `type` и опционально `children`/`child`.

### Контейнерные виджеты
```json
{ "type": "container", "padding": [16,0,16,0], "decoration": { "color": "#FFFFFF", "borderRadius": 14 } }
{ "type": "padding", "padding": [16, 0, 16, 0], "child": { ... } }
{ "type": "sizedBox", "height": 14, "width": 128 }
{ "type": "expanded", "child": { ... } }
{ "type": "flexible", "flex": 1, "child": { ... } }
{ "type": "positioned", "top": 0, "left": 0, "right": 0, "bottom": 0, "child": { ... } }
```

### Layout виджеты
```json
{ "type": "listView", "scrollDirection": "horizontal", "children": [...] }
{ "type": "row", "mainAxisAlignment": "spaceBetween", "crossAxisAlignment": "start", "spacing": 12, "children": [...] }
{ "type": "column", "crossAxisAlignment": "start", "mainAxisAlignment": "spaceBetween", "spacing": 4, "children": [...] }
{ "type": "stack", "fit": "expand", "children": [...] }
```

### Текстовые виджеты
```json
{ "type": "text", "data": "Hello", "maxLines": 1, "overflow": "ellipsis", "textAlign": "center",
  "style": { "fontFamily": "Roboto", "fontSize": 14, "fontWeight": "w700", "color": "#141414", "letterSpacing": 0.5 } }
```

### Медиа виджеты
```json
{ "type": "image", "src": "https://...", "imageType": "network", "fit": "cover" }
{ "type": "icon", "icon": "sports_soccer", "iconType": "material", "size": 18, "color": "#F52F3B" }
```

### Интерактивные виджеты
```json
{ "type": "inAppLinkContainer", "link": "app://inApp?tabBarId=matches&topMenuId=football", "child": { ... } }
```

### Кастомные виджеты
```json
{ "type": "homeHeroCarousel", "height": 196, "viewportFraction": 1.0, "padEnds": false,
  "pageHorizontalPadding": 16, "indicatorBottom": 12, "indicatorSize": 6, "indicatorSpacing": 6,
  "activeIndicatorColor": "#FFFFFF", "inactiveIndicatorColor": "#66FFFFFF", "children": [...] }
```

## Продвинутые возможности

### Маркеры событий
```json
{ "type": "inAppLinkContainer", "event_card_marker": "home_event_card_1", "link": "app://inApp?..." }
```

### Внешние ссылки
```json
{ "type": "inAppLinkContainer", "link": "https://external.site.com", "isExternal": true }
```

### Шаблонизация (плейсхолдеры)
```json
{ "type": "text", "data": "{{team_name}}" }
{ "type": "image", "src": "{{logo_url}}" }
```

### Условная видимость
```json
{ "_visible_if": "condition_name" }
```

### Декорации (Container)
```json
"decoration": {
  "color": "#F52F3B",
  "borderRadius": 999,
  "border": { "color": "#ECECEC", "width": 1 }
}
```

## Дизайн-токены (scorex_tokens)

Файл `theme/color_sheme.json` содержит:
- Material 3 color scheme (light + dark)
- Seed color
- Типографика с fontFamily Roboto

Токены используются во всех UI-файлах как ссылки `{{scorex_token_name}}`.

## Правила при работе с SDUI JSON

1. **Локализация:** всегда синхронизируй изменения между `en/`, `ru/` и `mx/`. Если меняешь `en/ui/home/home_response.json`, те же правки примени к `ru/` и `mx/`.
2. **Валидация JSON:** перед коммитом проверяй валидность JSON (без trailing commas, корректные кавычки).
3. **Цвета:** используй HEX-формат `#RRGGBB` или `#AARRGGBB`.
4. **Отступы:** все padding/margin — массивы `[top, right, bottom, left]` или `[all]`.
5. **Изображения:** `imageType` может быть `network` (URL) или `asset` (локальный).
6. **Типографика:** `fontWeight` использует значения `w400`, `w500`, `w600`, `w700`.
7. **Не добавляй** Flutter/Dart код — это SDUI, всё описывается JSON.
8. **Оверскролл:** ширина `width: "infinite"` доступна для растяжения на весь экран.
