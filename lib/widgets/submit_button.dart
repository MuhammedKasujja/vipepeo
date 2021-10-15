import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class SubmitButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String hint;

  const SubmitButtonWidget({Key key, @required this.onPressed, this.hint})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      // color: AppTheme.APP_COLOR,
      textColor: AppTheme.APP_COLOR,
      onPressed: onPressed,
      child: Text(hint ?? "Submit"),
    );
  }
}
