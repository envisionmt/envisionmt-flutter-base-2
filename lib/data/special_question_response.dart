import 'package:project_care_app/data/remote/question_model.dart';

class SpecialQuestionResponse {
  List<QuestionModel>? socialQuestions;
  List<QuestionModel>? helpQuestions;
  List<QuestionModel>? cogQuestions;
  List<QuestionModel>? panasQuestions;

  SpecialQuestionResponse({
    this.socialQuestions,
    this.helpQuestions,
    this.cogQuestions,
    this.panasQuestions,
  });

  factory SpecialQuestionResponse.fromJson(Map<String, dynamic> json) {
    return SpecialQuestionResponse(
      socialQuestions:
          (json['socialQuestions'] as List<dynamic>).map((e) => QuestionModel.fromJson(e)).toList(),
      helpQuestions:
          (json['helpQuestions'] as List<dynamic>).map((e) => QuestionModel.fromJson(e)).toList(),
      cogQuestions:
          (json['cogQuestions'] as List<dynamic>).map((e) => QuestionModel.fromJson(e)).toList(),
      panasQuestions:
          (json['panasQuestions'] as List<dynamic>).map((e) => QuestionModel.fromJson(e)).toList(),
    );
  }
}
