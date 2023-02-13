import 'package:collection/collection.dart';
import 'package:project_care_app/common/enums/survey_type.dart';

class NotificationData {
  String? surveyID;
  SurveyCategory? type;
  NotificationStatus? status;

  NotificationData({
    this.surveyID,
    this.type,
    this.status,
  });
}

enum NotificationStatus {
  created('1'), sent('2'), clicked('3'), expired('4');
  const NotificationStatus(this.value);
  final String value;
}

extension NotificationStatusX on NotificationStatus {
  static NotificationStatus? initFrom(String? value) {
    return NotificationStatus.values.firstWhereOrNull((NotificationStatus e) => e.value == value);
  }
}