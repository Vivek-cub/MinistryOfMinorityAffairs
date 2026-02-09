# Ministry of Minority Affairs - Mobile App

A Flutter mobile application for the Ministry of Minority Affairs (Pradhan Mantri Jan Vikas Karyakram - PMJVK) using GetX state management and clean architecture.

<div align="center">
  <img src="assets/images/splash_screen.jpg" alt="Ministry Logo" width="300"/>
</div>

## 📱 About

This application serves as a digital platform for the Ministry of Minority Affairs, Government of India, providing access to various schemes, announcements, and services for minority communities.

## 🏗️ Architecture

This project follows **GetX Clean Architecture** with a feature-based modular structure:

```
lib/
├── app/
│   ├── core/              # Core functionality (theme, constants, utils)
│   ├── data/              # Data layer (models, providers, repositories)
│   ├── modules/           # Feature modules (splash, home, etc.)
│   ├── routes/            # Navigation configuration
│   └── services/          # Global services (storage, API)
└── main.dart              # App entry point
```

### Key Features:
- ✅ **GetX State Management** - Reactive programming
- ✅ **Named Route Navigation** - Type-safe and maintainable
- ✅ **Dependency Injection** - Using GetX bindings
- ✅ **Clean Architecture** - Separation of concerns
- ✅ **Indian Government Theme** - Saffron, white, and green colors
- ✅ **Bilingual Support** - English and Hindi ready
- ✅ **API Integration Ready** - Dio HTTP client configured
- ✅ **Local Storage** - GetStorage for persistent data
- ✅ **Custom Helpers** - Date formatting, validation, etc.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS development tools (for iOS)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd ministry_of_minority_affairs
   ```

2. **Copy the splash screen image:**
   - Save your splash screen image as `assets/images/splash_screen.jpg`

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 📚 Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Detailed architecture guide
- **[QUICK_START.md](QUICK_START.md)** - Quick start guide with examples

## 🎯 Routing Strategy

### ✅ Use Named Routes (Recommended)

This project uses **named routes** for navigation, which is the best practice for scalable apps:

```dart
// Navigate to home screen
Get.toNamed(AppRoutes.home);

// Navigate with arguments
Get.toNamed(AppRoutes.profile, arguments: userData);

// Replace current screen
Get.offNamed(AppRoutes.login);

// Clear all routes and navigate
Get.offAllNamed(AppRoutes.dashboard);
```

### Why Named Routes?
1. ✅ Type-safe navigation
2. ✅ Centralized route management
3. ✅ Easy to implement deep linking
4. ✅ Better for route guards & middleware
5. ✅ Easier to maintain and refactor
6. ✅ Clear navigation flow

### ❌ Avoid Direct Navigation
```dart
// DON'T use this approach
Get.to(() => HomeScreen());

// Use named routes instead
Get.toNamed(AppRoutes.home);
```

## 📦 Dependencies

### State Management & Navigation
- **get** (^4.7.3) - State management and routing

### Storage
- **get_storage** (^2.1.1) - Local persistent storage

### Networking
- **dio** (^5.4.0) - HTTP client for API calls
- **connectivity_plus** (^5.0.2) - Network connectivity

### UI & UX
- **cached_network_image** (^3.3.1) - Optimized image loading
- **intl** (^0.19.0) - Internationalization and date formatting

## 🎨 Theme & Colors

The app uses colors inspired by the Indian national flag:

- **Primary (Saffron)**: `#FF9933`
- **Secondary (Green)**: `#138808`
- **Accent (Navy Blue)**: `#000080`

```dart
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';

Container(
  color: AppColors.primary,  // Saffron color
  child: Text(
    'Welcome',
    style: TextStyle(color: AppColors.textWhite),
  ),
)
```

## 🔧 Project Structure

### Adding a New Feature

1. **Create module structure:**
   ```
   lib/app/modules/feature_name/
   ├── bindings/
   │   └── feature_binding.dart
   ├── controllers/
   │   └── feature_controller.dart
   └── views/
       └── feature_view.dart
   ```

2. **Define route in `app_routes.dart`:**
   ```dart
   static const featureName = '/feature-name';
   ```

3. **Add route configuration in `app_pages.dart`:**
   ```dart
   GetPage(
     name: AppRoutes.featureName,
     page: () => const FeatureView(),
     binding: FeatureBinding(),
   ),
   ```

4. **Navigate to the feature:**
   ```dart
   Get.toNamed(AppRoutes.featureName);
   ```

## 🌐 API Integration

The app includes a pre-configured `ApiService` for HTTP requests:

```dart
// In your controller
final apiService = Get.find<ApiService>();

// GET request
final response = await apiService.get('/schemes');

// POST request
final response = await apiService.post('/apply', data: formData);
```

### Features:
- Automatic token injection
- Error handling with user-friendly messages
- Request/response logging
- Timeout configuration
- File upload/download support

## 💾 Local Storage

Use `StorageService` for persistent data:

```dart
final storage = Get.find<StorageService>();

// Save data
storage.saveToken('auth_token_here');
storage.saveLanguage('en');

// Read data
final token = storage.getToken();
final isLoggedIn = storage.isLoggedIn();

// Clear data
storage.logout();
```

## 🛠️ Useful Helpers

The `Helpers` utility class provides common functions:

```dart
// Date formatting
Helpers.formatDate(DateTime.now());  // 22/01/2026
Helpers.getRelativeTime(dateTime);   // 2 hours ago

// Validation
Helpers.isValidEmail(email);
Helpers.isValidIndianPhone(phone);
Helpers.isValidAadhaar(aadhaar);

// Currency formatting
Helpers.formatCurrency(100000);  // ₹1,00,000.00

// Snackbars
Helpers.showSuccess('Saved successfully');
Helpers.showError('Something went wrong');

// Dialogs
final confirmed = await Helpers.showConfirmDialog(
  title: 'Confirm',
  message: 'Are you sure?',
);
```

## 🔐 Best Practices

1. **Controllers**: Keep business logic in controllers
2. **Views**: Keep UI code clean and reactive
3. **Services**: Use for API calls and storage
4. **Bindings**: Always use bindings for dependency injection
5. **Named Routes**: Always use named routes for navigation
6. **Reactive State**: Use `.obs` and `Obx()` for reactive programming
7. **Error Handling**: Always handle errors gracefully
8. **Comments**: Document complex logic

## 📱 Screens

Currently implemented:

- ✅ **Splash Screen** - Ministry logo with loading
- ✅ **Home Screen** - Main dashboard (template)

To be implemented:
- ⏳ Onboarding screens
- ⏳ Login/Authentication
- ⏳ Dashboard
- ⏳ Schemes listing
- ⏳ Application forms
- ⏳ Profile management
- ⏳ Notifications
- ⏳ Settings (Language, Theme)

## 🌍 Localization

The app is ready for bilingual support (English/Hindi):

```dart
// In app_constants.dart
static const List<String> supportedLanguages = ['en', 'hi'];
```

You can extend this using Flutter's localization features or GetX translations.

## 🐛 Troubleshooting

### Issue: Asset not found
```bash
flutter pub get
flutter clean
flutter run
```

### Issue: GetX controller not found
Check if the binding is added in `app_pages.dart`

### Issue: Build errors
```bash
flutter clean
flutter pub get
flutter run
```

## 📝 TODO

- [ ] Copy splash screen image to `assets/images/splash_screen.jpg`
- [ ] Implement authentication flow
- [ ] Add more screens (schemes, profile, etc.)
- [ ] Integrate with actual APIs
- [ ] Add Hindi localization
- [ ] Implement push notifications
- [ ] Add offline support
- [ ] Write unit tests

## 👥 Contributing

1. Follow the existing folder structure
2. Use named routes for navigation
3. Keep controllers thin
4. Add comments for complex logic
5. Test on both Android and iOS
6. Follow Flutter best practices

## 📄 License

Government of India - Ministry of Minority Affairs

## 📞 Support

For issues or questions, please contact the development team.

---

**Built with ❤️ for Minority Communities of India**

*Satyameva Jayate* (सत्यमेव जयते) - Truth Alone Triumphs
