import 'package:get/get.dart';

class JournalController extends GetxController {
  // Liste des entrées du journal
  final RxList<HealthEntry> entries = <HealthEntry>[].obs;
  final RxString selectedPeriod = 'Semaine'.obs;
  final RxString selectedMetric = 'Tous'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadEntries();
  }

  void _loadEntries() {
    // Données de démonstration
    entries.value = [
      HealthEntry(
        id: '1',
        date: DateTime.now(),
        type: HealthMetricType.bloodPressure,
        value: '120/80',
        unit: 'mmHg',
        status: HealthStatus.normal,
        note: 'Mesure du matin',
      ),
      HealthEntry(
        id: '2',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        type: HealthMetricType.weight,
        value: '68.5',
        unit: 'kg',
        status: HealthStatus.normal,
        note: 'Poids stable',
      ),
      HealthEntry(
        id: '3',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: HealthMetricType.glucose,
        value: '95',
        unit: 'mg/dL',
        status: HealthStatus.normal,
        note: 'À jeun',
      ),
      HealthEntry(
        id: '4',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: HealthMetricType.temperature,
        value: '36.8',
        unit: '°C',
        status: HealthStatus.normal,
        note: '',
      ),
      HealthEntry(
        id: '5',
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: HealthMetricType.heartRate,
        value: '72',
        unit: 'bpm',
        status: HealthStatus.normal,
        note: 'Au repos',
      ),
      HealthEntry(
        id: '6',
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: HealthMetricType.hydration,
        value: '7',
        unit: 'verres',
        status: HealthStatus.normal,
        note: '',
      ),
    ];
  }

  void setPeriod(String period) {
    selectedPeriod.value = period;
  }

  void setMetric(String metric) {
    selectedMetric.value = metric;
  }

  List<HealthEntry> get filteredEntries {
    List<HealthEntry> filtered = entries;

    // Filter by metric type
    if (selectedMetric.value != 'Tous') {
      filtered = filtered.where((entry) {
        return _getMetricName(entry.type) == selectedMetric.value;
      }).toList();
    }

    // Filter by period
    final now = DateTime.now();
    switch (selectedPeriod.value) {
      case 'Jour':
        filtered = filtered.where((entry) {
          return entry.date.day == now.day &&
              entry.date.month == now.month &&
              entry.date.year == now.year;
        }).toList();
        break;
      case 'Semaine':
        final weekAgo = now.subtract(const Duration(days: 7));
        filtered = filtered.where((entry) => entry.date.isAfter(weekAgo)).toList();
        break;
      case 'Mois':
        filtered = filtered.where((entry) {
          return entry.date.month == now.month && entry.date.year == now.year;
        }).toList();
        break;
    }

    return filtered;
  }

  String _getMetricName(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.bloodPressure:
        return 'Tension';
      case HealthMetricType.weight:
        return 'Poids';
      case HealthMetricType.glucose:
        return 'Glycémie';
      case HealthMetricType.temperature:
        return 'Température';
      case HealthMetricType.heartRate:
        return 'Fréquence cardiaque';
      case HealthMetricType.hydration:
        return 'Hydratation';
    }
  }

  void deleteEntry(String id) {
    entries.removeWhere((entry) => entry.id == id);
    Get.snackbar('Supprimé', 'Entrée supprimée avec succès');
  }
}

// Models
enum HealthMetricType { bloodPressure, weight, glucose, temperature, heartRate, hydration }

enum HealthStatus { low, normal, high, critical }

class HealthEntry {
  final String id;
  final DateTime date;
  final HealthMetricType type;
  final String value;
  final String unit;
  final HealthStatus status;
  final String note;

  HealthEntry({
    required this.id,
    required this.date,
    required this.type,
    required this.value,
    required this.unit,
    required this.status,
    required this.note,
  });
}
