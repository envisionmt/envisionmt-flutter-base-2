import 'package:collection/collection.dart';

enum UserStatus {
  newUser(1),
  oldUser(2),
  existUser(3);

  const UserStatus(this.value);

  final int value;
}

extension UserStatusX on UserStatus {
  static UserStatus? initFrom(int? value) {
    return UserStatus.values.firstWhereOrNull((UserStatus e) => e.value == value);
  }
}