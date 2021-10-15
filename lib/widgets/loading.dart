import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        backgroundColor: AppTheme.PrimaryDarkColor,
      ),
    );
  }
}
