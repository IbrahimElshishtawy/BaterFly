// models/policy_models.dart

class PolicyItemModel {
  final String? number;
  final String title;
  final String body;

  PolicyItemModel({this.number, required this.title, required this.body});

  factory PolicyItemModel.fromJson(Map<String, dynamic> json) {
    return PolicyItemModel(
      number: json['number'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

class PolicyPageModel {
  final String slug;
  final String mainTitle;
  final String? introText;
  final String? noteText;
  final List<PolicyItemModel> items;

  PolicyPageModel({
    required this.slug,
    required this.mainTitle,
    this.introText,
    this.noteText,
    required this.items,
  });

  /// Factory لتحويل بيانات Supabase إلى Model
  factory PolicyPageModel.fromJson(
    Map<String, dynamic> json,
    List<PolicyItemModel> items,
  ) {
    return PolicyPageModel(
      slug: json['slug'] as String,
      mainTitle: json['main_title'] as String,
      introText: json['intro_text'] as String?,
      noteText: json['note_text'] as String?,
      items: items,
    );
  }
}
