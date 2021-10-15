import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_utils.dart';

class CalendarDatepickerWidget extends StatefulWidget {
  final Function(String) onDateChanged;

  const CalendarDatepickerWidget({
    Key key,
    @required this.onDateChanged,
  }) : super(key: key);
  @override
  _CalendarDatepickerWidgetState createState() =>
      _CalendarDatepickerWidgetState();
}

class _CalendarDatepickerWidgetState extends State<CalendarDatepickerWidget> {
  DateTime _dateTime;
  var _strDate;
  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.parse('1980-01-01');
    _strDate = AppUtils.convertDateFormat(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Text('$_strDate', style: Theme.of(context).textTheme.headline6),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.calendar_today,
              color: Colors.blue,
            )
          ],
        ),
      ),
      onTap: () {
        showDatePicker(
                helpText: 'Date of birth',
                context: context,
                initialDate: DateTime.parse(_strDate),
                firstDate: DateTime.parse(_strDate),
                lastDate: DateTime.parse('2020-01-01'))
            .then((date) {
          if (date != null) {
            setState(() {
              _strDate = AppUtils.convertDateFormat(date);
            });
            widget.onDateChanged(AppUtils.convertDateFormat(date));
          }
        });
      },
    );
  }
}
