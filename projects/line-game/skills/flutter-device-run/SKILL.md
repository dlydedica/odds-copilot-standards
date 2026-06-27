---
name: flutter-device-run
description: "Use when: запуск Flutter приложения на устройстве, сборка APK, Gradle ошибки, ADB offline, device not found, USB debugging, установка на телефон"
---

# Flutter Device Run

## Источник знаний
- `client/flutter/app_odds_new/` — Flutter проект
- `client/flutter/app_odds_new/android/gradle.properties` — настройки Gradle
- `client/flutter/app_odds_new/pubspec.yaml` — зависимости

## Когда применять
- запуск приложения на физическом устройстве или эмуляторе
- сборка APK / AppBundle
- ошибки Gradle (heap space, кэш)
- устройство не определяется / ADB offline
- чистка кэша сборки

## Процесс запуска

### 1. Проверить устройства
```powershell
cd client/flutter/app_odds_new
flutter devices
```

Ожидаемый вывод: список подключённых устройств с ID.
Если устройство не отображается:
- Проверить USB-кабель
- Включить отладку по USB на телефоне
- Переподключить кабель

### 2. Запуск в debug-режиме
```powershell
flutter run -d <device_id>
```

### 3. Запуск в release-режиме (без красного экрана)
```powershell
flutter run -d <device_id> --release
```

### 4. Сборка APK для публикации
```powershell
flutter build apk --release
```

## Типовые проблемы и решения

### Gradle: Java heap space
**Ошибка:** `Java heap space` / `OutOfMemoryError` во время сборки.
**Решение:** увеличить память Gradle в `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m
org.gradle.parallel=true
```

### ADB: device offline
**Ошибка:** `adb.exe: device offline`.
**Решение:**
1. Переподключить USB-кабель
2. На телефоне подтвердить «Разрешить отладку по USB»
3. Проверить: `adb devices` (должен быть статус `device`, не `offline`)
4. Если не помогло: `adb kill-server && adb start-server`

### Сборка падает после обновления зависимостей
**Решение:**
```powershell
flutter clean
flutter pub get
flutter run -d <device_id>
```

### Устройство не найдено (no supported devices)
**Решение:**
1. `flutter devices` — проверить список
2. Если пусто — переустановить драйвер ADB
3. Если эмулятор — запустить через Android Studio

### Flutter analyze показывает ошибки
```powershell
flutter analyze
```
Исправить все `error` перед запуском. `info` и `warning` не блокируют сборку.

## Быстрые команды

| Действие | Команда |
|----------|---------|
| Список устройств | `flutter devices` |
| Debug-запуск | `flutter run -d <id>` |
| Release-запуск | `flutter run -d <id> --release` |
| Сборка APK | `flutter build apk --release` |
| Чистка кэша | `flutter clean && flutter pub get` |
| Перезапуск ADB | `adb kill-server && adb start-server` |
