---
name: flutter-theming
description: "Use when: темизация, Material 3, цвета, цветовые схемы, AppUiTheme, brandScheme, light/dark темы, scaffoldBackgroundColor, ThemeExtension, копирование темы"
---

# Flutter Theming

## Источник знаний
- `lib/app/theme/app_theme.dart` — фабрика ThemeData (light/dark)
- `lib/app/theme/app_color_schemes.dart` — статические ColorScheme (light/dark)
- `lib/app/theme/app_ui_theme.dart` — кастомный ThemeExtension (AppUiTheme)
- `lib/core/models/mobile_init_response_v2.dart` — RuntimeBrandSchemeConfig, RuntimeAppChromeTokens

## Когда применять
- настройка/правка цветовой схемы приложения
- добавление новых токенов в AppUiTheme
- интеграция brandScheme с сервера (runtime-переопределение цветов)
- работа с scaffold, card, divider, text цветами
- создание новых ThemeExtension

## Ключевые компоненты

### AppTheme
- `AppTheme.light(overrides, appChromeOverrides)` / `AppTheme.dark(...)` — создание ThemeData
- Использует `lightColorScheme` / `darkColorScheme` из `app_color_schemes.dart`
- Применяет `RuntimeBrandColorTokens` через `_applyOverrides()`
- Регистрирует `AppUiTheme` как `ThemeExtension`

### AppUiTheme (ThemeExtension)
- 15 полей: topMenu, appBar, bottomMenu, content цвета
- Собирается через `AppUiTheme.fromAppChrome(appChromeOverrides)`
- Доступ в UI: `Theme.of(context).extension<AppUiTheme>()`
- Обязательный lerp/copyWith для анимации перехода темы

### BrandScheme (с сервера)
- `RuntimeBrandColorTokens.light` / `.dark` — переопределения базовых цветов
- Маппинг: `primary → primary`, `onSurface → onSurface`, `outline → outline` и т.д.
- Применяется в `AppTheme._applyOverrides()`

## Принципы
- НИКОГДА не использовать `Color(0x...)` напрямую — только через `Theme.of(context)`
- Для цветов UI-компонентов (topMenu, bottomMenu, card) — использовать `AppUiTheme`
- Для базовых Material-цветов — использовать `ColorScheme`
- `contentPrimaryText` / `contentSecondaryText` — для текста в секциях
- `contentCardBackground` — для карточек матчей/офферов
