import 'package:project_care_app/common/utils/date_time.dart';
import 'package:project_care_app/common/utils/extensions/interable_extension.dart';

class Answer {
  String? questionID;
  String? optionID;
  List<String>? multipleOptionIDs;
  String? userID;
  dynamic answer;

  Answer({
    this.questionID,
    this.optionID,
    this.userID,
    this.answer,
  });

  Answer copyWith({
    String? questionID,
    String? optionID,
    String? userID,
    dynamic answer,
  }) {
    return Answer(
      questionID: questionID ?? this.questionID,
      optionID: optionID ?? this.optionID,
      userID: userID ?? this.userID,
      answer: answer ?? this.answer,
    );
  }

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionID: json['question_id'] as String?,
      optionID: json['option_id'] == null ? null : json['option_id'] as String?,
      userID: json['user_id'] as String?,
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionID,
      'option_id': optionID,
      // 'user_id': userID,
      'answer': (answer is DateTime) ? (answer as DateTime).toUtc().toHHMMString() : answer?.toString(),
    };
  }
}
