# 🔧 Guide Complet : Résoudre "ApiNotActivatedMapError"

## ❌ Erreur actuelle

```
Google Maps JavaScript API error: ApiNotActivatedMapError
https://developers.google.com/maps/documentation/javascript/error-messages#api-not-activated-map-error
```

**Signification** : Votre clé API existe MAIS l'API "Maps JavaScript API" n'est **pas activée** pour cette clé.

---

## ✅ Solution 1 : Activer l'API pour la clé existante

### Étape 1 : Ouvrez Google Cloud Console

🔗 Allez sur : **https://console.cloud.google.com/**

### Étape 2 : Sélectionnez votre projet

En haut de la page, cliquez sur le nom du projet (ex: "My Project", "VACCI-MED", etc.)

Si vous n'avez pas de projet, passez à la **Solution 2** ci-dessous.

### Étape 3 : Allez dans "APIs & Services"

Dans le menu latéral gauche (☰) :

- Cliquez sur **APIs & Services**
- Puis **Library**

Ou allez directement ici : **https://console.cloud.google.com/apis/library**

### Étape 4 : Activez les APIs nécessaires

Cherchez et activez **CES 3 APIs** (minimum) :

#### 1️⃣ Maps JavaScript API ⭐ (LE PLUS IMPORTANT)

1. Dans la barre de recherche, tapez : `Maps JavaScript API`
2. Cliquez sur **Maps JavaScript API**
3. Cliquez sur le bouton **ENABLE** (ou **ACTIVER**)
4. Attendez 10-20 secondes

#### 2️⃣ Maps SDK for Android

1. Cherchez : `Maps SDK for Android`
2. Cliquez dessus
3. Cliquez **ENABLE**

#### 3️⃣ Geocoding API (optionnel mais recommandé)

1. Cherchez : `Geocoding API`
2. Cliquez dessus
3. Cliquez **ENABLE**

### Étape 5 : Vérifiez que les APIs sont activées

Allez sur : **https://console.cloud.google.com/apis/dashboard**

Vous devriez voir dans la liste :

- ✅ Maps JavaScript API
- ✅ Maps SDK for Android
- ✅ Geocoding API (optionnel)

### Étape 6 : Attendez 2-5 minutes

Les changements peuvent prendre quelques minutes pour se propager.

### Étape 7 : Relancez l'application

```cmd
# Arrêtez l'app (Ctrl + C)
flutter run -d chrome
```

---

## ✅ Solution 2 : Créer une NOUVELLE clé API (recommandé si la solution 1 ne marche pas)

### Étape 1 : Créez un nouveau projet Google Cloud

🔗 **https://console.cloud.google.com/projectcreate**

- **Nom du projet** : `VACCI-MED`
- **Organisation** : Aucune (ou votre organisation)
- Cliquez **CREATE**
- Attendez 30 secondes

### Étape 2 : Activez la facturation (REQUIS)

⚠️ **Google Maps nécessite une carte bancaire** MAIS offre **$200 de crédit gratuit/mois**.

1. Allez sur : **https://console.cloud.google.com/billing**
2. Cliquez **Link a billing account**
3. Suivez les étapes pour ajouter votre carte
4. Pas de panique : $200/mois suffit largement pour le développement !

### Étape 3 : Activez les APIs

Comme dans la Solution 1, activez :

- Maps JavaScript API ✅
- Maps SDK for Android ✅
- Geocoding API ✅

### Étape 4 : Créez une clé API

🔗 **https://console.cloud.google.com/apis/credentials**

1. Cliquez sur **+ CREATE CREDENTIALS**
2. Sélectionnez **API Key**
3. Une clé sera générée (format : `AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`)
4. **COPIEZ** immédiatement cette clé !

### Étape 5 : (Optionnel mais recommandé) Sécurisez votre clé

1. Cliquez sur **RESTRICT KEY** (ou sur le crayon ✏️ à côté de votre clé)

2. Donnez un nom : `VACCI-MED API Key`

3. Sous **Application restrictions** :

   - Sélectionnez **HTTP referrers (web sites)**
   - Cliquez **+ ADD AN ITEM**
   - Ajoutez :
     ```
     http://localhost:*
     https://localhost:*
     http://127.0.0.1:*
     ```

4. Sous **API restrictions** :

   - Sélectionnez **Restrict key**
   - Cochez uniquement :
     - Maps JavaScript API ✅
     - Maps SDK for Android ✅
     - Geocoding API ✅

5. Cliquez **SAVE**

### Étape 6 : Remplacez la clé dans votre code

#### Fichier 1 : `web/index.html`

Remplacez `VOTRE_NOUVELLE_CLE_API` par votre vraie clé :

```html
<!-- Google Maps JavaScript API -->
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"></script>
```

#### Fichier 2 : `android/app/src/main/AndroidManifest.xml`

Ligne ~25, remplacez :

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" />
```

**⚠️ Utilisez la MÊME clé dans les 2 fichiers !**

### Étape 7 : Rebuild complet

```cmd
flutter clean
flutter pub get
flutter run -d chrome
```

---

## 🧪 Testez votre clé API

### Test rapide dans le navigateur

Ouvrez cette URL dans Chrome (remplacez `VOTRE_CLE` par votre vraie clé) :

```
https://maps.googleapis.com/maps/api/js?key=VOTRE_CLE
```

**Résultat attendu :**

- ✅ Vous voyez du code JavaScript → Clé valide
- ❌ Erreur "API key not valid" → Clé invalide ou restreinte
- ❌ Erreur "RefererNotAllowedMapError" → Restreignez mieux votre clé

---

## 📊 Vérification rapide

Dans Google Cloud Console : **https://console.cloud.google.com/apis/dashboard**

Vous devriez voir :

| API                  | Status     |
| -------------------- | ---------- |
| Maps JavaScript API  | ✅ Enabled |
| Maps SDK for Android | ✅ Enabled |
| Geocoding API        | ✅ Enabled |

---

## 🚨 Problèmes fréquents

### ❌ "This API project is not authorized to use this API"

**Solution** : Activez l'API dans Google Cloud Console (voir Solution 1)

### ❌ "API keys with referer restrictions cannot be used with this API"

**Solution** :

1. Allez dans **Credentials**
2. Cliquez sur votre clé
3. Sous **Application restrictions**, sélectionnez **None** (pour le développement)
4. Sauvegardez

### ❌ "You must enable Billing on the Google Cloud Project"

**Solution** : Ajoutez une carte bancaire (pas de frais si usage < $200/mois)

### ❌ La carte ne s'affiche toujours pas après 5 minutes

**Solutions** :

1. Videz le cache du navigateur (`Ctrl + Shift + Delete`)
2. Testez en mode incognito (`Ctrl + Shift + N`)
3. Vérifiez les logs de la console JavaScript (`F12`)
4. Vérifiez que vous avez bien sauvegardé les fichiers modifiés

---

## 💡 Astuce : Mode développement SANS clé API

Si vous voulez tester rapidement SANS configurer Google Cloud :

### Option 1 : Utilisez une clé de démo (NON RECOMMANDÉ)

```html
<!-- ⚠️ SEULEMENT POUR TESTS - Ne fonctionne pas toujours -->
<script src="https://maps.googleapis.com/maps/api/js"></script>
```

Vous verrez "For development purposes only" sur la carte.

### Option 2 : Utilisez une autre librairie de cartes

- **OpenStreetMap** avec `flutter_map` (gratuit, pas de clé requise)
- **Mapbox** (300,000 chargements gratuits/mois)

---

## 📝 Checklist finale

Avant de lancer l'application, vérifiez :

- [ ] Projet Google Cloud créé
- [ ] Facturation activée (carte bancaire ajoutée)
- [ ] Maps JavaScript API activée ✅
- [ ] Maps SDK for Android activée ✅
- [ ] Clé API créée et copiée
- [ ] Clé ajoutée dans `web/index.html`
- [ ] Clé ajoutée dans `android/app/src/main/AndroidManifest.xml`
- [ ] Fichiers sauvegardés
- [ ] `flutter clean` exécuté
- [ ] `flutter pub get` exécuté
- [ ] Application relancée

---

## 🎯 Résultat attendu

Après configuration correcte, vous devriez voir :

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

**SANS** les erreurs :

- ❌ `ApiNotActivatedMapError`
- ❌ `Cannot read properties of undefined`
- ❌ `API key not valid`

Et la carte Google Maps s'affichera avec tous les marqueurs ! 🎉

---

## 📞 Besoin d'aide ?

Consultez :

- [Documentation officielle](https://developers.google.com/maps/documentation/javascript/get-api-key)
- [Messages d'erreur Google Maps](https://developers.google.com/maps/documentation/javascript/error-messages)
- [Tarification Google Maps](https://mapsplatform.google.com/pricing/)
