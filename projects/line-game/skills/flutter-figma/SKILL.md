---
name: flutter-figma
description: "Use when: Figma макеты, экспорт дизайн-токенов, цвета/шрифты/отступы из Figma, импорт UI-kit, проверка соответствия пиксель-перфект, передача дизайн-спецификаций в код"
---

# Figma to Flutter

## Назначение
Скил для синхронизации Figma-дизайна с Flutter-кодом проекта.

## Когда применять
- перенос макета из Figma в Flutter-виджеты
- экспорт цветов, типографики, отступов, радиусов
- проверка pixel-perfect соответствия
- генерация токенов темы из Figma Variables
- создание компонентов по дизайн-системе

## Процесс переноса

### 1. Цвета → ColorScheme + AppUiTheme
- Из Figma собрать: primary, secondary, surface, error, on-цвета
- Сопоставить с существующей `app_color_schemes.dart`
- Если Figma использует новые токены — добавить в `AppUiTheme` (ThemeExtension)
- Убедиться, что нет хардкоженных `Color(0x...)` в коде

### 2. Типографика → TextTheme
- Figma: font family, size, weight, line height, letter spacing
- Flutter: `Theme.of(context).textTheme`
- Для UI-компонентов appShell — использовать `AppUiTheme` текстовые цвета
- Избегать `const TextStyle(...)` с жёсткими значениями

### 3. Отступы → Spacing constants
- Создать централизованные константы или использовать существующий паттерн
- Figma auto-layout padding/margin → EdgeInsets

### 4. Радиусы → ShapeTheme
- BorderRadius из Figma → `CardTheme()`, `DialogTheme()` и т.д.
- Для кастомных скруглений — через `ClipRRect` с константой

### 5. Иконки/иллюстрации
- SVG из Figma → через `flutter_svg` (SvgPicture.asset или SvgPicture.network)
- Размещать в `assets/` или загружать с CDN
- Data URI из Figma поддерживается через `RuntimeImageService.decodeDataUri()`

### 6. Анимации/micro-interactions
- Figma Smart Animate → `AnimationController` + `Tween`
- Длительности: стандарт 200-300ms, `Curves.easeInOut`
- `LoadingDotsIndicator` — готовая анимация загрузки

## Проверка pixel-perfect
- `dart run build_runner` после добавления ассетов
- `flutter test` для виджет-тестов (Golden tests, если настроены)
- Визуальная проверка на эмуляторе/устройстве

## Инварианты
- Цвета ТОЛЬКО через `Theme.of(context)` и `AppUiTheme`
- Нет `fontFamily: 'Roboto'` хардкодом — использовать `textTheme`
- Размеры — кратные 4 (Material Design guideline, если Figma не диктует иное)
