import 'package:collection/collection.dart';
import 'package:project_care_app/entities/question_option.dart';

class Question {
  String? id;
  String? title;
  String? description;
  QuestionType? type;
  List<QuestionOption>? options;
  String? categoryID;

  Question({
    this.id,
    this.title,
    this.description,
    this.type,
    this.options,
    this.categoryID,
  });

  Question copyWith(
    String? id,
    String? title,
    QuestionType? type,
    List<QuestionOption>? options,
    String? categoryID,
  ) {
    return Question(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      options: options ?? this.options,
      categoryID: categoryID ?? this.categoryID,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json['id'] as String?,
        title: json['title'] as String?,
        type: json['type'] == null ? null : QuestionTypeX.initFrom(json['type'] as int?),
        options: json['options'] == null
            ? null
            : List.from((json['options'] as List<dynamic>).map((e) => QuestionOption.fromJson(e))),
        categoryID: json['category_id'] == null ? null : json['category_id'] as String?);
  }
}

enum QuestionType {
  options(1),
  yesNo1(2),
  yesNo2(3),
  datetime(4),
  rate(5),
  text(6),
  options2(7),
  options3(8),
  options4(9);

  const QuestionType(this.value);

  final int value;
}

extension QuestionTypeX on QuestionType {
  static QuestionType? initFrom(int? value) {
    return QuestionType.values.firstWhereOrNull((QuestionType e) => e.value == value);
  }
}
