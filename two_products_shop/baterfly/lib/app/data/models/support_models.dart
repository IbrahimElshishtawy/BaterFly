// app/data/models/support_models.dart

class SupportContactModel {
  final int? id;
  final String title;
  final String body;
  final String url;
  final String type;

  SupportContactModel({
    this.id,
    required this.title,
    required this.body,
    required this.url,
    required this.type,
  });

  factory SupportContactModel.fromJson(Map<String, dynamic> json) {
    return SupportContactModel(
      id: json['id'] as int?,
      title: json['title'] as String,
      body: json['body'] as String,
      url: json['url'] as String? ?? '',
      type: json['type'] as String,
    );
  }

  SupportContactModel copyWith({
    int? id,
    String? title,
    String? body,
    String? url,
    String? type,
  }) {
    return SupportContactModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      url: url ?? this.url,
      type: type ?? this.type,
    );
  }
}

class SupportPageModel {
  final String? introText;
  final String? noteText;
  final List<SupportContactModel> contacts;

  SupportPageModel({this.introText, this.noteText, required this.contacts});
}
