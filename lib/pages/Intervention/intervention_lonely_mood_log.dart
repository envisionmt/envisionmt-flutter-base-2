import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_care_app/common/utils/extensions/buildcontext_extension.dart';

import '../../common/enums/intervention_type.dart';
import '../../common/enums/request_status.dart';
import '../../common/utils/widgets/loading_indicator.dart';
import '../../common/utils/widgets/status_toast.dart';
import '../../di/injection.dart';
import '../../entities/answer.dart';
import '../route/app_route.dart';
import '../route/navigator.dart';
import '../widgets/question_widget.dart';
import 'bloc/intervention_cubit.dart';
import 'bloc/intervention_state.dart';
import 'intervention_a.dart';

class InterventionLMood extends StatefulWidget {
  @override
  _InterventionLMoodState createState() => _InterventionLMoodState();

  InterventionLMood({
    Key? key,
    this.interventionType,
    this.answers,
  }) : super(key: key);

  final InterventionType? interventionType;
  final List<Answer>? answers;
}

class _InterventionLMoodState extends State<InterventionLMood> {
  @override
  Widget build(BuildContext context) {
    final InterventionArgs? args = context.getRouteArguments();
    final questions = args?.interventionQuestions?.interventionLMoodQuestions ?? [];
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
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orangeAccent[200],
            title: const Text('Daily Mood Log'),
            centerTitle: true,
            // automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: questions.length,
                    itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: QuestionWidget(
                            index: index + 1,
                            question: questions[index],
                            selectedColor: Colors.redAccent[100]?.withOpacity(0.6),
                            onAnswerChanged: (answer) {
                              // final index = args?.interventionLMoodAnswer?.indexWhere(
                              //         (element) => element.questionID == answer?.questionID) ??
                              //     -1;
                              // if (index >= 0 && answer != null) {
                              //   args?.interventionLMoodAnswer?[index] = answer;
                              // }
                              // setState(() {});
                            },
                          ),
                        )),
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _validateAnswers(args?.interventionLMoodAnswer)
                            ? Colors.deepOrange[100]
                            : Colors.blueGrey),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 20))),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onPressed: () {
                  if (_validateAnswers(args?.interventionLMoodAnswer)) {
                    context.read<InterventionCubit>().submitAnswers();
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateAnswers(List<Answer>? answers) {
    return true;
    // final values = answers?.where((element) => element.optionID != null || element.answer != null);
    // return (values ?? []).length == answers?.length;
  }
}
