# Quick Start Guide - Ministry of Minority Affairs App

## 🚀 Setup Instructions

### Step 1: Save the Splash Screen Image
Save your splash screen image to:
```
assets/images/splash_screen.jpg
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Run the App
```bash
flutter run
```

## 📱 Current Features

✅ Splash screen with loading indicator  
✅ Named route navigation  
✅ GetX state management setup  
✅ Clean architecture structure  
✅ Custom theme with Indian government colors  
✅ Home screen example  

## 🎯 Navigation Examples

### Navigate to Home
```dart
Get.toNamed(AppRoutes.home);
```

### Navigate with Arguments
```dart
Get.toNamed(AppRoutes.profile, arguments: userData);

// Retrieve in controller
final data = Get.arguments;
```

### Navigate with Parameters
```dart
Get.toNamed(AppRoutes.details, parameters: {'id': '123'});

// Retrieve in controller
final id = Get.parameters['id'];
```

### Replace Current Screen
```dart
Get.offNamed(AppRoutes.login);
```

### Clear All and Navigate
```dart
Get.offAllNamed(AppRoutes.dashboard);
```

### Go Back
```dart
Get.back();

// With result
Get.back(result: userData);
```

## 📂 Project Structure

```
lib/
├── app/
│   ├── core/                    # Core app files
│   │   ├── constants/           # App constants
│   │   ├── theme/               # App theme
│   │   ├── utils/               # Utilities
│   │   └── values/              # Colors, styles
│   ├── data/                    # Data layer
│   │   ├── models/              # Data models
│   │   ├── providers/           # API providers
│   │   └── repositories/        # Repositories
│   ├── modules/                 # Features
│   │   ├── splash/              # Splash screen
│   │   └── home/                # Home screen
│   ├── routes/                  # Navigation
│   └── services/                # Global services
└── main.dart
```

## 🎨 Using Theme Colors

```dart
import 'package:ministry_of_minority_affairs/app/core/values/app_colors.dart';

// In your widgets
Container(
  color: AppColors.primary,      // Saffron
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textWhite),
  ),
)
```

### Available Colors:
- `AppColors.primary` - Saffron (main color)
- `AppColors.secondary` - Green
- `AppColors.accent` - Navy Blue
- `AppColors.textPrimary` - Dark text
- `AppColors.textSecondary` - Light text
- `AppColors.background` - App background
- `AppColors.success`, `error`, `warning`, `info` - Status colors

## 🔧 Creating a New Screen

### 1. Create folder structure:
```
lib/app/modules/my_screen/
├── bindings/
│   └── my_screen_binding.dart
├── controllers/
│   └── my_screen_controller.dart
└── views/
    └── my_screen_view.dart
```

### 2. Create Controller:
```dart
// controllers/my_screen_controller.dart
import 'package:get/get.dart';

class MyScreenController extends GetxController {
  final count = 0.obs;
  
  void increment() => count.value++;
}
```

### 3. Create Binding:
```dart
// bindings/my_screen_binding.dart
import 'package:get/get.dart';
import '../controllers/my_screen_controller.dart';

class MyScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyScreenController());
  }
}
```

### 4. Create View:
```dart
// views/my_screen_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_screen_controller.dart';

class MyScreenView extends GetView<MyScreenController> {
  const MyScreenView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: Center(
        child: Obx(() => Text('Count: ${controller.count}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### 5. Add Route:
```dart
// In app/routes/app_routes.dart
static const myScreen = '/my-screen';

// In app/routes/app_pages.dart
GetPage(
  name: AppRoutes.myScreen,
  page: () => const MyScreenView(),
  binding: MyScreenBinding(),
  transition: Transition.rightToLeft,
),
```

### 6. Navigate to it:
```dart
Get.toNamed(AppRoutes.myScreen);
```

## 🌐 API Integration Example

### 1. Create Model:
```dart
// lib/app/data/models/scheme_model.dart
class SchemeModel {
  final int id;
  final String name;
  final String description;
  
  SchemeModel({
    required this.id,
    required this.name,
    required this.description,
  });
  
  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
```

### 2. Create Provider:
```dart
// lib/app/data/providers/scheme_provider.dart
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/constants/app_constants.dart';

class SchemeProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConstants.baseUrl;
    httpClient.timeout = const Duration(milliseconds: AppConstants.apiTimeout);
  }
  
  Future<Response> getSchemes() => get('/schemes');
  Future<Response> getScheme(int id) => get('/schemes/$id');
}
```

### 3. Use in Controller:
```dart
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/data/models/scheme_model.dart';
import 'package:ministry_of_minority_affairs/app/data/providers/scheme_provider.dart';

class SchemesController extends GetxController {
  final SchemeProvider provider = Get.put(SchemeProvider());
  final schemes = <SchemeModel>[].obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchSchemes();
  }
  
  Future<void> fetchSchemes() async {
    try {
      isLoading.value = true;
      final response = await provider.getSchemes();
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body;
        schemes.value = data.map((json) => SchemeModel.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load schemes');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
```

## 💾 Local Storage Example

### 1. Initialize GetStorage in main.dart:
```dart
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}
```

### 2. Use in Controller:
```dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final storage = GetStorage();
  
  // Save data
  void saveLanguage(String lang) {
    storage.write('language', lang);
  }
  
  // Read data
  String getLanguage() {
    return storage.read('language') ?? 'en';
  }
  
  // Remove data
  void clearLanguage() {
    storage.remove('language');
  }
  
  // Clear all
  void clearAll() {
    storage.erase();
  }
}
```

## 🎯 Tips & Best Practices

### ✅ DO:
- Use named routes (`Get.toNamed()`)
- Keep controllers thin
- Use reactive variables (`.obs`)
- Use `Obx()` for reactive widgets
- Follow the folder structure
- Use dependency injection via bindings

### ❌ DON'T:
- Use `Get.to(() => Screen())` for navigation
- Put business logic in views
- Forget to dispose resources in `onClose()`
- Use `setState()` - use `.obs` instead
- Hard-code strings - use constants

## 📚 Additional Resources

- [GetX Documentation](https://pub.dev/packages/get)
- [Flutter Documentation](https://flutter.dev/docs)
- See `ARCHITECTURE.md` for detailed architecture guide

## 🐛 Common Issues

### Issue: Asset not found
**Solution**: Make sure the image is in `assets/images/` and run `flutter pub get`

### Issue: GetX controller not found
**Solution**: Make sure you've added the binding in `app_pages.dart`

### Issue: Hot reload not working
**Solution**: Try hot restart (Shift + R in terminal)

## 🚀 Next Steps

1. ✅ Copy splash screen image to `assets/images/`
2. ✅ Run `flutter pub get`
3. ✅ Run the app
4. Add more screens following the structure
5. Integrate APIs
6. Add authentication
7. Add localization (English/Hindi)

Happy coding! 🎉
