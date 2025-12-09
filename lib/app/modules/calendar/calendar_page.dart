import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'calendar_controller.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarController controller;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _selectedFilter = 'Tous';

  @override
  void initState() {
    super.initState();
    controller = Get.find<CalendarController>();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxHeight < 650;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: Text(
              'Mes Rendez-vous',
              style: AppTextStyles.h2.copyWith(
                color: Colors.white,
                fontSize: isSmallScreen ? 16 : 18,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, size: isSmallScreen ? 20 : 24),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              // Calendar Card
              Container(
                margin: EdgeInsets.all(isSmallScreen ? 8 : 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      controller.selectDate(selectedDay);
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: AppColors.secondary.withAlpha(128),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: AppTextStyles.h3.copyWith(fontSize: isSmallScreen ? 14 : 16),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: AppColors.primary,
                        size: isSmallScreen ? 20 : 24,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: AppColors.primary,
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: AppTextStyles.bodySmall.copyWith(
                        fontSize: isSmallScreen ? 11 : 12,
                      ),
                      weekendStyle: AppTextStyles.bodySmall.copyWith(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: AppColors.danger,
                      ),
                    ),
                    eventLoader: (day) {
                      return controller.getAppointmentsForDate(day);
                    },
                  ),
                ),
              ),

              // Filter Chips
              SizedBox(
                height: isSmallScreen ? 36 : 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
                  children: [
                    _buildFilterChip('Tous', isSmallScreen),
                    _buildFilterChip('CPN', isSmallScreen),
                    _buildFilterChip('PPN', isSmallScreen),
                    _buildFilterChip('Échographie', isSmallScreen),
                    _buildFilterChip('Test', isSmallScreen),
                    _buildFilterChip('Vaccination', isSmallScreen),
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 8 : 12),

              // Appointments List
              Expanded(
                child: Builder(
                  builder: (context) {
                    final appointments = _selectedFilter == 'Tous'
                        ? controller.appointments
                        : controller.appointments
                              .where((apt) => _getFilterType(apt.type) == _selectedFilter)
                              .toList();

                    if (appointments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/empty.json',
                              width: isSmallScreen ? 120 : 160,
                              height: isSmallScreen ? 120 : 160,
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            Text(
                              'Aucun rendez-vous',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return _buildAppointmentCard(appointment, isSmallScreen);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSmallScreen) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: isSmallScreen ? 11 : 13,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
          controller.setFilter(label);
        },
        selectedColor: AppColors.secondary,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.secondary : AppColors.primary.withAlpha(128),
          ),
        ),
        showCheckmark: false,
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getTypeColor(appointment.type).withAlpha(128), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showAppointmentDetails(appointment, isSmallScreen);
          },
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
            child: Row(
              children: [
                // Type Indicator
                Container(
                  width: isSmallScreen ? 4 : 5,
                  height: isSmallScreen ? 50 : 60,
                  decoration: BoxDecoration(
                    color: _getTypeColor(appointment.type),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 10 : 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              appointment.title,
                              style: AppTextStyles.h3.copyWith(fontSize: isSmallScreen ? 13 : 15),
                            ),
                          ),
                          _buildStatusBadge(appointment.status, isSmallScreen),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: isSmallScreen ? 12 : 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd MMM yyyy').format(appointment.date),
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: isSmallScreen ? 11 : 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            size: isSmallScreen ? 12 : 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            appointment.time,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: isSmallScreen ? 11 : 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: isSmallScreen ? 12 : 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              appointment.location,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: isSmallScreen ? 11 : 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Button
                Icon(Icons.chevron_right, color: Colors.grey[400], size: isSmallScreen ? 20 : 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AppointmentStatus status, bool isSmallScreen) {
    String text;
    Color color;

    switch (status) {
      case AppointmentStatus.confirmed:
        text = 'Confirmé';
        color = AppColors.success;
        break;
      case AppointmentStatus.pending:
        text = 'En attente';
        color = AppColors.warning;
        break;
      case AppointmentStatus.cancelled:
        text = 'Annulé';
        color = AppColors.danger;
        break;
      case AppointmentStatus.completed:
        text = 'Terminé';
        color = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 6 : 8,
        vertical: isSmallScreen ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(128)),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: isSmallScreen ? 9 : 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getTypeColor(AppointmentType type) {
    switch (type) {
      case AppointmentType.cpn:
        return AppColors.secondary;
      case AppointmentType.ppn:
        return AppColors.accent;
      case AppointmentType.echography:
        return Colors.purple;
      case AppointmentType.test:
        return Colors.orange;
      case AppointmentType.vaccination:
        return Colors.blue;
    }
  }

  String _getFilterType(AppointmentType type) {
    switch (type) {
      case AppointmentType.cpn:
        return 'CPN';
      case AppointmentType.ppn:
        return 'PPN';
      case AppointmentType.echography:
        return 'Échographie';
      case AppointmentType.test:
        return 'Test';
      case AppointmentType.vaccination:
        return 'Vaccination';
    }
  }

  void _showAppointmentDetails(Appointment appointment, bool isSmallScreen) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                    decoration: BoxDecoration(
                      color: _getTypeColor(appointment.type).withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.event,
                      color: _getTypeColor(appointment.type),
                      size: isSmallScreen ? 24 : 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.title,
                          style: AppTextStyles.h3.copyWith(fontSize: isSmallScreen ? 15 : 17),
                        ),
                        const SizedBox(height: 4),
                        _buildStatusBadge(appointment.status, isSmallScreen),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Details
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                child: Column(
                  children: [
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Date',
                      DateFormat('EEEE dd MMMM yyyy').format(appointment.date),
                      isSmallScreen,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildDetailRow(Icons.access_time, 'Heure', appointment.time, isSmallScreen),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildDetailRow(
                      Icons.person_outline,
                      'Médecin',
                      appointment.doctor,
                      isSmallScreen,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildDetailRow(
                      Icons.location_on_outlined,
                      'Lieu',
                      appointment.location,
                      isSmallScreen,
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  if (appointment.status == AppointmentStatus.pending ||
                      appointment.status == AppointmentStatus.confirmed) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showRescheduleDialog(appointment, isSmallScreen);
                        },
                        icon: Icon(Icons.schedule, size: isSmallScreen ? 18 : 20),
                        label: Text(
                          'Demander un report',
                          style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: isSmallScreen ? 18 : 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: isSmallScreen ? 13 : 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(Appointment appointment, bool isSmallScreen) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.schedule, color: AppColors.secondary, size: isSmallScreen ? 20 : 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Demander un report',
                style: AppTextStyles.h3.copyWith(fontSize: isSmallScreen ? 15 : 17),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rendez-vous : ${appointment.title}',
              style: AppTextStyles.bodyMedium.copyWith(fontSize: isSmallScreen ? 13 : 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Date actuelle : ${DateFormat('dd MMM yyyy').format(appointment.date)}',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: isSmallScreen ? 11 : 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Raison du report',
              style: AppTextStyles.bodyMedium.copyWith(fontSize: isSmallScreen ? 13 : 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ex: Conflit d\'emploi du temps, problème de santé...',
                hintStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.all(isSmallScreen ? 10 : 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(fontSize: isSmallScreen ? 13 : 14, color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                Get.snackbar(
                  'Erreur',
                  'Veuillez indiquer la raison du report',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.danger,
                  colorText: Colors.white,
                );
                return;
              }

              // TODO: Envoyer la demande au backend
              Navigator.pop(context);
              Get.snackbar(
                'Demande envoyée',
                'Votre demande de report a été envoyée. Vous serez notifié de la réponse.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.success,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: isSmallScreen ? 10 : 12,
              ),
            ),
            child: Text('Envoyer', style: TextStyle(fontSize: isSmallScreen ? 13 : 14)),
          ),
        ],
      ),
    );
  }
}
