import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class IgnoreLoadingIndicator {
  factory IgnoreLoadingIndicator() {
    return _dialog;
  }

  IgnoreLoadingIndicator._internal();

  static final IgnoreLoadingIndicator _dialog = IgnoreLoadingIndicator._internal();

  final GlobalKey<State> _key = GlobalKey<State>();

  bool isShowing = false;

  Future<void> show(BuildContext context) async {
    if (isShowing) {
      return;
    }
    isShowing = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          key: _key,
          onWillPop: () async => false,
          child: const Center(
            child: SpinKitChasingDots(
              color: Colors.orangeAccent,
              size: 100,
            ),
          ),
        );
      },
    );
  }

  void hide(BuildContext context) {
    if (!isShowing) {
      return;
    }
    isShowing = false;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
