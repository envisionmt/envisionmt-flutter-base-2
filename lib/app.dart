import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_care_app/pages/Intervention/intervention_a.dart';
import 'package:project_care_app/pages/Intervention/intervention_lonely.dart';
import 'package:project_care_app/pages/Intervention/intervention_lonely_mood_log.dart';
import 'package:project_care_app/pages/Intervention/intervention_mood_log.dart';
import 'package:project_care_app/pages/Intervention/intervention_reminder.dart';
import 'package:project_care_app/pages/auth/gather_info_page.dart';
import 'package:project_care_app/pages/auth/wrapper_page.dart';
import 'package:project_care_app/pages/route/navigator.dart';
import 'package:project_care_app/pages/surveys/pending_surveys_page.dart';
import 'package:project_care_app/pages/surveys/random_survey_page.dart';
import 'package:project_care_app/pages/surveys/survey_page.dart';
import 'package:project_care_app/utils/firebase_utils.dart';

import 'generated/l10n.dart';
import 'pages/Intervention/intervention_log.dart';
import 'pages/route/app_route.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseUtils.setupNotify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Project Care App",
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        for (final Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      navigatorKey: AppNavigator.navigatorKey,
      onGenerateRoute: AppRoutes.onGenerateRoutes,
    );
  }
}
