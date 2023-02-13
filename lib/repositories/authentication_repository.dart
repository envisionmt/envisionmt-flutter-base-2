import 'package:injectable/injectable.dart';
import 'package:project_care_app/common/enums/user_status.dart';
import 'package:project_care_app/data/local/keychain/shared_prefs.dart';
import 'package:project_care_app/data/remote/data_service.dart';
import 'package:project_care_app/data/remote/login/login_request.dart';
import 'package:project_care_app/data/remote/login/user_status_request.dart';

import '../common/api_client/data_state.dart';
import '../data/local/keychain/shared_prefs_key.dart';

abstract class AuthenticationRepository {
  Future<DataState<void>> login(LoginRequest data);

  Future<DataState<UserStatus>> checkUserStatus(UserStatusRequest data);

  Future<DataState<bool>> logout();
}

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(this._userService, this._sharedPrefs);

  final DataService _userService;
  final SharedPrefs _sharedPrefs;

  @override
  Future<DataState<void>> login(LoginRequest data) async {
    final result = await _userService.login(data);
    if (result.isSuccess() && result.data?.token != null) {
      _sharedPrefs.put(SharedPrefsKey.token, result.data?.token);
    }
    return result;
  }

  @override
  Future<DataState<bool>> logout() {
    return _userService.logout();
  }

  @override
  Future<DataState<UserStatus>> checkUserStatus(UserStatusRequest data) async {
    return _userService.checkUserStatus(data);
  }
}
