import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_care_app/common/resources/app_colors.dart';
import 'package:project_care_app/common/utils/date_time.dart';
import 'package:project_care_app/entities/survey.dart';
import 'package:project_care_app/pages/auth/bloc/login_state.dart';
import 'package:project_care_app/pages/route/app_route.dart';
import 'package:project_care_app/pages/route/navigator.dart';
import 'package:project_care_app/pages/surveys/bloc/pending_survey_cubit.dart';
import 'package:project_care_app/pages/surveys/random_survey_page.dart';
import 'package:project_care_app/pages/surveys/survey_page.dart';

import '../../common/enums/request_status.dart';
import '../../common/enums/survey_type.dart';
import '../../common/resources/styles/text_styles.dart';
import '../../common/utils/widgets/loading_indicator.dart';
import '../../data/remote/submit_answer_response.dart';
import '../../di/injection.dart';
import '../Intervention/intervention_a.dart';
import '../auth/bloc/login_cubit.dart';
import '../widgets/content_widget.dart';
import 'bloc/pending_survey_state.dart';

class PendingSurveysPage extends StatelessWidget {
  const PendingSurveysPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LoginCubit>()),
        BlocProvider(create: (_) => getIt<PendingSurveyCubit>()..loadData()),
      ],
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          // switch (state.requestStatus) {
          //   case RequestStatus.initial:
          //     break;
          //   case RequestStatus.requesting:
          //     IgnoreLoadingIndicator().show(context);
          //     break;
          //   case RequestStatus.success:
          //     IgnoreLoadingIndicator().hide(context);
          //     AppNavigator.pushNamedAndRemoveUntil(RouterName.login, (Route<dynamic> route) => false);
          //     break;
          //   case RequestStatus.failed:
          //     IgnoreLoadingIndicator().hide(context);
          //     AppNavigator.pushNamedAndRemoveUntil(RouterName.login, (Route<dynamic> route) => false);
          //     break;
          // }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Pending'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.redAccent[100],
            // leading: const SizedBox(),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<LoginCubit>().logout();
                  AppNavigator.pushNamedAndRemoveUntil(RouterName.login, (Route<dynamic> route) => false);
                },
                child: const Text('Sign out', style: TextStyles.whiteHeaderRegular,),
              )
            ],
          ),
          body: BlocConsumer<PendingSurveyCubit, PendingSurveyState>(
            listener: _handleStateListener,
            builder: (context, state) {
              final bloc = context.read<PendingSurveyCubit>();
              return ContentBundle(
                onRefresh: (_) => bloc.refresh(),
                emptyAction: (_) => bloc.refresh(),
                status: state.status,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: state.surveys.length,
                  itemBuilder: (_, index) {
                    final survey = state.surveys[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: InkWell(
                        onTap: () => _onItemTapped(survey),
                        borderRadius: BorderRadius.circular(8),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: AppColors.orange300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                survey.type?.name ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              if (survey.startTime != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    survey.startTime?.toMMDDYYHHMMAString() ?? '',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onItemTapped(Survey item) {
    switch (item.type) {
      case SurveyCategory.morning:
      case SurveyCategory.evening:
        AppNavigator.pushNamed(RouterName.survey,
            arguments: SurveyArgs(surveyCategory: item.type, surveyID: item.id));
        break;
      case SurveyCategory.early:
      case SurveyCategory.mid:
      case SurveyCategory.late:
        AppNavigator.pushNamed(RouterName.randomSurvey,
            arguments: RandomSurveyArgs(surveyID: item.id));
        break;
      case SurveyCategory.intervention:
        AppNavigator.navigatorKey.currentState?.pushNamed(RouterName.interventionMorning,
            arguments:
            InterventionArgs(interventionResult: SubmitAnswerResponse(id: item.id)));
        break;
      default:
        break;
    }
  }

  Future<void> _handleStateListener(BuildContext context, PendingSurveyState state) async {
    switch (state.status) {
      case DataSourceStatus.empty:
      case DataSourceStatus.failed:
        // Future.delayed(const Duration(seconds: 1), () {
        //   AppNavigator.pushNamedAndRemoveUntil(RouterName.start, (route) => false);
        // });
        break;
      default:
        break;
    }
  }
}
