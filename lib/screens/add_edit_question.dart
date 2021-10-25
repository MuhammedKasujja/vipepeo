import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
// import 'package:flutter_multi_chip_select/flutter_multi_chip_select.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class AddEditQuestionScreen extends StatefulWidget {
  final Question question;

  const AddEditQuestionScreen({Key key, this.question}) : super(key: key);
  @override
  _AddEditQuestionScreenState createState() => _AddEditQuestionScreenState();
}

class _AddEditQuestionScreenState extends State<AddEditQuestionScreen> {
  List<dynamic> selectedConditions = [];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask a question"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: BlocBuilder<QuestionsBloc, QuestionsState>(
            builder: (context, state) {
              return Container(
                width: double.infinity,
                child: state.status == AppStatus.loading
                    ? const LinearProgressIndicator()
                    : Container(),
                color: Colors.black,
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              TextfieldControllerWidget(
                  controller: _controller, hint: 'Type something'),
              Row(
                children: const <Widget>[
                  Text(
                    "Condition(s)",
                    style: TextStyle(
                      color: AppTheme.PrimaryDarkColor,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              MultiSelectDialog(
                title: 'Topics',
                onselectedConditions: (conditions) {
                  selectedConditions = conditions;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              SubmitButtonWidget(onPressed: () {
                if (_validateFields()) {
                  BlocProvider.of<QuestionsBloc>(context)
                      .add(AddQuestion(_controller.text, selectedConditions));
                } else {
                  AppUtils.showToast(Constants.HINT_FILL_ALL_FIELDS);
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    return _controller.text.isNotEmpty;
  }
}
