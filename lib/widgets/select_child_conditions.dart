import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:multiple_select/multiple_select.dart';
// import 'package:multiple_select/multi_drop_down.dart';
import 'package:multiple_select/multi_filter_select.dart';
// import 'package:snd_events/models/child_conditions.dart';
import 'package:multiple_select/Item.dart';
import 'package:vipepeo_app/blocs/blocs.dart';

class ChildConditionWidget extends StatefulWidget {
  final Function(List) onselectedConditions;

  const ChildConditionWidget({Key key, @required this.onselectedConditions})
      : super(key: key);

  @override
  State<ChildConditionWidget> createState() => _ChildConditionWidgetState();
}

class _ChildConditionWidgetState extends State<ChildConditionWidget> {
  @override
  void initState() {
    final _childConditionsBloc = BlocProvider.of<ChildConditionsBloc>(context);
    if (_childConditionsBloc.state.data == null) {
      _childConditionsBloc.add(FetchChildConditions());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildConditionsBloc, ChildConditionsState>(
      builder: (context, state) {
        List<Item<num, String, String>> items = state.data
            .map((c) =>
                Item.build(value: c.id, display: c.name, content: c.name))
            .toList();
        return MultiFilterSelect(
          hintText: 'Select',
          allItems: items,
          initValue: [],
          selectCallback: (selectedValues) {
            widget.onselectedConditions(selectedValues);
            // print(selectedValues);
          },
        );
      },
    );
  }
}
