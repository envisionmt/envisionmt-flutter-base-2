import 'package:project_care_app/entities/question.dart';

import '../../entities/question_option.dart';

class QuestionModel extends Question {
  QuestionModel({
    String? id,
    String? title,
    String? description,
    QuestionType? type,
    List<QuestionOption>? options,
    String? category,
  }) : super(
          id: id,
          title: title,
          description: description,
          type: type,
          options: options,
          categoryID: category,
        );

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
        id: json['id'] as String?,
        title: json['title'] as String?,
        description: json['description'] == null ? null : json['description'] as String?,
        type: json['type'] == null ? null : QuestionTypeX.initFrom(json['type'] as int?),
        options: json['options'] == null
            ? null
            : List.from((json['options'] as List<dynamic>).map((e) => QuestionOption.fromJson(e))),
        category: json['category_id'] == null ? null : json['category_id'] as String?);
  }
}
