// models/policy_models.dart

class PolicyItemModel {
  final int? id; // 👈 مهم للحذف / التعديل
  final String? number;
  final String title;
  final String body;

  PolicyItemModel({
    this.id,
    this.number,
    required this.title,
    required this.body,
  });

  factory PolicyItemModel.fromJson(Map<String, dynamic> json) {
    return PolicyItemModel(
      id: json['id'] as int?,
      number: json['number'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  PolicyItemModel copyWith({
    int? id,
    String? number,
    String? title,
    String? body,
  }) {
    return PolicyItemModel(
      id: id ?? this.id,
      number: number ?? this.number,
      title: title ?? this.title,
      body: body ?? this.body,
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
