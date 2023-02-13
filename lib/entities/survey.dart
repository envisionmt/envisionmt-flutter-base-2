import '../common/enums/survey_type.dart';

class Survey {
  String? id;
  String? userID;
  SurveyCategory? type;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? surveyDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;

  Survey({
    this.id,
    this.userID,
    this.type,
    this.startTime,
    this.endTime,
    this.surveyDate,
    this.createdAt,
    this.updatedAt,
    this.title,
  });
}