import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class EventTypeIcon extends StatelessWidget {
  final String type;
  final Function() onSelected;
  final Color color;
  final Color textColor;

  const EventTypeIcon(
      {Key key,
      @required this.type,
      @required this.onSelected,
      this.color,
      this.textColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.only(left: 1.5, right: 1.5),
            child: Container(
                decoration: BoxDecoration(
                    color: color ?? Colors.grey,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3))
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(type,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor ?? AppTheme.PrimaryDarkColor,
                        )))),
          ),
          onTap: onSelected,
        ));
  }
}
