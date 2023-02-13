import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:project_care_app/common/api_client/data_state.dart';
import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/common/event/event_bus_mixin.dart';
import 'package:project_care_app/pages/surveys/help/even_bus_event.dart';
import 'package:project_care_app/pages/widgets/content_widget.dart';
import 'package:project_care_app/repositories/data_repository.dart';

import '../../../entities/answer.dart';
import '../../../entities/question.dart';
import 'survey_state.dart';

@injectable
class SurveyCubit extends Cubit<SurveyState> with EventBusMixin {
  SurveyCubit(this._dataRepository) : super(SurveyState());

  final DataRepository _dataRepository;
  String? _surveyID;

  Future<void> _getSurveyDetail(String? surveyID) async {
    if (surveyID == null) {
      return;
    }
    emit(state.copyWith(initRequestStatus: RequestStatus.requesting));
    final result = await _dataRepository.startSurvey(surveyID);
    if (result.isSuccess()) {
      shareEvent(UpdatedSurveyEvent());
    }
    emit(state.copyWith(
        survey: result.data,
        initRequestStatus: result.isSuccess() ? RequestStatus.success : RequestStatus.failed));
  }

  Future<void> _getQuestions(String? surveyID) async {
    if (surveyID == null) {
      return;
    }
    final result = await _dataRepository.getQuestions(surveyID);
    if (result.isSuccess()) {
      final answers = List<Answer>.from((result.data ?? []).map((e) {
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
        status: (result.data ?? []).isNotEmpty ? DataSourceStatus.success : DataSourceStatus.empty,
        questions: result.data,
        answers: answers,
      ));
    } else {
      emit(state.copyWith(status: DataSourceStatus.failed, questions: []));
    }
  }

  Future<void> getData(String? surveyID) async {
    _surveyID = surveyID;
    await _getSurveyDetail(surveyID);
    emit(state.copyWith(status: DataSourceStatus.loading));
    await _getQuestions(surveyID);
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: DataSourceStatus.refreshing));
    await _getQuestions(_surveyID);
  }

  void changeAnswerAt(int index, Answer? answer) {
    if ((index < (state.answers ?? []).length) && answer != null) {
      final newAnswers = List<Answer>.from(state.answers ?? []);
      newAnswers[index] = answer;
      emit(state.copyWith(answers: newAnswers));
    }
  }

  Future<void> submitAnswers() async {
    if (state.survey?.id == null || (state.answers ?? []).isEmpty) {
      return;
    }
    emit(state.copyWith(requestStatus: RequestStatus.requesting));
    try {
      List<Answer> answers = [];
      state.answers?.forEach((element) {
        if ((element.multipleOptionIDs ?? []).isNotEmpty) {
          final subAnswers = (element.multipleOptionIDs ?? []).map((e) => Answer(questionID: element.questionID, optionID: e)).toList();
          subAnswers.last.answer = element.answer;
          answers.addAll(subAnswers);
        } else {
          answers.add(element);
        }
      });
      final result =
          await _dataRepository.sendResults(surveyID: state.survey!.id!, answers: answers);
      if (result.isSuccess()) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          interventionResult: result.data?.status,
        ));
        shareEvent(UpdatedSurveyEvent());
      } else {
        emit(state.copyWith(requestStatus: RequestStatus.failed, errorMessage: result.message));
      }
    } catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.failed, errorMessage: e.toString()));
    }
  }
}
