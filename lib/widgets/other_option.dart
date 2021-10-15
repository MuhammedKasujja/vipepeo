import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class ORWidget extends StatelessWidget {
  const ORWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 15,
        ),
        Stack(
          children: <Widget>[
            Container(),
            const Divider(
              thickness: 2,
            ),
            Center(
              child: Container(
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 6, right: 6),
                    child: Text(
                      "OR",
                      style: TextStyle(
                          color: AppTheme.PrimaryDarkColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
