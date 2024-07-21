import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
    try {
      return TherapistModel(
        id: id,
        createdAt: json['createdAt'] as Timestamp,
        updatedAt: json['updatedAt'] as Timestamp,
        aspects: Aspects.fromJson(json['aspects'] as Map<String, dynamic>),
        subscription:
            Subscription.fromJson(json['subscription'] as Map<String, dynamic>),
        score: Score.fromJson(json['score'] as Map<String, dynamic>),
        therapistInfo: TherapistInfo.fromJson(
            json['therapistInfo'] as Map<String, dynamic>),
        isOnline: json['isOnline'] as bool,
        lastOnline: json['lastOnline'] as Timestamp,
      );
    } catch (e, stack) {
      debugPrint('Error in TherapistModel.fromJson for ID $id: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
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
    try {
      return Term(
        term: json['term'] as String,
        public: json['public'] as bool,
      );
    } catch (e, stack) {
      debugPrint('Error in Term.fromJson: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
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
    try {
      return Aspects(
        positive: (json['positive'] as List)
            .map((item) => Term.fromJson(item as Map<String, dynamic>))
            .toList(),
        negative: (json['negative'] as List)
            .map((item) => Term.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, stack) {
      debugPrint('Error in Aspects.fromJson: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
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
    try {
      return Subscription(
        endsAt: json['endsAt'] as Timestamp,
        plan: json['plan'] as String,
        startedAt: json['startedAt'] as Timestamp,
        autoRenewal: json['autoRenewal'] as bool,
      );
    } catch (e, stack) {
      debugPrint('Error in Subscription.fromJson: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
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
    try {
      return Score(
        rating: (json['rating'] as num).toDouble(),
        amountRatings: json['amountRatings'] as int,
      );
    } catch (e, stack) {
      debugPrint('Error in Score.fromJson: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'amountRatings': amountRatings,
    };
  }
}

class TherapistInfo {
  Timestamp birthday;
  String firstName;
  String email;
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
    required this.email,
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
    try {
      return TherapistInfo(
        birthday: json['birthday'] as Timestamp,
        firstName: json['firstName'] as String,
        intro: json['intro'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        location: Location.fromJson(json['location'] as Map<String, dynamic>),
        meetingType:
            MeetingType.fromJson(json['meetingType'] as Map<String, dynamic>),
        phone: Phone.fromJson(json['phone'] as Map<String, dynamic>),
        privateNotes: json['privateNotes'] as String,
        profilePictureUrl: ProfilePictureUrl.fromJson(
            json['profilePictureUrl'] as Map<String, dynamic>),
        publicPresentation: json['publicPresentation'] as String,
        specializations: List<String>.from(json['specializations'] as List),
        spokenLanguages: List<String>.from(json['spokenLanguages'] as List),
        professionalCertificates: (json['professionalCertificates'] as List)
            .map((i) =>
                ProfessionalCertificate.fromJson(i as Map<String, dynamic>))
            .toList(),
        title: json['title'] as String,
        userInfoIsVerified: json['userInfoIsVerified'] as bool,
      );
    } catch (e, stack) {
      debugPrint('Error in TherapistInfo.fromJson for ID ${json['id']}: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'birthday': birthday,
      'firstName': firstName,
      'email': email,
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
    try {
      return Location(
        address: json['address'] as String,
        city: json['city'] as String,
        country: json['country'] as String,
        geolocation: json['geolocation'] as GeoPoint,
        stateProvince: json['stateProvince'] as String,
        zip: json['zip'] as String,
      );
    } catch (e, stack) {
      debugPrint('Error in Location.fromJson: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
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
    try {
      return MeetingType(
        presential: json['presential'] as bool,
        remote: json['remote'] as bool,
      );
    } catch (e, stack) {
      debugPrint('Error in MeetingType.fromJson: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
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
    try {
      return Phone(
        areaCode: json['areaCode'] as String,
        number: json['number'] as String,
      );
    } catch (e, stack) {
      debugPrint('Error in Phone.fromJson: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
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
    try {
      return ProfessionalCertificate(
        institution: json['institution'] as String,
        photoUrl: json['photoUrl'] as String,
        title: json['title'] as String,
        type: json['type'] as String,
        verified: json['verified'] as bool,
        yearObtained: json['yearObtained'] as int,
      );
    } catch (e, stack) {
      debugPrint('Error in ProfessionalCertificate.fromJson: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
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
    try {
      return ProfilePictureUrl(
        large: json['large'] as String,
        small: json['small'] as String,
        thumb: json['thumb'] as String,
      );
    } catch (e, stack) {
      debugPrint('Error in ProfilePictureUrl.fromJson: $e');
      debugPrint('Stack trace: $stack');
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'large': large,
      'small': small,
      'thumb': thumb,
    };
  }
}

Future<List<TherapistModel>> _fetchTherapists() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('therapists').get();
    return snapshot.docs
        .map((doc) {
          try {
            return TherapistModel.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          } catch (e, stack) {
            debugPrint('Error in processing document ID ${doc.id}: $e');
            debugPrint('Stack trace: $stack');
            return null;
          }
        })
        .where((doc) => doc != null)
        .cast<TherapistModel>()
        .toList();
  } catch (e, stack) {
    debugPrint('Failed to get therapists: $e');
    debugPrint('Stack trace: $stack');
    return [];
  }
}
