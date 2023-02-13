import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_care_app/pages/route/navigator.dart';

class OldStart extends StatefulWidget {
  @override
  _OldStartState createState() => _OldStartState();
}

class _OldStartState extends State<OldStart> {
  final navigatorkey = AppNavigator.navigatorKey;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      // key: NavigationService.navigatorKey,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: height * 0.15),
            Text(
              "Project Care",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.05),
            TextButton(
              style: TextButton.styleFrom(
                fixedSize: Size(width * 0.9, height * 0.22),
                backgroundColor: Colors.greenAccent[100]?.withOpacity(0.5),
              ),
              child: Text(
                'Morning Survey',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () {
                navigatorkey.currentState
                    ?.pushNamed('/morning', arguments: {"time": DateTime.now()});
                // Navigator.pushNamed(context, '/survey');
              },
            ),
            SizedBox(height: height * 0.02),
            TextButton(
              style: TextButton.styleFrom(
                fixedSize: Size(width * 0.9, height * 0.22),
                backgroundColor: Colors.lightBlue[100]?.withOpacity(0.5),
              ),
              child: Text(
                'Evening Survey',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () {
                navigatorkey.currentState
                    ?.pushNamed('/evening', arguments: {"time": DateTime.now()});
              },
            ),
            SizedBox(height: height * 0.02),
            TextButton(
              style: TextButton.styleFrom(
                fixedSize: Size(width * 0.9, height * 0.22),
                backgroundColor: Colors.deepOrange[100]?.withOpacity(0.5),
              ),
              child: Text(
                'Random Survey',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () {
                navigatorkey.currentState
                    ?.pushNamed('/randsocial', arguments: {"time": DateTime.now()});
              },
            ),
          ],
        ),
      ),
    );
  }
}
