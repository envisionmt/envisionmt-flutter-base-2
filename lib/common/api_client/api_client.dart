import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../configs/build_config.dart';
import '../../di/injection.dart';
import '../resources/asset_strings.dart';
import 'api_response.dart';
import 'interceptors/auth_interceptor.dart';

@singleton
class ApiClient {
  ApiClient({required this.dio}) {
    final BuildConfig buildConfig = getIt<BuildConfig>();
    dio.options.baseUrl = buildConfig.kBaseUrl;
    dio.options.headers['API-Version'] = 'v1';
    // dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.connectTimeout = const Duration(minutes: 3).inMilliseconds;
    dio.options.receiveTimeout = const Duration(minutes: 3).inMilliseconds;
    dio.interceptors.add(AuthInterceptor());
    if (buildConfig.debugLog) {
      dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }
  }

  final Dio dio;

  Future<ApiResponse> post(
      {required String path,
      dynamic data,
      ProgressCallback? onSendProgress,
      CancelToken? cancelToken}) async {
    return responseWrapper(dio.post<dynamic>(path,
        data: data, onSendProgress: onSendProgress, cancelToken: cancelToken));
  }

  Future<ApiResponse> put({required String path, dynamic data}) async {
    return responseWrapper(dio.put<dynamic>(path, data: data));
  }

  Future<ApiResponse> patch({required String path, dynamic data}) async {
    return responseWrapper(dio.patch<dynamic>(path, data: data));
  }

  Future<ApiResponse> delete({required String path, dynamic data}) async {
    return responseWrapper(dio.delete<dynamic>(path, data: data));
  }

  Future<ApiResponse> get({required String path, Map<String, dynamic>? queryParameters}) async {
    return responseWrapper(dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
    ));
  }

  Future<ApiResponse> download({required String path, required String savePath}) async {
    try {
      await dio.download(path, savePath);
      return ApiResponse(success: true, statusCode: 200);
    } on DioError catch (e) {
      return _handleRequestError(e);
    }
  }

  Future<ApiResponse> responseWrapper(Future<Response<dynamic>> func) async {
    try {
      final Response<dynamic> response = await func;
      if (response.data is Map<String?, dynamic>) {
        return ApiResponse.fromJson(response.data as Map<String?, dynamic>);
      }
      return ApiResponse(
        success: false,
        statusCode: 500,
        message: Strings.somethingWentWrong,
      );
    } on DioError catch (e) {
      return _handleRequestError(e);
    }
  }

  ApiResponse _handleRequestError(DioError e) {
    if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.other) {
      return ApiResponse(
        success: false,
        statusCode: 500,
        message: Strings.networkErrorMessage,
      );
    }
    if (e.response == null || e.response?.data == null) {
      return ApiResponse(
        success: false,
        statusCode: 500,
        message: Strings.somethingWentWrong,
      );
    }

    if (e.response?.data is Map<String?, dynamic>) {
      return ApiResponse.fromJson(e.response?.data as Map<String?, dynamic>);
    }

    return ApiResponse(
      success: false,
      statusCode: 500,
      message: Strings.somethingWentWrong,
    );
  }
}
