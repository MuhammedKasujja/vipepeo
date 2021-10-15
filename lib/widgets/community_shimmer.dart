import 'package:flutter/material.dart';

class CommunityShimmer extends StatelessWidget {
  const CommunityShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width - 80;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        width: _width,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              color: Colors.grey,
              width: double.infinity,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 20,
              color: Colors.grey,
              width: _width - 40,
            )
          ],
        ),
      ),
    );
  }
}
