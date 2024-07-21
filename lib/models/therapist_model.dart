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
  Timestamp lastOnline;

  TherapistModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.aspects,
    required this.subscription,
    required this.score,
    required this.therapistInfo,
    required this.isOnline,
    required this.lastOnline,
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
      lastOnline: json['lastOnline'] as Timestamp,
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
      'lastOnline': lastOnline,
    };
  }

  TherapistModel copyWith({
    Aspects? aspects,
    Subscription? subscription,
    Score? score,
    TherapistInfo? therapistInfo,
    bool? isOnline,
    Timestamp? lastOnline,
  }) {
    return TherapistModel(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      aspects: aspects ?? this.aspects,
      subscription: subscription ?? this.subscription,
      score: score ?? this.score,
      therapistInfo: therapistInfo ?? this.therapistInfo,
      isOnline: isOnline ?? this.isOnline,
      lastOnline: lastOnline ?? this.lastOnline,
    );
  }
}

class Term {
  String term;
  bool public;

  Term({
    required this.term,
    required this.public,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      term: json['term'],
      public: json['public'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'term': term,
      'public': public,
    };
  }
}

class Aspects {
  List<Term> positive;
  List<Term> negative;

  Aspects({
    required this.positive,
    required this.negative,
  });

  factory Aspects.fromJson(Map<String, dynamic> json) {
    return Aspects(
      positive: (json['positive'] as List)
          .map((item) => Term.fromJson(item))
          .toList(),
      negative: (json['negative'] as List)
          .map((item) => Term.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'positive': positive.map((term) => term.toJson()).toList(),
      'negative': negative.map((term) => term.toJson()).toList(),
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
  String birthday;
  String firstName;
  String intro;
  String lastName;
  Location location;
  MeetingType meetingType;
  Phone phone;
  String privateNotes;
  ProfilePictureUrl profilePictureUrl;
  String publicPresentation;
  List<String> specializations;
  List<String> spokenLanguages;
  List<ProfessionalCertificate> professionalCertificates;
  String title;
  bool userInfoIsVerified;

  TherapistInfo({
    required this.birthday,
    required this.firstName,
    required this.intro,
    required this.lastName,
    required this.location,
    required this.meetingType,
    required this.phone,
    required this.privateNotes,
    required this.profilePictureUrl,
    required this.publicPresentation,
    required this.specializations,
    required this.spokenLanguages,
    required this.professionalCertificates,
    required this.title,
    required this.userInfoIsVerified,
  });

  factory TherapistInfo.fromJson(Map<String, dynamic> json) {
    return TherapistInfo(
      birthday: json['birthday'],
      firstName: json['firstName'],
      intro: json['intro'],
      lastName: json['lastName'],
      location: Location.fromJson(json['location']),
      meetingType: MeetingType.fromJson(json['meetingType']),
      phone: Phone.fromJson(json['phone']),
      privateNotes: json['privateNotes'],
      profilePictureUrl: ProfilePictureUrl.fromJson(json['profilePictureUrl']),
      publicPresentation: json['publicPresentation'],
      specializations: List<String>.from(json['specializations']),
      spokenLanguages: List<String>.from(json['spokenLanguages']),
      professionalCertificates: (json['professionalCertificates'] as List)
          .map((i) => ProfessionalCertificate.fromJson(i))
          .toList(),
      title: json['title'],
      userInfoIsVerified: json['userInfoIsVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'birthday': birthday,
      'firstName': firstName,
      'intro': intro,
      'lastName': lastName,
      'location': location.toJson(),
      'meetingType': meetingType.toJson(),
      'phone': phone.toJson(),
      'privateNotes': privateNotes,
      'profilePictureUrl': profilePictureUrl.toJson(),
      'publicPresentation': publicPresentation,
      'specializations': specializations,
      'spokenLanguages': spokenLanguages,
      'professionalCertificates':
          professionalCertificates.map((i) => i.toJson()).toList(),
      'title': title,
      'userInfoIsVerified': userInfoIsVerified,
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

class MeetingType {
  bool presential;
  bool remote;

  MeetingType({
    required this.presential,
    required this.remote,
  });

  factory MeetingType.fromJson(Map<String, dynamic> json) {
    return MeetingType(
      presential: json['presential'],
      remote: json['remote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'presential': presential,
      'remote': remote,
    };
  }
}

class Phone {
  String areaCode;
  String number;

  Phone({
    required this.areaCode,
    required this.number,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      areaCode: json['areaCode'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'areaCode': areaCode,
      'number': number,
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
