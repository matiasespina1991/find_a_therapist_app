import 'package:cloud_firestore/cloud_firestore.dart';

class TherapistModel {
  String id;
  Timestamp createdAt;
  Timestamp updatedAt;
  Aspects aspects;
  Subscription subscription;
  Score score;
  TherapistInfo therapistInfo;
  bool isOnline;

  TherapistModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.aspects,
    required this.subscription,
    required this.score,
    required this.therapistInfo,
    required this.isOnline,
  });

  factory TherapistModel.fromJson(Map<String, dynamic> json, String id) {
    return TherapistModel(
      id: id,
      createdAt: json['createdAt'] as Timestamp,
      updatedAt: json['updatedAt'] as Timestamp,
      aspects: Aspects.fromJson(json['aspects']),
      subscription: Subscription.fromJson(json['subscription']),
      score: Score.fromJson(json['score']),
      therapistInfo: TherapistInfo.fromJson(json['therapistInfo']),
      isOnline: json['isOnline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'aspects': aspects.toJson(),
      'subscription': subscription.toJson(),
      'score': score.toJson(),
      'therapistInfo': therapistInfo.toJson(),
      'isOnline': isOnline,
    };
  }
}

class Aspects {
  List<String> positive;
  List<String> negative;

  Aspects({
    required this.positive,
    required this.negative,
  });

  factory Aspects.fromJson(Map<String, dynamic> json) {
    return Aspects(
      positive: List<String>.from(json['positive']),
      negative: List<String>.from(json['negative']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'positive': positive,
      'negative': negative,
    };
  }
}

class Subscription {
  Timestamp endsAt;
  String plan;
  Timestamp startedAt;
  bool autoRenewal;

  Subscription({
    required this.endsAt,
    required this.plan,
    required this.startedAt,
    required this.autoRenewal,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      endsAt: json['endsAt'] as Timestamp,
      plan: json['plan'],
      startedAt: json['startedAt'] as Timestamp,
      autoRenewal: json['autoRenewal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endsAt': endsAt,
      'plan': plan,
      'startedAt': startedAt,
      'autoRenewal': autoRenewal,
    };
  }
}

class Score {
  double rating;
  int amountRatings;

  Score({
    required this.rating,
    required this.amountRatings,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      rating: (json['rating'] as num).toDouble(),
      amountRatings: json['amountRatings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'amountRatings': amountRatings,
    };
  }
}

class TherapistInfo {
  String bio;
  String? publicPresentation;
  String? privateNotes;
  Location location;
  String firstName;
  bool userInfoIsVerified;
  String lastName;
  List<String> specializations;
  List<String> spokenLanguages;
  List<ProfessionalCertificate> professionalCertificates;
  ProfilePictureUrl profilePictureUrl;

  TherapistInfo({
    required this.bio,
    required this.publicPresentation,
    required this.privateNotes,
    required this.location,
    required this.firstName,
    required this.userInfoIsVerified,
    required this.lastName,
    required this.specializations,
    required this.spokenLanguages,
    required this.professionalCertificates,
    required this.profilePictureUrl,
  });

  factory TherapistInfo.fromJson(Map<String, dynamic> json) {
    return TherapistInfo(
      bio: json['bio'],
      publicPresentation: json['publicPresentation'],
      privateNotes: json['privateNotes'],
      location: Location.fromJson(json['location']),
      firstName: json['firstName'],
      userInfoIsVerified: json['userInfoIsVerified'],
      lastName: json['lastName'],
      specializations: List<String>.from(json['specializations']),
      spokenLanguages: List<String>.from(json['spokenLanguages']),
      professionalCertificates: (json['professionalCertificates'] as List)
          .map((i) => ProfessionalCertificate.fromJson(i))
          .toList(),
      profilePictureUrl: ProfilePictureUrl.fromJson(json['profilePictureUrl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'publicPresentation': publicPresentation,
      'privateNotes': privateNotes,
      'location': location.toJson(),
      'firstName': firstName,
      'userInfoIsVerified': userInfoIsVerified,
      'lastName': lastName,
      'specializations': specializations,
      'spokenLanguages': spokenLanguages,
      'professionalCertificates':
          professionalCertificates.map((i) => i.toJson()).toList(),
      'profilePictureUrl': profilePictureUrl.toJson(),
    };
  }
}

class Location {
  String address;
  String city;
  String country;
  GeoPoint geolocation;
  String stateProvince;
  String zip;

  Location({
    required this.address,
    required this.city,
    required this.country,
    required this.geolocation,
    required this.stateProvince,
    required this.zip,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'],
      city: json['city'],
      country: json['country'],
      geolocation: json['geolocation'] as GeoPoint,
      stateProvince: json['stateProvince'],
      zip: json['zip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'country': country,
      'geolocation': geolocation,
      'stateProvince': stateProvince,
      'zip': zip,
    };
  }
}

class ProfessionalCertificate {
  String institution;
  String photoUrl;
  String title;
  String type;
  bool verified;
  int yearObtained;

  ProfessionalCertificate({
    required this.institution,
    required this.photoUrl,
    required this.title,
    required this.type,
    required this.verified,
    required this.yearObtained,
  });

  factory ProfessionalCertificate.fromJson(Map<String, dynamic> json) {
    return ProfessionalCertificate(
      institution: json['institution'],
      photoUrl: json['photoUrl'],
      title: json['title'],
      type: json['type'],
      verified: json['verified'],
      yearObtained: json['yearObtained'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'photoUrl': photoUrl,
      'title': title,
      'type': type,
      'verified': verified,
      'yearObtained': yearObtained,
    };
  }
}

class ProfilePictureUrl {
  String large;
  String small;
  String thumb;

  ProfilePictureUrl({
    required this.large,
    required this.small,
    required this.thumb,
  });

  factory ProfilePictureUrl.fromJson(Map<String, dynamic> json) {
    return ProfilePictureUrl(
      large: json['large'],
      small: json['small'],
      thumb: json['thumb'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'large': large,
      'small': small,
      'thumb': thumb,
    };
  }
}
