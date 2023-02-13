import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_care_app/common/enums/intervention_type.dart';
import 'package:project_care_app/common/utils/extensions/buildcontext_extension.dart';
import 'package:project_care_app/data/intervention_question_response.dart';
import 'package:project_care_app/di/injection.dart';
import 'package:project_care_app/entities/answer.dart';
import 'package:project_care_app/entities/question.dart';
import 'package:project_care_app/pages/Intervention/bloc/intervention_cubit.dart';
import 'package:project_care_app/pages/Intervention/bloc/intervention_state.dart';

import '../../common/enums/request_status.dart';
import '../../common/utils/widgets/loading_indicator.dart';
import '../../common/utils/widgets/status_toast.dart';
import '../../data/remote/submit_answer_response.dart';
import '../route/app_route.dart';
import '../route/navigator.dart';
import '../widgets/question_widget.dart';

class InterventionArgs {
  final SubmitAnswerResponse? interventionResult;
  final InterventionQuestionResponse? interventionQuestions;
  final List<Answer>? socialAnswers;
  final List<Answer>? helpAnswers;
  final List<Answer>? cogAnswers;
  final List<Answer>? panasAnswers;
  final List<Question>? socialQuestions;
  final List<Question>? helpQuestions;
  final List<Question>? cogQuestions;
  final List<Question>? panasQuestions;

  List<Answer>? interventionAAnswer;
  List<Answer>? interventionMoodAnswer;
  List<Answer>? interventionReminderAnswer;
  List<Answer>? interventionLonelyAnswer;
  List<Answer>? interventionLMoodAnswer;
  List<Answer>? interventionLogAnswer;

  InterventionArgs({
    this.interventionResult,
    this.interventionQuestions,
    this.socialAnswers,
    this.socialQuestions,
    this.helpAnswers,
    this.cogAnswers,
    this.panasAnswers,
    this.helpQuestions,
    this.cogQuestions,
    this.panasQuestions,
    this.interventionAAnswer,
    this.interventionMoodAnswer,
    this.interventionReminderAnswer,
    this.interventionLonelyAnswer,
    this.interventionLMoodAnswer,
    this.interventionLogAnswer,
  });
}

class InterventionA extends StatefulWidget {
  const InterventionA({
    Key? key,
    this.interventionType,
    this.answers,
  }) : super(key: key);

  final InterventionType? interventionType;
  final List<Answer>? answers;

  @override
  _InterventionAState createState() => _InterventionAState();
}

class _InterventionAState extends State<InterventionA> {
  @override
  Widget build(BuildContext context) {
    final InterventionArgs? args = context.getRouteArguments();
    final questions = args?.interventionQuestions?.interventionAQuestions ?? [];
    return BlocProvider<InterventionCubit>(
      create: (_) => getIt<InterventionCubit>()..init(args),
      child: BlocConsumer<InterventionCubit, InterventionState>(
          listener: (context, state) {
            switch (state.requestStatus) {
              case RequestStatus.initial:
                break;
              case RequestStatus.requesting:
                IgnoreLoadingIndicator().show(context);
                break;
              case RequestStatus.success:
                IgnoreLoadingIndicator().hide(context);
                AppNavigator.pushNamedAndRemoveUntil(RouterName.start, (route) => false);
                break;
              case RequestStatus.failed:
                IgnoreLoadingIndicator().hide(context);
                showFailureMessage(context, state.errorMessage);
                break;
            }
          },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orangeAccent[200],
              title: const Text('Intervention A'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    AppNavigator.pushNamedAndRemoveUntil(RouterName.start, (route) => false);
                  },
                )
              ],
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: questions.length,
                        itemBuilder: (_, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: QuestionWidget(
                                index: questions.length == 1 ? null : index + 1,
                                question: questions[index],
                                showTextTypeInputField: false,
                                textTypeBackground: Colors.orangeAccent[100]?.withOpacity(0.6),
                                onAnswerChanged: (answer) {
                                  // final index = args?.interventionAAnswer?.indexWhere(
                                  //         (element) => element.questionID == answer?.questionID) ??
                                  //     -1;
                                  // if (index >= 0 && answer != null) {
                                  //   args?.interventionAAnswer?[index] = answer;
                                  // }
                                },
                              ),
                            )),
                  ),
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepOrange[100]),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 50, vertical: 20))),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () => _navigateIntervention(context, args)),
                const SizedBox(height: 16)
              ],
            ),
          );
        }
      ),
    );
  }

  void _navigateIntervention(BuildContext context, InterventionArgs? args) {
    switch (args?.interventionResult?.status) {
      case InterventionType.highNA:
        AppNavigator.pushNamed(RouterName.interventionMood, arguments: args);
        break;
      // case InterventionType.lowPA:
      // case InterventionType.highDailyNA:
      // case InterventionType.normal:
      //   AppNavigator.pushNamed(RouterName.interventionB, arguments: args);
      //   break;
      case InterventionType.highLonely:
        AppNavigator.pushNamed(RouterName.interventionLonely, arguments: args);
        break;
      default:
        // AppNavigator.pushNamedAndRemoveUntil(RouterName.start, (route) => false);
        context.read<InterventionCubit>().submitAnswers();
        break;
    }
  }
}
