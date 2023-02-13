import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:project_care_app/common/api_client/data_state.dart';
import 'package:project_care_app/common/enums/intervention_type.dart';
import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/common/event/event_bus_mixin.dart';
import 'package:project_care_app/data/intervention_question_response.dart';
import 'package:project_care_app/pages/widgets/content_widget.dart';
import 'package:project_care_app/repositories/data_repository.dart';

import '../../../entities/answer.dart';
import '../../../entities/question.dart';
import '../help/even_bus_event.dart';
import 'random_survey_state.dart';

@injectable
class RandomSurveyCubit extends Cubit<RandomSurveyState> with EventBusMixin {
  RandomSurveyCubit(this._dataRepository) : super(RandomSurveyState());

  final DataRepository _dataRepository;
  String? _surveyID;

  Future<void> _startSurvey(String? surveyID) async {
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
    final result = await _dataRepository.getSpecialQuestions(surveyID);
    if (result.isSuccess()) {
      DataSourceStatus dataSourceStatus = DataSourceStatus.initial;
      switch (state.step) {
        case 0:
          dataSourceStatus = (result.data?.socialQuestions ?? []).isNotEmpty
              ? DataSourceStatus.success
              : DataSourceStatus.empty;
          break;
        case 1:
          dataSourceStatus = (result.data?.helpQuestions ?? []).isNotEmpty
              ? DataSourceStatus.success
              : DataSourceStatus.empty;
          break;
        case 2:
          dataSourceStatus = (result.data?.cogQuestions ?? []).isNotEmpty
              ? DataSourceStatus.success
              : DataSourceStatus.empty;
          break;
        case 3:
          dataSourceStatus = (result.data?.panasQuestions ?? []).isNotEmpty
              ? DataSourceStatus.success
              : DataSourceStatus.empty;
          break;
      }
      emit(state.copyWith(
        status: dataSourceStatus,
        socialQuestions: result.data?.socialQuestions,
        helpQuestions: result.data?.helpQuestions,
        cogQuestions: result.data?.cogQuestions,
        panasQuestions: result.data?.panasQuestions,
        socialAnswers: _generateAnswer(result.data?.socialQuestions),
        helpAnswers: _generateAnswer(result.data?.helpQuestions),
        cogAnswers: _generateAnswer(result.data?.cogQuestions),
        panasAnswers: _generateAnswer(result.data?.panasQuestions),
      ));
    } else {
      emit(state.copyWith(status: DataSourceStatus.failed, socialQuestions: []));
    }
  }

  List<Answer> _generateAnswer(List<Question>? questions) {
    return List<Answer>.from((questions ?? []).map((e) {
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
  }

  DataSourceStatus _getDataSourceStatus(int step) {
    switch (step) {
      case 0:
        return (state.socialQuestions ?? []).isNotEmpty
            ? DataSourceStatus.success
            : DataSourceStatus.empty;
      case 1:
        return (state.helpQuestions ?? []).isNotEmpty
            ? DataSourceStatus.success
            : DataSourceStatus.empty;
      case 2:
        return (state.cogQuestions ?? []).isNotEmpty
            ? DataSourceStatus.success
            : DataSourceStatus.empty;
      case 3:
        return (state.panasQuestions ?? []).isNotEmpty
            ? DataSourceStatus.success
            : DataSourceStatus.empty;
      default:
        return DataSourceStatus.initial;
    }
  }

  Future<void> getData(String? surveyID) async {
    _surveyID = surveyID;
    await _startSurvey(surveyID);
    emit(state.copyWith(status: DataSourceStatus.loading));
    await _getQuestions(surveyID);
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: DataSourceStatus.refreshing));
    await _getQuestions(_surveyID);
  }

  void changeAnswerAt(int index, Answer? answer) {
    switch (state.step) {
      case 0:
        if ((index < (state.socialAnswers ?? []).length) && answer != null) {
          final newAnswers = List<Answer>.from(state.socialAnswers ?? []);
          newAnswers[index] = answer;
          emit(state.copyWith(socialAnswers: newAnswers));
        }
        break;
      case 1:
        if ((index < (state.helpAnswers ?? []).length) && answer != null) {
          final newAnswers = List<Answer>.from(state.helpAnswers ?? []);
          newAnswers[index] = answer;
          emit(state.copyWith(helpAnswers: newAnswers));
        }
        break;
      case 2:
        if ((index < (state.cogAnswers ?? []).length) && answer != null) {
          final newAnswers = List<Answer>.from(state.cogAnswers ?? []);
          newAnswers[index] = answer;
          emit(state.copyWith(cogAnswers: newAnswers));
        }
        break;
      case 3:
        if ((index < (state.panasAnswers ?? []).length) && answer != null) {
          final newAnswers = List<Answer>.from(state.panasAnswers ?? []);
          newAnswers[index] = answer;
          emit(state.copyWith(panasAnswers: newAnswers));
        }
        break;
    }
  }

  Future<void> submitAnswers() async {
    if (state.survey?.id == null ||
        (state.socialAnswers ?? []).isEmpty ||
        (state.helpAnswers ?? []).isEmpty ||
        (state.cogAnswers ?? []).isEmpty ||
        (state.panasAnswers ?? []).isEmpty) {
      return;
    }
    emit(state.copyWith(requestStatus: RequestStatus.requesting));
    try {
      final answers = [
        ...state.socialAnswers!,
        ...state.helpAnswers!,
        ...state.cogAnswers!,
        ...state.panasAnswers!
      ];
      List<Answer> newAnswers = [];
      answers.forEach((element) {
        if ((element.multipleOptionIDs ?? []).isNotEmpty) {
          final subAnswers = (element.multipleOptionIDs ?? []).map((e) => Answer(questionID: element.questionID, optionID: e)).toList();
          subAnswers.last.answer = element.answer;
          newAnswers.addAll(subAnswers);
        } else {
          newAnswers.add(element);
        }
      });
      final result =
          await _dataRepository.sendResults(surveyID: state.survey!.id!, answers: newAnswers);
      if (result.isSuccess()) {
        await _startSurvey(result.data?.id);
        final interventionQuestions = await getInterventionQuestions(result.data?.id, result.data?.status);
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          interventionResult: result.data,
          interventionQuestionResponse: interventionQuestions,
        ));
        shareEvent(UpdatedSurveyEvent());
      } else {
        emit(state.copyWith(requestStatus: RequestStatus.failed, errorMessage: result.message));
      }
    } catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.failed, errorMessage: e.toString()));
    }
  }

  void nextStep() {
    final step = state.step + 1;
    emit(state.copyWith(step: step, status: _getDataSourceStatus(step)));
  }

  Future<InterventionQuestionResponse?> getInterventionQuestions(String? interventionID, InterventionType? interventionType) async {
    if (interventionID == null) {
      return null;
    }
    final result = await _dataRepository.getInterventionQuestions(interventionID, interventionType: interventionType);
    if (result.isSuccess()) {
      return result.data;
    }
    return null;
  }
}
