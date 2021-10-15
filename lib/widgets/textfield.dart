import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class TextfieldWidget extends StatelessWidget {
  final Function(String) onTextChange;
  final String hint;
  final bool isPassword;
  final TextInputType inputType;

  const TextfieldWidget(
      {Key key,
      @required this.onTextChange,
      @required this.hint,
      this.isPassword,
      this.inputType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          keyboardType: inputType ?? TextInputType.text,
          obscureText: isPassword ?? false,
          onChanged: onTextChange,
          decoration: InputDecoration(
              border: const OutlineInputBorder(borderSide: BorderSide()),
              //hintText: this.hint,
              labelText: hint,
              labelStyle: const TextStyle(color: AppTheme.PrimaryDarkColor)),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
