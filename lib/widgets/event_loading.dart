import 'package:flutter/material.dart';

class EventLoadingWidget extends StatelessWidget {
  final double size;

  const EventLoadingWidget({Key key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      height: size ?? 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: <Widget>[
          Container(
            width: size ?? 100,
            margin: const EdgeInsets.only(right: 10),
            color: Colors.blue,
          ),
          Expanded(
              child: Container(
            color: Colors.grey[300],
          ))
        ],
      ),
    );
  }
}
