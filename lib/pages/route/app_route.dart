import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_care_app/pages/Intervention/intervention_morning_page.dart';
import 'package:project_care_app/pages/auth/gather_info_page.dart';
import 'package:project_care_app/pages/route/navigator.dart';
import 'package:project_care_app/pages/surveys/pending_surveys_page.dart';
import 'package:project_care_app/pages/surveys/random_survey_page.dart';

import '../Intervention/intervention_log.dart';
import '../Intervention/intervention_lonely.dart';
import '../Intervention/intervention_lonely_mood_log.dart';
import '../Intervention/intervention_mood_log.dart';
import '../Intervention/intervention_reminder.dart';
import '../Intervention/intervention_b.dart';
import '../Intervention/intervention_a.dart';
import '../auth/start_page.dart';
import '../auth/wrapper_page.dart';
import '../surveys/survey_page.dart';

// ignore_for_file: avoid_classes_with_only_static_members
class RouterName {
  static const String bootstrap = '/';
  static const String start = '/start';
  static const String login = '/login';
  static const String survey = '/survey';
  static const String randomSurvey = '/randomSurvey';
  static const String interventionA = '/InterventionA';
  static const String interventionMood = '/InterventionMood';
  static const String interventionLMood = '/InterventionLMood';
  static const String interventionRemind = '/InterventionRemind';
  static const String interventionB = '/InterventionB';
  static const String interventionLonely = '/InterventionLonely';
  static const String interventionLog = '/InterventionLog';
  static const String interventionMorning = '/interventionMorning';
  static const String pendingSurvey = '/pendingSurvey';
}

class AppRoutes {
  static Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
    print('Navigate to:' + (settings.name ?? ''));
    switch (settings.name) {
      case RouterName.bootstrap:
        return _materialRoute(settings, const Wrapper());
      case RouterName.start:
        return _materialRoute(settings, const StartPage());
      case RouterName.login:
        return _materialRoute(settings, const GatherInfo());
      case RouterName.survey:
        return _materialRoute(settings, const SurveyPage());
      case RouterName.randomSurvey:
        return _materialRoute(settings, const RandomSurveyPage());
      case RouterName.interventionA:
        // For evey intervention this is the first page displayed, the page displays the text located in the notification details
        return _materialRoute(settings, const InterventionA());
      case RouterName.interventionMood:
        // second page displayed if they answered yes to barriers, for the High NA intervention
        return _materialRoute(settings, InterventionMood());
      case RouterName.interventionLMood:
        // 3 page displayed for the High Lonely intervention
        return _materialRoute(settings, InterventionLMood());
      case RouterName.interventionRemind:
        // 3rd page displayed for the High NA intervention
        return _materialRoute(settings, InterventionRemind());
      case RouterName.interventionB:
        return _materialRoute(settings, const InterventionB());
      case RouterName.interventionLonely:
        // 2nd page displayed for the High Lonely intervention
        return _materialRoute(settings, InterventionLonely());
      case RouterName.interventionLog:
        return _materialRoute(settings, InterventionLog());
      case RouterName.interventionMorning:
        return _materialRoute(settings, InterventionMorning());
      case RouterName.pendingSurvey:
        return _materialRoute(settings, const PendingSurveysPage());
      default:
        return _materialRoute(settings, const StartPage());
    }
  }

  static Route<dynamic> _materialRoute(RouteSettings settings, Widget view) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => view,
    );
  }

  static Route<dynamic> _pageRouteBuilderWithPresentEffect(RouteSettings settings, Widget view) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          view,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        const Offset begin = Offset(0.0, 1.0);
        const Offset end = Offset.zero;
        final Cubic curve = Curves.ease;

        final Animatable<Offset> tween =
            Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route<dynamic> _pageRouteBuilderWithFadeEffect(RouteSettings settings, Widget view) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      opaque: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          view,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
