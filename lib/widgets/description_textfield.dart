import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class DescriptionTextfieldWidget extends StatelessWidget {
  final Function(String) onTextChange;

  const DescriptionTextfieldWidget({Key key, @required this.onTextChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onTextChange,
      minLines: 5,
      maxLines: 10,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Description',
          labelStyle: TextStyle(color: AppTheme.PrimaryDarkColor)),
    );
  }
}
