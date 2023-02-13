import 'package:project_care_app/data/remote/question_model.dart';

class InterventionQuestionResponse {
  List<QuestionModel>? interventionAQuestions;
  List<QuestionModel>? interventionMoodQuestions;
  List<QuestionModel>? interventionReminderQuestions;
  List<QuestionModel>? interventionLonelyQuestions;
  List<QuestionModel>? interventionLMoodQuestions;
  List<QuestionModel>? interventionLogQuestions;
  List<QuestionModel>? interventionMorningQuestions;

  InterventionQuestionResponse({
    this.interventionAQuestions,
    this.interventionMoodQuestions,
    this.interventionReminderQuestions,
    this.interventionLonelyQuestions,
    this.interventionLMoodQuestions,
    this.interventionLogQuestions,
    this.interventionMorningQuestions,
  });

  factory InterventionQuestionResponse.fromJson(Map<String, dynamic> json) {
    return InterventionQuestionResponse(
      interventionAQuestions: (json['interventionAQuestions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
      interventionMoodQuestions: (json['interventionMoodQuestions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
      interventionReminderQuestions: (json['interventionReminderQuestions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
      interventionLonelyQuestions: (json['interventionLonelyQuestions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
      interventionLMoodQuestions: (json['interventionLMoodQuestions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
      interventionLogQuestions: (json['interventionLogQuestions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
      interventionMorningQuestions: (json['interventionMorningQuestions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
    );
  }
}
