import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:project_care_app/common/api_client/data_state.dart';
import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/entities/answer.dart';
import 'package:project_care_app/pages/Intervention/intervention_a.dart';
import 'package:project_care_app/repositories/data_repository.dart';

import '../../../entities/question.dart';
import 'intervention_morning_state.dart';

@injectable
class InterventionMorningCubit extends Cubit<InterventionMorningState> {
  InterventionMorningCubit(this._dataRepository) : super(InterventionMorningState());

  final DataRepository _dataRepository;

  Future<void> init(InterventionArgs? args) async {
    emit(state.copyWith(interventionID: args?.interventionResult?.id));
    await _startSurvey(args?.interventionResult?.id);
    _getInterventionQuestions(args?.interventionResult?.id);
  }

  Future<void> _startSurvey(String? surveyID) async {
    if (surveyID == null) {
      return;
    }
    emit(state.copyWith(initDataRequestStatus: RequestStatus.requesting));
    final result = await _dataRepository.startSurvey(surveyID);
    emit(state.copyWith(
        initDataRequestStatus: result.isSuccess() ? RequestStatus.success : RequestStatus.failed));
  }

  Future<void> _getInterventionQuestions(String? interventionID) async {
    if (interventionID == null) {
      return;
    }
    try {
      emit(state.copyWith(initDataRequestStatus: RequestStatus.requesting));
      final result = await _dataRepository.getInterventionQuestions(interventionID);
      if (result.isSuccess()) {
        final answers =
            List<Answer>.from((result.data?.interventionMorningQuestions ?? []).map((e) {
          final answer = Answer(questionID: e.id);
          switch (e.type) {
            case QuestionType.datetime:
              answer.answer = DateTime.now();
              break;
            case QuestionType.rate:
              answer.answer = 0;
              break;
            default:
              break;
          }
          return answer;
        }));
        emit(state.copyWith(
            questions: result.data?.interventionMorningQuestions,
            answers: answers,
            initDataRequestStatus: RequestStatus.success));
      } else {
        emit(state.copyWith(
            initDataRequestStatus: RequestStatus.failed, errorMessage: result.message));
      }
    } catch (e) {
      emit(state.copyWith(initDataRequestStatus: RequestStatus.failed, errorMessage: e.toString()));
    }
  }

  void changeAnswer(Answer? answer) {
    final List<Answer> answers = [...(state.answers ?? [])];
    final index = answers.indexWhere((element) => element.questionID == answer?.questionID);
    if (index >= 0 && answer != null) {
      answers[index] = answer;
      emit(state.copyWith(answers: answers));
    }
  }

  Future<void> submitAnswers() async {
    if (state.interventionID == null) {
      return;
    }
    emit(state.copyWith(requestStatus: RequestStatus.requesting));
    try {
      final List<Answer> answers = [
        ...state.answers ?? [],
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
