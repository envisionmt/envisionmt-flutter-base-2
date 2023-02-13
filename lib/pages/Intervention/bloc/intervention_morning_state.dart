import 'package:equatable/equatable.dart';
import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/entities/answer.dart';
import 'package:project_care_app/entities/question.dart';

class InterventionMorningState extends Equatable {
  String? interventionID;
  List<Answer>? answers;
  List<Question>? questions;

  RequestStatus requestStatus;
  RequestStatus initDataRequestStatus;
  String? errorMessage;

  InterventionMorningState({
    this.interventionID,
    this.requestStatus = RequestStatus.initial,
    this.initDataRequestStatus = RequestStatus.initial,
    this.errorMessage,
    this.answers,
    this.questions,
  });

  InterventionMorningState copyWith({
    RequestStatus? requestStatus,
    RequestStatus? initDataRequestStatus,
    String? errorMessage,
    String? interventionID,
    List<Answer>? answers,
    List<Question>? questions,
  }) {
    return InterventionMorningState(
      interventionID: interventionID ?? this.interventionID,
      requestStatus: requestStatus ?? RequestStatus.initial,
      initDataRequestStatus: initDataRequestStatus ?? RequestStatus.initial,
      errorMessage: errorMessage ?? this.errorMessage,
      answers: answers ?? this.answers,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [
        interventionID,
        requestStatus,
        initDataRequestStatus,
        errorMessage,
        answers,
        questions,
      ];
}
