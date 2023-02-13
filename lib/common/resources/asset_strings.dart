// ignore_for_file: always_specify_types
// ignore: avoid_classes_with_only_static_members
import '../../generated/l10n.dart';

class Strings {
  static final localized = S.current;

  static String get serviceLimitReached => localized.serviceLimitReached;

  static String get networkErrorMessage => localized.networkErrorMessage;

  static String get somethingWentWrong => localized.somethingWentWrong;
}
