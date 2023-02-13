import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_care_app/common/utils/widgets/confirm_dialog.dart';
import 'package:project_care_app/common/utils/widgets/loading_indicator.dart';
import 'package:project_care_app/common/utils/widgets/status_toast.dart';
import 'package:project_care_app/data/app_singleton.dart';
import 'package:project_care_app/pages/auth/bloc/login_cubit.dart';
import 'package:project_care_app/pages/auth/bloc/login_state.dart';

import '../../common/enums/request_status.dart';
import '../../common/enums/user_status.dart';
import '../../di/injection.dart';
import '../route/app_route.dart';
import '../route/navigator.dart';

class GatherInfo extends StatefulWidget {
  const GatherInfo({Key? key}) : super(key: key);

  @override
  _GatherInfoState createState() => _GatherInfoState();
}

class _GatherInfoState extends State<GatherInfo> {
  final _formKey = GlobalKey<FormState>();
  late String _studyID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => getIt<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: _handleStateListener,
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.orange[50],
          appBar: AppBar(
            backgroundColor: Colors.orange[300],
            elevation: 0,
            title: const Text('User Information'),
            centerTitle: true,
            leading: const SizedBox(),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your Study ID: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      // color: Color.fromRGBO(219, 255, 237, 0.3),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 60.0,
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0),
                      ),
                      validator: (val) => (val ?? '').isEmpty ? 'Enter your study ID' : null,
                      onChanged: (val) {
                        _studyID = val;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () => _onSubmit(context),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleStateListener(BuildContext context, LoginState state) {
    switch (state.checkUserStatus) {
      case RequestStatus.initial:
        break;
      case RequestStatus.requesting:
        IgnoreLoadingIndicator().show(context);
        break;
      case RequestStatus.success:
        IgnoreLoadingIndicator().hide(context);
        switch (state.userStatus) {
          case UserStatus.newUser:
          case UserStatus.oldUser:
            context.read<LoginCubit>().callLogin();
            break;
          case UserStatus.existUser:
            ConfirmDialog(
              title: 'This student id is registered already, Will you continue?',
              onYes: () {
                context.read<LoginCubit>().callLogin();
              },
            ).show(context);
            break;
          default:
            break;
        }
        break;
      case RequestStatus.failed:
        IgnoreLoadingIndicator().hide(context);
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
        AppSingleton.instance.isLogin = true;
        AppNavigator.pushNamedAndRemoveUntil(RouterName.start, (route) => false);
        break;
      case RequestStatus.failed:
        IgnoreLoadingIndicator().hide(context);
        showFailureMessage(context, 'Login failed');
        break;
    }
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().checkUser(_studyID);
    }
  }
}
