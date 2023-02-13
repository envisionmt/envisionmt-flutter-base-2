import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../common/resources/asset_strings.dart';
import '../../common/utils/notification_service.dart';
import '../../data/app_singleton.dart';
import 'start_page.dart';
import 'gather_info_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    if (!AppSingleton.instance.isLogin || (AppSingleton.instance.studyID == null)) {
      if (kDebugMode) {
        print('User Not Existed');
      }
      return const GatherInfo();
    } else {
      if (kDebugMode) {
        print('User Existed');
      }
      return const StartPage();
    }
  }
}
