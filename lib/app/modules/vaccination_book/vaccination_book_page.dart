import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'vaccination_book_controller.dart';

class VaccinationBookPage extends StatefulWidget {
  const VaccinationBookPage({super.key});

  @override
  State<VaccinationBookPage> createState() => _VaccinationBookPageState();
}

class _VaccinationBookPageState extends State<VaccinationBookPage> {
  late VaccinationBookController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VaccinationBookController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8), // Couleur papier ancien
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Carnet de Vaccination', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.children.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            // Sélecteur d'enfants
            if (controller.children.length > 1) _buildChildSelector(),

            const SizedBox(height: 16),

            // Livre de vaccination
            Expanded(child: _buildVaccinationBook()),

            // Navigation pages
            _buildPageNavigation(),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.baby_changing_station, size: 100, color: AppColors.textGray.withAlpha(128)),
          const SizedBox(height: 24),
          Text(
            'Aucun enfant enregistré',
            style: AppTextStyles.h2.copyWith(color: AppColors.textGray),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to add child
            },
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un enfant'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildSelector() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.children.length,
        itemBuilder: (context, index) {
          final child = controller.children[index];
          final isSelected = controller.selectedChildIndex.value == index;

          return GestureDetector(
            onTap: () => controller.selectChild(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.lightGray,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(77),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isSelected ? AppColors.white : AppColors.accent,
                    child: Text(
                      child.name[0],
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textGray,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    child.name.split(' ')[0],
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? AppColors.white : AppColors.textGray,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVaccinationBook() {
    final child = controller.selectedChild;
    if (child == null) return const SizedBox();

    return Obx(() {
      final currentPage = controller.currentPage.value;

      return PageView.builder(
        controller: PageController(initialPage: currentPage),
        onPageChanged: controller.changePage,
        itemCount: controller.totalPages,
        itemBuilder: (context, pageIndex) {
          if (pageIndex == 0) {
            return _buildCoverPage(child);
          }

          // Pages de vaccinations (2 vaccinations par page)
          final vaccinationIndex = (pageIndex - 1) * 2;
          return _buildVaccinationPage(child, vaccinationIndex, pageIndex);
        },
      );
    });
  }

  Widget _buildCoverPage(Child child) {
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Effet de texture papier
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(painter: PaperTexturePainter()),
              ),
            ),

            // Contenu
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Spacer(),

                  // Titre
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'CARNET DE VACCINATION',
                      style: AppTextStyles.h2.copyWith(color: AppColors.primary, letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Photo de l'enfant
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.accent,
                    child: Text(
                      child.name[0],
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Nom de l'enfant
                  Text(
                    child.name,
                    style: AppTextStyles.h1.copyWith(fontSize: 28, color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Date de naissance
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cake, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMMM yyyy', 'fr_FR').format(child.birthDate),
                          style: AppTextStyles.body.copyWith(color: AppColors.textGray),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    child.ageDisplay,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textGray,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const Spacer(),

                  // Barre de progression
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Progression', style: AppTextStyles.bodyMedium),
                          Text(
                            '${(controller.vaccinationProgress * 100).toInt()}%',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: controller.vaccinationProgress,
                          minHeight: 12,
                          backgroundColor: AppColors.lightGray,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Statistiques
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        Icons.check_circle,
                        '${child.vaccinations.where((v) => v.status == VaccinationStatus.completed).length}',
                        'Complétés',
                        AppColors.success,
                      ),
                      _buildStatItem(
                        Icons.pending,
                        '${child.vaccinations.where((v) => v.status == VaccinationStatus.pending || v.status == VaccinationStatus.scheduled).length}',
                        'En attente',
                        AppColors.warning,
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h2.copyWith(color: color)),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
      ],
    );
  }

  Widget _buildVaccinationPage(Child child, int startIndex, int pageNumber) {
    final vaccinations = child.vaccinations;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Stack(
        children: [
          // Texture papier
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(painter: PaperTexturePainter()),
            ),
          ),

          // Contenu
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Numéro de page
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Page $pageNumber',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.medical_services, color: AppColors.primary.withAlpha(77)),
                  ],
                ),

                const SizedBox(height: 24),

                // Première vaccination
                if (startIndex < vaccinations.length)
                  _buildVaccinationCard(vaccinations[startIndex]),

                if (startIndex < vaccinations.length) const SizedBox(height: 24),

                // Deuxième vaccination
                if (startIndex + 1 < vaccinations.length)
                  _buildVaccinationCard(vaccinations[startIndex + 1]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationCard(Vaccination vaccination) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (vaccination.status) {
      case VaccinationStatus.completed:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusText = 'Complété';
        break;
      case VaccinationStatus.scheduled:
        statusColor = AppColors.info;
        statusIcon = Icons.event;
        statusText = 'Programmé';
        break;
      case VaccinationStatus.pending:
        statusColor = AppColors.warning;
        statusIcon = Icons.pending;
        statusText = 'En attente';
        break;
      case VaccinationStatus.overdue:
        statusColor = AppColors.danger;
        statusIcon = Icons.warning;
        statusText = 'En retard';
        break;
    }

    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: statusColor.withAlpha(13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vaccination.name,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vaccination.disease,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textGray,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(statusIcon, color: AppColors.white, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Dose
            _buildInfoRow(Icons.medication, vaccination.doseDisplay, AppColors.primary),

            const SizedBox(height: 8),

            // Date
            if (vaccination.date != null)
              _buildInfoRow(
                Icons.calendar_today,
                'Fait le ${DateFormat('dd/MM/yyyy').format(vaccination.date!)}',
                statusColor,
              ),

            if (vaccination.date != null) const SizedBox(height: 8),

            // Lot
            if (vaccination.lot != null)
              _buildInfoRow(Icons.qr_code, 'Lot: ${vaccination.lot}', AppColors.textGray),

            if (vaccination.lot != null) const SizedBox(height: 8),

            // Centre de santé
            if (vaccination.healthCenter != null)
              _buildInfoRow(Icons.local_hospital, vaccination.healthCenter!, AppColors.textGray),

            // Prochaine dose
            if (vaccination.nextDose != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withAlpha(77)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_available, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Prochaine dose: ${DateFormat('dd/MM/yyyy').format(vaccination.nextDose!)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Statut
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: AppTextStyles.body.copyWith(color: color)),
        ),
      ],
    );
  }

  Widget _buildPageNavigation() {
    return Obx(() {
      if (controller.totalPages <= 1) return const SizedBox();

      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: controller.currentPage.value > 0
                  ? () => controller.changePage(controller.currentPage.value - 1)
                  : null,
              color: AppColors.primary,
            ),
            const SizedBox(width: 16),
            ...List.generate(
              controller.totalPages,
              (index) => GestureDetector(
                onTap: () => controller.changePage(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: controller.currentPage.value == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.currentPage.value == index
                        ? AppColors.primary
                        : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: controller.currentPage.value < controller.totalPages - 1
                  ? () => controller.changePage(controller.currentPage.value + 1)
                  : null,
              color: AppColors.primary,
            ),
          ],
        ),
      );
    });
  }
}

// Custom Painter pour l'effet de texture papier
class PaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFAF8F3).withAlpha(128)
      ..style = PaintingStyle.fill;

    // Lignes horizontales subtiles
    for (var i = 0; i < size.height; i += 30) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint..strokeWidth = 0.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
