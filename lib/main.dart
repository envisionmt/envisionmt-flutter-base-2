import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:project_care_app/utils/device_info_util.dart';

import 'app.dart';
import 'configs/build_config.dart';
import 'di/injection.dart';
import 'utils/firebase_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseUtils.initialize();
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.dev,
  );
  await configureDependencies(environment);
  await DeviceInfoUtil.saveDeviceId();
  final BuildConfig buildConfig = getIt<BuildConfig>();
  if (buildConfig.debugLog) {
    Bloc.observer = AppBlocObserver();
  }
  runApp(MyApp());
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}