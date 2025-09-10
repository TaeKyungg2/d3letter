# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

d3letters (편지3개) is a Flutter mobile app that delivers 3 inspirational letters (quotes) daily. It's built in Korean and provides users with meaningful quotes and sayings. The app allows users to swipe through cards containing quotes and save favorites.

## Architecture

The app uses a simple Flutter architecture:

- `lib/main.dart` - Entry point with home screen containing a mail emoji button
- `lib/card_page.dart` - Main card swiping interface with quote display
- `lib/favorite_page.dart` - Favorites management page
- `assets/` - Contains app icon and background images

### Key Components

- **Quote Source**: Quotes are fetched from a GitHub Gist JSON endpoint
- **Card Swiping**: Uses `flutter_card_swiper` package for interactive card interface
- **Local Storage**: Uses `path_provider` to cache data and manage favorites
- **Styling**: Uses `google_fonts` (Orbit, Actor, ABeeZee, Aboreto fonts)

## Development Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Build for production
flutter build apk          # Android
flutter build ios          # iOS

# Generate launcher icons
flutter pub run flutter_launcher_icons

# Analyze code
flutter analyze

# Run tests
flutter test
```

## Key Dependencies

- `flutter_card_swiper: ^7.0.2` - Card swiping functionality
- `google_fonts: ^6.3.1` - Typography
- `http: ^1.5.0` - API calls for fetching quotes
- `like_button: ^2.1.0` - Heart button for favorites
- `path_provider: ^2.1.5` - Local file storage

## Data Source

Quotes are loaded from: `https://gist.githubusercontent.com/TaeKyungg2/dd77b00e3929e3feb64be5bd411096cf/raw/saying.json`

The JSON structure contains objects with `text` and `author` fields.

## Development Notes

- The app randomly selects 3 quotes daily from the available dataset
- Uses file caching for offline functionality
- Korean language interface and content
- Material Design with custom color scheme (blue theme)
- Currently has incomplete favorite persistence (favorites are stored in memory only)