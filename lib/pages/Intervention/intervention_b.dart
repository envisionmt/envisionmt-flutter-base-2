import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_care_app/common/utils/date_time.dart';
import 'package:project_care_app/common/utils/extensions/buildcontext_extension.dart';
import 'package:project_care_app/common/utils/widgets/loading_indicator.dart';
import 'package:project_care_app/common/utils/widgets/status_toast.dart';
import 'package:project_care_app/di/injection.dart';
import 'package:project_care_app/pages/Intervention/bloc/intervention_cubit.dart';
import 'package:project_care_app/pages/route/app_route.dart';
import 'package:project_care_app/pages/route/navigator.dart';

import '../../common/enums/request_status.dart';
import '../../entities/answer.dart';
import '../../entities/question.dart';
import 'bloc/intervention_state.dart';
import 'intervention_a.dart';

class InterventionB extends StatefulWidget {
  const InterventionB({Key? key}) : super(key: key);

  @override
  _InterventionBState createState() => _InterventionBState();
}

class _InterventionBState extends State<InterventionB> {
  @override
  Widget build(BuildContext context) {
    final InterventionArgs? args = context.getRouteArguments();
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
            title: const Text('Intervention B'),
            centerTitle: true,
            // leading: Builder(
            //   builder: (BuildContext context) {
            //     return IconButton(
            //       icon: const Icon(Icons.arrow_back),
            //       onPressed: () {
            //         AppNavigator.pushReplacementNamed(RouterName.interventionA);
            //       },
            //     );
            //   },
            // ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Social', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                      _buildListView(args?.socialAnswers, args?.socialQuestions),
                      const Text('Help', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                      _buildListView(args?.helpAnswers, args?.helpQuestions),
                      const Text('COG', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                      _buildListView(args?.cogAnswers, args?.cogQuestions),
                      const Text('PANAS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                      _buildListView(args?.panasAnswers, args?.panasQuestions),
                    ],
                  ),
                )),
                const SizedBox(height: 16),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepOrange[100]),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 20))),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  onPressed: () => context.read<InterventionCubit>().submitAnswers(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView _buildListView(List<Answer>? answers, List<Question>? questions) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: (questions ?? []).length,
        itemBuilder: (context, index) {
          final question = questions?[index];
          final answer = question?.options
                  ?.where((element) => element.id == answers?[index].optionID)
                  .firstOrNull
                  ?.key ??
              answers?[index].answer ??
              '';
          return Container(
            color: Colors.redAccent[100]?.withOpacity(0.1),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (index + 1).toString() + '. ' + (question?.title ?? ''),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Answer: ' +
                      (answer is DateTime
                          ? answer.format(DateTimeFormat.HH_MM_A)
                          : (answer?.toString() ?? '')),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        });
  }
}
