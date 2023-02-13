import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: SpinKitChasingDots(
          color: Colors.orangeAccent,
          size: 100,
        ),
      ),
    );
  }
}

class Loading2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: const Center(
        child: SpinKitChasingDots(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
