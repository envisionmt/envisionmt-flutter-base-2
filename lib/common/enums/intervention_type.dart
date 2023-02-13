import 'package:collection/collection.dart';

enum InterventionType {
  none(0),
  highNA(1),
  lowPA(2),
  highLonely(3),
  normal(4),
  highDailyNA(5);

  const InterventionType(this.value);

  final int value;
}

extension InterventionTypeX on InterventionType {
  static InterventionType? initFrom(int? value) {
    return InterventionType.values.firstWhereOrNull((InterventionType e) => e.value == value);
  }
}
