import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project_care_app/firebase_options.dart';

import '../common/utils/notification_service.dart';
import '../pages/route/app_route.dart';
import '../pages/route/navigator.dart';

class FirebaseUtils {
  static final FirebaseMessaging firebase = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await NotificationService.initialize();
    print('Token');
    final token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  static Future<String?> getToken() async {
    return FirebaseMessaging.instance.getToken();
    // if (Platform.isIOS) {
    //   return await FirebaseMessaging.instance.getAPNSToken();
    // } else {
    //   return FirebaseMessaging.instance.getToken();
    // }
  }

  /// Use in Home
  static setupNotify() {
    _onReceiveForegroundMessage();
    _openNotificationAppKill();
    _onReceiveBackgroundMessage();
    _onMessageOpenedApp();
  }

  static _onReceiveForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      NotificationService.display(message);
      NotificationService.handleNotification(message);
    });
  }

  static _onReceiveBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage((message) async {
      print('Received a background message');
      NotificationService.handleNotification(message);
    });
  }

  static _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      NotificationService.handleNotification(event);
    });
  }

  static _openNotificationAppKill() async {
    final message = await firebase.getInitialMessage();
    if (message == null) {
      return;
    }
    AppNavigator.pushNamed(RouterName.pendingSurvey);
  }
}
