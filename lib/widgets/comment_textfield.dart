import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class CommentWidget extends StatefulWidget {
  final Function(String value) onSendClicked;

  const CommentWidget({Key key, @required this.onSendClicked})
      : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 6),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'comment ....',
                suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: AppTheme.PrimaryDarkColor,
                    ),
                    onPressed: () {
                      widget.onSendClicked(_controller.text);
                    })),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
