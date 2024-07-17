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

class UserRequestFilters {
  bool remote;
  bool presential;
  String country;

  UserRequestFilters({
    required this.remote,
    required this.presential,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'remote': remote,
      'presential': presential,
      'country': country,
    };
  }

  factory UserRequestFilters.fromMap(Map<String, dynamic> map) {
    return UserRequestFilters(
      remote: map['remote'] ?? false,
      presential: map['presential'] ?? false,
      country: map['country'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserRequestFilters(remote: $remote, presential: $presential, country: $country)';
  }
}
