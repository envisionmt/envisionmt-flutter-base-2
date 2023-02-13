// ignore_for_file: always_specify_types
// ignore: avoid_classes_with_only_static_members
class ApiEndpoint {
  static const String login = '/guest/login';
  static const String logout = '/account/logout';
  static const String checkUserStatus = '/guest/check-user';
  static const String question = '/surveys/questions';
  static const String specialQuestion = '/surveys/special-questions';
  static const String finishSurvey = '/surveys/finish';
  static const String startSurvey = '/surveys/start';
  static const String surveyResults = '/surveys/results';
  static const String pendingSurveys = '/surveys/pending';
  static const String interventionQuestion = '/surveys/intervention-questions';
}
