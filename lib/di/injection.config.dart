// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i5;

import '../common/api_client/api_client.dart' as _i7;
import '../configs/build_config.dart' as _i3;
import '../data/local/keychain/shared_prefs.dart' as _i6;
import '../data/remote/data_service.dart' as _i8;
import '../pages/auth/bloc/login_cubit.dart' as _i13;
import '../pages/Intervention/bloc/intervention_cubit.dart' as _i11;
import '../pages/Intervention/bloc/intervention_morning_cubit.dart' as _i12;
import '../pages/surveys/bloc/pending_survey_cubit.dart' as _i14;
import '../pages/surveys/bloc/random_survey_cubit.dart' as _i15;
import '../pages/surveys/bloc/survey_cubit.dart' as _i16;
import '../repositories/authentication_repository.dart' as _i9;
import '../repositories/data_repository.dart' as _i10;
import 'modules.dart' as _i17;

const String _dev = 'dev';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final injectableModule = _$InjectableModule();
  gh.factory<_i3.BuildConfig>(
    () => _i3.BuildConfigProd(),
    registerFor: {_dev},
  );
  gh.lazySingleton<_i4.Dio>(() => injectableModule.dio);
  await gh.factoryAsync<_i5.SharedPreferences>(
    () => injectableModule.prefs,
    preResolve: true,
  );
  gh.lazySingleton<_i6.SharedPrefs>(
      () => _i6.SharedPrefs(get<_i5.SharedPreferences>()));
  gh.singleton<_i7.ApiClient>(_i7.ApiClient(dio: get<_i4.Dio>()));
  gh.lazySingleton<_i8.DataService>(
      () => _i8.DataServiceImplement(get<_i7.ApiClient>()));
  gh.lazySingleton<_i9.AuthenticationRepository>(
      () => _i9.AuthenticationRepositoryImpl(
            get<_i8.DataService>(),
            get<_i6.SharedPrefs>(),
          ));
  gh.lazySingleton<_i10.DataRepository>(
      () => _i10.DataRepositoryImplement(get<_i8.DataService>()));
  gh.factory<_i11.InterventionCubit>(
      () => _i11.InterventionCubit(get<_i10.DataRepository>()));
  gh.factory<_i12.InterventionMorningCubit>(
      () => _i12.InterventionMorningCubit(get<_i10.DataRepository>()));
  gh.factory<_i13.LoginCubit>(
      () => _i13.LoginCubit(get<_i9.AuthenticationRepository>()));
  gh.factory<_i14.PendingSurveyCubit>(
      () => _i14.PendingSurveyCubit(get<_i10.DataRepository>()));
  gh.factory<_i15.RandomSurveyCubit>(
      () => _i15.RandomSurveyCubit(get<_i10.DataRepository>()));
  gh.factory<_i16.SurveyCubit>(
      () => _i16.SurveyCubit(get<_i10.DataRepository>()));
  return get;
}

class _$InjectableModule extends _i17.InjectableModule {}
