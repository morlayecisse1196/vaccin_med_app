# 🧪 Guide de test - Carnet de Vaccination

## 🚀 Comment tester

### 1. Lancer l'application

```bash
cd c:\Users\USER\Desktop\STAGE\GOVATHON\vaccin_app
flutter run
```

Ou utilisez le fichier `run.bat` fourni :

```bash
run.bat
```

### 2. Navigation jusqu'au carnet

#### Étape par étape :

1. ✅ Ouvrez l'application
2. ✅ Naviguez jusqu'à la **HomePage** (premier onglet)
3. ✅ Faites défiler la section **Quick Stats** horizontalement
4. ✅ Trouvez la carte **"Carnet de Vaccination"** (avec gradient bleu et icône 📖)
5. ✅ Cliquez sur cette carte
6. ✅ Vous arrivez sur la page du carnet !

## ✅ Points à vérifier

### Page d'accueil (HomePage)

- [ ] La carte "Carnet de Vaccination" s'affiche dans Quick Stats
- [ ] Elle a un gradient bleu (primary)
- [ ] Elle affiche l'icône de livre (📖)
- [ ] Elle a un bouton flèche (→)
- [ ] L'effet d'ombre est visible
- [ ] Au tap, la navigation fonctionne

### Page de couverture du carnet

- [ ] Le titre "CARNET DE VACCINATION" s'affiche
- [ ] L'avatar de l'enfant apparaît (cercle avec initiale)
- [ ] Le nom complet est affiché : "Emma Martin"
- [ ] La date de naissance est formatée : "15 mars 2023"
- [ ] L'âge est calculé automatiquement : "8 mois"
- [ ] La barre de progression s'affiche
- [ ] Le pourcentage est correct (75%)
- [ ] Les statistiques sont visibles :
  - ✅ Complétés : 4
  - ⏳ En attente : 2

### Pages de vaccinations

- [ ] La navigation par swipe fonctionne (gauche/droite)
- [ ] Les boutons ◀️ ▶️ fonctionnent
- [ ] Les indicateurs de page (dots) s'affichent
- [ ] Le dot actif est plus grand et coloré
- [ ] Chaque page affiche 2 vaccinations maximum
- [ ] Les cartes de vaccination ont les bonnes couleurs selon le statut :
  - ✅ Vert pour "Complété"
  - 📅 Bleu pour "Programmé"
  - ⏳ Orange pour "En attente"
  - ⚠️ Rouge pour "En retard"

### Détails des vaccinations

Pour chaque vaccination, vérifier :

- [ ] Nom du vaccin (ex: "BCG", "Pentavalent")
- [ ] Maladie prévenue (ex: "Tuberculose")
- [ ] Numéro de dose (ex: "Dose 1/3")
- [ ] Date d'administration (si complété)
- [ ] Numéro de lot (si complété)
- [ ] Centre de santé (si complété)
- [ ] Prochaine dose (si applicable)
- [ ] Badge de statut avec bonne couleur

### Sélecteur d'enfants (si données multiples)

- [ ] La barre de sélection s'affiche en haut
- [ ] Scroll horizontal fonctionne
- [ ] L'enfant sélectionné a un fond bleu
- [ ] L'enfant sélectionné a un texte blanc
- [ ] Au tap, le carnet change d'enfant
- [ ] La page revient à 0 (couverture)

### Texture et design

- [ ] L'effet de texture papier est visible
- [ ] Les ombres portées sont présentes
- [ ] Les bordures sont bien définies
- [ ] Les animations FadeInUp fonctionnent
- [ ] Le design ressemble à un vrai carnet papier

## 🐛 Problèmes potentiels

### Erreur : "No route defined"

**Cause** : Les routes ne sont pas bien configurées
**Solution** :

```dart
// Vérifier dans app_routes.dart
static const String vaccinationBook = '/vaccination-book';

// Vérifier dans app_pages.dart
GetPage(
  name: AppRoutes.vaccinationBook,
  page: () => const VaccinationBookPage(),
  binding: VaccinationBookBinding(),
)
```

### Erreur : "Controller not found"

**Cause** : Le binding n'est pas configuré
**Solution** :

```dart
// Dans vaccination_book_page.dart, initState()
controller = Get.put(VaccinationBookController());
```

### Erreur de couleur (AppColors.xxx not defined)

**Cause** : Couleur inexistante dans AppColors
**Solution** : Utiliser les couleurs disponibles :

- `AppColors.primary`
- `AppColors.secondary`
- `AppColors.white`
- `AppColors.lightGray`
- `AppColors.textGray`
- `AppColors.danger`
- `AppColors.warning`
- `AppColors.info`
- `AppColors.success`

### Les données ne s'affichent pas

**Cause** : Données de démonstration non chargées
**Solution** :

```dart
// Dans VaccinationBookController.onInit()
loadChildren(); // Devrait charger les données de démo
```

## 📸 Captures d'écran à faire

1. **HomePage avec bouton**

   - Screenshot de la section Quick Stats
   - Focus sur la carte "Carnet de Vaccination"

2. **Couverture du carnet**

   - Page 0 avec toutes les informations de l'enfant
   - Barre de progression visible

3. **Page de vaccination**

   - 2 vaccinations affichées
   - Différents statuts visibles

4. **Navigation**

   - Indicateurs de page actifs
   - Boutons de navigation

5. **Sélecteur d'enfants**
   - Si plusieurs enfants
   - Montrer l'enfant sélectionné

## 🔧 Commandes utiles

### Rebuild complet

```bash
flutter clean
flutter pub get
flutter run
```

### Hot reload (pendant l'exécution)

```bash
Press 'r' in terminal
```

### Hot restart

```bash
Press 'R' in terminal
```

### Inspecter les widgets

```bash
Press 'w' in terminal → Widget Inspector
```

## 📊 Checklist finale

- [ ] Application compile sans erreur
- [ ] Navigation fonctionne (HomePage → Carnet)
- [ ] Page de couverture s'affiche correctement
- [ ] Pages de vaccinations s'affichent
- [ ] Navigation entre pages fonctionne
- [ ] Statuts colorés sont visibles
- [ ] Texture papier est présente
- [ ] Animations sont fluides
- [ ] Aucune erreur dans la console
- [ ] Performance acceptable (pas de lag)

## 🎯 Tests avancés (optionnel)

### Test sur différentes plateformes

```bash
# Android
flutter run -d android

# iOS (Mac uniquement)
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

### Test avec différentes données

Modifier `vaccination_book_controller.dart` :

```dart
// Ajouter plus d'enfants
children.value = [child1, child2, child3];

// Modifier les statuts
status: VaccinationStatus.overdue // Tester le rouge

// Ajouter plus de vaccinations
// Pour tester plus de pages
```

### Test de performance

```bash
flutter run --profile
# Vérifier les FPS dans DevTools
```

## 📞 Support

En cas de problème :

1. Vérifier les fichiers créés dans `lib/app/modules/vaccination_book/`
2. Vérifier les routes dans `lib/app/routes/`
3. Vérifier les imports dans `home_page.dart`
4. Consulter la documentation : `VACCINATION_BOOK_MODULE.md`
5. Consulter le guide visuel : `CARNET_VISUAL_GUIDE.md`

---

**Bonne chance pour les tests !** 🚀
