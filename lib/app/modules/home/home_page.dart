import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  // Remplacez par l'URL ou le path local de votre enregistrement vocal
  final String _sampleAudioUrl = 'assets/audio/vocal.mp3';

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _UserGreeting(controller: controller),
            Text('Comment vous sentez-vous aujourd\'hui ?', style: AppTextStyles.caption),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              child: Text(
                controller.userName.value[0],
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Hero Card - Next Appointment
            _buildHeroCard(),

            const SizedBox(height: 24),

            // Carnet de Vaccination Button (bien visible)
            _buildVaccinationBookButton(),

            const SizedBox(height: 24),

            // Quick Stats
            _buildQuickStats(),

            const SizedBox(height: 24),

            // Tips Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Conseils pour vous', style: AppTextStyles.h2),
            ),
            const SizedBox(height: 16),
            _buildTipsCarousel(),

            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: _buildSOSButton(),
    );
  }

  Widget _buildHeroCard() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(77),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(
                    () => Text(
                      'Semaine ${controller.pregnancyWeek.value}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.calendar_today, color: AppColors.white, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Prochaine consultation',
              style: AppTextStyles.body.copyWith(color: AppColors.white.withAlpha(230)),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                'Dans ${controller.nextAppointment.value}',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                controller.nextAppointmentDate.value,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white.withAlpha(204)),
              ),
            ),
            const SizedBox(height: 16),
            // Petit player audio : play / pause pour écouter un vocal lié à la prise de vaccination
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Centre de Santé Almadies',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.white.withAlpha(204)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                // Bouton circulaire play / pause
                GestureDetector(
                  onTap: () async {
                    if (!_isPlaying) {
                      // play from URL (ou remplacez par UrlSource(filePath) pour un fichier local)
                      await _audioPlayer.play(UrlSource(_sampleAudioUrl));
                      setState(() {
                        _isPlaying = true;
                      });
                    } else {
                      await _audioPlayer.pause();
                      setState(() {
                        _isPlaying = false;
                      });
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(220),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.stop : Icons.play_arrow,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isPlaying ? 'Lecture en cours...' : 'Écouter le vocal de vaccination',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.white.withAlpha(220)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 100),
      child: SizedBox(
        height: 110,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildStatCard(
              icon: Icons.water_drop_outlined,
              title: 'Hydratation',
              value: '6/8 verres',
              color: AppColors.info,
            ),
            _buildStatCard(
              icon: Icons.favorite_outline,
              title: 'Tension',
              value: '120/80',
              color: AppColors.success,
            ),
            _buildStatCard(
              icon: Icons.monitor_weight_outlined,
              title: 'Poids',
              value: '68.5 kg',
              color: AppColors.warning,
            ),
            _buildVaccinationBookCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(51), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(color: AppColors.textGray.withAlpha(179)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationBookCard() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.vaccinationBook);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primary.withAlpha(204)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(77),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.book, color: AppColors.white, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, color: AppColors.white, size: 14),
                ),
              ],
            ),
            const Spacer(),
            Text(
              'Carnet de\nVaccination',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Voir le carnet',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withAlpha(204),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Gros bouton bien visible pour accéder au carnet
  Widget _buildVaccinationBookButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.vaccinationBook);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.secondary, AppColors.secondary.withAlpha(204)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withAlpha(77),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.book, color: AppColors.white, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carnet de Vaccination',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Consultez les vaccins de vos enfants',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipsCarousel() {
    final tips = [
      {
        'title': 'Nutrition',
        'description': 'Mangez équilibré et évitez les repas trop sucrés',
        'icon': '🥗',
      },
      {
        'title': 'Diabète Gestationnel',
        'description': 'Surveillez votre glycémie régulièrement',
        'icon': '🩺',
      },
      {
        'title': 'Allaitement',
        'description': 'Préparez-vous à l\'allaitement dès maintenant',
        'icon': '🍼',
      },
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return FadeInRight(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: 200 + (index * 100)),
            child: Container(
              width: 280,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(tip['icon']!, style: const TextStyle(fontSize: 32)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Nouveau',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(tip['title']!, style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Text(
                    tip['description']!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textGray.withAlpha(179),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSOSButton() {
    return FadeIn(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 600),
      child: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Show SOS bottom sheet
          Get.bottomSheet(
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('SOS - Symptômes de danger', style: AppTextStyles.h2),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.bloodtype, color: AppColors.danger),
                    title: const Text('Saignements'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.flash_on, color: AppColors.warning),
                    title: const Text('Maux de tête violents'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.child_care, color: AppColors.info),
                    title: const Text('Bébé ne bouge pas'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: AppColors.danger,
        icon: const Icon(Icons.emergency, color: AppColors.white),
        label: Text('SOS', style: AppTextStyles.buttonSmall.copyWith(color: AppColors.white)),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

// Widget séparé pour le message de bienvenue avec Obx
class _UserGreeting extends StatelessWidget {
  final HomeController controller;

  const _UserGreeting({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
        'Bonjour, ${controller.userName.value.split(' ').first} 👋',
        style: AppTextStyles.h2,
      ),
    );
  }
}
