# Configuration Google Maps API pour VACCI-MED

## 🗺️ Page Map - Centres de Santé

La page Map affiche les centres de santé à proximité avec toutes leurs informations détaillées.

## 📋 Configuration Requise

### 1. Obtenir une clé API Google Maps

1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. Créez un nouveau projet ou sélectionnez un projet existant
3. Activez les APIs suivantes :

   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Geolocation API**
   - **Places API** (optionnel)

4. Créez une clé API :
   - Navigation → APIs & Services → Credentials
   - Cliquez sur "Create Credentials" → "API Key"
   - Copiez la clé générée

### 2. Configuration Android

Ouvrez `android/app/src/main/AndroidManifest.xml` et remplacez `YOUR_GOOGLE_MAPS_API_KEY` par votre clé :

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="VOTRE_CLE_API_ICI" />
```

### 3. Configuration iOS

Ouvrez `ios/Runner/AppDelegate.swift` et ajoutez :

```swift
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("VOTRE_CLE_API_ICI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 🎨 Fonctionnalités de la Page Map

### Interface Utilisateur

- ✅ **Carte Google Maps plein écran** avec zoom et navigation
- ✅ **Barre de recherche** pour filtrer les centres
- ✅ **Marqueurs colorés** :
  - 🔵 Bleu = Position actuelle
  - 🟢 Vert = Centre ouvert
  - 🔴 Rouge = Centre fermé
- ✅ **Bouton "Ma position"** pour recentrer la carte
- ✅ **Bottom Sheet détaillé** avec swipe down pour fermer

### Informations Affichées

Pour chaque centre de santé :

- 📍 **Nom et distance** depuis votre position
- ⭐ **Note et nombre d'avis**
- 🏥 **Statut** (Ouvert/Fermé)
- 📮 **Adresse complète**
- 📞 **Téléphone** (cliquable pour appeler)
- 📧 **Email**
- 💊 **Services disponibles** (CPN, Vaccination, Échographie, etc.)
- 🕐 **Horaires d'ouverture** complets (7 jours)
  - Mise en évidence du jour actuel
  - Affichage des heures d'ouverture/fermeture

### Actions Disponibles

- 🧭 **Bouton Itinéraire** : Ouvre Google Maps pour la navigation
- ☎️ **Bouton Appeler** : Lance l'appel téléphonique
- 🔍 **Recherche** : Filtre par nom, adresse ou service
- 📍 **Clic sur marqueur** : Affiche les détails du centre

## 🔧 Architecture Backend

### API Endpoint Requis

```
GET /api/health-centers?lat={latitude}&lng={longitude}&radius={radius_km}
```

**Réponse attendue (JSON)** :

```json
[
  {
    "id": "1",
    "name": "Centre de Santé Almadies",
    "address": "Route des Almadies, Dakar",
    "latitude": 14.7392,
    "longitude": -17.4931,
    "phone": "+221 33 869 05 00",
    "email": "contact@almadies-health.sn",
    "services": ["CPN", "Vaccination", "Échographie", "Consultation"],
    "openingHours": {
      "lundi": { "openTime": "08:00", "closeTime": "18:00", "isClosed": false },
      "mardi": { "openTime": "08:00", "closeTime": "18:00", "isClosed": false },
      "mercredi": {
        "openTime": "08:00",
        "closeTime": "18:00",
        "isClosed": false
      },
      "jeudi": { "openTime": "08:00", "closeTime": "18:00", "isClosed": false },
      "vendredi": {
        "openTime": "08:00",
        "closeTime": "18:00",
        "isClosed": false
      },
      "samedi": {
        "openTime": "09:00",
        "closeTime": "13:00",
        "isClosed": false
      },
      "dimanche": { "openTime": "", "closeTime": "", "isClosed": true }
    },
    "isOpen": true,
    "distance": 2.5,
    "rating": 4.5,
    "reviewCount": 128,
    "imageUrl": "https://example.com/image.jpg"
  }
]
```

### Intégration Backend

Dans `lib/app/modules/map/map_controller.dart`, remplacez la méthode `_loadHealthCenters()` :

```dart
Future<void> _loadHealthCenters() async {
  try {
    final lat = currentPosition.value?.latitude ?? defaultPosition.latitude;
    final lng = currentPosition.value?.longitude ?? defaultPosition.longitude;

    final response = await dio.get(
      '/api/health-centers',
      queryParameters: {
        'lat': lat,
        'lng': lng,
        'radius': 10, // 10 km
      },
    );

    healthCenters.value = (response.data as List)
        .map((json) => HealthCenter.fromJson(json))
        .toList();
    filteredCenters.value = healthCenters;
  } catch (e) {
    Get.snackbar(
      'Erreur',
      'Impossible de charger les centres de santé',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
```

## 📱 Permissions Requises

Déjà configurées dans `AndroidManifest.xml` :

- `ACCESS_FINE_LOCATION` - Position GPS précise
- `ACCESS_COARSE_LOCATION` - Position approximative
- `INTERNET` - Chargement des tuiles de carte

## 🎯 Utilisation

1. Ouvrez l'application
2. Accédez à l'onglet "Carte" (dernier onglet)
3. Autorisez l'accès à la localisation
4. La carte affiche votre position et les centres à proximité
5. Cliquez sur un marqueur pour voir les détails
6. Utilisez la recherche pour filtrer les centres
7. Cliquez sur "Itinéraire" ou "Appeler" pour interagir

## 🔄 Prochaines Améliorations

- [ ] Filtres avancés (services, horaires, note)
- [ ] Mode liste/carte
- [ ] Favoris
- [ ] Réservation de rendez-vous directement
- [ ] Avis et commentaires
- [ ] Photos des centres
- [ ] Navigation turn-by-turn intégrée

---

**VACCI-MED © 2025** 🏥
