# Architecture Guide - Ministry of Minority Affairs App

## 📁 Project Structure

```
lib/
├── app/
│   ├── core/                    # Core functionality
│   │   ├── constants/           # App-wide constants
│   │   │   └── app_constants.dart
│   │   ├── theme/               # App theming
│   │   │   └── app_theme.dart
│   │   ├── utils/               # Utility functions
│   │   └── values/              # Colors, dimensions, etc.
│   │       └── app_colors.dart
│   │
│   ├── data/                    # Data layer
│   │   ├── models/              # Data models
│   │   ├── providers/           # API providers
│   │   └── repositories/        # Repository pattern
│   │
│   ├── modules/                 # Feature modules
│   │   ├── splash/
│   │   │   ├── bindings/        # Dependency injection
│   │   │   ├── controllers/     # Business logic
│   │   │   └── views/           # UI screens
│   │   ├── home/
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   └── ...                  # Add more modules
│   │
│   ├── routes/                  # Navigation
│   │   ├── app_pages.dart       # Route configuration
│   │   └── app_routes.dart      # Route names
│   │
│   └── services/                # Global services
│       └── ...                  # Storage, API, etc.
│
└── main.dart                    # App entry point
```

## 🏗️ Architecture Pattern

This project follows **GetX Clean Architecture** with separation of concerns:

### 1. **Presentation Layer (Views)**
- UI components and screens
- Minimal business logic
- Reactive to state changes

### 2. **Business Logic Layer (Controllers)**
- Manages application state
- Handles user interactions
- Coordinates data flow

### 3. **Data Layer (Repositories & Providers)**
- API communication
- Local storage
- Data transformation

## 🧭 Navigation Strategy

### ✅ Use Named Routes (Recommended)

```dart
// ✅ CORRECT - Type-safe, maintainable
Get.toNamed(AppRoutes.home);
Get.toNamed(AppRoutes.profile, arguments: userData);
Get.offAllNamed(AppRoutes.login); // Clear stack
```

### ❌ Avoid Direct Navigation

```dart
// ❌ AVOID - Hard to maintain
Get.to(() => HomeScreen());
```

### Route Configuration

**1. Define route names in `app_routes.dart`:**
```dart
abstract class AppRoutes {
  static const home = '/home';
  static const profile = '/profile';
}
```

**2. Configure routes in `app_pages.dart`:**
```dart
GetPage(
  name: AppRoutes.home,
  page: () => const HomeView(),
  binding: HomeBinding(),
  transition: Transition.rightToLeft,
),
```

**3. Navigate using route names:**
```dart
// Simple navigation
Get.toNamed(AppRoutes.home);

// With arguments
Get.toNamed(AppRoutes.profile, arguments: {'userId': 123});

// Replace current route
Get.offNamed(AppRoutes.login);

// Clear all and navigate
Get.offAllNamed(AppRoutes.dashboard);
```

## 🎯 GetX Features Used

### 1. **State Management**
```dart
class MyController extends GetxController {
  // Observable variable
  final count = 0.obs;
  
  // Update state
  void increment() => count.value++;
}

// In View
Obx(() => Text('${controller.count}'))
```

### 2. **Dependency Injection**
```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
```

### 3. **Routing**
```dart
// Named routes with bindings
Get.toNamed(AppRoutes.home);

// With parameters
Get.toNamed(AppRoutes.details, parameters: {'id': '123'});

// With arguments
Get.toNamed(AppRoutes.profile, arguments: userData);
```

## 📱 Creating New Features

### Step 1: Create Module Structure
```bash
lib/app/modules/my_feature/
├── bindings/
│   └── my_feature_binding.dart
├── controllers/
│   └── my_feature_controller.dart
└── views/
    └── my_feature_view.dart
```

### Step 2: Define Controller
```dart
class MyFeatureController extends GetxController {
  final isLoading = false.obs;
  final data = <String>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
  
  void fetchData() async {
    isLoading.value = true;
    // Fetch data
    isLoading.value = false;
  }
}
```

### Step 3: Create Binding
```dart
class MyFeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyFeatureController());
  }
}
```

### Step 4: Build View
```dart
class MyFeatureView extends GetView<MyFeatureController> {
  const MyFeatureView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: Obx(() => controller.isLoading.value
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: controller.data.length,
              itemBuilder: (context, index) => Text(controller.data[index]),
            ),
      ),
    );
  }
}
```

### Step 5: Add Route
```dart
// In app_routes.dart
static const myFeature = '/my-feature';

// In app_pages.dart
GetPage(
  name: AppRoutes.myFeature,
  page: () => const MyFeatureView(),
  binding: MyFeatureBinding(),
),
```

## 🎨 Theming

Use predefined colors from `AppColors`:
```dart
Text(
  'Hello',
  style: TextStyle(color: AppColors.primary),
)

Container(
  color: AppColors.background,
)
```

## 🔐 Best Practices

### 1. **Separation of Concerns**
- Views only handle UI
- Controllers manage business logic
- Services handle data operations

### 2. **Reactive Programming**
```dart
// Use .obs for reactive variables
final count = 0.obs;

// Use Obx() for reactive widgets
Obx(() => Text('${count.value}'))
```

### 3. **Dependency Management**
```dart
// Use lazyPut for lazy initialization
Get.lazyPut(() => MyController());

// Use put for immediate initialization
Get.put(MyService());

// Use find to retrieve
final controller = Get.find<MyController>();
```

### 4. **Error Handling**
```dart
try {
  await apiCall();
} catch (e) {
  Get.snackbar('Error', e.toString());
}
```

### 5. **Resource Cleanup**
```dart
@override
void onClose() {
  // Dispose controllers, close streams
  super.onClose();
}
```

## 🌐 Adding API Integration

### 1. Create Model
```dart
// lib/app/data/models/user_model.dart
class UserModel {
  final int id;
  final String name;
  
  UserModel({required this.id, required this.name});
  
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
  );
}
```

### 2. Create Provider
```dart
// lib/app/data/providers/user_provider.dart
class UserProvider extends GetConnect {
  Future<Response> getUsers() => get('${AppConstants.baseUrl}/users');
}
```

### 3. Create Repository
```dart
// lib/app/data/repositories/user_repository.dart
class UserRepository {
  final UserProvider provider;
  
  UserRepository(this.provider);
  
  Future<List<UserModel>> getUsers() async {
    final response = await provider.getUsers();
    if (response.statusCode == 200) {
      return (response.body as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
    }
    throw Exception('Failed to load users');
  }
}
```

### 4. Use in Controller
```dart
class HomeController extends GetxController {
  final UserRepository repository;
  final users = <UserModel>[].obs;
  
  HomeController(this.repository);
  
  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }
  
  void fetchUsers() async {
    try {
      users.value = await repository.getUsers();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
```

## 📦 Folder Naming Conventions

- **snake_case**: File and folder names
- **PascalCase**: Class names
- **camelCase**: Variable and function names
- **SCREAMING_SNAKE_CASE**: Constants

## 🚀 Getting Started

1. Copy splash screen image to `assets/images/splash_screen.jpg`
2. Run `flutter pub get`
3. Run `flutter run`

## 📝 Notes

- Always use named routes for navigation
- Keep controllers thin, move complex logic to services
- Use bindings for dependency injection
- Follow the existing folder structure for consistency
- Use GetX reactive state management (.obs and Obx)
