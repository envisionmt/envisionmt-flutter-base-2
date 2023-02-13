import 'package:injectable/injectable.dart';

abstract class BuildConfig {
  bool get debugLog;

  String get kBaseUrl;

  String get kBaseImageUrl;

  String get kDefaultAppName;

  String get kAppStoreUrl;

  String get kPlayStoreUrl;
}

@Injectable(as: BuildConfig, env: [Environment.dev])
@lazySingleton
class BuildConfigProd implements BuildConfig {
  @override
  bool debugLog = true;
  @override

  @override
  String kBaseUrl = 'http://3.22.53.148/api/v1/app';
  // String kBaseUrl = 'https://3add-2405-4802-70fe-e30-c1b7-5d28-cd0f-a981.ap.ngrok.io/api/v1/app';

  @override
  String kBaseImageUrl = '';
  @override
  String kDefaultAppName = 'App Care';

  @override
  String kAppStoreUrl = '';
  @override
  String kPlayStoreUrl = '';
}
