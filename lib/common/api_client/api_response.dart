import 'message_parser.dart';

class ApiResponse {
  ApiResponse({this.success, this.data, this.statusCode, this.message});

  ApiResponse.fromJson(Map<String?, dynamic> json) {
    data = json['data'];
    success = json['success'] == null ? data != null : json['success'] as bool;
    statusCode = json['status_code'] == null ? null : json['status_code'] as int;
    if (statusCode != null && messageParser[statusCode] != null) {
      message = messageParser[statusCode];
    } else if (json['error'] != null) {
      if (json['error'] is String) {
        message = json['error'] as String;
      } else if (json['error'] is Map<String, dynamic>) {
        message = json['error']['notification_at'].toString();
      }
    }
  }

  bool? success;
  dynamic data;
  int? statusCode;
  String? message;

  bool isSuccess() => success ?? false;
}
