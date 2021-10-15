import 'package:flutter/material.dart';

class LoadingConditionHList extends StatelessWidget {
  const LoadingConditionHList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: 40,
        width: 120,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.grey[500])),
        child: Center(
          child: Container(
            height: 20,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
