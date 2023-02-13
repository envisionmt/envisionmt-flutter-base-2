import 'package:equatable/equatable.dart';
import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/entities/answer.dart';

class InterventionState extends Equatable {
  String? interventionID;
  List<Answer>? interventionAAnswer;
  List<Answer>? interventionMoodAnswer;
  List<Answer>? interventionReminderAnswer;
  List<Answer>? interventionLonelyAnswer;
  List<Answer>? interventionLMoodAnswer;
  List<Answer>? interventionLogAnswer;

  RequestStatus requestStatus;
  String? errorMessage;

  InterventionState({
    this.interventionID,
    this.requestStatus = RequestStatus.initial,
    this.errorMessage,
    this.interventionAAnswer,
    this.interventionMoodAnswer,
    this.interventionReminderAnswer,
    this.interventionLonelyAnswer,
    this.interventionLMoodAnswer,
    this.interventionLogAnswer,
  });

  InterventionState copyWith({
    RequestStatus? requestStatus,
    String? errorMessage,
    String? interventionID,
    List<Answer>? interventionAAnswer,
    List<Answer>? interventionMoodAnswer,
    List<Answer>? interventionReminderAnswer,
    List<Answer>? interventionLonelyAnswer,
    List<Answer>? interventionLMoodAnswer,
    List<Answer>? interventionLogAnswer,
  }) {
    return InterventionState(
      interventionID: interventionID ?? this.interventionID,
      requestStatus: requestStatus ?? RequestStatus.initial,
      errorMessage: errorMessage ?? this.errorMessage,
      interventionAAnswer: interventionAAnswer ?? this.interventionAAnswer,
      interventionMoodAnswer: interventionMoodAnswer ?? this.interventionMoodAnswer,
      interventionReminderAnswer: interventionReminderAnswer ?? this.interventionReminderAnswer,
      interventionLonelyAnswer: interventionLonelyAnswer ?? this.interventionLonelyAnswer,
      interventionLMoodAnswer: interventionLMoodAnswer ?? this.interventionLMoodAnswer,
      interventionLogAnswer: interventionLogAnswer ?? this.interventionLogAnswer,
    );
  }

  @override
  List<Object?> get props => [
        interventionID,
        requestStatus,
        errorMessage,
        interventionAAnswer,
        interventionMoodAnswer,
        interventionReminderAnswer,
        interventionLonelyAnswer,
        interventionLMoodAnswer,
        interventionLogAnswer,
      ];
}
