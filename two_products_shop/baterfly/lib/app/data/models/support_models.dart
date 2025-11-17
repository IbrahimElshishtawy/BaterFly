// models/support_models.dart
class SupportContactModel {
  final String title;
  final String body;
  final String url;
  final String type;

  SupportContactModel({
    required this.title,
    required this.body,
    required this.url,
    required this.type,
  });

  factory SupportContactModel.fromJson(Map<String, dynamic> json) {
    return SupportContactModel(
      title: json['title'] as String,
      body: json['body'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
    );
  }
}

class SupportPageModel {
  final String? introText;
  final String? noteText;
  final List<SupportContactModel> contacts;

  SupportPageModel({this.introText, this.noteText, required this.contacts});
}
