import 'package:cloud_firestore/cloud_firestore.dart';

class TermIndex {
  String id;
  String term;
  List<String> associatedTerms;
  List<TherapistIndex> negative;
  List<TherapistIndex> positive;

  TermIndex({
    required this.id,
    required this.term,
    required this.associatedTerms,
    required this.negative,
    required this.positive,
  });

  factory TermIndex.fromJson(Map<String, dynamic> json, String id) {
    List<String> associatedTerms = [
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
      associatedTerms: associatedTerms,
      negative: negative,
      positive: positive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'term': term,
      'associatedTerms': associatedTerms,
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
