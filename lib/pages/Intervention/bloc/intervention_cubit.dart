import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:project_care_app/common/api_client/data_state.dart';
import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/entities/answer.dart';
import 'package:project_care_app/pages/Intervention/intervention_a.dart';
import 'package:project_care_app/repositories/data_repository.dart';

import 'intervention_state.dart';

@injectable
class InterventionCubit extends Cubit<InterventionState> {
  InterventionCubit(this._dataRepository) : super(InterventionState());

  final DataRepository _dataRepository;

  void init(InterventionArgs? args) {
    emit(state.copyWith(
      interventionID: args?.interventionResult?.id,
      interventionReminderAnswer: args?.interventionReminderAnswer,
      interventionMoodAnswer: args?.interventionMoodAnswer,
      interventionLonelyAnswer: args?.interventionLonelyAnswer,
      interventionLogAnswer: args?.interventionLogAnswer,
      interventionLMoodAnswer: args?.interventionLMoodAnswer,
      interventionAAnswer: args?.interventionAAnswer,
    ));
  }

  Future<void> submitAnswers() async {
    if (state.interventionID == null) {
      return;
    }
    emit(state.copyWith(requestStatus: RequestStatus.requesting));
    try {
      final List<Answer> answers = [
        ...state.interventionAAnswer ?? [],
        ...state.interventionReminderAnswer ?? [],
        ...state.interventionLMoodAnswer ?? [],
        ...state.interventionMoodAnswer ?? [],
        ...state.interventionLonelyAnswer ?? [],
        ...state.interventionLogAnswer ?? []
      ];
      answers.removeWhere((element) => element.optionID == null && element.answer == null);
      final result =
          await _dataRepository.sendResults(surveyID: state.interventionID!, answers: answers);
      if (result.isSuccess()) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
        ));
      } else {
        emit(state.copyWith(requestStatus: RequestStatus.failed, errorMessage: result.message));
      }
    } catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.failed, errorMessage: e.toString()));
    }
  }
}
