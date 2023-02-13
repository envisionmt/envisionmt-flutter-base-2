import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_care_app/common/event/event_bus_mixin.dart';

// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:project_care_app/data/remote/notification_data_model.dart';
import 'package:project_care_app/data/remote/submit_answer_response.dart';
import 'package:project_care_app/pages/Intervention/intervention_a.dart';
import 'package:project_care_app/pages/route/app_route.dart';
import 'package:project_care_app/pages/surveys/help/even_bus_event.dart';
import 'package:project_care_app/pages/surveys/survey_page.dart';
import 'package:rxdart/subjects.dart';

// import 'package:timezone/data/latest.dart' as tzi;
// import 'package:timezone/timezone.dart' as tz;

import '../../entities/notification_data.dart';
import '../../entities/received_notification.dart';
import '../../pages/route/navigator.dart';
import '../../pages/surveys/random_survey_page.dart';
import '../enums/survey_type.dart';

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

class NotificationService with EventBusMixin {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // await _configureLocalTimeZone();
    InitializationSettings initializationSettings = InitializationSettings(
        android: const AndroidInitializationSettings("@mipmap/launcher_icon"),
        iOS: IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
          ) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ));
          },
        ));

    _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    _notificationsPlugin.initialize(initializationSettings, onSelectNotification: (route) {
      //handle click when click app mode background or force ground
      print("on click $route");
      handleLocalNotification(route, isTap: true);
    });
  }

  static void display(RemoteMessage? message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "approach",
            "app_channel",
            icon: "@mipmap/launcher_icon",
            importance: Importance.max,
            priority: Priority.high,
            timeoutAfter: 1800000,
          ),
          iOS: IOSNotificationDetails());
      await _notificationsPlugin.show(
        id,
        message?.notification?.title ?? message?.data['title'],
        message?.notification?.body ?? message?.data['body'],
        notificationDetails,
        payload: jsonEncode(message?.data),
      );
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Future<void> handleNotification(RemoteMessage? message, {bool isTap = false}) async {
    debugPrint(
        "===============================Data from notification=====================\n$message");
    print('A new message opened app event was published');
    final NotificationData data = NotificationDataModel.fromJson(message?.data ?? {});
    if (data.type != null) {
      EventBusMixin.shareStaticEvent(InComingSurveyEvent());
    }
    if (message != null && isTap) {
      if (data.status == NotificationStatus.expired) {
        return;
      }
      if (data.surveyID != null) {
        switch (data.type) {
          case SurveyCategory.morning:
          case SurveyCategory.evening:
            Future.delayed(const Duration(milliseconds: 1000), () async {
              AppNavigator.pushNamed(RouterName.survey,
                  arguments: SurveyArgs(
                    surveyID: data.surveyID,
                    surveyCategory: data.type,
                  ));
            });
            break;
          case SurveyCategory.early:
          case SurveyCategory.mid:
          case SurveyCategory.late:
          Future.delayed(const Duration(milliseconds: 1000), () async {
            AppNavigator.pushNamed(RouterName.randomSurvey,
                arguments: RandomSurveyArgs(
                  surveyID: data.surveyID,
                ));
          });
            break;
          case SurveyCategory.intervention:
            Future.delayed(const Duration(milliseconds: 1000), () async {
              AppNavigator.pushNamed(RouterName.interventionMorning,
                  arguments:
                  InterventionArgs(interventionResult: SubmitAnswerResponse(id: data.surveyID)));
            });
            break;
          default:
            break;
        }
      }
    }
  }

  static Future<void> handleLocalNotification(String? message, {bool isTap = false}) async {
    debugPrint(
        "===============================Data from notification=====================\n$message");
    final NotificationData data = NotificationDataModel.fromJson(jsonDecode(message ?? ''));
    if (data.type != null) {
      EventBusMixin.shareStaticEvent(InComingSurveyEvent());
    }
    if (message != null && isTap) {
      if (data.status == NotificationStatus.expired) {
        return;
      }
      if (data.surveyID != null) {
        switch (data.type) {
          case SurveyCategory.morning:
          case SurveyCategory.evening:
            Future.delayed(const Duration(milliseconds: 1000), () async {
              AppNavigator.pushNamed(RouterName.survey,
                  arguments: SurveyArgs(
                    surveyID: data.surveyID,
                    surveyCategory: data.type,
                  ));
            });
            break;
          case SurveyCategory.early:
          case SurveyCategory.mid:
          case SurveyCategory.late:
            Future.delayed(const Duration(milliseconds: 1000), () async {
              AppNavigator.pushNamed(RouterName.randomSurvey,
                  arguments: RandomSurveyArgs(
                    surveyID: data.surveyID,
                  ));
            });
            break;
          case SurveyCategory.intervention:
            Future.delayed(const Duration(milliseconds: 1000), () async {
              AppNavigator.pushNamed(RouterName.interventionMorning,
                  arguments:
                  InterventionArgs(interventionResult: SubmitAnswerResponse(id: data.surveyID)));
            });
            break;
          default:
            break;
        }
      }
    }
  }

// static Future<void> _configureLocalTimeZone() async {
//   tzi.initializeTimeZones();
//   final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(timeZone));
// }
//
// /// Set right date and time for notifications
// static tz.TZDateTime _convertTime(int hour, int minutes, int second) {
//   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//   tz.TZDateTime scheduleDate = tz.TZDateTime(
//     tz.local,
//     now.year,
//     now.month,
//     now.day,
//     hour,
//     minutes,
//     second,
//   );
//   if (scheduleDate.isBefore(now)) {
//     scheduleDate = scheduleDate.add(const Duration(days: 1));
//   }
//   return scheduleDate;
// }
//
// /// Scheduled Notification
// static scheduledNotification({
//   required int hour,
//   required int minutes,
//   required int seconds,
//   required int id,
//   required String title,
//   required String body,
//   String? payload,
//   String? sound,
// }) async {
//   await _notificationsPlugin.zonedSchedule(
//     id,
//     title,
//     body,
//     _convertTime(hour, minutes, seconds),
//     NotificationDetails(
//       android: AndroidNotificationDetails(
//         'your channel id $sound',
//         'your channel name',
//         channelDescription: 'your channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         sound: sound == null ? null : RawResourceAndroidNotificationSound(sound),
//       ),
//       iOS: IOSNotificationDetails(sound: sound == null ? null : '$sound.mp3'),
//     ),
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//     payload: payload,
//   );
// }
//
// cancelAll() async => await _notificationsPlugin.cancelAll();
//
// cancel(id) async => await _notificationsPlugin.cancel(id);
}
