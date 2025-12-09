# 🗺️ Configuration Google Maps pour VACCI-MED

## ⚠️ PROBLÈME ACTUEL

Votre application affiche l'erreur **"undefined (reading 'maps')"** car la clé API Google Maps n'est PAS configurée.

Dans `android/app/src/main/AndroidManifest.xml`, ligne 25 :

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY" />
```

`YOUR_GOOGLE_MAPS_API_KEY` est un **placeholder** ! Il faut le remplacer par une vraie clé.

---

## ✅ SOLUTION : Obtenir et configurer une clé API

### 📋 Étape 1 : Créer un projet Google Cloud

1. Allez sur **https://console.cloud.google.com/**
2. Connectez-vous avec votre compte Google
3. En haut de la page, cliquez sur **Select a project** → **NEW PROJECT**
4. Nommez votre projet : `VACCI-MED` ou `vaccin-app`
5. Cliquez **Create**
6. Attendez quelques secondes, puis sélectionnez votre nouveau projet

---

### 🔑 Étape 2 : Générer une clé API

1. Dans le menu latéral, allez dans **APIs & Services** → **Credentials**
2. Cliquez sur **+ CREATE CREDENTIALS**
3. Sélectionnez **API Key**
4. Une clé sera générée (format : `AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`)
5. **COPIEZ** cette clé immédiatement !

**⚠️ Sécurité (optionnel mais recommandé) :**

- Cliquez sur **RESTRICT KEY**
- Sous **Application restrictions**, choisissez **Android apps**
- Cliquez **+ Add an item**
- Package name : `com.example.vaccin_app` (ou votre package)
- SHA-1 : Obtenez-le avec :
  ```cmd
  cd android
  gradlew signingReport
  ```
  Copiez le SHA-1 de `Variant: debug` → `SHA1:`

---

### 🌍 Étape 3 : Activer les APIs Maps

1. Dans **APIs & Services** → **Library**
2. Cherchez et activez ces APIs :
   - **Maps SDK for Android** ✅ (OBLIGATOIRE)
   - **Geocoding API** (pour convertir adresses ↔ coordonnées)
   - **Places API** (pour rechercher des lieux)
   - **Directions API** (pour les itinéraires)

Pour chaque API :

- Cliquez dessus
- Cliquez **ENABLE**

---

### 📝 Étape 4 : Remplacer la clé dans AndroidManifest.xml

1. Ouvrez le fichier :

   ```
   android/app/src/main/AndroidManifest.xml
   ```

2. Trouvez la ligne 25 :

   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY" />
   ```

3. Remplacez `YOUR_GOOGLE_MAPS_API_KEY` par votre vraie clé :

   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" />
   ```

   _(Utilisez VOTRE clé, pas cet exemple)_

4. **Sauvegardez** le fichier

---

### 🔄 Étape 5 : Rebuild l'application

1. **Nettoyez** le build :

   ```cmd
   flutter clean
   ```

2. **Récupérez** les dépendances :

   ```cmd
   flutter pub get
   ```

3. **Rebuild** pour Android :

   ```cmd
   flutter run
   ```

4. La carte devrait maintenant s'afficher correctement ! 🎉

---

## 🧪 Test de vérification

Une fois l'app relancée, vous devriez voir :

- ✅ Une carte Google Maps centrée sur Dakar
- ✅ Un marqueur bleu pour votre position actuelle
- ✅ 5 marqueurs verts/rouges pour les centres de santé
- ✅ Possibilité de zoomer/déplacer la carte
- ✅ Cliquer sur un marqueur affiche les détails du centre

---

## 🚨 Problèmes fréquents

### Erreur : "API key not found"

→ Vérifiez que vous avez bien remplacé `YOUR_GOOGLE_MAPS_API_KEY` par votre vraie clé dans `AndroidManifest.xml`

### Erreur : "This API project is not authorized to use this API"

→ Activez **Maps SDK for Android** dans Google Cloud Console

### Carte grise avec "For development purposes only"

→ Activez la facturation dans Google Cloud (carte bancaire requise, mais Google offre $200 de crédit gratuit/mois)

### Marqueurs ne s'affichent pas

→ Vérifiez que vous avez autorisé la permission de localisation dans les paramètres Android

---

## 💡 Conseils

1. **Ne partagez JAMAIS votre clé API** sur GitHub public

   - Ajoutez `android/local.properties` à `.gitignore`
   - Utilisez des secrets d'environnement pour la production

2. **Sécurisez votre clé** avec des restrictions :

   - Restriction par package Android
   - Restriction par SHA-1
   - Restreignez aux APIs utilisées uniquement

3. **Surveillez votre quota** :
   - Google Maps offre $200/mois gratuit
   - Après, c'est payant
   - Activez les alertes de facturation

---

## 📚 Documentation officielle

- [Get API Key](https://developers.google.com/maps/documentation/android-sdk/get-api-key)
- [Maps SDK for Flutter](https://pub.dev/packages/google_maps_flutter)
- [Google Cloud Console](https://console.cloud.google.com/)

---

## 🎯 Résumé rapide

```cmd
1. https://console.cloud.google.com/ → Créer projet
2. APIs & Services → Credentials → Create API Key
3. APIs & Services → Library → Enable "Maps SDK for Android"
4. Copier la clé
5. Coller dans android/app/src/main/AndroidManifest.xml ligne 25
6. flutter clean && flutter pub get && flutter run
```

**Voilà ! Votre carte devrait maintenant fonctionner ! 🚀**
