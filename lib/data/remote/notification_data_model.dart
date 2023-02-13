import 'package:project_care_app/common/enums/survey_type.dart';

import '../../entities/notification_data.dart';

class NotificationDataModel extends NotificationData {
  NotificationDataModel({
    String? surveyID,
    String? type,
    String? status,
  }) : super(
          surveyID: surveyID,
          type: SurveyCategoryX.initFrom(type),
          status: NotificationStatusX.initFrom(status),
        );

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      surveyID: json['id'],
      type: json['type'],
      status: json['status'],
    );
  }
}
