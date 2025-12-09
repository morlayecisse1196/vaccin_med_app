import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/health_center.dart';
import 'map_controller.dart' as map_ctrl;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final map_ctrl.MapController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<map_ctrl.MapController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.isLoading.value
            ? _buildLoadingState()
            : Stack(
                children: [
                  // Google Map
                  _buildMap(),

                  // Search Bar
                  _buildSearchBar(),

                  // My Location Button
                  _buildMyLocationButton(),

                  // Detail Sheet
                  if (controller.selectedCenter.value != null)
                    _buildDetailSheet(controller.selectedCenter.value!),
                ],
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppColors.offWhite,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.secondary),
            const SizedBox(height: 16),
            Text(
              'Chargement de la carte...',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Obx(
      () => flutter_map.FlutterMap(
        mapController: controller.mapController,
        options: flutter_map.MapOptions(
          initialCenter: controller.currentPosition.value ?? map_ctrl.MapController.defaultPosition,
          initialZoom: 14,
          minZoom: 10,
          maxZoom: 18,
        ),
        children: [
          // OpenStreetMap Tile Layer
          flutter_map.TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.vaccin_app',
          ),

          // Markers Layer
          flutter_map.MarkerLayer(markers: controller.markers),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primary.withAlpha(230)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Centres de Santé',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: controller.searchHealthCenters,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un centre...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightGray),
                      prefixIcon: const Icon(Icons.search, color: AppColors.secondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: controller.refreshLocation,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.my_location, color: AppColors.secondary, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSheet(HealthCenter center) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 5) {
            controller.closeDetailSheet();
          }
        },
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -4))],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header with close button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              center.name,
                              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: center.isOpen
                                        ? AppColors.success.withAlpha(26)
                                        : AppColors.danger.withAlpha(26),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    center.isOpen ? 'Ouvert' : 'Fermé',
                                    style: AppTextStyles.caption.copyWith(
                                      color: center.isOpen ? AppColors.success : AppColors.danger,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.star, color: AppColors.accent, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${center.rating} (${center.reviewCount})',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: controller.closeDetailSheet,
                        icon: const Icon(Icons.close),
                        color: AppColors.textGray,
                      ),
                    ],
                  ),
                ),

                const Divider(height: 24),

                // Distance
                _buildInfoTile(
                  icon: Icons.location_on,
                  title: 'Distance',
                  subtitle: '${center.distance.toStringAsFixed(1)} km',
                  color: AppColors.secondary,
                ),

                // Address
                _buildInfoTile(
                  icon: Icons.place,
                  title: 'Adresse',
                  subtitle: center.address,
                  color: AppColors.info,
                ),

                // Phone
                _buildInfoTile(
                  icon: Icons.phone,
                  title: 'Téléphone',
                  subtitle: center.phone,
                  color: AppColors.success,
                  onTap: () => controller.callCenter(center),
                ),

                // Email
                if (center.email.isNotEmpty)
                  _buildInfoTile(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: center.email,
                    color: AppColors.warning,
                  ),

                const Divider(height: 24),

                // Services
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.medical_services, color: AppColors.accent, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Services disponibles',
                            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: center.services.map((service) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withAlpha(26),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.secondary.withAlpha(77)),
                            ),
                            child: Text(
                              service,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 24),

                // Opening Hours
                _buildOpeningHours(center),

                const SizedBox(height: 20),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => controller.openInMaps(center),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.directions),
                          label: const Text('Itinéraire'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => controller.callCenter(center),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.secondary,
                            side: const BorderSide(color: AppColors.secondary, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.phone),
                          label: const Text('Appeler'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.lightGray)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (onTap != null) const Icon(Icons.chevron_right, color: AppColors.lightGray),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHours(HealthCenter center) {
    final weekdays = [
      {'key': 'lundi', 'label': 'Lundi'},
      {'key': 'mardi', 'label': 'Mardi'},
      {'key': 'mercredi', 'label': 'Mercredi'},
      {'key': 'jeudi', 'label': 'Jeudi'},
      {'key': 'vendredi', 'label': 'Vendredi'},
      {'key': 'samedi', 'label': 'Samedi'},
      {'key': 'dimanche', 'label': 'Dimanche'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Horaires d\'ouverture',
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...weekdays.map((day) {
            final schedule = center.openingHours.schedule[day['key']];
            final isToday = DateTime.now().weekday - 1 == weekdays.indexOf(day);

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isToday ? AppColors.secondary.withAlpha(13) : AppColors.offWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day['label']!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                      color: isToday ? AppColors.secondary : AppColors.textGray,
                    ),
                  ),
                  Text(
                    schedule?.isClosed == true
                        ? 'Fermé'
                        : '${schedule?.openTime} - ${schedule?.closeTime}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: schedule?.isClosed == true ? AppColors.danger : AppColors.textGray,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
