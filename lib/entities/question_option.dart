import 'package:project_care_app/entities/question.dart';

class QuestionOption {
  String? id;
  String? key;
  dynamic value;
  String? questionID;
  QuestionType? type;

  QuestionOption({
    this.id,
    this.key,
    this.value,
    this.questionID,
    this.type,
  });

  QuestionOption copyWith(
    String? id,
    String? key,
    dynamic value,
    String? questionID,
    QuestionType? type,
  ) {
    return QuestionOption(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      questionID: questionID ?? this.questionID,
      type: type ?? this.type,
    );
  }

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] as String?,
      key: json['key'] as String?,
      value: json['value'],
      questionID: json['question_id'] as String?,
      type: json['type'] == null ? null : QuestionTypeX.initFrom(json['type'] as int?),
    );
  }
}
