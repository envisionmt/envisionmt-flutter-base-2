import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_care_app/common/enums/intervention_type.dart';
import 'package:project_care_app/common/enums/survey_type.dart';
import 'package:project_care_app/common/utils/extensions/buildcontext_extension.dart';
import 'package:project_care_app/pages/surveys/bloc/survey_cubit.dart';
import 'package:project_care_app/pages/widgets/content_widget.dart';
import 'package:project_care_app/pages/widgets/question_widget.dart';

import '../../common/enums/request_status.dart';
import '../../common/utils/widgets/loading_indicator.dart';
import '../../common/utils/widgets/status_toast.dart';
import '../../di/injection.dart';
import '../../entities/answer.dart';
import '../../entities/question.dart';
import '../Intervention/intervention_a.dart';
import '../route/app_route.dart';
import '../route/navigator.dart';
import 'bloc/survey_state.dart';

// This document shows the morning survey, the responses to the data are stored in the finalanswers MAP.
// Once the participant submits the survey DatabseServices is called which adds the response to the firebase database

class SurveyArgs {
  String? surveyID;
  SurveyCategory? surveyCategory;

  SurveyArgs({
    this.surveyID,
    this.surveyCategory,
  });
}

class SurveyPage extends StatelessWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SurveyArgs? args = context.getRouteArguments();
    return BlocProvider<SurveyCubit>(
      create: (_) => getIt<SurveyCubit>()..getData(args?.surveyID),
      child: Scaffold(
        appBar: AppBar(
          title: Text(args?.surveyCategory?.name ?? ''),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.redAccent[100],
        ),
        body: BlocConsumer<SurveyCubit, SurveyState>(
          listener: _handleStateListener,
          builder: (context, state) {
            final bloc = context.read<SurveyCubit>();
            return Column(
              children: [
                Expanded(
                  child: ContentBundle(
                    onRefresh: (_) => bloc.refresh(),
                    emptyAction: (_) => bloc.refresh(),
                    status: state.status,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: (state.questions ?? []).length,
                        itemBuilder: (_, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: QuestionWidget(
                                index: index + 1,
                                question: state.questions?[index],
                                onAnswerChanged: (answer) => bloc.changeAnswerAt(index, answer),
                              ),
                            )),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepOrange[100]),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 16))),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  onPressed: () => _onSubmit(context, bloc),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleStateListener(BuildContext context, SurveyState state) async {
    switch (state.initRequestStatus) {
      case RequestStatus.initial:
        break;
      case RequestStatus.requesting:
        IgnoreLoadingIndicator().show(context);
        break;
      case RequestStatus.success:
        IgnoreLoadingIndicator().hide(context);
        break;
      case RequestStatus.failed:
        IgnoreLoadingIndicator().hide(context);
        showFailureMessage(context, state.errorMessage);
        break;
    }

    switch (state.requestStatus) {
      case RequestStatus.initial:
        break;
      case RequestStatus.requesting:
        IgnoreLoadingIndicator().show(context);
        break;
      case RequestStatus.success:
        IgnoreLoadingIndicator().hide(context);
        if (state.interventionResult != null) {
          AppNavigator.pushNamedAndRemoveUntil(RouterName.start, (route) => false);
        }
        break;
      case RequestStatus.failed:
        IgnoreLoadingIndicator().hide(context);
        showFailureMessage(context, state.errorMessage);
        Future.delayed(
          const Duration(seconds: 2),
          () {
            AppNavigator.pushNamedAndRemoveUntil(RouterName.start, (route) => false);
          },
        );
        break;
    }
  }

  bool _validateAnswer(List<Answer>? answers) {
    for (var element in (answers ?? [])) {
      if (element.answer == null && element.optionIDs == null) {
        return false;
      }
    }
    return true;
  }

  void _onSubmit(BuildContext context, SurveyCubit bloc) {
    if (!_validateAnswer(bloc.state.answers)) {
      showFailureMessage(context, 'Please fill out all answer!');
      return;
    }
    bloc.submitAnswers();
  }
}
