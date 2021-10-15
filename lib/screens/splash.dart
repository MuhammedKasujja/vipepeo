import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/screens/home.dart';
import 'package:vipepeo_app/screens/login.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (t) {
      var appState = Provider.of<AppState>(context, listen: false);
      // print('AppStateToken: ${appState.userToken}');
      // Repository().loadPrefs().then((map) {
      if (appState.userToken != null) {
        // print('RepoToken: ${appState.userToken}');
        appState.getUserData();
        appState.loadInitialData();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
      // });
      print("Loaded Page");
      t.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Constants.APP_NAME,
                style:
                    TextStyle(fontSize: 25, color: AppTheme.PrimaryDarkColor),
              )
            ],
          ),
        ),
      )),
    );
  }
}
