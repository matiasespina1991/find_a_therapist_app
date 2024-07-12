import 'package:cloud_firestore/cloud_firestore.dart';

class TermIndex {
  String id;
  String term;
  List<String> associations;
  List<TherapistIndex> negative;
  List<TherapistIndex> positive;

  TermIndex({
    required this.id,
    required this.term,
    required this.associations,
    required this.negative,
    required this.positive,
  });

  factory TermIndex.fromJson(Map<String, dynamic> json, String id) {
    List<String> associations = [
      ...List<String>.from(json['equivalents'] ?? []),
      ...List<String>.from(json['related'] ?? []),
      ...List<String>.from(json['subcategories'] ?? []),
    ];

    List<TherapistIndex> negative = (json['negative'] as List)
        .map((item) => TherapistIndex.fromJson(item))
        .toList();

    List<TherapistIndex> positive = (json['positive'] as List)
        .map((item) => TherapistIndex.fromJson(item))
        .toList();

    return TermIndex(
      id: id,
      term: json['term'] ?? '',
      associations: associations,
      negative: negative,
      positive: positive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'term': term,
      'associations': associations,
      'negative': negative.map((item) => item.toJson()).toList(),
      'positive': positive.map((item) => item.toJson()).toList(),
    };
  }
}

class TherapistIndex {
  String therapistId;

  TherapistIndex({
    required this.therapistId,
  });

  factory TherapistIndex.fromJson(Map<String, dynamic> json) {
    return TherapistIndex(
      therapistId: json['therapistId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'therapistId': therapistId,
    };
  }
}
