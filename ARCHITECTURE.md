# 🏗️ Architecture NeoCare+

## 📁 Structure du Projet

```
neocare_plus/
├── lib/
│   ├── app/
│   │   ├── core/                    # Composants centraux
│   │   │   ├── theme/              # Design System
│   │   │   │   ├── app_colors.dart
│   │   │   │   ├── app_text_styles.dart
│   │   │   │   └── app_theme.dart
│   │   │   ├── utils/              # Helpers & Constants
│   │   │   └── widgets/            # Widgets réutilisables
│   │   │
│   │   ├── data/                    # Couche de données
│   │   │   ├── models/             # Modèles de données
│   │   │   ├── services/           # Services API
│   │   │   └── repositories/       # Repository pattern
│   │   │
│   │   ├── modules/                 # Features/Modules
│   │   │   ├── splash/
│   │   │   │   ├── splash_page.dart
│   │   │   │   └── splash_controller.dart
│   │   │   ├── onboarding/
│   │   │   │   ├── onboarding_page.dart
│   │   │   │   └── onboarding_controller.dart
│   │   │   ├── auth/
│   │   │   │   ├── login_page.dart
│   │   │   │   ├── signup_page.dart
│   │   │   │   └── auth_controller.dart
│   │   │   ├── home/
│   │   │   │   ├── home_page.dart
│   │   │   │   └── home_controller.dart
│   │   │   ├── calendar/           # 🔜 À venir
│   │   │   ├── journal/            # 🔜 À venir
│   │   │   ├── chat/               # 🔜 À venir
│   │   │   ├── map/                # 🔜 À venir
│   │   │   └── profile/            # 🔜 À venir
│   │   │
│   │   └── routes/                  # Navigation
│   │       ├── app_routes.dart     # Noms des routes
│   │       └── app_pages.dart      # Configuration GetX
│   │
│   └── main.dart                    # Point d'entrée
│
├── android/                         # Configuration Android
├── ios/                             # Configuration iOS
├── assets/                          # Assets statiques
│   ├── images/
│   ├── icons/
│   └── animations/
├── test/                            # Tests unitaires
└── pubspec.yaml                     # Dépendances

```

## 🎯 Pattern Architectural

### **GetX MVC Pattern**

NeoCare+ utilise **GetX** pour une architecture MVC simplifiée :

1. **Model** → `lib/app/data/models/`
2. **View** → `*_page.dart` (UI)
3. **Controller** → `*_controller.dart` (Logique métier)

### Exemple : Module Auth

```dart
// 📁 auth_controller.dart (Controller)
class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  
  Future<void> login() async {
    isLoading.value = true;
    // API call...
    isLoading.value = false;
  }
}

// 📁 login_page.dart (View)
class LoginPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => 
      controller.isLoading.value 
        ? CircularProgressIndicator()
        : LoginForm()
    );
  }
}
```

## 🔄 Flux de Données

```
User Action → Controller → Service/Repository → API
                  ↓
            Update State (Rx)
                  ↓
            UI Rebuild (Obx)
```

## 🎨 Design System

### Couleurs
- **Primary**: `#0B1F3A` (Midnight Blue)
- **Secondary**: `#1BB5A5` (Teal)
- **Accent**: `#D4AF37` (Gold)

### Typographie
- **Font**: Inter (Google Fonts)
- **Sizes**: 12-32pt

### Spacing System
- Base: 8px
- Gutters: 16px
- Cards: 20px radius

## 🚀 Navigation

### Routes GetX
```dart
Get.toNamed(AppRoutes.login);        // Navigate
Get.offNamed(AppRoutes.home);        // Replace
Get.offAllNamed(AppRoutes.home);     // Clear stack
Get.back();                           // Go back
```

### Route Names
```dart
AppRoutes.splash      // /splash
AppRoutes.onboarding  // /onboarding
AppRoutes.login       // /login
AppRoutes.signup      // /signup
AppRoutes.home        // /home
```

## 📡 Services API (À implémenter)

### Structure
```dart
// lib/app/data/services/api_service.dart
class ApiService {
  final Dio _dio;
  
  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response.data);
  }
}
```

### Endpoints Backend (Spring Boot)
```
Base URL: https://api.neocare.sn/v1

POST   /auth/login
POST   /auth/register
GET    /user/profile
GET    /appointments
POST   /appointments/{id}/confirm
POST   /vitals
GET    /centers?lat={lat}&lon={lon}
GET    /tips?lang={lang}
POST   /sos
```

## 💾 Stockage Local

### Hive (NoSQL)
```dart
// Pour le mode offline
await Hive.initFlutter();
var box = await Hive.openBox('userData');
box.put('name', 'Fatou');
```

### SharedPreferences
```dart
// Pour les préférences simples
final prefs = await SharedPreferences.getInstance();
prefs.setBool('isFirstLaunch', false);
```

## 🎭 State Management

### GetX Reactive (Rx)
```dart
// Observable variable
final RxInt counter = 0.obs;

// Update
counter.value++;

// Listen
Obx(() => Text('${counter.value}'))
```

### GetX Simple
```dart
// Without Rx
int counter = 0;

// Update
counter++;
update(); // Rebuild

// Listen
GetBuilder<MyController>(
  builder: (controller) => Text('${controller.counter}')
)
```

## 🧪 Tests (À implémenter)

### Structure
```
test/
├── unit/
│   └── controllers/
├── widget/
│   └── pages/
└── integration/
```

### Exemple
```dart
test('Login controller test', () {
  final controller = AuthController();
  expect(controller.isLoading.value, false);
});
```

## 📦 Dépendances Clés

| Package | Usage |
|---------|-------|
| get | State management & Navigation |
| dio | HTTP Client |
| hive | Local database |
| google_fonts | Typography |
| animate_do | Animations |
| geolocator | GPS |
| google_maps_flutter | Maps |

## 🔐 Sécurité

### API Keys
- Stocker dans `.env` (non commité)
- Utiliser `flutter_dotenv`
- Backend: JWT tokens

### Permissions
- Géolocalisation
- Caméra (QR scan)
- Notifications
- Microphone (chatbot vocal)

## 📱 Responsive Design

### Breakpoints
```dart
// Mobile: < 600px
// Tablet: 600px - 900px
// Desktop: > 900px

MediaQuery.of(context).size.width
```

## 🌍 Internationalisation (À venir)

```dart
// lib/app/translations/
languages/
├── fr_FR.dart  // Français
├── en_US.dart  // English
├── wo_SN.dart  // Wolof
└── ff_SN.dart  // Pulaar
```

## 🚀 Performance

### Optimisations
- ✅ Lazy loading des modules
- ✅ Cached network images
- ✅ Const constructors
- ✅ ListView.builder (pas List.generate)
- ✅ Keys pour widgets animés

### Monitoring
```dart
// DevTools
flutter run --profile
```

---

**Dernière mise à jour:** 29 octobre 2025
