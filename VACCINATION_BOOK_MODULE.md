# 📖 Module Carnet de Vaccination

## Vue d'ensemble

Le module **Carnet de Vaccination** permet aux parents de consulter et de suivre les vaccinations de leurs enfants dans une interface élégante rappelant un carnet papier traditionnel.

## Fonctionnalités

### 🎯 Fonctionnalités principales

1. **Gestion multi-enfants**
   - Visualisation des carnets de plusieurs enfants
   - Sélecteur horizontal pour basculer entre enfants
   - Avatar personnalisé pour chaque enfant

2. **Interface type livre papier**
   - Design élégant avec effet de texture papier
   - Navigation par pages avec indicateurs
   - Transitions fluides entre les pages
   - Page de couverture avec informations de l'enfant

3. **Suivi des vaccinations**
   - Liste complète des vaccinations (effectuées et à venir)
   - Statuts visuels colorés :
     - ✅ Complété (vert)
     - 📅 Programmé (bleu)
     - ⏳ En attente (orange)
     - ⚠️ En retard (rouge)
   - Informations détaillées :
     - Nom du vaccin et maladie prévenue
     - Numéro de dose (1/3, 2/3, etc.)
     - Date d'administration
     - Numéro de lot
     - Centre de santé
     - Date de la prochaine dose

4. **Statistiques et progression**
   - Barre de progression globale
   - Nombre de vaccins complétés
   - Nombre de vaccins en attente
   - Calcul automatique de l'âge de l'enfant

## Structure des fichiers

```
lib/app/modules/vaccination_book/
├── vaccination_book_controller.dart   # Logique métier
├── vaccination_book_page.dart         # Interface utilisateur
└── vaccination_book_binding.dart      # Configuration GetX
```

## Modèles de données

### Child (Enfant)
```dart
{
  id: String              // Identifiant unique
  name: String            // Nom complet
  birthDate: DateTime     // Date de naissance
  photoUrl: String        // URL de la photo
  vaccinations: List      // Liste des vaccinations
}
```

### Vaccination
```dart
{
  id: String              // Identifiant unique
  name: String            // Nom du vaccin (ex: "BCG", "Pentavalent")
  disease: String         // Maladie prévenue
  date: DateTime?         // Date d'administration (null si non fait)
  nextDose: DateTime?     // Date de la prochaine dose
  doseNumber: int         // Numéro de la dose actuelle
  totalDoses: int         // Nombre total de doses
  lot: String?            // Numéro de lot
  healthCenter: String?   // Centre de santé
  status: VaccinationStatus  // Statut
}
```

### VaccinationStatus (Statut)
- `completed` : Vaccination effectuée
- `scheduled` : Rendez-vous pris
- `pending` : En attente de planification
- `overdue` : En retard

## Navigation

### Accès au carnet
Depuis la **HomePage**, cliquez sur la carte "Carnet de Vaccination" dans la section Quick Stats.

```dart
Get.toNamed(AppRoutes.vaccinationBook);
```

## Design

### Palette de couleurs
- **Page de couverture** : Blanc avec texture papier ancien (#F5F1E8)
- **Badges de statut** :
  - Complété : Vert (AppColors.success)
  - Programmé : Bleu (AppColors.info)
  - En attente : Orange (AppColors.warning)
  - En retard : Rouge (AppColors.danger)

### Composants visuels
1. **PaperTexturePainter** : CustomPainter créant l'effet de lignes de cahier
2. **Cartes de vaccination** : Bordures colorées selon le statut
3. **Indicateurs de progression** : Barre horizontale animée
4. **Navigation** : Dots indicateurs de page

## Intégration backend

### Endpoints requis

```
GET /api/children
Response: List<Child>

GET /api/children/{childId}/vaccinations
Response: List<Vaccination>

POST /api/vaccinations/{vaccinationId}/complete
Body: {
  date: DateTime,
  lot: String,
  healthCenter: String
}

POST /api/vaccinations/{vaccinationId}/schedule
Body: {
  appointmentDate: DateTime,
  healthCenter: String
}
```

## Exemples de vaccinations (Sénégal)

### Calendrier vaccinal
| Âge | Vaccin | Maladie |
|-----|--------|---------|
| À la naissance | BCG | Tuberculose |
| 6 semaines | Pentavalent (Dose 1) | DTC + Hépatite B + Hib |
| 6 semaines | VPO (Dose 1) | Poliomyélite |
| 10 semaines | Pentavalent (Dose 2) | DTC + Hépatite B + Hib |
| 10 semaines | VPO (Dose 2) | Poliomyélite |
| 14 semaines | Pentavalent (Dose 3) | DTC + Hépatite B + Hib |
| 14 semaines | VPO (Dose 3) | Poliomyélite |
| 9 mois | Rougeole (Dose 1) | Rougeole |
| 15 mois | ROR (Dose 2) | Rougeole-Oreillons-Rubéole |

## Améliorations futures

### À court terme
- [ ] Export PDF du carnet
- [ ] Partage par email
- [ ] Notifications de rappel
- [ ] Ajout de photos de l'enfant
- [ ] Scan de QR codes de vaccins

### À moyen terme
- [ ] Synchronisation cloud
- [ ] Mode hors ligne
- [ ] Historique des modifications
- [ ] Validation par QR code du centre de santé
- [ ] Certificats de vaccination officiels

### À long terme
- [ ] Intégration IA pour recommandations
- [ ] Reconnaissance d'image de carnet papier
- [ ] Blockchain pour l'authenticité
- [ ] Intégration avec systèmes de santé nationaux

## Tests

### Cas de tests manuels
1. ✅ Navigation vers le carnet depuis HomePage
2. ✅ Affichage de la page de couverture
3. ✅ Navigation entre les pages du carnet
4. ✅ Sélection de différents enfants
5. ✅ Affichage des statuts de vaccination
6. ✅ Calcul de l'âge de l'enfant
7. ✅ Progression des vaccinations

## Support

Pour toute question ou problème, consultez :
- Documentation principale : `README.md`
- Guide de développement : `DEVELOPMENT_GUIDE.md`
- Architecture : `ARCHITECTURE.md`

---

**Dernière mise à jour** : 8 novembre 2025
**Version** : 1.0.0
