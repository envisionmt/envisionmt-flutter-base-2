import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:project_care_app/common/enums/intervention_type.dart';
import 'package:project_care_app/common/utils/extensions/interable_extension.dart';
import 'package:project_care_app/data/remote/login/login_request.dart';
import 'package:project_care_app/entities/answer.dart';
import 'package:project_care_app/entities/question.dart';

import '../../common/api_client/api_client.dart';
import '../../common/api_client/api_response.dart';
import '../../common/api_client/data_state.dart';
import '../../common/enums/user_status.dart';
import '../intervention_question_response.dart';
import '../special_question_response.dart';
import 'api_endpoint.dart';
import 'login/login_response.dart';
import 'login/user_status_request.dart';
import 'question_model.dart';
import 'submit_answer_response.dart';
import 'survey_model.dart';

abstract class DataService {
  Future<DataState<LoginResponse>> login(LoginRequest data);

  Future<DataState<bool>> logout();

  Future<DataState<UserStatus>> checkUserStatus(UserStatusRequest data);

  Future<DataState<List<QuestionModel>>> getQuestions(String surveyID);

  Future<DataState<SpecialQuestionResponse>> getSpecialQuestions(String surveyID);

  Future<DataState<InterventionQuestionResponse>> getInterventionQuestions(String interventionID,
      {InterventionType? interventionType});

  Future<DataState<List<Answer>>> getResults(String type);

  Future<DataState<SubmitAnswerResponse>> sendResults(String surveyID, List<Answer> answers);

  Future<DataState<SurveyModel>> getSurveyDetail(String surveyID);

  Future<DataState<List<SurveyModel>>> getPendingSurveys();
}

@LazySingleton(as: DataService)
class DataServiceImplement extends DataService {
  DataServiceImplement(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<List<QuestionModel>>> getQuestions(String surveyID) async {
    try {
      final ApiResponse result = await _apiClient.get(
        path: ApiEndpoint.question + '/$surveyID',
      );
      if (result.isSuccess()) {
        return DataSuccess<List<QuestionModel>>(
            List<QuestionModel>.from((result.data as List<dynamic>).map<Question>(
          (dynamic x) => QuestionModel.fromJson(x as Map<String, dynamic>),
        )));
      } else {
        return DataFailed<List<QuestionModel>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<List<QuestionModel>>(e.message);
    } on Exception catch (e) {
      return DataFailed<List<QuestionModel>>(e.toString());
    }
  }

  @override
  Future<DataState<List<Answer>>> getResults(String type) async {
    try {
      final ApiResponse result = await _apiClient.get(
        path: ApiEndpoint.question,
        queryParameters: {'type': type},
      );
      if (result.isSuccess()) {
        return DataSuccess<List<Answer>>(
            List<Answer>.from((result.data['data'] as List<dynamic>).map<Answer>(
          (dynamic x) => Answer.fromJson(x as Map<String, dynamic>),
        )));
      } else {
        return DataFailed<List<Answer>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<List<Answer>>(e.message);
    } on Exception catch (e) {
      return DataFailed<List<Answer>>(e.toString());
    }
  }

  @override
  Future<DataState<SubmitAnswerResponse>> sendResults(String surveyID, List<Answer> answers) async {
    try {
      final ApiResponse response = await _apiClient.post(
        path: ApiEndpoint.finishSurvey + '/$surveyID',
        data: answers.map((e) => e.toJson()).toList(),
      );
      if (response.isSuccess()) {
        return DataSuccess<SubmitAnswerResponse>(SubmitAnswerResponse.fromJson(response.data));
      } else {
        return DataFailed<SubmitAnswerResponse>(response.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<SubmitAnswerResponse>(e.message);
    } on Exception catch (e) {
      return DataFailed<SubmitAnswerResponse>(e.toString());
    }
  }

  @override
  Future<DataState<LoginResponse>> login(LoginRequest data) async {
    try {
      final ApiResponse response = await _apiClient.post(
        path: ApiEndpoint.login,
        data: data.toJson(),
      );
      if (response.isSuccess()) {
        return DataSuccess<LoginResponse>(LoginResponse.fromJson(response.data));
      } else {
        return DataFailed<LoginResponse>(response.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<LoginResponse>(e.message);
    } on Exception catch (e) {
      return DataFailed<LoginResponse>(e.toString());
    }
  }

  @override
  Future<DataState<SurveyModel>> getSurveyDetail(String surveyID) async {
    try {
      final ApiResponse response = await _apiClient.post(
        path: ApiEndpoint.startSurvey + '/$surveyID',
      );
      if (response.isSuccess()) {
        return DataSuccess<SurveyModel>(SurveyModel.fromJson(response.data));
      } else {
        return DataFailed<SurveyModel>(response.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<SurveyModel>(e.message);
    } on Exception catch (e) {
      return DataFailed<SurveyModel>(e.toString());
    }
  }

  @override
  Future<DataState<SpecialQuestionResponse>> getSpecialQuestions(String surveyID) async {
    try {
      final ApiResponse result =
          await _apiClient.get(path: ApiEndpoint.specialQuestion + '/$surveyID');
      if (result.isSuccess()) {
        return DataSuccess<SpecialQuestionResponse>(SpecialQuestionResponse.fromJson(result.data));
      } else {
        return DataFailed<SpecialQuestionResponse>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<SpecialQuestionResponse>(e.message);
    } on Exception catch (e) {
      return DataFailed<SpecialQuestionResponse>(e.toString());
    }
  }

  @override
  Future<DataState<List<SurveyModel>>> getPendingSurveys() async {
    try {
      final ApiResponse result = await _apiClient.get(path: ApiEndpoint.pendingSurveys);
      if (result.isSuccess()) {
        return DataSuccess<List<SurveyModel>>(
            List<SurveyModel>.from((result.data as List<dynamic>).map<SurveyModel>(
          (dynamic x) => SurveyModel.fromJson(x as Map<String, dynamic>),
        )));
      } else {
        return DataFailed<List<SurveyModel>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<List<SurveyModel>>(e.message);
    } on Exception catch (e) {
      return DataFailed<List<SurveyModel>>(e.toString());
    }
  }

  @override
  Future<DataState<UserStatus>> checkUserStatus(UserStatusRequest data) async {
    try {
      final ApiResponse response = await _apiClient.post(
        path: ApiEndpoint.checkUserStatus,
        data: data.toJson(),
      );
      if (response.isSuccess()) {
        return DataSuccess<UserStatus>(UserStatusX.initFrom(response.data as int?));
      } else {
        return DataFailed<UserStatus>(response.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<UserStatus>(e.message);
    } on Exception catch (e) {
      return DataFailed<UserStatus>(e.toString());
    }
  }

  @override
  Future<DataState<bool>> logout() async {
    try {
      final ApiResponse response = await _apiClient.post(
        path: ApiEndpoint.logout,
      );
      if (response.isSuccess()) {
        return const DataSuccess<bool>(true);
      } else {
        return DataFailed<bool>(response.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<bool>(e.message);
    } on Exception catch (e) {
      return DataFailed<bool>(e.toString());
    }
  }

  @override
  Future<DataState<InterventionQuestionResponse>> getInterventionQuestions(String interventionID,
      {InterventionType? interventionType}) async {
    try {
      final ApiResponse result = await _apiClient.get(
        path: ApiEndpoint.interventionQuestion + '/$interventionID',
        queryParameters: {'intervention_status': interventionType?.value}..removeNull(),
      );
      if (result.isSuccess()) {
        return DataSuccess<InterventionQuestionResponse>(
            InterventionQuestionResponse.fromJson(result.data));
      } else {
        return DataFailed<InterventionQuestionResponse>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<InterventionQuestionResponse>(e.message);
    } on Exception catch (e) {
      return DataFailed<InterventionQuestionResponse>(e.toString());
    }
  }
}
