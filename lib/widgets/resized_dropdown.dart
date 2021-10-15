import 'package:flutter/material.dart';

class ResizedDropdown extends StatefulWidget {
  final String hint;
  final double size;
  final List items;
  final Function(dynamic value) onChanged;

  const ResizedDropdown(
      {Key key,
      this.hint,
      this.size = 300,
      @required this.items,
      @required this.onChanged})
      : super(key: key);

  @override
  State<ResizedDropdown> createState() => _ResizedDropdownState();
}

class _ResizedDropdownState extends State<ResizedDropdown> {
  var _value;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        decoration: const BoxDecoration(),
        width: widget.size,
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              iconSize: 0.0,
              value: _value,
              items: widget.items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Center(child: Text(item.toString())),
                      ))
                  .toList(),
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyText1,
              hint: Text(widget.hint ?? ''),
            ),
          ),
        ),
      ),
    );
  }

  void onChanged(value) {
    setState(() {
      _value = value;
    });
    widget.onChanged(value);
  }
}
