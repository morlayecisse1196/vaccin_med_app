class HealthCenter {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String email;
  final List<String> services;
  final OpeningHours openingHours;
  final bool isOpen;
  final double distance; // Distance en km depuis la position actuelle
  final double rating;
  final int reviewCount;
  final String imageUrl;

  HealthCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.email,
    required this.services,
    required this.openingHours,
    required this.isOpen,
    required this.distance,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.imageUrl = '',
  });

  factory HealthCenter.fromJson(Map<String, dynamic> json) {
    return HealthCenter(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      services: List<String>.from(json['services'] ?? []),
      openingHours: OpeningHours.fromJson(json['openingHours'] ?? {}),
      isOpen: json['isOpen'] ?? false,
      distance: (json['distance'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'services': services,
      'openingHours': openingHours.toJson(),
      'isOpen': isOpen,
      'distance': distance,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
    };
  }
}

class OpeningHours {
  final Map<String, DaySchedule> schedule;

  OpeningHours({required this.schedule});

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    final Map<String, DaySchedule> schedule = {};
    json.forEach((key, value) {
      schedule[key] = DaySchedule.fromJson(value);
    });
    return OpeningHours(schedule: schedule);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    schedule.forEach((key, value) {
      json[key] = value.toJson();
    });
    return json;
  }

  String getTodaySchedule() {
    final now = DateTime.now();
    final weekdays = ['lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'];
    final today = weekdays[now.weekday - 1];

    if (schedule.containsKey(today)) {
      final daySchedule = schedule[today]!;
      if (daySchedule.isClosed) {
        return 'Fermé';
      }
      return '${daySchedule.openTime} - ${daySchedule.closeTime}';
    }
    return 'Horaires non disponibles';
  }
}

class DaySchedule {
  final String openTime;
  final String closeTime;
  final bool isClosed;

  DaySchedule({required this.openTime, required this.closeTime, this.isClosed = false});

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      openTime: json['openTime'] ?? '',
      closeTime: json['closeTime'] ?? '',
      isClosed: json['isClosed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'openTime': openTime, 'closeTime': closeTime, 'isClosed': isClosed};
  }
}
