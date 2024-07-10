// lib/models/tag_model.dart

class GeminiTagsResponse {
  final Tags tags;
  final String? error;

  GeminiTagsResponse({this.error, required this.tags});

  factory GeminiTagsResponse.fromJson(Map<String, dynamic> json) {
    return GeminiTagsResponse(
      tags: Tags.fromJson(json['tags']),
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tags': tags.toJson(),
      'error': error,
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
}
