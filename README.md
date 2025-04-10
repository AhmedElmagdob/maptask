# 🚀 Flutter Package Integration Automator

**Automate Flutter package setup with zero hassle!**  
A powerful tool that handles package integration, platform configuration, and boilerplate generation in one click.
[![Flutter](https://www.reshot.com/preview-assets/icons/TZCXQGV5F4/maps-TZCXQGV5F4.svg)](https://flutter.dev)
<p align="center">
  <img src="https://www.svgrepo.com/show/444064/legal-license-mit.svg" alt="Demo" width="800">
</p>


## ✨ Features

✅ **One-Command Integration**
- Adds packages to `pubspec.yaml`
- Configures Android/iOS automatically

✅ **Smart Platform Setup**
- Android: Updates `AndroidManifest.xml` & `build.gradle`
- iOS: Configures `AppDelegate.swift` and `Info.plist`

✅ **State Management Ready**
- Generates **BLoC/Riverpod** templates
- Pre-built map screen with live location

✅ **User-Friendly**
- GUI & CLI support
- Interactive API key prompt

## 🛠️ Installation

```bash
# Clone the repository
git clone https://github.com/AhmedElmagdob/maptask/
cd flutter-package-integrator

# Install dependencies
flutter pub get
your_project/
├── lib/
│   ├── bloc/          # BLoC files (events, states)
│   ├── screens/       # Pre-built map screen
│   └── main.dart      # Updated entry point
├── android/           # Auto-configured
└── ios/               # Auto-configured
