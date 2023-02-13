import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_care_app/common/utils/extensions/buildcontext_extension.dart';

import '../../common/enums/intervention_type.dart';
import '../../common/enums/request_status.dart';
import '../../common/utils/widgets/loading_indicator.dart';
import '../../common/utils/widgets/status_toast.dart';
import '../../di/injection.dart';
import '../../entities/answer.dart';
import '../../entities/question.dart';
import '../route/app_route.dart';
import '../route/navigator.dart';
import '../widgets/question_widget.dart';
import 'bloc/intervention_cubit.dart';
import 'bloc/intervention_state.dart';
import 'intervention_a.dart';

class InterventionLonely extends StatefulWidget {
  @override
  _InterventionLonelyState createState() => _InterventionLonelyState();

  InterventionLonely({
    Key? key,
    this.interventionType,
    this.answers,
  }) : super(key: key);

  final InterventionType? interventionType;
  final List<Answer>? answers;
}

class _InterventionLonelyState extends State<InterventionLonely> {
  Map<String, dynamic> finalAnswers = {'confidence': null, 'barriers': null};

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final InterventionArgs? args = context.getRouteArguments();
    final questions = args?.interventionQuestions?.interventionLonelyQuestions ?? [];
    print(questions.map((e) => e.type));
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
              // AppNavigator.pushNamedAndRemoveUntil(RouterName.start, (route) => false);
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
                            question: questions[index],
                            onAnswerChanged: (answer) {
                              final index = args?.interventionLonelyAnswer?.indexWhere(
                                      (element) => element.questionID == answer?.questionID) ??
                                  -1;
                              if (index >= 0 && answer != null) {
                                args?.interventionLonelyAnswer?[index] = answer;
                                setState(() {});
                                if (questions[index].type == QuestionType.yesNo2 && answer.answer == 1) {
                                  AppNavigator.pushNamed(RouterName.interventionLMood, arguments: args);
                                  return;
                                }
                              }
                            },
                          ),
                        )),
              ),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          _validateAnswers(questions, args?.interventionLonelyAnswer)
                              ? Colors.deepOrange[100]
                              : Colors.blueGrey),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 20))),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  onPressed: () {
                    final index = questions.indexWhere(
                            (element) => element.type == QuestionType.yesNo2);
                    if (index >= 0 && args?.interventionLonelyAnswer?[index].answer == 1) {
                      AppNavigator.pushNamed(RouterName.interventionLMood, arguments: args);
                      return;
                    }
                    if (_validateAnswers(questions, args?.interventionLonelyAnswer)){
                      context.read<InterventionCubit>().submitAnswers();
                    }
                  }),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  bool _validateAnswers(List<Question> questions, List<Answer>? answers) {
    final index = questions.indexWhere(
            (element) => element.type == QuestionType.yesNo2);
    if (index >= 0 && answers?[index].answer == 0) {
      final values = answers?.where((element) => element.optionID != null || element.answer != null);
      return (values ?? []).length == answers?.length;
    }
    return true;
  }
}
