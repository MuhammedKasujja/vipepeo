// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'resized_dropdown.dart';

class CustomDateOfBirth extends StatefulWidget {
  final Function({String day, String month, String year}) onDateChanged;
  final String title;
  const CustomDateOfBirth(
      {Key key, @required this.onDateChanged, this.title = 'Date of Birth'})
      : super(key: key);

  @override
  _CustomDateOfBirthState createState() => _CustomDateOfBirthState();
}

class _CustomDateOfBirthState extends State<CustomDateOfBirth> {
  List days = [];
  List months = [];
  List years = [];

  var dayOfBirth;
  var monthOfBirth;
  var yearOfBirth;

  @override
  void initState() {
    days = [for (var i = 0; i < 31; i += 1) i + 1];
    months = [for (var i = 0; i < 12; i += 1) i + 1];
    const int startingYear = 1999;
    final yearDiff = (DateTime.now().year - startingYear);
    years = List<String>.generate(
        yearDiff, (i) => ((i + startingYear) + 1).toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              widget.title,
              style: const TextStyle(color: AppTheme.PrimaryDarkColor),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: ResizedDropdown(
                  hint: 'dd',
                  size: 60,
                  items: days,
                  onChanged: (value) {
                    widget.onDateChanged(
                        day: value.toString(),
                        month: monthOfBirth,
                        year: yearOfBirth);
                    setState(() {
                      dayOfBirth = value.toString();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: ResizedDropdown(
                  hint: 'mm',
                  size: 60,
                  items: months,
                  onChanged: (value) {
                    widget.onDateChanged(
                        day: dayOfBirth,
                        month: value.toString(),
                        year: yearOfBirth);
                    setState(() {
                      monthOfBirth = value.toString();
                    });
                  },
                ),
              ),
              ResizedDropdown(
                hint: 'yyyy',
                size: 100,
                items: years,
                onChanged: (value) {
                  widget.onDateChanged(
                      day: dayOfBirth,
                      month: monthOfBirth,
                      year: value.toString());
                  setState(() {
                    yearOfBirth = value.toString();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
