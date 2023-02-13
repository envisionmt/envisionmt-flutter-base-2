import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/entities/survey.dart';
import 'package:project_care_app/pages/widgets/content_widget.dart';

class PendingSurveyState {
  List<Survey> surveys;
  DataSourceStatus status;

  PendingSurveyState({
    this.surveys = const [],
    this.status = DataSourceStatus.initial,
  });

  PendingSurveyState copyWith({
    List<Survey>? surveys,
    DataSourceStatus? status,
  }) {
    return PendingSurveyState(
      status: status ?? this.status,
      surveys: surveys ?? this.surveys,
    );
  }
}
