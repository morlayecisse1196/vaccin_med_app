import 'package:get/get.dart';

class VaccinationBookController extends GetxController {
  // Observable pour l'enfant sélectionné
  final selectedChildIndex = 0.obs;

  // Liste des enfants (à remplacer par les données de l'API)
  final children = <Child>[].obs;

  // Page actuelle du livre
  final currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadChildren();
  }

  void loadChildren() {
    // TODO: Charger depuis l'API
    // Données de démonstration
    children.value = [
      Child(
        id: '1',
        name: 'Emma Martin',
        birthDate: DateTime(2023, 3, 15),
        photoUrl: '',
        vaccinations: [
          Vaccination(
            id: '1',
            name: 'BCG',
            disease: 'Tuberculose',
            date: DateTime(2023, 3, 16),
            nextDose: null,
            doseNumber: 1,
            totalDoses: 1,
            lot: 'LOT2023-BCG-001',
            healthCenter: 'Centre de Santé Dakar',
            status: VaccinationStatus.completed,
          ),
          Vaccination(
            id: '2',
            name: 'Pentavalent',
            disease: 'DTC + Hépatite B + Hib',
            date: DateTime(2023, 5, 15),
            nextDose: DateTime(2023, 7, 15),
            doseNumber: 1,
            totalDoses: 3,
            lot: 'LOT2023-PENTA-045',
            healthCenter: 'Centre de Santé Dakar',
            status: VaccinationStatus.completed,
          ),
          Vaccination(
            id: '3',
            name: 'Pentavalent',
            disease: 'DTC + Hépatite B + Hib',
            date: DateTime(2023, 7, 15),
            nextDose: DateTime(2023, 9, 15),
            doseNumber: 2,
            totalDoses: 3,
            lot: 'LOT2023-PENTA-067',
            healthCenter: 'Centre de Santé Dakar',
            status: VaccinationStatus.completed,
          ),
          Vaccination(
            id: '4',
            name: 'Pentavalent',
            disease: 'DTC + Hépatite B + Hib',
            date: null,
            nextDose: DateTime(2023, 9, 15),
            doseNumber: 3,
            totalDoses: 3,
            lot: null,
            healthCenter: null,
            status: VaccinationStatus.scheduled,
          ),
          Vaccination(
            id: '5',
            name: 'VPO (Polio oral)',
            disease: 'Poliomyélite',
            date: DateTime(2023, 5, 15),
            nextDose: null,
            doseNumber: 1,
            totalDoses: 3,
            lot: 'LOT2023-VPO-023',
            healthCenter: 'Centre de Santé Dakar',
            status: VaccinationStatus.completed,
          ),
          Vaccination(
            id: '6',
            name: 'Rougeole',
            disease: 'Rougeole',
            date: null,
            nextDose: DateTime(2024, 3, 15),
            doseNumber: 1,
            totalDoses: 2,
            lot: null,
            healthCenter: null,
            status: VaccinationStatus.pending,
          ),
        ],
      ),
      Child(
        id: '2',
        name: 'Lucas Martin',
        birthDate: DateTime(2021, 8, 20),
        photoUrl: '',
        vaccinations: [
          Vaccination(
            id: '7',
            name: 'ROR',
            disease: 'Rougeole-Oreillons-Rubéole',
            date: DateTime(2022, 8, 20),
            nextDose: null,
            doseNumber: 1,
            totalDoses: 2,
            lot: 'LOT2022-ROR-089',
            healthCenter: 'Hôpital Principal',
            status: VaccinationStatus.completed,
          ),
        ],
      ),
    ];
  }

  void selectChild(int index) {
    selectedChildIndex.value = index;
    currentPage.value = 0;
  }

  void changePage(int page) {
    currentPage.value = page;
  }

  Child? get selectedChild {
    if (children.isEmpty) return null;
    return children[selectedChildIndex.value];
  }

  int get totalPages {
    if (selectedChild == null) return 0;
    // 1 page de couverture + pages de vaccinations (2 par page)
    return 1 + ((selectedChild!.vaccinations.length + 1) / 2).ceil();
  }

  double get vaccinationProgress {
    if (selectedChild == null) return 0;
    final completed = selectedChild!.vaccinations
        .where((v) => v.status == VaccinationStatus.completed)
        .length;
    return completed / selectedChild!.vaccinations.length;
  }
}

// Modèles de données
class Child {
  final String id;
  final String name;
  final DateTime birthDate;
  final String photoUrl;
  final List<Vaccination> vaccinations;

  Child({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.photoUrl,
    required this.vaccinations,
  });

  int get ageInMonths {
    final now = DateTime.now();
    return (now.year - birthDate.year) * 12 + now.month - birthDate.month;
  }

  String get ageDisplay {
    final months = ageInMonths;
    if (months < 12) {
      return '$months mois';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years ${years > 1 ? 'ans' : 'an'}';
      }
      return '$years ${years > 1 ? 'ans' : 'an'} et $remainingMonths mois';
    }
  }
}

class Vaccination {
  final String id;
  final String name;
  final String disease;
  final DateTime? date;
  final DateTime? nextDose;
  final int doseNumber;
  final int totalDoses;
  final String? lot;
  final String? healthCenter;
  final VaccinationStatus status;

  Vaccination({
    required this.id,
    required this.name,
    required this.disease,
    required this.date,
    required this.nextDose,
    required this.doseNumber,
    required this.totalDoses,
    required this.lot,
    required this.healthCenter,
    required this.status,
  });

  String get doseDisplay => 'Dose $doseNumber/$totalDoses';
}

enum VaccinationStatus {
  completed, // Vaccination effectuée
  scheduled, // Rendez-vous pris
  pending, // En attente
  overdue, // En retard
}
