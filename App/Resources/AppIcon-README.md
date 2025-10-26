# App Icon guidance

This project currently defines a minimal iPhone app icon set in `Assets.xcassets/AppIcon.appiconset/Contents.json`.

Recommended next steps to complete the icon set:

- Provide at least these iPhone icon bitmaps (PNG, no alpha):
  - 60x60 @2x → 120x120 (iPhone App)
  - 60x60 @3x → 180x180 (iPhone App)
  - 1024x1024 (App Store / marketing)
- Optional legacy sizes (Xcode may infer automatically, but include if you want explicit coverage):
  - 40x40 @2x (80x80), @3x (120x120)
  - 29x29 @2x (58x58), @3x (87x87)

How to generate quickly:

- Using Xcode on macOS: drop a 1024x1024 PNG into the AppIcon catalog and let Xcode scale variants.
- Using a web generator (Windows-friendly): export a 1024x1024 PNG and generate iOS icon set; then replace/add the generated PNG files and update `Contents.json` if needed.

Tips:
- Keep the background opaque; avoid transparency.
- Use sRGB PNGs and avoid color profiles that can shift on device.
- After updating icons, do a clean build to ensure the new assets are packaged.
