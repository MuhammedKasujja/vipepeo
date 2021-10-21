import 'package:flutter/material.dart';
// import 'package:multiple_select/multiple_select.dart';
// import 'package:multiple_select/multi_drop_down.dart';
import 'package:multiple_select/multi_filter_select.dart';
// import 'package:snd_events/models/child_conditions.dart';
import 'package:multiple_select/Item.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:provider/provider.dart';

class ChildConditionWidget extends StatelessWidget {
  final Function(List) onselectedConditions;

  const ChildConditionWidget({Key key, @required this.onselectedConditions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var conditions =
        Provider.of<AppState>(context, listen: false).childConditions;
    List<Item<num, String, String>> items = conditions
        .map((c) => Item.build(value: c.id, display: c.name, content: c.name))
        .toList();
    return MultiFilterSelect(
      hintText: 'Select',
      allItems: items,
      initValue: [],
      selectCallback: (selectedValues) {
        onselectedConditions(selectedValues);
        // print(selectedValues);
      },
    );
  }
}
