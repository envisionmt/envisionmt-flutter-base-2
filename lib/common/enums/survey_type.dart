import 'package:collection/collection.dart';

enum SurveyCategory {
  morning('1'),
  early('2'),
  mid('3'),
  late('4'),
  evening('5'),
  intervention('6');

  const SurveyCategory(this.value);

  final String value;
}

extension SurveyCategoryX on SurveyCategory {
  static SurveyCategory? initFrom(String? value) {
    return SurveyCategory.values.firstWhereOrNull((SurveyCategory e) => e.value == value);
  }

  String get name {
    switch (this) {
      case SurveyCategory.morning:
        return 'Morning Survey';
      case SurveyCategory.evening:
        return 'Evening Survey';
      case SurveyCategory.early:
      case SurveyCategory.mid:
      case SurveyCategory.late:
        return 'Random Survey';
      case SurveyCategory.intervention:
        return 'Morning Intervention';
    }
  }
}
