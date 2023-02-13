import 'package:injectable/injectable.dart';
import 'package:project_care_app/common/enums/intervention_type.dart';
import 'package:project_care_app/data/intervention_question_response.dart';
import 'package:project_care_app/data/remote/data_service.dart';
import 'package:project_care_app/entities/survey.dart';

import '../common/api_client/data_state.dart';
import '../common/enums/survey_type.dart';
import '../data/remote/submit_answer_response.dart';
import '../data/special_question_response.dart';
import '../entities/question.dart';
import '../entities/answer.dart';

abstract class DataRepository {
  Future<DataState<List<Question>>> getQuestions(String surveyID);

  Future<DataState<InterventionQuestionResponse>> getInterventionQuestions(String interventionID,
      {InterventionType? interventionType});

  Future<DataState<SpecialQuestionResponse>> getSpecialQuestions(String surveyID);

  Future<DataState<List<Answer>>> getResults(String type);

  Future<DataState<SubmitAnswerResponse>> sendResults({required String surveyID, required List<Answer> answers});

  Future<DataState<Survey>> startSurvey(String surveyID);

  Future<DataState<List<Survey>>> getPendingSurveys();
}

@LazySingleton(as: DataRepository)
class DataRepositoryImplement extends DataRepository {

  DataRepositoryImplement(this._dataService);

  final DataService _dataService;

  @override
  Future<DataState<List<Question>>> getQuestions(String surveyID) {
    return _dataService.getQuestions(surveyID);
  }

  @override
  Future<DataState<List<Answer>>> getResults(String type) {
    return _dataService.getResults(type);
  }

  @override
  Future<DataState<Survey>> startSurvey(String surveyID) {
    return _dataService.getSurveyDetail(surveyID);
  }

  @override
  Future<DataState<SubmitAnswerResponse>> sendResults({required String surveyID, required List<Answer> answers}) {
    return _dataService.sendResults(surveyID, answers);
  }

  @override
  Future<DataState<SpecialQuestionResponse>> getSpecialQuestions(String surveyID) {
    return _dataService.getSpecialQuestions(surveyID);
  }

  @override
  Future<DataState<List<Survey>>> getPendingSurveys() {
    return _dataService.getPendingSurveys();
  }

  @override
  Future<DataState<InterventionQuestionResponse>> getInterventionQuestions(String interventionID, {InterventionType? interventionType}) {
    return _dataService.getInterventionQuestions(interventionID, interventionType: interventionType);
  }
}