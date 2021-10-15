import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class TextfieldControllerWidget extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const TextfieldControllerWidget({
    Key key,
    @required this.hint,
    @required this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            //hintText: this.hint,
            labelText: hint,
            labelStyle: const TextStyle(color: AppTheme.PrimaryDarkColor),
            // suffixIcon: this.controller.text.isEmpty
            //     ? Container(
            //       height: 10,
            //       width: 10,
            //       child: CircularProgressIndicator(
            //           backgroundColor: AppTheme.PrimaryDarkColor,
            //         ),
            //     )
            //     : Opacity(opacity: 0.0)
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
