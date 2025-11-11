# 
Pokémon Trading Cards Mobile App

A complete Flutter mobile application for managing Pokémon trading cards with local storage and beautiful Material Design UI.
Built with assistance from GitHub Copilot 
Copilot helped generate boilerplate code, API logic, and UI components during development.

##  Features

- **Card Fetching**: Automatically fetches Pokémon cards from the Pokémon TCG API
- **Local Storage**: Stores cards locally using SharedPreferences (web-compatible)
- **Card Display**: Shows cards in a scrollable ListView with small images and names
- **Detail View**: Tap any card to see an enlarged image with pan/zoom capabilities
- **Offline Support**: Works offline after initial data load
- **Material Design**: Clean, modern UI following Material Design principles
- **Cross-Platform**: Runs on Web, Windows, Android, and iOS
- **API Authentication**: Uses authenticated API access for better performance

##  Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- A web browser (Chrome, Edge, or Firefox)
- Internet connection for initial data fetch

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AbishekBasnet/pokemon_gameL4.git
   cd pokemon_gameL4
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For web browsers
   flutter run -d chrome
   flutter run -d edge

   # For desktop (requires Developer Mode on Windows)
   flutter run -d windows

   # For mobile (requires emulator/device)
   flutter run -d android
   flutter run -d ios
   ```


```yaml
dependencies:
  flutter: sdk: flutter
  http: ^1.1.0                 # HTTP requests
  shared_preferences: ^2.2.2   # Local storage
```



1. **Launch the app** - It will automatically fetch Pokémon cards
2. **Browse cards** - Scroll through the list of cards
3. **View details** - Tap any card to see the enlarged image
4. **Pan/Zoom** - Use gestures to explore card details
5. **Refresh** - Pull down to refresh or use the refresh button

##  API Configuration

The app uses the Pokémon TCG API with authentication:

```dart
static const String apiKey = '6b4ed620-4f9d-4bf4-90ed-8bfa588004cc';
```

**Note**: This API key is included for demo purposes. In production, use environment variables or secure storage.

### Mock Cards Included:
- Charizard
- Pikachu  
- Blastoise
- Venusaur
- Alakazam
- Mewtwo
- And 12 more classic cards!


