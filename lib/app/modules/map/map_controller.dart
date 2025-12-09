import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/health_center.dart';

class MapController extends GetxController {
  final mapController = flutter_map.MapController();
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  final RxList<HealthCenter> healthCenters = <HealthCenter>[].obs;
  final RxList<flutter_map.Marker> markers = <flutter_map.Marker>[].obs;
  final Rx<HealthCenter?> selectedCenter = Rx<HealthCenter?>(null);
  final RxBool isLoading = true.obs;
  final RxBool locationPermissionGranted = false.obs;
  final RxString searchQuery = ''.obs;
  final RxList<HealthCenter> filteredCenters = <HealthCenter>[].obs;

  // Camera position par défaut (Dakar, Sénégal)
  static const LatLng defaultPosition = LatLng(14.6928, -17.4467);

  @override
  void onInit() {
    super.onInit();
    _initializeMap();
  }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }

  Future<void> _initializeMap() async {
    print('🗺️ Début initialisation carte...');
    isLoading.value = true;

    await _checkLocationPermission();
    print('✅ Permission vérifiée');

    await _getCurrentLocation();
    print('✅ Position obtenue: ${currentPosition.value}');

    await _loadHealthCenters();
    print('✅ Centres chargés: ${healthCenters.length}');

    _updateMarkers();
    print('✅ Markers créés: ${markers.length}');

    isLoading.value = false;
    print('🎉 Carte prête à afficher!');
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();
    locationPermissionGranted.value = status.isGranted;

    if (!status.isGranted) {
      Get.snackbar(
        'Permission requise',
        'L\'accès à la localisation est nécessaire pour afficher les centres à proximité',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!locationPermissionGranted.value) {
      print('⚠️ Permission localisation refusée, utilisation position par défaut');
      currentPosition.value = defaultPosition;
      return;
    }

    try {
      print('📍 Récupération position GPS...');

      // Timeout plus court pour éviter un blocage
      final position =
          await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low, // Changé de high à low
              distanceFilter: 10,
            ),
          ).timeout(
            const Duration(seconds: 5), // Réduit de 10s à 5s
            onTimeout: () {
              print('⏱️ Timeout GPS - Utilisation position par défaut');
              throw Exception('GPS timeout');
            },
          );

      currentPosition.value = LatLng(position.latitude, position.longitude);
      print('✅ Position GPS obtenue: ${position.latitude}, ${position.longitude}');
      print('✅ Position obtenue: ${currentPosition.value}');

      // Animer la caméra vers la position actuelle
      mapController.move(currentPosition.value!, 14);
    } catch (e) {
      print('❌ Erreur GPS: $e - Utilisation position par défaut (Dakar)');
      currentPosition.value = defaultPosition;

      // Notification discrète
      Get.snackbar(
        'Position par défaut',
        'Centré sur Dakar. Activez le GPS pour voir votre position.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _loadHealthCenters() async {
    try {
      print('🏥 Chargement des centres de santé...');

      // TODO: Remplacer par l'appel API backend
      // GET /api/health-centers?lat={lat}&lng={lng}&radius={radius}

      // Simuler un délai réseau (réduit)
      await Future.delayed(const Duration(milliseconds: 500));

      // Données simulées (à remplacer par l'API)
      healthCenters.value = _getSampleHealthCenters();
      filteredCenters.value = healthCenters;

      print('✅ ${healthCenters.length} centres chargés');
    } catch (e) {
      print('❌ Erreur chargement centres: $e');
      healthCenters.value = [];
      filteredCenters.value = [];
    }
  }

  List<HealthCenter> _getSampleHealthCenters() {
    return [
      HealthCenter(
        id: '1',
        name: 'Centre de Santé Almadies',
        address: 'Route des Almadies, Dakar',
        latitude: 14.7392,
        longitude: -17.4931,
        phone: '+221 33 869 05 00',
        email: 'contact@almadies-health.sn',
        services: ['CPN', 'Vaccination', 'Échographie', 'Consultation'],
        openingHours: OpeningHours(
          schedule: {
            'lundi': DaySchedule(openTime: '08:00', closeTime: '18:00'),
            'mardi': DaySchedule(openTime: '08:00', closeTime: '18:00'),
            'mercredi': DaySchedule(openTime: '08:00', closeTime: '18:00'),
            'jeudi': DaySchedule(openTime: '08:00', closeTime: '18:00'),
            'vendredi': DaySchedule(openTime: '08:00', closeTime: '18:00'),
            'samedi': DaySchedule(openTime: '09:00', closeTime: '13:00'),
            'dimanche': DaySchedule(openTime: '', closeTime: '', isClosed: true),
          },
        ),
        isOpen: true,
        distance: 2.5,
        rating: 4.5,
        reviewCount: 128,
      ),
      HealthCenter(
        id: '2',
        name: 'Hôpital Principal de Dakar',
        address: 'Avenue Nelson Mandela, Dakar',
        latitude: 14.6937,
        longitude: -17.4472,
        phone: '+221 33 839 50 50',
        email: 'contact@hopital-dakar.sn',
        services: ['CPN', 'PPN', 'Vaccination', 'Échographie', 'Urgences', 'Consultation'],
        openingHours: OpeningHours(
          schedule: {
            'lundi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'mardi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'mercredi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'jeudi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'vendredi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'samedi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'dimanche': DaySchedule(openTime: '00:00', closeTime: '23:59'),
          },
        ),
        isOpen: true,
        distance: 0.8,
        rating: 4.2,
        reviewCount: 342,
      ),
      HealthCenter(
        id: '3',
        name: 'Clinique Mère-Enfant Ouakam',
        address: 'Quartier Ouakam, Dakar',
        latitude: 14.7167,
        longitude: -17.4833,
        phone: '+221 33 820 15 20',
        email: 'info@clinique-ouakam.sn',
        services: ['CPN', 'PPN', 'Vaccination', 'Pédiatrie'],
        openingHours: OpeningHours(
          schedule: {
            'lundi': DaySchedule(openTime: '07:30', closeTime: '19:00'),
            'mardi': DaySchedule(openTime: '07:30', closeTime: '19:00'),
            'mercredi': DaySchedule(openTime: '07:30', closeTime: '19:00'),
            'jeudi': DaySchedule(openTime: '07:30', closeTime: '19:00'),
            'vendredi': DaySchedule(openTime: '07:30', closeTime: '19:00'),
            'samedi': DaySchedule(openTime: '08:00', closeTime: '14:00'),
            'dimanche': DaySchedule(openTime: '', closeTime: '', isClosed: true),
          },
        ),
        isOpen: true,
        distance: 3.2,
        rating: 4.7,
        reviewCount: 95,
      ),
      HealthCenter(
        id: '4',
        name: 'Centre de Santé Fann',
        address: 'Quartier Fann, Dakar',
        latitude: 14.6850,
        longitude: -17.4550,
        phone: '+221 33 825 30 40',
        email: 'fann@sante.sn',
        services: ['CPN', 'Vaccination', 'Test sanguin'],
        openingHours: OpeningHours(
          schedule: {
            'lundi': DaySchedule(openTime: '08:00', closeTime: '17:00'),
            'mardi': DaySchedule(openTime: '08:00', closeTime: '17:00'),
            'mercredi': DaySchedule(openTime: '08:00', closeTime: '17:00'),
            'jeudi': DaySchedule(openTime: '08:00', closeTime: '17:00'),
            'vendredi': DaySchedule(openTime: '08:00', closeTime: '17:00'),
            'samedi': DaySchedule(openTime: '', closeTime: '', isClosed: true),
            'dimanche': DaySchedule(openTime: '', closeTime: '', isClosed: true),
          },
        ),
        isOpen: false,
        distance: 1.2,
        rating: 4.0,
        reviewCount: 67,
      ),
      HealthCenter(
        id: '5',
        name: 'Maternité Aristide Le Dantec',
        address: 'Avenue Pasteur, Dakar',
        latitude: 14.6755,
        longitude: -17.4375,
        phone: '+221 33 821 21 21',
        email: 'ledantec@sante.sn',
        services: ['CPN', 'PPN', 'Accouchement', 'Échographie', 'Urgences'],
        openingHours: OpeningHours(
          schedule: {
            'lundi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'mardi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'mercredi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'jeudi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'vendredi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'samedi': DaySchedule(openTime: '00:00', closeTime: '23:59'),
            'dimanche': DaySchedule(openTime: '00:00', closeTime: '23:59'),
          },
        ),
        isOpen: true,
        distance: 1.8,
        rating: 4.3,
        reviewCount: 256,
      ),
    ];
  }

  void _updateMarkers() {
    // Markers pour flutter_map
    markers.clear();

    // Marqueur position actuelle (bleu)
    if (currentPosition.value != null) {
      markers.add(
        flutter_map.Marker(
          point: currentPosition.value!,
          width: 40,
          height: 40,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 40),
        ),
      );
    }

    // Marqueurs centres de santé (vert/rouge selon statut)
    for (final center in filteredCenters) {
      markers.add(
        flutter_map.Marker(
          point: LatLng(center.latitude, center.longitude),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => selectHealthCenter(center),
            child: Icon(
              Icons.location_on,
              color: center.isOpen ? Colors.green : Colors.red,
              size: 40,
            ),
          ),
        ),
      );
    }
  }

  void selectHealthCenter(HealthCenter center) {
    selectedCenter.value = center;

    // Animer la caméra vers le centre sélectionné
    mapController.move(LatLng(center.latitude, center.longitude), 16);
  }

  void closeDetailSheet() {
    selectedCenter.value = null;
  }

  void searchHealthCenters(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredCenters.value = healthCenters;
    } else {
      filteredCenters.value = healthCenters.where((center) {
        return center.name.toLowerCase().contains(query.toLowerCase()) ||
            center.address.toLowerCase().contains(query.toLowerCase()) ||
            center.services.any((service) => service.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    }

    _updateMarkers();
  }

  Future<void> refreshLocation() async {
    isLoading.value = true;
    await _getCurrentLocation();
    await _loadHealthCenters();
    _updateMarkers();
    isLoading.value = false;
  }

  Future<void> openInMaps(HealthCenter center) async {
    // TODO: Implémenter l'ouverture dans Google Maps
    Get.snackbar(
      'Navigation',
      'Ouverture de Google Maps vers ${center.name}...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> callCenter(HealthCenter center) async {
    // TODO: Implémenter l'appel téléphonique
    Get.snackbar(
      'Appel',
      'Appel vers ${center.name}: ${center.phone}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
