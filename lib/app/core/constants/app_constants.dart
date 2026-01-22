/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'Ministry of Minority Affairs';
  static const String appNameHindi = 'अल्पसंख्यक कार्य मंत्रालय';
  static const String appVersion = '1.0.0';

  // API Configuration (Update with actual API endpoints)
  static const String baseUrl = 'https://api.minorityaffairs.gov.in';
  static const String apiVersion = 'v1';

  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUser = 'user_data';
  static const String storageKeyLanguage = 'app_language';
  static const String storageKeyTheme = 'app_theme';
  static const String storageKeyFirstTime = 'is_first_time';

  // Timing
  static const int splashDuration = 3000; // milliseconds
  static const int apiTimeout = 30000; // milliseconds

  // Pagination
  static const int defaultPageSize = 20;

  // Languages
  static const String defaultLanguage = 'en';
  static const List<String> supportedLanguages = ['en', 'hi'];

  // Assets Paths
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  static const String animationsPath = 'assets/animations/';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'No internet connection. Please check your network.';
  static const String errorTimeout = 'Request timeout. Please try again.';
}
