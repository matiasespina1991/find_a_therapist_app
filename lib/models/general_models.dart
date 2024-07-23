import 'package:country_picker/country_picker.dart';

class LottieAnimationBackground {
  final String animationPath;
  final int width;
  final double x;
  final double y;
  final double blur;
  final bool active;
  final double opacity;

  const LottieAnimationBackground({
    required this.animationPath,
    required this.width,
    required this.x,
    required this.y,
    required this.blur,
    required this.active,
    required this.opacity,
  });
}

class LocationFilters {
  bool enabled;
  String country;
  String? state;
  String? city;

  LocationFilters({
    required this.enabled,
    required this.country,
    this.state,
    this.city,
  });

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'country': country,
      'state': state,
      'city': city,
    };
  }

  factory LocationFilters.fromMap(Map<String, dynamic> map) {
    return LocationFilters(
      enabled: map['enabled'] ?? false,
      country: map['country'] ?? '',
      state: map['state'],
      city: map['city'],
    );
  }

  @override
  String toString() =>
      'LocationFilters(enabled: $enabled, country: $country, state: $state, city: $city)';
}

class UserRequestFilters {
  bool remote;
  bool presential;
  List<String> preferredLanguages = [];
  LocationFilters location;

  UserRequestFilters({
    required this.remote,
    required this.presential,
    required this.preferredLanguages,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'remote': remote,
      'presential': presential,
      'preferredLanguages': preferredLanguages,
      'location': location.toMap(),
    };
  }

  factory UserRequestFilters.fromMap(Map<String, dynamic> map) {
    return UserRequestFilters(
      remote: map['remote'] ?? false,
      presential: map['presential'] ?? false,
      preferredLanguages: List<String>.from(map['preferredLanguages'] ?? []),
      location: LocationFilters.fromMap(map['location'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'UserRequestFilters(remote: $remote, presential: $presential, preferredLanguages: $preferredLanguages, location: $location)';
  }
}
