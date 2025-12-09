# 🚀 Guide de Démarrage Rapide - NeoCare+

## ✅ Configuration Complétée

Votre projet Flutter est maintenant optimisé pour **Flutter 3.35.6** et **Dart 3.9.2** !

## 📦 Installation des Dépendances

```bash
# 1. Nettoyer le cache
flutter clean

# 2. Installer les packages
flutter pub get

# 3. (Optionnel) Générer les fichiers Hive
flutter pub run build_runner build --delete-conflicting-outputs
```

## ⚡ Lancer l'Application

### Mode Debug (recommandé pour développement)
```bash
flutter run
```

### Mode Release (pour tester les performances)
```bash
flutter run --release
```

### Sélectionner un appareil spécifique
```bash
# Lister les appareils
flutter devices

# Lancer sur un appareil spécifique
flutter run -d <device_id>
```

## 🔧 Optimisations Gradle Appliquées

### ✅ Fichiers Modifiés

1. **`android/gradle.properties`**
   - Parallel build activé
   - Cache Gradle activé
   - Mémoire optimisée (4GB max)
   - R8 full mode activé

2. **`android/app/build.gradle.kts`**
   - minSdk: 24 (Android 7.0+)
   - targetSdk: 35 (Android 15)
   - Java 17
   - MultiDex activé
   - ProGuard configuré

3. **`android/settings.gradle.kts`**
   - Gradle 8.7.3
   - Kotlin 2.1.0
   - Configure on demand

4. **`AndroidManifest.xml`**
   - Permissions complètes (GPS, Caméra, Notifications, etc.)
   - Google Maps API configurée
   - Label: "NeoCare+"

## 🎯 Packages Mis à Jour

### State Management
- ✅ GetX 4.6.6

### UI/UX & Animations
- ✅ animate_do
- ✅ flutter_animate
- ✅ shimmer
- ✅ smooth_page_indicator
- ✅ lottie
- ✅ google_fonts

### Maps & Location
- ✅ google_maps_flutter 2.10.0+
- ✅ geolocator 13.0.2+
- ✅ geocoding

### Storage
- ✅ shared_preferences
- ✅ hive + hive_flutter

### Backend
- ✅ dio 5.7.0
- ✅ http 1.2.2

## 🐛 Résolution des Problèmes Courants

### Problème 1: "Running Gradle task 'assembleDebug' trop long"

**Solution:**
```bash
# 1. Arrêter le daemon Gradle
cd android
./gradlew --stop

# 2. Nettoyer le build
cd ..
flutter clean

# 3. Rebuild
flutter pub get
flutter run
```

### Problème 2: Erreur de compilation Gradle

**Solution:**
```bash
# Supprimer les fichiers de build
rm -rf android/.gradle
rm -rf android/app/build
rm -rf build

# Reinstaller
flutter pub get
flutter run
```

### Problème 3: Conflit de dépendances

**Solution:**
```bash
flutter pub upgrade --major-versions
flutter pub get
```

### Problème 4: Erreur Google Maps

**Action requise:** Ajouter votre clé API Google Maps dans:
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="VOTRE_CLE_API_ICI"/>
```

## 📱 Build APK/AAB

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

### Release AAB (pour Play Store)
```bash
flutter build appbundle --release
```

## 🔍 Analyse du Code

```bash
# Vérifier les erreurs
flutter analyze

# Formatter le code
dart format lib/

# Linter
flutter analyze --no-fatal-infos
```

## 🎨 Écrans Disponibles

### ✅ Terminés
1. **Splash Screen** (`/splash`) - Logo animé
2. **Onboarding** (`/onboarding`) - 3 slides
3. **Login** (`/login`) - Connexion
4. **Signup** (`/signup`) - Inscription
5. **Home** (`/home`) - Dashboard

### 🔜 À Venir
6. Calendrier CPN/PPN
7. Journal de santé
8. Chatbot multilingue
9. Carte centres de santé
10. Carnet médical

## 📊 Performance Tips

### Hot Reload
```bash
# Pendant que l'app tourne, appuyez sur:
r  # Hot reload
R  # Hot restart
q  # Quitter
```

### Build plus rapide
- ✅ Utilisez un émulateur au lieu d'un appareil physique pour le dev
- ✅ Activez Gradle daemon (déjà fait)
- ✅ Utilisez `--profile` pour debugger les performances

## 🌐 Configuration Backend (Spring Boot)

### Endpoints à implémenter:
```
POST   /api/auth/login
POST   /api/auth/register
GET    /api/user/profile
GET    /api/appointments
POST   /api/appointments/{id}/confirm
POST   /api/vitals
GET    /api/centers?lat=&lon=
GET    /api/tips?lang=fr
POST   /api/sos
```

## 🎯 Prochaines Étapes

1. ✅ **Testez l'application** - `flutter run`
2. 📝 **Créer les pages suivantes** - Calendrier, Journal, Chat, Map
3. 🔌 **Intégrer le backend** - Spring Boot API
4. 🎨 **Ajouter des assets** - Images, icons, animations Lottie
5. 🌍 **Implémenter i18n** - FR/EN/Wolof/Pulaar

## 💡 Commandes Utiles

```bash
# Informations sur Flutter
flutter doctor -v

# Mettre à jour Flutter
flutter upgrade

# Lister les packages outdated
flutter pub outdated

# Nettoyer complètement
flutter clean && flutter pub get

# Rebuild complet
flutter clean && flutter pub get && flutter run
```

## 🆘 Support

En cas de problème:
1. Vérifier `flutter doctor`
2. Vérifier les logs: `flutter logs`
3. Relancer depuis zéro: `flutter clean && flutter pub get`

---

**NeoCare+ © 2025** - Ready to run! 🚀
