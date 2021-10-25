import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class TextfieldWidget extends StatelessWidget {
  final Function(String) onTextChange;
  final String hint;
  final bool isPassword;
  final TextInputType inputType;
  final TextEditingController controller;

  const TextfieldWidget(
      {Key key,
      @required this.onTextChange,
      @required this.hint,
      this.isPassword,
      this.inputType,
      this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
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
