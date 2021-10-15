import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class TimepickerWidget extends StatelessWidget {
  final format = DateFormat("HH:mm");
  final TextEditingController controller;

  TimepickerWidget({Key key, @required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      //Text('Basic time field (${format.pattern})'),
      DateTimeField(
        controller: controller,
        resetIcon: null,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.timer),
            labelText: 'Time',
            labelStyle: TextStyle(color: AppTheme.PrimaryDarkColor)),
        format: format,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
      ),
    ]);
  }
}
