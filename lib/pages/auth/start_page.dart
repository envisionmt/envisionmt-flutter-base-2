import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_care_app/common/resources/index.dart';
import 'package:project_care_app/common/utils/widgets/loading_indicator.dart';
import 'package:project_care_app/di/injection.dart';
import 'package:project_care_app/pages/auth/bloc/login_cubit.dart';
import 'package:project_care_app/pages/auth/bloc/login_state.dart';
import 'package:project_care_app/pages/route/navigator.dart';
import 'package:project_care_app/pages/surveys/bloc/pending_survey_cubit.dart';

import '../../common/enums/request_status.dart';
import '../../common/enums/user_status.dart';
import '../../common/resources/styles/text_styles.dart';
import '../../data/app_singleton.dart';
import '../route/app_route.dart';
import '../surveys/bloc/pending_survey_state.dart';
import '../widgets/content_widget.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  bool _firstShowPending = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LoginCubit>()..checkUser(AppSingleton.instance.studyID)),
        BlocProvider(
          create: (_) {
            final bloc = getIt<PendingSurveyCubit>();
            if ((AppSingleton.instance.accessToken ?? '').isNotEmpty) {
              return bloc..loadData();
            }
            return bloc;
          },
        ),
      ],
      child: BlocListener<PendingSurveyCubit, PendingSurveyState>(
          listener: (context, state) {
            switch (state.status) {
              case DataSourceStatus.initial:
                IgnoreLoadingIndicator().hide(context);
                break;
              case DataSourceStatus.loading:
              case DataSourceStatus.refreshing:
                IgnoreLoadingIndicator().show(context);
                break;
              case DataSourceStatus.empty:
              case DataSourceStatus.success:
              case DataSourceStatus.failed:
                IgnoreLoadingIndicator().hide(context);
                if (state.surveys.isNotEmpty && _firstShowPending) {
                  if (ModalRoute.of(context)?.settings.name != RouterName.pendingSurvey) {
                    AppNavigator.pushNamed(RouterName.pendingSurvey);
                  }
                }
                _firstShowPending = false;
                break;
              case DataSourceStatus.loadMore:
                break;
            }
          },
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              switch (state.checkUserStatus) {
                case RequestStatus.initial:
                  break;
                case RequestStatus.requesting:
                  // IgnoreLoadingIndicator().show(context);
                  break;
                case RequestStatus.success:
                  // IgnoreLoadingIndicator().hide(context);
                  switch (state.userStatus) {
                    case UserStatus.newUser:
                      context.read<LoginCubit>().logout();
                      AppNavigator.pushNamedAndRemoveUntil(
                          RouterName.login, (Route<dynamic> route) => false);
                      break;
                    default:
                      break;
                  }
                  break;
                case RequestStatus.failed:
                  IgnoreLoadingIndicator().hide(context);
                  break;
              }
            },
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) => MaterialApp(
                home: Scaffold(
                  appBar: AppBar(
                    title: const Text('Home'),
                    centerTitle: true,
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.read<LoginCubit>().logout();
                          AppNavigator.pushNamed(RouterName.pendingSurvey);
                        },
                        child: const Text(
                          'Pending',
                          style: TextStyles.whiteHeaderRegular,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<LoginCubit>().logout();
                          AppNavigator.pushNamedAndRemoveUntil(
                              RouterName.login, (Route<dynamic> route) => false);
                        },
                        icon: AssetImages.iconLogout.toSvg(color: AppColors.white),
                      )
                    ],
                  ),
                  body: Image.asset(
                    'assets/CARE_App_Home.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
