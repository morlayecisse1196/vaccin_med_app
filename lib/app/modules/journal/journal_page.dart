import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'journal_controller.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late JournalController controller;
  String _selectedPeriod = 'Semaine';
  String _selectedMetric = 'Tous';

  @override
  void initState() {
    super.initState();
    controller = Get.find<JournalController>();
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
              'Journal de Santé',
              style: AppTextStyles.h2.copyWith(
                color: Colors.white,
                fontSize: isSmallScreen ? 16 : 18,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.insights, size: isSmallScreen ? 20 : 24),
                onPressed: () {
                  Get.snackbar('Info', 'Statistiques à venir');
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Stats Overview Cards
              Container(
                margin: EdgeInsets.all(isSmallScreen ? 8 : 12),
                child: Row(
                  children: [
                    _buildStatCard(
                      'Entrées',
                      '${controller.entries.length}',
                      Icons.edit_note,
                      AppColors.secondary,
                      isSmallScreen,
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    _buildStatCard(
                      'Cette semaine',
                      '12',
                      Icons.calendar_today,
                      AppColors.accent,
                      isSmallScreen,
                    ),
                  ],
                ),
              ),

              // Filter Period
              SizedBox(
                height: isSmallScreen ? 36 : 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
                  children: [
                    _buildPeriodChip('Jour', isSmallScreen),
                    _buildPeriodChip('Semaine', isSmallScreen),
                    _buildPeriodChip('Mois', isSmallScreen),
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 8 : 12),

              // Filter Metrics
              SizedBox(
                height: isSmallScreen ? 36 : 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
                  children: [
                    _buildMetricChip('Tous', isSmallScreen),
                    _buildMetricChip('Tension', isSmallScreen),
                    _buildMetricChip('Poids', isSmallScreen),
                    _buildMetricChip('Glycémie', isSmallScreen),
                    _buildMetricChip('Température', isSmallScreen),
                    _buildMetricChip('Fréquence cardiaque', isSmallScreen),
                    _buildMetricChip('Hydratation', isSmallScreen),
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 8 : 12),

              // Entries List
              Expanded(
                child: Builder(
                  builder: (context) {
                    final entries = _getFilteredEntries();

                    if (entries.isEmpty) {
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
                              'Aucune entrée',
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
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return _buildEntryCard(entry, isSmallScreen);
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isSmallScreen,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: isSmallScreen ? 20 : 24),
            ),
            SizedBox(width: isSmallScreen ? 10 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyles.h2.copyWith(
                      fontSize: isSmallScreen ? 18 : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String label, bool isSmallScreen) {
    final isSelected = _selectedPeriod == label;
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
            _selectedPeriod = label;
          });
          controller.setPeriod(label);
        },
        selectedColor: AppColors.primary,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.primary.withAlpha(128),
          ),
        ),
        showCheckmark: false,
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
      ),
    );
  }

  Widget _buildMetricChip(String label, bool isSmallScreen) {
    final isSelected = _selectedMetric == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: isSmallScreen ? 11 : 13,
            color: isSelected ? Colors.white : AppColors.secondary,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedMetric = label;
          });
          controller.setMetric(label);
        },
        selectedColor: AppColors.secondary,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.secondary : AppColors.secondary.withAlpha(128),
          ),
        ),
        showCheckmark: false,
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
      ),
    );
  }

  Widget _buildEntryCard(HealthEntry entry, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getMetricColor(entry.type).withAlpha(128), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showEntryDetails(entry, isSmallScreen);
          },
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                  decoration: BoxDecoration(
                    color: _getMetricColor(entry.type).withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getMetricIcon(entry.type),
                    color: _getMetricColor(entry.type),
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 10 : 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMetricName(entry.type),
                        style: AppTextStyles.h3.copyWith(fontSize: isSmallScreen ? 13 : 15),
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      Row(
                        children: [
                          Text(
                            '${entry.value} ${entry.unit}',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontSize: isSmallScreen ? 15 : 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(entry.status, isSmallScreen),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      Text(
                        DateFormat('dd MMM yyyy - HH:mm').format(entry.date),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: isSmallScreen ? 11 : 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Action
                Icon(Icons.chevron_right, color: Colors.grey[400], size: isSmallScreen ? 20 : 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(HealthStatus status, bool isSmallScreen) {
    String text;
    Color color;

    switch (status) {
      case HealthStatus.normal:
        text = 'Normal';
        color = AppColors.success;
        break;
      case HealthStatus.low:
        text = 'Bas';
        color = AppColors.info;
        break;
      case HealthStatus.high:
        text = 'Élevé';
        color = AppColors.warning;
        break;
      case HealthStatus.critical:
        text = 'Critique';
        color = AppColors.danger;
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

  Color _getMetricColor(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.bloodPressure:
        return AppColors.danger;
      case HealthMetricType.weight:
        return AppColors.accent;
      case HealthMetricType.glucose:
        return Colors.orange;
      case HealthMetricType.temperature:
        return Colors.red;
      case HealthMetricType.heartRate:
        return Colors.pink;
      case HealthMetricType.hydration:
        return AppColors.info;
    }
  }

  IconData _getMetricIcon(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.bloodPressure:
        return Icons.favorite;
      case HealthMetricType.weight:
        return Icons.monitor_weight;
      case HealthMetricType.glucose:
        return Icons.bloodtype;
      case HealthMetricType.temperature:
        return Icons.thermostat;
      case HealthMetricType.heartRate:
        return Icons.heart_broken;
      case HealthMetricType.hydration:
        return Icons.water_drop;
    }
  }

  String _getMetricName(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.bloodPressure:
        return 'Tension Artérielle';
      case HealthMetricType.weight:
        return 'Poids';
      case HealthMetricType.glucose:
        return 'Glycémie';
      case HealthMetricType.temperature:
        return 'Température';
      case HealthMetricType.heartRate:
        return 'Fréquence Cardiaque';
      case HealthMetricType.hydration:
        return 'Hydratation';
    }
  }

  List<HealthEntry> _getFilteredEntries() {
    List<HealthEntry> filtered = controller.entries;

    // Filter by metric
    if (_selectedMetric != 'Tous') {
      filtered = filtered.where((entry) {
        return _getMetricName(entry.type) == _selectedMetric;
      }).toList();
    }

    // Filter by period
    final now = DateTime.now();
    switch (_selectedPeriod) {
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

  void _showEntryDetails(HealthEntry entry, bool isSmallScreen) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                    decoration: BoxDecoration(
                      color: _getMetricColor(entry.type).withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getMetricIcon(entry.type),
                      color: _getMetricColor(entry.type),
                      size: isSmallScreen ? 24 : 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getMetricName(entry.type),
                          style: AppTextStyles.h3.copyWith(fontSize: isSmallScreen ? 15 : 17),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${entry.value} ${entry.unit}',
                          style: AppTextStyles.h2.copyWith(
                            fontSize: isSmallScreen ? 20 : 24,
                            color: AppColors.secondary,
                          ),
                        ),
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem(
                      'Date et heure',
                      DateFormat('EEEE dd MMMM yyyy à HH:mm').format(entry.date),
                      isSmallScreen,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildDetailItem('Statut', _getStatusText(entry.status), isSmallScreen),
                    if (entry.note.isNotEmpty) ...[
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      _buildDetailItem('Note', entry.note, isSmallScreen),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isSmallScreen) {
    return Column(
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
        Text(value, style: AppTextStyles.bodyMedium.copyWith(fontSize: isSmallScreen ? 13 : 14)),
      ],
    );
  }

  String _getStatusText(HealthStatus status) {
    switch (status) {
      case HealthStatus.normal:
        return 'Normal';
      case HealthStatus.low:
        return 'Bas';
      case HealthStatus.high:
        return 'Élevé';
      case HealthStatus.critical:
        return 'Critique';
    }
  }
}
