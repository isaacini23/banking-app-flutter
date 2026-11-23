# Flutter Banking App

A Flutter-based banking dashboard UI prototype built with Dart. The project demonstrates a multi-screen mobile finance interface, reusable widgets, Provider-based state management, chart visualisation, and a locally stored display preference.

> **Project status:** UI prototype / learning project. The balances, card details, and transaction records shown in the app are sample interface data. This project does not connect to a bank, process payments, transfer real money, or provide production banking security.

## Screenshots

The repository includes simulator screenshots in the `screenshots/` directory.

![Banking app screenshot](screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20-%202022-01-18%20at%2003.22.04.png)

[Browse all screenshots](screenshots/)

## Features

- **Home dashboard:** sample account balance, payment-card presentation, quick-action shortcuts, and recent transactions.
- **Wallet:** card overview interface and an add-card form prototype.
- **Statistics:** income/expense dashboard presentation with line-chart visualisation using `fl_chart`.
- **Profile:** profile screen and settings-style menu.
- **Theme preference:** light/dark appearance managed through Provider and SharedPreferences.
- **Bottom navigation:** navigation between Home, Wallet, Statistics, and Profile.
- **Reusable UI:** shared widgets, styling helpers, and custom font assets.

## Tech stack

- Flutter
- Dart
- Provider
- SharedPreferences
- fl_chart
- gap
- Custom fonts and local image assets

## Project structure

```text
lib/
├── generated/       # Generated asset references
├── json/            # Sample transaction and shortcut data
├── repo/            # Shared theme and presentation helpers
├── utils/           # Styles, layouts, sizing and icon definitions
├── view_models/     # Provider view model
├── views/           # Home, Wallet, Stats, Profile and Add Card screens
├── widgets/         # Reusable UI components and bottom navigation
└── main.dart        # Application entry point

assets/              # Fonts, card artwork and other app assets
screenshots/         # Simulator screenshots
test/                # Flutter widget tests
```

## Getting started

### Requirements

- Flutter SDK
- Dart SDK compatible with the SDK constraint in `pubspec.yaml`
- Android Studio, VS Code, or another Flutter-supported IDE
- An Android emulator, iOS simulator (on macOS), or connected device

### Run locally

1. Clone the repository:

   ```bash
   git clone https://github.com/isaacini23/banking-app-flutter.git
   cd banking-app-flutter
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

4. Run the available tests:

   ```bash
   flutter test
   ```

> Note: The existing widget test should be reviewed and updated to match the current banking interface before treating the test suite as a reliable verification of app behaviour.

## Architecture notes

The app separates screen widgets, reusable components, presentation helpers, and a Provider view model. The `Repository` class centralises theme-dependent colours, while `ViewModel` exposes the theme state and uses SharedPreferences for local preference storage.

## Limitations and future improvements

- Replace sample balances, card numbers, and transaction data with clearly labelled demo data or a secure backend integration.
- Complete and validate the add-card form; it is currently a UI prototype and does not store or tokenize payment cards.
- Add authentication and backend APIs only if the project is extended beyond a UI demonstration.
- Review and replace the starter widget test with tests for the actual screens and interactions.
- Verify compatibility with a current Flutter/Dart toolchain and refresh outdated dependencies where needed.

## Author

**Ini Isaac**

- GitHub: [@isaacini23](https://github.com/isaacini23)

---

This repository is intended as a demonstration of Flutter UI development and application structure, not as a real financial service.
