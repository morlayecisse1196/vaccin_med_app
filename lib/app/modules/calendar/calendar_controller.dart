import 'package:get/get.dart';

class CalendarController extends GetxController {
  // Liste des rendez-vous
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString selectedFilter = 'Tous'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAppointments();
  }

  void _loadAppointments() {
    // Données de démonstration
    appointments.value = [
      Appointment(
        id: '1',
        title: 'Consultation Prénatale 1',
        type: AppointmentType.cpn,
        date: DateTime.now().add(const Duration(days: 2)),
        time: '09:00',
        doctor: 'Dr. Fatou Sall',
        location: 'Centre de Santé Almadies',
        status: AppointmentStatus.confirmed,
      ),
      Appointment(
        id: '2',
        title: 'Échographie 2ème trimestre',
        type: AppointmentType.echography,
        date: DateTime.now().add(const Duration(days: 7)),
        time: '14:30',
        doctor: 'Dr. Amadou Diop',
        location: 'Clinique Suma',
        status: AppointmentStatus.pending,
      ),
      Appointment(
        id: '3',
        title: 'Consultation Prénatale 2',
        type: AppointmentType.cpn,
        date: DateTime.now().add(const Duration(days: 14)),
        time: '10:00',
        doctor: 'Dr. Fatou Sall',
        location: 'Centre de Santé Almadies',
        status: AppointmentStatus.pending,
      ),
      Appointment(
        id: '4',
        title: 'Test de glycémie',
        type: AppointmentType.test,
        date: DateTime.now().add(const Duration(days: 21)),
        time: '08:00',
        doctor: 'Laboratoire',
        location: 'Centre de Santé Almadies',
        status: AppointmentStatus.pending,
      ),
    ];
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<Appointment> get filteredAppointments {
    if (selectedFilter.value == 'Tous') {
      return appointments;
    }
    return appointments
        .where((apt) => apt.type.name == selectedFilter.value.toLowerCase())
        .toList();
  }

  List<Appointment> getAppointmentsForDate(DateTime date) {
    return appointments.where((apt) {
      return apt.date.year == date.year && apt.date.month == date.month && apt.date.day == date.day;
    }).toList();
  }

  void cancelAppointment(String id) {
    final index = appointments.indexWhere((apt) => apt.id == id);
    if (index != -1) {
      appointments[index] = appointments[index].copyWith(status: AppointmentStatus.cancelled);
      appointments.refresh();
      Get.snackbar('Annulé', 'Rendez-vous annulé avec succès');
    }
  }

  void confirmAppointment(String id) {
    final index = appointments.indexWhere((apt) => apt.id == id);
    if (index != -1) {
      appointments[index] = appointments[index].copyWith(status: AppointmentStatus.confirmed);
      appointments.refresh();
      Get.snackbar('Confirmé', 'Rendez-vous confirmé');
    }
  }
}

// Models
enum AppointmentType { cpn, ppn, echography, test, vaccination }

enum AppointmentStatus { pending, confirmed, cancelled, completed }

class Appointment {
  final String id;
  final String title;
  final AppointmentType type;
  final DateTime date;
  final String time;
  final String doctor;
  final String location;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.time,
    required this.doctor,
    required this.location,
    required this.status,
  });

  Appointment copyWith({
    String? id,
    String? title,
    AppointmentType? type,
    DateTime? date,
    String? time,
    String? doctor,
    String? location,
    AppointmentStatus? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      time: time ?? this.time,
      doctor: doctor ?? this.doctor,
      location: location ?? this.location,
      status: status ?? this.status,
    );
  }
}
