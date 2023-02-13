import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:project_care_app/common/api_client/data_state.dart';
import 'package:project_care_app/common/enums/request_status.dart';
import 'package:project_care_app/common/enums/user_status.dart';
import 'package:project_care_app/data/app_singleton.dart';
import 'package:project_care_app/data/remote/login/login_request.dart';
import 'package:project_care_app/data/remote/login/login_response.dart';
import 'package:project_care_app/data/remote/login/user_status_request.dart';
import 'package:project_care_app/repositories/authentication_repository.dart';
import 'package:project_care_app/utils/device_info_util.dart';
import 'package:project_care_app/utils/firebase_utils.dart';

import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(LoginState());

  final AuthenticationRepository _authenticationRepository;
  String? name;

  Future<void> checkUser(String? name) async {
    if (name == null) {
      return;
    }
    this.name = name;
    final deviceID = await DeviceInfoUtil.getDeviceId();
    emit(LoginState(checkUserStatus: RequestStatus.requesting));
    final result = await _authenticationRepository.checkUserStatus(UserStatusRequest(
      name: name,
      deviceType: Platform.isAndroid ? '1' : '2',
      deviceID: deviceID,
    ));
    if (result.isSuccess()) {
      emit(state.copyWith(checkUserStatus: RequestStatus.success, userStatus: result.data));
    } else {
      emit(state.copyWith(checkUserStatus: RequestStatus.failed));
    }
  }

  Future<void> callLogin() async {
    final deviceToken = await FirebaseUtils.getToken();
    final deviceID = await DeviceInfoUtil.getDeviceId();
    final current = DateTime.now();
    var duration = current.timeZoneOffset;
    // final timezone =
    //     '${duration.isNegative ? '' : '+'}${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}';
    final timezone =
        '${duration.isNegative ? '' : '+'}${duration.inHours.toString().padLeft(2, '0')}:00';
    final deviceType = Platform.isAndroid ? '1' : '2';
    AppSingleton.instance.studyID = name;
    emit(state.copyWith(requestStatus: RequestStatus.requesting));
    final result = await _authenticationRepository.login(LoginRequest(
      name: name,
      deviceToken: deviceToken,
      deviceID: deviceID,
      deviceType: deviceType,
      timezone: timezone,
    ));
    emit(LoginState(
        requestStatus: result.isSuccess() ? RequestStatus.success : RequestStatus.failed));
  }

  Future<void> logout() async {
    emit(state.copyWith(requestStatus: RequestStatus.requesting));
    AppSingleton.instance.studyID = null;
    final result = await _authenticationRepository.logout();
    if (result.isSuccess()) {
      emit(state.copyWith(
          requestStatus: (result.data ?? false) ? RequestStatus.success : RequestStatus.failed));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.failed));
    }
  }
}
