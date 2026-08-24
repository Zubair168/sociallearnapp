# EduVerse — Social Learning & Gamified EdTech Mobile App

[![Flutter CI/CD](https://github.com/Zubair168/sociallearnapp/actions/workflows/ci.yml/badge.svg)](https://github.com/Zubair168/sociallearnapp/actions/workflows/ci.yml)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue)](#)

---

## 📖 Executive Summary
**EduVerse** is a cross-platform Social Learning & Exam Preparation mobile application built with **Flutter**, **Firebase**, and modern reactive state management (`Provider`). It empowers students to explore courses, practice test questions, watch video lectures, track detailed analytics, and sync daily study tasks in real-time.

---

## 🚀 Key Features & Full User Flow

```
   ┌────────────────┐      ┌─────────────────┐      ┌─────────────────┐
   │  1. Onboarding │ ───► │ 2. Auth Gate    │ ───► │ 3. Home & Course│
   │  & Role Select │      │  (Login/Signup) │      │    Enrollment   │
   └────────────────┘      └─────────────────┘      └────────┬────────┘
                                                             │
   ┌────────────────┐      ┌─────────────────┐               ▼
   │ 5. Analytics & │ ◄─── │ 4. Learn & Test │ ◄─────────────┘
   │  Progress Sync │      │ (Video & Quiz)  │
   └────────────────┘      └─────────────────┘
```

1. **Onboarding & Role Selection**: Seamless introduction flow with student/parent/teacher persona configuration.
2. **Authentication & Session**: Firebase Auth (Email/Password, Registration, Password Recovery, Auto-login persistence).
3. **Course Enrollment & Discovery**: Dynamic course catalog, search & filtering, instant enrollment, and category breakdowns.
4. **Interactive Learning & Assessment**:
   - Rich video lecture player with interactive timestamps and playback controls.
   - Timed quiz/test solving with real-time feedback and detailed answer explanations.
   - Question favoriting & bookmarking for focused revision.
5. **Progress Tracking & Gamified Analytics**:
   - Interactive Smart Study Plan with synchronized task completion across screens.
   - Comprehensive performance analytics (accuracy rates, study streaks, topic mastery).
   - Dynamic Dark / Light theme switching with glassmorphism UI.
   - Push notifications powered by Firebase Cloud Messaging (FCM).

---

## 🏗️ Architecture & Tech Stack

- **Framework**: Flutter 3.x (Dart 3.x)
- **State Management**: `Provider` (`ChangeNotifierProvider`, `MultiProvider`)
- **Backend / Services**:
  - Firebase Authentication
  - Firebase Cloud Messaging & Local Notifications
  - Local Storage via `shared_preferences`
- **Design System**: Custom design tokens, `AppTheme` (Light & Dark), Glassmorphic widgets, and fluid micro-animations.
- **Testing**: Complete suite of Unit and Widget tests covering providers, data models, and UI components.
- **CI/CD**: GitHub Actions workflow running formatting, static analysis, unit/widget tests with coverage, and automated release APK packaging.

---

## 🧪 Testing & CI/CD Pipeline

The project includes an automated CI/CD workflow defined in [`.github/workflows/ci.yml`](.github/workflows/ci.yml):

```bash
# Run Static Code Analysis
flutter analyze --no-fatal-infos

# Run Unit & Widget Tests with Coverage
flutter test --coverage
```

### Test Suite Highlights:
- **Unit Tests**:
  - `course_model_test.dart`: JSON serialization, model validity, and edge cases.
  - `progress_provider_test.dart`: State manipulation, task toggling, and local storage synchronization.
  - `stats_model_test.dart`: Score calculations and analytics integrity.
  - `theme_provider_test.dart`: Dark/light mode state transitions.
- **Widget Tests**:
  - `course_card_test.dart`: UI rendering and tap interactions.
  - `notification_modal_test.dart`: Notification modal lifecycle and action callbacks.
  - `support_chip_test.dart`: Support pill tags and styling.
  - `welcome_screen_test.dart`: Role selection buttons and navigation triggers.

---

## 📦 Build & Release Artifacts

- **Release APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk`

To generate a new release build locally:
```bash
flutter build apk --release
```

---

## 🛠️ Getting Started & Installation

### Prerequisites
- Flutter SDK `^3.x`
- Java JDK 17
- Android SDK 34+

### Quick Start
```bash
# 1. Clone the repository
git clone https://github.com/Zubair168/sociallearnapp.git
cd sociallearnapp

# 2. Install dependencies
flutter pub get

# 3. Run the application
flutter run
```

---

## 👥 Repository & Handover Information
- **Repository**: [https://github.com/Zubair168/sociallearnapp](https://github.com/Zubair168/sociallearnapp)
- **Primary Branch**: `main`
- **CI/CD Status**: Active & Passing
