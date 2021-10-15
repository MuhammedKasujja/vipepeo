import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/constants.dart';

class AppIcon extends StatelessWidget {
  final Color textColor;

  const AppIcon({Key key, this.textColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          //color: Colors.blue,
          // width: double.infinity,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Text(
              Constants.APP_NAME,
              style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: textColor ?? AppTheme.PrimaryDarkColor),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
