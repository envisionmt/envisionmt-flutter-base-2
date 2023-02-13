import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_care_app/common/utils/extensions/buildcontext_extension.dart';

import '../../common/enums/request_status.dart';
import '../../common/utils/widgets/loading_indicator.dart';
import '../../common/utils/widgets/status_toast.dart';
import '../../di/injection.dart';
import '../../entities/answer.dart';
import '../route/app_route.dart';
import '../route/navigator.dart';
import '../widgets/question_widget.dart';
import 'bloc/intervention_morning_cubit.dart';
import 'bloc/intervention_morning_state.dart';
import 'intervention_a.dart';

class InterventionMorning extends StatefulWidget {
  @override
  _InterventionMorningState createState() => _InterventionMorningState();

  InterventionMorning({Key? key}) : super(key: key);
}

class _InterventionMorningState extends State<InterventionMorning> {
  @override
  Widget build(BuildContext context) {
    final InterventionArgs? args = context.getRouteArguments();
    return BlocProvider<InterventionMorningCubit>(
      create: (_) => getIt<InterventionMorningCubit>()..init(args),
      child: BlocConsumer<InterventionMorningCubit, InterventionMorningState>(
        listener: (context, state) {
          switch (state.initDataRequestStatus) {
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
            title: const Text('Morning Intervention'),
            centerTitle: true,
            // automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: (state.questions ?? []).length,
                    itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: QuestionWidget(
                            index: index + 1,
                            question: state.questions?[index],
                            onAnswerChanged: (answer) => context.read<InterventionMorningCubit>().changeAnswer(answer),
                          ),
                        )),
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _validateAnswers(state.answers) ? Colors.deepOrange[100] : Colors.blueGrey),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 20))),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onPressed: () {
                  if (_validateAnswers(state.answers)) {
                    context.read<InterventionMorningCubit>().submitAnswers();
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
    final values = answers?.where((element) => element.optionID != null || element.answer != null);
    return (values ?? []).length == answers?.length;
  }
}
