import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUserData {
  final String id;
  final UserInfo userInfo;
  final bool isTherapist;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final bool isOnline;
  final Timestamp lastOnline;
  final Score score;
  final Subscription subscription;

  CurrentUserData({
    required this.id,
    required this.userInfo,
    required this.isTherapist,
    required this.createdAt,
    required this.updatedAt,
    required this.isOnline,
    required this.lastOnline,
    required this.score,
    required this.subscription,
  });

  factory CurrentUserData.fromJson(Map<String, dynamic> json) {
    return CurrentUserData(
      id: json['userId'],
      userInfo: UserInfo.fromJson(json['userInfo'] ?? {}),
      isTherapist: json['isTherapist'] ?? false,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isOnline: json['isOnline'] ?? false,
      lastOnline: json['lastOnline'],
      score: Score.fromJson(json['score'] ?? {}),
      subscription: Subscription.fromJson(json['subscription'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'userInfo': userInfo.toJson(),
      'isTherapist': isTherapist,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isOnline': isOnline,
      'lastOnline': lastOnline,
      'score': score.toJson(),
      'subscription': subscription.toJson(),
    };
  }
}

class UserInfo {
  final String? email;
  final String displayName;
  final Phone phone;
  final ProfilePictureUrl profilePictureUrl;
  final String title;

  UserInfo({
    this.email,
    required this.displayName,
    required this.phone,
    required this.profilePictureUrl,
    required this.title,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      displayName: json['displayName'] ?? '',
      phone: Phone.fromJson(json['phone'] ?? {}),
      profilePictureUrl:
          ProfilePictureUrl.fromJson(json['profilePictureUrl'] ?? {}),
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'displayName': displayName,
      'phone': phone.toJson(),
      'profilePictureUrl': profilePictureUrl.toJson(),
      'title': title,
    };
  }
}

class Phone {
  final String areaCode;
  final String number;

  Phone({
    required this.areaCode,
    required this.number,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      areaCode: json['areaCode'] ?? '',
      number: json['number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'areaCode': areaCode,
      'number': number,
    };
  }
}

class ProfilePictureUrl {
  final String large;
  final String small;
  final String thumb;

  ProfilePictureUrl({
    required this.large,
    required this.small,
    required this.thumb,
  });

  factory ProfilePictureUrl.fromJson(Map<String, dynamic> json) {
    return ProfilePictureUrl(
      large: json['large'] ?? '',
      small: json['small'] ?? '',
      thumb: json['thumb'] ?? '',
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

class Score {
  final double rating;
  final int amountRatings;

  Score({
    required this.rating,
    required this.amountRatings,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      rating: (json['rating'] as num).toDouble(),
      amountRatings: json['amountRatings'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'amountRatings': amountRatings,
    };
  }
}

class Subscription {
  final Timestamp endsAt;
  final String plan;
  final Timestamp startedAt;
  final bool autoRenewal;

  Subscription({
    required this.endsAt,
    required this.plan,
    required this.startedAt,
    required this.autoRenewal,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      endsAt: json['endsAt'] as Timestamp,
      plan: json['plan'] ?? '',
      startedAt: json['startedAt'] as Timestamp,
      autoRenewal: json['autoRenewal'] ?? false,
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
