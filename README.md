# Nomo — No More

Track your progress, understand your cravings, and quit for good. Nomo is a privacy‑friendly quit tracker with rich insights and a clean, Bauhaus‑inspired UI.

## Features

- **Multiple trackers**: Create and manage separate trackers for different habits or addictions.
- **Craving logging**: Log craving events over time and use them to identify patterns.
- **Insights & trends (Premium)**: Unlock the Insights screen to see craving trends, peak hours, and patterns, with detailed charts and a full calendar view.
- **Charts & calendar**: Visualize streaks and craving frequency using interactive charts (`fl_chart`) and calendar‑based summaries.
- **Local‑first storage**: All data is stored locally on device using SQLite via Drift, so your data stays with you.
- **Notifications & reminders**: Local notifications help you stay on track and remember to log your progress.
- **Modern theming & typography**: Custom `Nomo` theme, components (Bauhaus buttons/cards), and Noto Sans font family for a consistent look.

## Tech stack

- **Framework**: Flutter (Dart, mobile‑first)
- **State management**: `flutter_riverpod` with code generation via `riverpod_annotation`
- **Navigation**: `go_router`
- **Persistence**: `drift` + `sqlite3_flutter_libs`
- **UI & animations**: `fl_chart`, `flutter_animate`, `animations`
- **Preferences & utilities**: `shared_preferences`, `intl`, `uuid`, `path_provider`, `path`

## Getting started

1. **Install Flutter**  
   Make sure you have Flutter SDK \(3.10.0 or higher\) installed and configured.

2. **Clone the repository**
   ```bash
   git clone <this-repo-url>
   cd "Quit Tracker"
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate code (Drift, Riverpod, etc.)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Project structure (high level)

- **`lib/core`**: Theme, dimensions, typography, and other core utilities.
- **`lib/domain`**: Entities and use cases (e.g., cravings analysis).
- **`lib/presentation`**: Screens, widgets, and providers (including the Insights screen, paywall, and tracker flows).

This README describes the current state of the project; update it as new features or platforms are added.
