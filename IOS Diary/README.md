# Mood Diary (iOS 17+)

A minimal SwiftUI mood tracker with an interactive Widget (WidgetKit + App Intents) and App Group persistence.

## Features
- One-tap logging from a medium widget with 4 emoji buttons
- "Fine tune" sheet with slider (0…10), note, haptics, and auto-close on save
- App Intents: QuickMoodIntent(value:) and OpenFineTuneIntent()
- UserDefaults with App Group JSON storage: group.com.yourcompany.mood
- Daily reminders via UNUserNotificationCenter
- Export entries as JSON or CSV
- RU/EN localization

## Structure
- App/ — SwiftUI app (ContentView, FineTuneSheet, AppIntents, App entry)
- Widget/ — WidgetKit extension with interactive ControlWidgetButton
- Shared/ — Models, Store, Helpers, Localizations (used by both targets)
- project.yml — XcodeGen project configuration

## Requirements
- Xcode 15+, iOS 17+
- App Group: group.com.yourcompany.mood

## Setup (macOS)
1. Install XcodeGen (optional but recommended):
   
    ```bash
    brew install xcodegen
    ```
2. Generate Xcode project:
   
    ```bash
    xcodegen generate
    ```
3. Open MoodDiary.xcodeproj in Xcode
4. Set Signing & Capabilities:
    - Team: your Apple Developer team
    - Bundle IDs: com.yourcompany.mood (app), com.yourcompany.mood.widget (widget)
    - Add App Groups: group.com.yourcompany.mood to both targets
5. Build and run on iOS 17+ simulator or device

## Notes
- Interactive widgets require iOS 17+
- ControlWidgetButton triggers App Intents without confirmation
- OpenFineTuneIntent sets a flag in App Group; the app shows FineTuneSheet on launch

## Localization
Localizable.strings in en.lproj and ru.lproj contain UI strings.

## Haptics
- Slider changes use UIImpactFeedbackGenerator
- Save uses UINotificationFeedbackGenerator(.success)

## Export
- JSON via MoodStore.exportJSON()
- CSV via MoodStore.exportCSV()

## Privacy / Security
- Optional Face ID/Keychain can be added later (entitlement placeholder added)

---
Friendly, commented code throughout for easy extension. Enjoy! 😊