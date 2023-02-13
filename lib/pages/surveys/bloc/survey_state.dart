import 'package:equatable/equatable.dart';
import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/entities/question.dart';
import 'package:project_care_app/entities/answer.dart';
import 'package:project_care_app/entities/survey.dart';

import '../../../../common/enums/intervention_type.dart';
import '../../widgets/content_widget.dart';

class SurveyState extends Equatable {
  List<Question>? questions;
  List<Answer>? answers;
  DataSourceStatus status;
  RequestStatus requestStatus;
  RequestStatus initRequestStatus;
  Survey? survey;
  String? errorMessage;
  InterventionType? interventionResult;

  SurveyState({
    this.questions = const [],
    this.answers = const [],
    this.survey,
    this.status = DataSourceStatus.initial,
    this.requestStatus = RequestStatus.initial,
    this.initRequestStatus = RequestStatus.initial,
    this.errorMessage,
    this.interventionResult,
  });

  SurveyState copyWith({
    List<Question>? questions,
    List<Answer>? answers,
    Survey? survey,
    DataSourceStatus? status,
    RequestStatus? requestStatus,
    RequestStatus? initRequestStatus,
    String? errorMessage,
    InterventionType? interventionResult,
  }) {
    return SurveyState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      survey: survey ?? this.survey,
      status: status ?? this.status,
      requestStatus: requestStatus ?? RequestStatus.initial,
      initRequestStatus: initRequestStatus ?? RequestStatus.initial,
      errorMessage: errorMessage ?? this.errorMessage,
      interventionResult: interventionResult ?? this.interventionResult,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        answers,
        survey,
        status,
        requestStatus,
        initRequestStatus,
        errorMessage,
        interventionResult,
      ];
}
