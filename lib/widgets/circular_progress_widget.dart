import 'package:flutter/material.dart';

class CircularProgressWidget extends StatelessWidget {
  const CircularProgressWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
        child: Center(
            child: SizedBox(
                width: 15, height: 15, child: CircularProgressIndicator())));
  }
}
