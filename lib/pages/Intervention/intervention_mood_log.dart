import 'package:flutter/material.dart';
import 'package:project_care_app/common/utils/extensions/buildcontext_extension.dart';
import 'package:project_care_app/entities/question.dart';
import 'package:project_care_app/pages/route/app_route.dart';

import '../../common/enums/intervention_type.dart';
import '../../entities/answer.dart';
import '../route/navigator.dart';
import '../widgets/question_widget.dart';
import 'intervention_a.dart';

class InterventionMood extends StatefulWidget {
  @override
  _InterventionMoodState createState() => _InterventionMoodState();

  InterventionMood({
    Key? key,
    this.interventionType,
    this.answers,
  }) : super(key: key);

  final InterventionType? interventionType;
  final List<Answer>? answers;
}

class _InterventionMoodState extends State<InterventionMood> {

  @override
  Widget build(BuildContext context) {
    final InterventionArgs? args = context.getRouteArguments();
    final questions = args?.interventionQuestions?.interventionMoodQuestions ?? [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent[200],
        title: const Text('Daily Mood Log'),
        centerTitle: true,
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
                    selectedColor: Colors.deepOrange[100]?.withOpacity(0.5),
                    onAnswerChanged: (answer) {
                      final index = args?.interventionMoodAnswer?.indexWhere((element) => element.questionID == answer?.questionID) ?? -1;
                      if (index >= 0 && answer != null) {
                        // args?.interventionMoodAnswer?[index] = answer;
                        if (questions[index].type == QuestionType.options2 && answer.answer == 2) {
                          AppNavigator.pushNamed(RouterName.interventionRemind, arguments: args);
                        } else {
                          AppNavigator.pushNamed(RouterName.interventionLog, arguments: args);
                        }
                      }
                    },
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
