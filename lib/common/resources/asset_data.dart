import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class AssetData {
  static const String currencies = 'assets/data/currencies.json';
  static const String timezones = 'assets/data/timezones.json';
  static const String measurements = 'assets/data/measurements.json';

  //https://gist.githubusercontent.com/erdem/8c7d26765831d0f9a8c62f02782ae00d/raw/248037cd701af0a4957cce340dabb0fd04e38f4c/countries.json
  static const String countryTimezones = 'assets/data/timezones_countries.json';
}

extension AssetDataX on String {
  Future<dynamic> getJson({bool cache = true}) async {
    final String snapShot = await rootBundle.loadString(this, cache: cache);
    return jsonDecode(snapShot);
  }
}
