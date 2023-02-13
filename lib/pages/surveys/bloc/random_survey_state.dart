import 'package:equatable/equatable.dart';
import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/data/intervention_question_response.dart';
import 'package:project_care_app/entities/answer.dart';
import 'package:project_care_app/entities/question.dart';
import 'package:project_care_app/entities/survey.dart';

import '../../../../common/enums/intervention_type.dart';
import '../../../data/remote/submit_answer_response.dart';
import '../../widgets/content_widget.dart';

class RandomSurveyState {
  List<Question>? socialQuestions;
  List<Question>? helpQuestions;
  List<Question>? cogQuestions;
  List<Question>? panasQuestions;
  List<Answer>? socialAnswers;
  List<Answer>? helpAnswers;
  List<Answer>? cogAnswers;
  List<Answer>? panasAnswers;
  DataSourceStatus status;
  RequestStatus requestStatus;
  RequestStatus initRequestStatus;
  Survey? survey;
  String? errorMessage;
  SubmitAnswerResponse? interventionResult;
  InterventionQuestionResponse? interventionQuestionResponse;
  int step;

  RandomSurveyState({
    this.socialQuestions = const [],
    this.helpQuestions = const [],
    this.cogQuestions = const [],
    this.panasQuestions = const [],
    this.socialAnswers = const [],
    this.helpAnswers = const [],
    this.cogAnswers = const [],
    this.panasAnswers = const [],
    this.survey,
    this.status = DataSourceStatus.initial,
    this.requestStatus = RequestStatus.initial,
    this.initRequestStatus = RequestStatus.initial,
    this.errorMessage,
    this.interventionResult,
    this.interventionQuestionResponse,
    this.step = 0,
  });

  RandomSurveyState copyWith({
    List<Question>? socialQuestions,
    List<Question>? helpQuestions,
    List<Question>? cogQuestions,
    List<Question>? panasQuestions,
    List<Answer>? socialAnswers,
    List<Answer>? helpAnswers,
    List<Answer>? cogAnswers,
    List<Answer>? panasAnswers,
    Survey? survey,
    DataSourceStatus? status,
    RequestStatus? requestStatus,
    RequestStatus? initRequestStatus,
    String? errorMessage,
    SubmitAnswerResponse? interventionResult,
    InterventionQuestionResponse? interventionQuestionResponse,
    int? step,
  }) {
    return RandomSurveyState(
      socialQuestions: socialQuestions ?? this.socialQuestions,
      helpQuestions: helpQuestions ?? this.helpQuestions,
      cogQuestions: cogQuestions ?? this.cogQuestions,
      panasQuestions: panasQuestions ?? this.panasQuestions,
      socialAnswers: socialAnswers ?? this.socialAnswers,
      helpAnswers: helpAnswers ?? this.helpAnswers,
      cogAnswers: cogAnswers ?? this.cogAnswers,
      panasAnswers: panasAnswers ?? this.panasAnswers,
      survey: survey ?? this.survey,
      status: status ?? this.status,
      requestStatus: requestStatus ?? RequestStatus.initial,
      initRequestStatus: initRequestStatus ?? RequestStatus.initial,
      errorMessage: errorMessage ?? this.errorMessage,
      interventionResult: interventionResult ?? this.interventionResult,
      interventionQuestionResponse: interventionQuestionResponse ?? this.interventionQuestionResponse,
      step: step ?? this.step,
    );
  }

  // @override
  // List<Object?> get props => [
  //       socialQuestions,
  //       helpQuestions,
  //       cogQuestions,
  //       panasQuestions,
  //       socialAnswers,
  //       helpQuestions,
  //       cogAnswers,
  //       panasAnswers,
  //       survey,
  //       status,
  //       requestStatus,
  //       initRequestStatus,
  //       errorMessage,
  //       interventionResult,
  //       step,
  //     ];
}
