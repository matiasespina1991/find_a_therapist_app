import 'package:findatherapistapp/models/therapist_model.dart';

class GeminiTagsResponse {
  final Tags tags;
  final GeminiErrorResponse? error;
  final List<Candidate>? candidates;

  GeminiTagsResponse(
      {this.error, required this.tags, this.candidates = const []});

  factory GeminiTagsResponse.fromJson(Map<String, dynamic> json) {
    return GeminiTagsResponse(
      tags: Tags.fromJson(json['tags']),
      error: json['error'] != null
          ? GeminiErrorResponse(message: json['error'], code: null)
          : null,
      candidates: (json['candidates'] as List<dynamic>?)
              ?.map((candidate) => Candidate.fromJson(candidate))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tags': tags.toJson(),
      'error': error?.toJson(),
      'candidates': candidates?.map((candidate) => candidate.toJson()).toList(),
    };
  }
}

class Tags {
  final List<String> positive;
  final List<String> negative;

  Tags({required this.positive, required this.negative});

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(
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

  Aspects toAspects() {
    return Aspects(
      positive: positive,
      negative: negative,
    );
  }
}

class Candidate {
  final String? text;
  final List<SafetyRating>? safetyRatings;

  Candidate({this.text, this.safetyRatings});

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      text: json['text'],
      safetyRatings: (json['safetyRatings'] as List<dynamic>?)
          ?.map((rating) => SafetyRating.fromJson(rating))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'safetyRatings': safetyRatings?.map((rating) => rating.toJson()).toList(),
    };
  }
}

class GeminiErrorResponse {
  final String? message;
  final String? code;

  GeminiErrorResponse({this.message, this.code});

  factory GeminiErrorResponse.fromJson(Map<String, dynamic> json) {
    return GeminiErrorResponse(
      message: json['message'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
    };
  }

  @override
  String toString() {
    return 'GeminiError{message: $message, code: $code}';
  }
}

class SafetyRating {
  final String category;
  final String probability;

  SafetyRating({required this.category, required this.probability});

  factory SafetyRating.fromJson(Map<String, dynamic> json) {
    return SafetyRating(
      category: json['category'],
      probability: json['probability'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'probability': probability,
    };
  }
}
