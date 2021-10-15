import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/screens/splash.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create:(context)=> AppState()),
        ChangeNotifierProvider.value(
          value: AppState(),
        )
      ],
      child: MaterialApp(
          title: Constants.APP_NAME,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // scaffoldBackgroundColor: Colors.grey[200],
            primaryColor: AppTheme.PrimaryColor,
            primaryColorDark: AppTheme.PrimaryDarkColor,
            primaryColorLight: AppTheme.PrimaryAssentColor,
            errorColor: AppTheme.ErrorColor,
            toggleableActiveColor: AppTheme.PrimaryColor,
            // primarySwatch: Colors.grey,
            // primarySwatch: const Color.fromRGBO(r, g, b, opacity),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textSelectionTheme: const TextSelectionThemeData(
                cursorColor: AppTheme.PrimaryDarkColor),
          ),
          home: SplashScreen()),
    );
  }
}
