# 🌐 Configuration Google Maps pour le Web (Chrome/Edge/Firefox)

## ❌ Erreur actuelle

```
TypeError: Cannot read properties of undefined (reading 'maps')
```

Cette erreur apparaît **uniquement sur le web** (Chrome/Edge) car le script Google Maps JavaScript API n'est pas chargé.

---

## ✅ Solution : Ajouter le script dans web/index.html

### 1. Ouvrez le fichier `web/index.html`

### 2. Ajoutez cette ligne **AVANT** `</head>` :

```html
<!-- Google Maps JavaScript API -->
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBgx1AkcwpFfElzC8re9I5s9l0rTFLKmdQ"></script>
```

### 3. Votre fichier doit ressembler à ça :

```html
<!DOCTYPE html>
<html>
  <head>
    <base href="$FLUTTER_BASE_HREF" />
    <meta charset="UTF-8" />
    <meta content="IE=Edge" http-equiv="X-UA-Compatible" />
    <meta
      name="description"
      content="VACCI-MED - Votre compagnon vaccination"
    />

    <!-- iOS meta tags -->
    <meta name="mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="apple-mobile-web-app-title" content="VACCI-MED" />
    <link rel="apple-touch-icon" href="icons/Icon-192.png" />

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="favicon.png" />

    <!-- 🗺️ Google Maps JavaScript API - AJOUTEZ CETTE LIGNE -->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBgx1AkcwpFfElzC8re9I5s9l0rTFLKmdQ"></script>

    <title>VACCI-MED</title>
    <link rel="manifest" href="manifest.json" />
  </head>
  <body>
    <script src="flutter_bootstrap.js" async></script>
  </body>
</html>
```

---

## 🔄 Redémarrez l'application

**IMPORTANT** : Hot Reload ne suffit PAS ! Il faut un **full restart**.

### Option 1 : Via le terminal

```cmd
# Arrêtez l'app (Ctrl + C)
# Relancez avec :
flutter run -d chrome
```

### Option 2 : Dans le terminal Flutter

```
# Appuyez sur la touche
R
# (Majuscule R pour full restart)
```

---

## 🎯 Résultat attendu

Après redémarrage, vous devriez voir dans les logs :

```
🗺️ Début initialisation carte...
✅ Permission vérifiée
📍 Récupération position GPS...
✅ Position GPS obtenue: 14.7226624, -17.4358528
🏥 Chargement des centres de santé...
✅ 5 centres chargés
✅ Markers créés: 6
🎉 Carte prête à afficher!
```

Et **PAS** d'erreur "Cannot read properties of undefined".

La carte Google Maps s'affichera avec :

- ✅ Votre position (marqueur bleu)
- ✅ 5 centres de santé (marqueurs verts/rouges)
- ✅ Zoom et navigation fonctionnels

---

## 🚨 Si l'erreur persiste

### 1. Vérifiez que le script est bien ajouté

```cmd
type web\index.html | findstr "maps.googleapis.com"
```

Vous devez voir :

```html
<script src="https://maps.googleapis.com/maps/api/js?key=AIza..."></script>
```

### 2. Videz le cache du navigateur

- Chrome : `Ctrl + Shift + Delete` → Cochez "Images et fichiers en cache" → Effacer
- Ou testez en **mode incognito** : `Ctrl + Shift + N`

### 3. Vérifiez la console JavaScript

- Chrome : `F12` → Onglet **Console**
- Cherchez des erreurs liées à Google Maps

### 4. Testez la clé API

Ouvrez dans Chrome :

```
https://maps.googleapis.com/maps/api/js?key=AIzaSyBgx1AkcwpFfElzC8re9I5s9l0rTFLKmdQ
```

Vous devriez voir du code JavaScript, PAS une erreur "API key not valid".

---

## 🔐 Sécurité de la clé API

### Pour la production, RESTREIGNEZ votre clé :

1. Allez sur : https://console.cloud.google.com/apis/credentials

2. Cliquez sur votre clé API

3. Sous **Application restrictions** :

   - Sélectionnez **HTTP referrers (web sites)**
   - Ajoutez :
     ```
     http://localhost:*
     https://votre-domaine.com/*
     ```

4. Sous **API restrictions** :
   - Sélectionnez **Restrict key**
   - Cochez uniquement :
     - Maps JavaScript API ✅
     - Geocoding API ✅
     - Places API ✅

---

## 📱 Android vs Web

| Plateforme | Fichier de config                          | Script requis                   |
| ---------- | ------------------------------------------ | ------------------------------- |
| Android    | `android/app/src/main/AndroidManifest.xml` | ❌ Non (meta-data suffit)       |
| iOS        | `ios/Runner/AppDelegate.swift`             | ❌ Non (GMSServices suffit)     |
| **Web**    | `web/index.html`                           | ✅ **OUI** (script obligatoire) |

**C'est pour ça que ça fonctionnait peut-être sur émulateur Android mais PAS sur web !**

---

## ✨ Commandes utiles

```cmd
# Tester sur Chrome
flutter run -d chrome

# Tester sur Edge
flutter run -d edge

# Tester sur émulateur Android
flutter run

# Lister les devices disponibles
flutter devices

# Clean + rebuild
flutter clean
flutter pub get
flutter run -d chrome
```

---

## 📚 Ressources

- [Google Maps JavaScript API](https://developers.google.com/maps/documentation/javascript/overview)
- [Flutter Web Google Maps](https://pub.dev/packages/google_maps_flutter_web)
- [API Key Best Practices](https://developers.google.com/maps/api-security-best-practices)
