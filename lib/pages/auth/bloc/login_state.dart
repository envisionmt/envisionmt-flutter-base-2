import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/common/enums/user_status.dart';

class LoginState {
  RequestStatus requestStatus;
  RequestStatus checkUserStatus;
  UserStatus? userStatus;

  LoginState({
    this.requestStatus = RequestStatus.initial,
    this.checkUserStatus = RequestStatus.initial,
    this.userStatus,
  });

  LoginState copyWith({
    RequestStatus? requestStatus,
    RequestStatus? checkUserStatus,
    UserStatus? userStatus,
  }) {
    return LoginState(
      requestStatus: requestStatus ?? RequestStatus.initial,
      checkUserStatus: checkUserStatus ?? RequestStatus.initial,
      userStatus: userStatus ?? this.userStatus,
    );
  }
}
