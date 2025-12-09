# 🗺️ Migration Google Maps → OpenStreetMap (flutter_map)

## ✅ Migration terminée !

VACCI-MED utilise maintenant **OpenStreetMap** avec le package **`flutter_map`** :

### 🎉 Avantages

| Caractéristique      | Google Maps                  | OpenStreetMap              |
| -------------------- | ---------------------------- | -------------------------- |
| **Coût**             | Payant après $200/mois       | ✅ **100% Gratuit**        |
| **Clé API**          | Obligatoire                  | ✅ **Aucune clé requise**  |
| **Configuration**    | Complexe (Android, iOS, Web) | ✅ **Simple**              |
| **Web support**      | Nécessite script JS          | ✅ **Natif**               |
| **Données**          | Google                       | OpenStreetMap (communauté) |
| **Personnalisation** | Limitée                      | ✅ **Très flexible**       |

---

## 📦 Packages installés

```yaml
# Maps & Location (OpenStreetMap - Gratuit, sans clé API)
flutter_map: ^7.0.2 # Affichage de cartes
latlong2: ^0.9.1 # Gestion des coordonnées (LatLng)
geolocator: ^13.0.2 # GPS (conservé)
geocoding: ^3.0.0 # Adresses (conservé)
url_launcher: ^6.3.1 # Liens externes (conservé)
```

**Packages SUPPRIMÉS** :

- ❌ `google_maps_flutter`
- ❌ `google_maps_flutter_android`
- ❌ `google_maps_flutter_ios`
- ❌ `google_maps_flutter_web`
- ❌ `google_maps_flutter_platform_interface`

---

## 🔄 Changements techniques

### 1. **Imports**

**Avant (Google Maps)** :

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
```

**Après (OpenStreetMap)** :

```dart
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
```

---

### 2. **Widget de carte**

**Avant (GoogleMap)** :

```dart
GoogleMap(
  onMapCreated: controller.onMapCreated,
  initialCameraPosition: CameraPosition(
    target: LatLng(14.6928, -17.4467),
    zoom: 14,
  ),
  markers: markers.toSet(),
  myLocationEnabled: true,
)
```

**Après (FlutterMap)** :

```dart
FlutterMap(
  mapController: controller.mapController,
  options: MapOptions(
    initialCenter: LatLng(14.6928, -17.4467),
    initialZoom: 14,
    minZoom: 10,
    maxZoom: 18,
  ),
  children: [
    // Tuiles OpenStreetMap
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.vaccin_app',
    ),

    // Marqueurs
    MarkerLayer(
      markers: markers,
    ),
  ],
)
```

---

### 3. **Markers**

**Avant (Google Maps)** :

```dart
Marker(
  markerId: MarkerId('center_1'),
  position: LatLng(14.7392, -17.4931),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  infoWindow: InfoWindow(title: 'Centre de Santé'),
  onTap: () => selectCenter(center),
)
```

**Après (flutter_map)** :

```dart
Marker(
  point: LatLng(14.7392, -17.4931),
  width: 40,
  height: 40,
  child: GestureDetector(
    onTap: () => selectCenter(center),
    child: Icon(
      Icons.location_on,
      color: Colors.green,
      size: 40,
    ),
  ),
)
```

✅ **Plus flexible** : Vous pouvez utiliser n'importe quel Widget Flutter comme marqueur !

---

### 4. **Contrôle de la caméra**

**Avant (Google Maps)** :

```dart
mapController.animateCamera(
  CameraUpdate.newLatLngZoom(LatLng(14.6928, -17.4467), 14)
);
```

**Après (flutter_map)** :

```dart
mapController.move(LatLng(14.6928, -17.4467), 14);
```

---

### 5. **MapController**

**Avant (Google Maps)** :

```dart
GoogleMapController? mapController;

void onMapCreated(GoogleMapController controller) {
  mapController = controller;
}
```

**Après (flutter_map)** :

```dart
final mapController = MapController();  // Initialisé directement

// Pas besoin de onMapCreated !
```

---

## 🎨 Tuiles de carte disponibles

Vous pouvez changer le style de la carte en modifiant `urlTemplate` :

### OpenStreetMap Standard (actuel)

```dart
urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
```

### OpenStreetMap Français

```dart
urlTemplate: 'https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png'
subdomains: ['a', 'b', 'c']
```

### Cartographie humanitaire

```dart
urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'
```

### Style sombre (dark mode)

```dart
urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
```

### Style clair (light mode)

```dart
urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'
```

### Topographique

```dart
urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png'
```

---

## 🚀 Comment tester

### 1. **Clean** le projet

```cmd
flutter clean
flutter pub get
```

### 2. **Lancez sur Chrome** (pas besoin de clé API !)

```cmd
flutter run -d chrome
```

### 3. **Ou sur Android**

```cmd
flutter run
```

**Aucune configuration Google Maps requise** - ça marche directement ! 🎉

---

## 📱 Fonctionnalités conservées

Tout fonctionne exactement comme avant :

- ✅ Affichage de la carte (Dakar par défaut)
- ✅ Position GPS actuelle (marqueur bleu)
- ✅ 5 centres de santé (marqueurs verts/rouges)
- ✅ Clic sur marqueur → Affichage détails
- ✅ Recherche de centres
- ✅ Zoom/Pan de la carte
- ✅ Bouton "Ma position"
- ✅ Bottom sheet avec infos complètes
- ✅ Actions : Itinéraire, Appeler

---

## 🧹 Nettoyage (optionnel)

Vous pouvez **supprimer** ces fichiers qui ne servent plus :

### Android

```
android/app/src/main/AndroidManifest.xml
```

Supprimez la ligne :

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="..." />
```

### Web

```
web/index.html
```

Supprimez la ligne :

```html
<script src="https://maps.googleapis.com/maps/api/js?key=..."></script>
```

### Documentation obsolète

- ❌ `CONFIGURATION_GOOGLE_MAPS.md`
- ❌ `GOOGLE_MAPS_API_SETUP_GUIDE.md`
- ❌ `GOOGLE_MAPS_SETUP.md`
- ❌ `WEB_GOOGLE_MAPS_FIX.md`

---

## 💡 Personnalisation avancée

### Marqueurs personnalisés avec icônes

```dart
Marker(
  point: LatLng(14.7392, -17.4931),
  width: 50,
  height: 50,
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.green, width: 3),
    ),
    child: Icon(Icons.local_hospital, color: Colors.green),
  ),
)
```

### Animation de caméra

```dart
mapController.move(
  LatLng(14.6928, -17.4467),
  14,
  // Optionnel: ajouter une animation personnalisée
);
```

### Cercles/Zones

```dart
CircleLayer(
  circles: [
    CircleMarker(
      point: LatLng(14.6928, -17.4467),
      radius: 500, // mètres
      color: Colors.blue.withOpacity(0.3),
      borderColor: Colors.blue,
      borderStrokeWidth: 2,
    ),
  ],
)
```

### Polygones (délimiter une zone)

```dart
PolygonLayer(
  polygons: [
    Polygon(
      points: [
        LatLng(14.7, -17.5),
        LatLng(14.8, -17.5),
        LatLng(14.8, -17.4),
        LatLng(14.7, -17.4),
      ],
      color: Colors.red.withOpacity(0.3),
      borderColor: Colors.red,
      borderStrokeWidth: 2,
    ),
  ],
)
```

---

## 📚 Documentation

- [flutter_map Documentation](https://pub.dev/packages/flutter_map)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [Tile Servers](https://wiki.openstreetmap.org/wiki/Tile_servers)
- [latlong2 Package](https://pub.dev/packages/latlong2)

---

## 🎯 Résultat

Vous avez maintenant une carte **100% gratuite**, **sans clé API**, qui fonctionne sur **web, Android, iOS** sans aucune configuration !

**Plus besoin de Google Cloud Console, de facturation, ou de restrictions API.** 🎉

---

## 🆘 Problèmes fréquents

### La carte ne s'affiche pas (écran blanc)

**Solution** : Les tuiles OSM nécessitent une connexion internet. Vérifiez votre connexion.

### Erreur "Failed to load tile"

**Solution** : Changez le `urlTemplate` pour un autre serveur de tuiles (voir liste ci-dessus).

### Marqueurs ne s'affichent pas

**Solution** : Vérifiez que `markers` n'est pas vide avec `print(markers.length)`.

### Position GPS ne fonctionne pas

**Solution** : Les permissions GPS n'ont pas changé. Vérifiez `AndroidManifest.xml` :

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

---

## ✨ Prochaines améliorations possibles

- [ ] Mode sombre/clair pour la carte
- [ ] Clustering des marqueurs (regrouper si trop proches)
- [ ] Itinéraires affichés sur la carte
- [ ] Zones de couverture des centres (cercles)
- [ ] Heatmap des zones à forte densité
- [ ] Tuiles offline (cache local)

**OpenStreetMap offre bien plus de possibilités que Google Maps !** 🚀
