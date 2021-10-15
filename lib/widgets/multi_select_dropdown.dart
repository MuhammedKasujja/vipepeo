import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/states/app_state.dart';

class MultiSelectDialog extends StatefulWidget {
  final String title;
  final Function(List) onselectedConditions;
  const MultiSelectDialog(
      {Key key,
      @required this.onselectedConditions,
      this.title = 'Child Condition'})
      : super(key: key);

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  List<String> _condition = [];
  @override
  Widget build(BuildContext context) {
    var conditions =
        Provider.of<AppState>(context, listen: false).childConditions;

    var items = conditions
        .map((c) => S2Choice<String>(value: c.id.toString(), title: c.name))
        .toList();

    return SmartSelect<String>.multiple(
      title: widget.title,
      selectedValue: _condition,
      onChange: (selected) {
        setState(() => _condition = selected.value);
        widget.onselectedConditions(selected.value);
      },
      choiceItems: items,
      modalType: S2ModalType.popupDialog,
      modalConfirm: true,
      modalValidation: (value) {
        return value.length > 0 ? null : 'Select at least one';
      },
      modalHeaderStyle: S2ModalHeaderStyle(
        elevation: .8,
        backgroundColor: Theme.of(context).cardColor,
      ),
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          // leading: Container(
          //   width: 40,
          //   alignment: Alignment.center,
          //   child: const Icon(Icons.shopping_cart),
          // ),
        );
      },
      modalActionsBuilder: (context, state) {
        return <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: state.choiceSelectorAll,
          )
        ];
      },
      modalDividerBuilder: (context, state) {
        return const Divider(height: 1);
      },
      modalFooterBuilder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 7.0,
          ),
          child: Row(
            children: <Widget>[
              const Spacer(),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => state.closeModal(confirmed: false),
              ),
              const SizedBox(width: 5),
              FlatButton(
                child: Text('OK (${state.selection.length})'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: state.selection.isValid
                    ? () => state.closeModal(confirmed: true)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
