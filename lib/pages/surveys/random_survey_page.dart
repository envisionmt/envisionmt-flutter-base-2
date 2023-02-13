import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_care_app/common/enums/intervention_type.dart';
import 'package:project_care_app/common/utils/extensions/buildcontext_extension.dart';
import 'package:project_care_app/pages/widgets/content_widget.dart';
import 'package:project_care_app/pages/widgets/question_widget.dart';

import '../../common/enums/request_status.dart';
import '../../common/utils/widgets/loading_indicator.dart';
import '../../common/utils/widgets/status_toast.dart';
import '../../data/intervention_question_response.dart';
import '../../data/remote/submit_answer_response.dart';
import '../../di/injection.dart';
import '../../entities/answer.dart';
import '../../entities/question.dart';
import '../Intervention/intervention_a.dart';
import '../route/app_route.dart';
import '../route/navigator.dart';
import 'bloc/random_survey_cubit.dart';
import 'bloc/random_survey_state.dart';

class RandomSurveyArgs {
  String? surveyID;

  RandomSurveyArgs({
    this.surveyID,
  });
}

class RandomSurveyPage extends StatefulWidget {
  const RandomSurveyPage({Key? key}) : super(key: key);

  @override
  State<RandomSurveyPage> createState() => _RandomSurveyPageState();
}

class _RandomSurveyPageState extends State<RandomSurveyPage> {
  final ScrollController _scrollController = ScrollController();
  final Key _socialListKey = UniqueKey();
  final Key _helpListKey = UniqueKey();
  final Key _cogListKey = UniqueKey();
  final Key _panasListKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final RandomSurveyArgs? args = context.getRouteArguments();
    print(args?.surveyID);
    return BlocProvider<RandomSurveyCubit>(
      create: (_) => getIt<RandomSurveyCubit>()..getData(args?.surveyID),
      child: BlocConsumer<RandomSurveyCubit, RandomSurveyState>(
          listener: _handleStateListener,
          builder: (context, state) {
            final bloc = context.read<RandomSurveyCubit>();
            final questions = _getQuestions(state);
            return Scaffold(
              appBar: AppBar(
                title: Text(_appBarTitle(state)),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.redAccent[100],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ContentBundle(
                      onRefresh: (_) => bloc.refresh(),
                      emptyAction: (_) => bloc.refresh(),
                      status: state.status,
                      child: _buildListView(questions, bloc),
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
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
    );
  }

  ListView _buildListView(List<Question> questions, RandomSurveyCubit bloc) {
    Key key;
    switch (bloc.state.step) {
      case 0:
        key = _socialListKey;
        break;
      case 1:
        key = _helpListKey;
        break;
      case 2:
        key = _cogListKey;
        break;
      case 3:
        key = _panasListKey;
        break;
      default:
        key = UniqueKey();
    }
    return ListView.builder(
        key: key,
        controller: _scrollController,
        padding: const EdgeInsets.all(10),
        itemCount: questions.length,
        itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: QuestionWidget(
                index: index + 1,
                question: questions[index],
                onAnswerChanged: (answer) => bloc.changeAnswerAt(index, answer),
              ),
            ));
  }

  String _appBarTitle(RandomSurveyState state) {
    switch (state.step) {
      case 0:
        return 'Social';
      case 1:
        return 'Help';
      case 2:
        return 'COG';
      case 3:
        return 'PANAS';
      default:
        return '';
    }
  }

  List<Question> _getQuestions(RandomSurveyState state) {
    switch (state.step) {
      case 0:
        return state.socialQuestions ?? [];
      case 1:
        return state.helpQuestions ?? [];
      case 2:
        return state.cogQuestions ?? [];
      case 3:
        return state.panasQuestions ?? [];
      default:
        return [];
    }
  }

  void _handleStateListener(BuildContext context, RandomSurveyState state) {
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
          _navigateIntervention(
            state.interventionResult!,
            state.interventionQuestionResponse,
            state.socialAnswers,
            state.helpAnswers,
            state.cogAnswers,
            state.panasAnswers,
            state.socialQuestions,
            state.helpQuestions,
            state.cogQuestions,
            state.panasQuestions,
          );
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

  void _onSubmit(BuildContext context, RandomSurveyCubit bloc) {
    bool validate = false;
    switch (bloc.state.step) {
      case 0:
        validate = _validateAnswer(bloc.state.socialAnswers);
        break;
      case 1:
        validate = _validateAnswer(bloc.state.helpAnswers);
        break;
      case 2:
        validate = _validateAnswer(bloc.state.cogAnswers);
        break;
      case 3:
        validate = _validateAnswer(bloc.state.panasAnswers);
        break;
    }
    if (!validate) {
      showFailureMessage(context, 'Please fill out all answer!');
      return;
    }
    if (bloc.state.step >= 3) {
      bloc.submitAnswers();
    } else {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      bloc.nextStep();
    }
  }

  List<Answer>? _generateAnswers(List<Question>? questions) {
    return questions?.map((e) {
      final answer = Answer(questionID: e.id);
      switch (e.type) {
        case QuestionType.datetime:
          answer.answer = DateTime.now();
          break;
        case QuestionType.rate:
          answer.answer = 0;
          break;
        default:
          break;
      }
      return answer;
    }).toList();
  }

  void _navigateIntervention(
    SubmitAnswerResponse? interventionType,
    InterventionQuestionResponse? interventionQuestionResponse,
    List<Answer>? socialAnswers,
    List<Answer>? helpAnswers,
    List<Answer>? cogAnswers,
    List<Answer>? panasAnswers,
    List<Question>? socialQuestions,
    List<Question>? helpQuestions,
    List<Question>? cogQuestions,
    List<Question>? panasQuestions,
  ) {
    final interventionAAnswer =
        _generateAnswers(interventionQuestionResponse?.interventionAQuestions);
    final interventionMoodAnswer =
        _generateAnswers(interventionQuestionResponse?.interventionMoodQuestions);
    final interventionReminderAnswer =
        _generateAnswers(interventionQuestionResponse?.interventionReminderQuestions);
    final interventionLonelyAnswer =
        _generateAnswers(interventionQuestionResponse?.interventionLonelyQuestions);
    final interventionLMoodAnswer =
        _generateAnswers(interventionQuestionResponse?.interventionLMoodQuestions);
    final interventionLogAnswer =
        _generateAnswers(interventionQuestionResponse?.interventionLogQuestions);

    final args = InterventionArgs(
      interventionQuestions: interventionQuestionResponse,
      interventionResult: interventionType,
      socialAnswers: socialAnswers,
      socialQuestions: socialQuestions,
      helpAnswers: helpAnswers,
      helpQuestions: helpQuestions,
      cogAnswers: cogAnswers,
      cogQuestions: cogQuestions,
      panasAnswers: panasAnswers,
      panasQuestions: panasQuestions,
      interventionAAnswer: interventionAAnswer,
      interventionLMoodAnswer: interventionLMoodAnswer,
      interventionLogAnswer: interventionLogAnswer,
      interventionLonelyAnswer: interventionLonelyAnswer,
      interventionMoodAnswer: interventionMoodAnswer,
      interventionReminderAnswer: interventionReminderAnswer,
    );

    switch (interventionType?.status) {
      case InterventionType.none:
        AppNavigator.pushNamedAndRemoveUntil(RouterName.start, (route) => false);
        break;
      case InterventionType.highNA:
      case InterventionType.lowPA:
      case InterventionType.highDailyNA:
      case InterventionType.normal:
      case InterventionType.highLonely:
        AppNavigator.pushNamedAndRemoveUntil(
            RouterName.interventionA, arguments: args, (route) => false);
        break;
      default:
        AppNavigator.pushNamedAndRemoveUntil(RouterName.start, (route) => false);
    }
  }
}
