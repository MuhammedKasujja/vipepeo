import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_utils.dart';

class AddIcon extends StatelessWidget {
  final Widget page;

  const AddIcon({Key key, this.page}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Tooltip(
        message: 'Add new Event',
        child: Icon(
          Icons.add_circle_outline,
          color: Colors.grey,
        ),
      ),
      onTap: () {
        if (page != null) {
          AppUtils(context).nextPage(page: page);
        }
      },
    );
  }
}
