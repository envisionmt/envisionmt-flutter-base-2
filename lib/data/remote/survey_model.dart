import 'package:project_care_app/entities/survey.dart';

import '../../common/enums/survey_type.dart';

class SurveyModel extends Survey {
  SurveyModel({
    String? id,
    String? userID,
    int? type,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? surveyDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          userID: userID,
          type: SurveyCategoryX.initFrom(type?.toString()),
          startTime: startTime,
          endTime: endTime,
          surveyDate: surveyDate,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: json['id'] as String?,
      userID: json['user_id'] as String?,
      type: json['type'] as int?,
      startTime: json['start_time'] == null ? null : DateTime.parse(json['start_time']).add(DateTime.now().timeZoneOffset),
      endTime: json['end_time'] == null ? null : DateTime.parse(json['end_time']).add(DateTime.now().timeZoneOffset),
      surveyDate: DateTime.parse(json['survey_date']).toLocal(),
    );
  }
}
