import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoUtil {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static const storage = FlutterSecureStorage();
  static String deviceStorageKey = 'device_id';

  static Future saveDeviceId() async {
    String? deviceId = await storage.read(key: deviceStorageKey);
    if ((deviceId ?? '').isNotEmpty) {
      return;
    }
    deviceId = await _getDeviceFromDevice();
    await storage.write(key: deviceStorageKey, value: deviceId);
  }

  static Future<String?> getDeviceId() async {
    final value = await storage.read(key: deviceStorageKey);
    return value;
  }

  static Future<String> _getDeviceFromDevice() async {
    String? deviceId;
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
    }
    return deviceId ?? const Uuid().v1();
  }

  static Future<String?> getDeviceName() async {
    String? deviceName;
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceName = iosDeviceInfo.model;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceName = androidDeviceInfo.model;
    }
    return deviceName;
  }
}