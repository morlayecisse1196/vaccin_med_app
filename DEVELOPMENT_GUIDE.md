# 📚 Guide de Développement - NeoCare+

## ✅ Phase 1 Complétée : Foundation

### Ce qui a été créé

#### 1. **Architecture & Structure**

```
lib/app/
├── core/theme/          ✅ Design System complet
├── routes/              ✅ Navigation GetX
├── modules/
│   ├── splash/          ✅ Écran de démarrage
│   ├── onboarding/      ✅ 3 slides
│   ├── auth/            ✅ Login + Signup
│   └── home/            ✅ Dashboard
```

#### 2. **Design System**

- ✅ `app_colors.dart` - Palette complète (Primary, Secondary, Accent, States)
- ✅ `app_text_styles.dart` - Typographie Inter
- ✅ `app_theme.dart` - Light & Dark themes Material 3

#### 3. **Écrans Fonctionnels**

- ✅ **Splash** : Animation + navigation automatique
- ✅ **Onboarding** : 3 slides avec SmoothPageIndicator
- ✅ **Login** : Email/Phone + Password avec validation
- ✅ **Signup** : Formulaire complet (Nom, Téléphone, Email, Date accouchement, Langue)
- ✅ **Home** : Dashboard avec Hero Card, Stats, Tips carousel, SOS button, Bottom Nav

#### 4. **Packages Installés**

- ✅ GetX (State Management + Navigation)
- ✅ Animate_do (Animations)
- ✅ Google Fonts (Typographie Inter)
- ✅ Smooth Page Indicator
- ✅ Tous les packages nécessaires pour la suite

---

## 🔜 Phase 2 : Navigation & Calendrier

### Prochaines Étapes

#### 1. **Navigation Bottom Bar Complète**

**Fichiers à créer :**

```dart
lib/app/modules/main/main_page.dart
lib/app/modules/main/main_controller.dart
lib/app/modules/calendar/calendar_page.dart
lib/app/modules/journal/journal_page.dart
lib/app/modules/chat/chat_page.dart
lib/app/modules/map/map_page.dart
```

**Fonctionnalités :**

- [ ] Page principale avec BottomNavigationBar
- [ ] Navigation fluide entre les 5 onglets
- [ ] Persistance de l'état entre les onglets
- [ ] Animations de transition

#### 2. **Calendrier CPN/PPN**

**Composants :**

- [ ] Vue mensuelle (Calendar widget)
- [ ] Liste des rendez-vous
- [ ] Carte de rendez-vous avec statut (Planned/Confirmed/Missed/Done)
- [ ] Boutons Confirmer/Reprogrammer
- [ ] Bottom sheet pour reprogrammation
- [ ] Système de rappels (J-7, J-3, J-1)

**Modèle de données :**

```dart
class Appointment {
  final String id;
  final DateTime date;
  final String type; // CPN1, CPN2, etc.
  final String facility;
  final String status; // planned, confirmed, missed, done
  final String doctorName;
}
```

#### 3. **Modèles de Données**

**Fichiers à créer :**

```dart
lib/app/data/models/user_model.dart
lib/app/data/models/appointment_model.dart
lib/app/data/models/vital_model.dart
lib/app/data/models/tip_model.dart
lib/app/data/models/health_center_model.dart
```

---

## 🎯 Phase 3 : Journal de Santé

### Fonctionnalités

#### 1. **Saisie des Mesures**

- [ ] Formulaire Poids (kg)
- [ ] Formulaire Tension artérielle (systolic/diastolic)
- [ ] Formulaire Glycémie (mg/dL)
- [ ] Validation des valeurs (plages OMS)
- [ ] Sauvegarde locale + sync API

#### 2. **Visualisation**

- [ ] Onglets : Aujourd'hui / Semaine / Mois
- [ ] Graphiques FL Chart (courbes de tendance)
- [ ] Sparklines pour aperçu rapide
- [ ] Indicateurs de seuils (normal/warning/danger)

#### 3. **Détection d'Anomalies**

```dart
// Règles simples - pas de ML
if (systolic > 140 || diastolic > 90) {
  showBanner("Tension élevée - Consultez une infirmière");
}
```

---

## 💬 Phase 4 : Chatbot

### Technologies

- **DialogFlow CX** ou **LangChain4J**
- **Flutter Chat UI** package
- **Speech to Text** + **TTS**

### Fonctionnalités

- [ ] Interface chat (bulles de messages)
- [ ] Support texte
- [ ] Support vocal (mic button)
- [ ] Multilingue (FR/EN/Wolof/Pulaar)
- [ ] Quick reply chips
- [ ] Historique des conversations

---

## 🗺️ Phase 5 : Carte & Géolocalisation

### Packages

- `google_maps_flutter`
- `geolocator`
- `geocoding`

### Fonctionnalités

- [ ] Map view avec user location
- [ ] Pins des centres de santé
- [ ] Filtres (CPN, Accouchement, Diabète, Vaccins)
- [ ] Bottom sheet détails centre
- [ ] Boutons : Appeler / Itinéraire
- [ ] Liste alternative avec tri par distance

---

## 🚨 Phase 6 : SOS

### Fonctionnalités

- [ ] Bottom sheet rouge avec options
- [ ] Symptômes : Saignements, Maux de tête, Bébé immobile, Tension haute
- [ ] Classification de gravité (simple rules)
- [ ] Envoi alerte au soignant référent
- [ ] Affichage centre le plus proche
- [ ] Conseils de sécurité

---

## 📄 Phase 7 : Carnet Médical

### Composants

- [ ] Onglets : Mère / Enfant
- [ ] Sections : Consultations, Vaccins, Examens, Documents
- [ ] Export PDF
- [ ] QR Code pour partage sécurisé
- [ ] Historique complet

---

## 🔌 Intégration Backend (Spring Boot)

### API Endpoints à Connecter

#### Authentification

```
POST /api/auth/login
POST /api/auth/register
POST /api/auth/verify-otp
POST /api/auth/reset-password
```

#### Profil Utilisateur

```
GET  /api/user/profile
PUT  /api/user/profile
POST /api/user/avatar
```

#### Rendez-vous

```
GET  /api/appointments
GET  /api/appointments/{id}
POST /api/appointments/{id}/confirm
POST /api/appointments/{id}/reschedule
```

#### Mesures Santé

```
POST /api/vitals
GET  /api/vitals?from=&to=
GET  /api/vitals/trends
```

#### Centres de Santé

```
GET /api/centers?lat={lat}&lon={lon}&service={service}
GET /api/centers/{id}
```

#### Conseils

```
GET /api/tips?lang={lang}&week={week}
```

#### SOS

```
POST /api/sos
POST /api/sos/{id}/update-status
```

### Service Layer

**Fichier à créer :**

```dart
lib/app/data/services/api_service.dart
lib/app/data/services/auth_service.dart
lib/app/data/services/appointment_service.dart
lib/app/data/services/vital_service.dart
```

---

## 🎨 Composants Réutilisables à Créer

### Widgets

```dart
lib/app/core/widgets/
├── neo_button_primary.dart       // Bouton principal
├── neo_button_secondary.dart     // Bouton secondaire
├── neo_card.dart                 // Carte de base
├── neo_card_stat.dart            // Carte statistique
├── neo_chip.dart                 // Chip filtrable
├── neo_banner.dart               // Banner info/warning/danger
├── neo_input.dart                // Input avec validation
├── neo_loading.dart              // Shimmer loading
└── neo_empty_state.dart          // État vide
```

---

## 📱 Tests Manuels

### Checklist pour chaque écran

#### Splash

- [ ] Logo animé visible
- [ ] Transition automatique après 3s
- [ ] Navigation vers Onboarding (première fois)

#### Onboarding

- [ ] 3 slides défilent correctement
- [ ] Indicateurs de page fonctionnent
- [ ] Bouton "Suivant" → slide suivante
- [ ] Bouton "Commencer" → Login
- [ ] Bouton "Passer" → Login

#### Login

- [ ] Validation email/phone
- [ ] Toggle mot de passe visible/caché
- [ ] Bouton désactivé si loading
- [ ] Navigation vers Signup
- [ ] Navigation vers Home après login

#### Signup

- [ ] Tous les champs requis
- [ ] Date picker fonctionne
- [ ] Dropdown langue fonctionne
- [ ] Validation formulaire
- [ ] Navigation vers Home après inscription

#### Home

- [ ] Données utilisateur affichées
- [ ] Hero card visible
- [ ] Boutons Confirmer/Reprogrammer fonctionnent
- [ ] Stats défilent horizontalement
- [ ] Tips carousel fonctionne
- [ ] Bouton SOS ouvre bottom sheet
- [ ] Bottom nav (5 onglets) responsive

---

## 🚀 Commandes Utiles

```bash
# Installer les dépendances
flutter pub get

# Lancer l'app en mode debug
flutter run

# Lancer avec hot reload
flutter run --hot

# Build APK de production
flutter build apk --release

# Analyser le code
flutter analyze

# Formater le code
dart format lib/

# Générer les fichiers Hive
flutter packages pub run build_runner build

# Clean
flutter clean
```

---

## 📝 Conventions de Code

### Nommage

- **Fichiers :** `snake_case.dart`
- **Classes :** `PascalCase`
- **Variables :** `camelCase`
- **Constants :** `kConstantName` ou `SCREAMING_SNAKE_CASE`

### Structure Controller

```dart
class MyController extends GetxController {
  // Observables
  final RxBool isLoading = false.obs;

  // Controllers
  final textController = TextEditingController();

  // Lifecycle
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  // Methods
  Future<void> loadData() async {
    // ...
  }
}
```

### Structure Page

```dart
class MyPage extends GetView<MyController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyController()); // Injecter le controller

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    // ...
  }

  Widget _buildBody() {
    // ...
  }
}
```

---

## 🎯 Prochaine Action Recommandée

**Testez manuellement l'application :**

1. Lancez `flutter pub get`
2. Lancez `flutter run`
3. Vérifiez le flow complet :
   - Splash → Onboarding → Login → Signup → Home
4. Testez toutes les animations
5. Vérifiez la réactivité des boutons
6. Testez la navigation bottom bar

**Ensuite, je continuerai avec :**

- Navigation principale complète
- Page Calendrier avec rendez-vous
- Intégration des données réelles (modèles + API mock)

---

**Prêt pour le test ? Dites-moi si vous rencontrez des erreurs !** 🚀
