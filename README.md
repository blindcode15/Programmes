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

## Install to iPhone from Windows (no local Mac)
You can generate an unsigned IPA in GitHub Actions and sideload it from Windows.

1) Generate IPA in CI
- Push the repo to GitHub
- Run workflow: `.github/workflows/ios-device-ipa.yml` (manually via “Run workflow” or push)
- Download artifact `MoodDiary-unsigned-ipa/MoodDiary-unsigned.ipa`

2) Install on iPhone from Windows via Sideloadly (or AltStore)
- Install Sideloadly on Windows
- Connect your iPhone via USB (or Wi‑Fi per Sideloadly docs)
- Drag `MoodDiary-unsigned.ipa` into Sideloadly and follow prompts

Notes:
- Unsigned IPA is packaged without code signing (for sideload tools to handle signing with your Apple ID)
- For interactive widgets and App Intents to work fully, iOS 17+ is required
- App Groups capability may require enabling the group in the final signed app; if needed, adjust Bundle IDs or capabilities accordingly

## TestFlight (alternative, requires paid developer account)
- Configure signing in Xcode with your team
- Archive and upload to App Store Connect
- Invite your device via TestFlight

## Troubleshooting sideload installs
- If the IPA fails to install due to entitlements or extensions, try an app-only build (without Widget target) while testing core flows:
    - Temporarily remove the `MoodWidget` dependency and target from `project.yml`
    - Regenerate the project with `xcodegen generate`
    - Re-run the `iOS Device IPA` workflow
    - Install the app-only IPA with Sideloadly
    - Re-enable the widget later when you move to TestFlight or a signed build on macOS

## Notes
- Interactive widgets require iOS 17+
- ControlWidgetButton triggers App Intents without confirmation
- OpenFineTuneIntent sets a flag in App Group; the app shows FineTuneSheet on launch
 - On Windows, you can preview the UX in a lightweight web mock at `PreviewWeb/index.html` (see below).

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

## Windows quick preview (no Mac required)
This project includes a lightweight web mock to preview the overall UX from Windows:

- Open `PreviewWeb/index.html` in your browser (no server required). You’ll see:
    - A mock of the medium widget row with 4 emoji and a fine‑tune button
    - A compact sheet (~35% height) with slider (0–10), note input, Save/Nothing
    - Haptic feedback simulated via `navigator.vibrate()` when supported

Limitations of the mock:
- No real iOS logic (WidgetKit/App Intents/App Groups aren’t available in the browser)
- Data is not persisted (page refresh clears entries)
- Visuals approximate SwiftUI look and spacing, not pixel‑perfect

Use this to get an immediate sense of flows and micro‑interactions. For actual iOS behavior, use Xcode on macOS.