import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_multi_chip_select/flutter_multi_chip_select.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:vipepeo_app/widgets/submit_button.dart';
import 'package:vipepeo_app/widgets/textfield.with.controller.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class AddEditQuestionScreen extends StatefulWidget {
  final Function(Question child) onQuestionAdded;
  final Question question;

  const AddEditQuestionScreen({Key key, this.onQuestionAdded, this.question})
      : super(key: key);
  @override
  _AddEditQuestionScreenState createState() => _AddEditQuestionScreenState();
}

class _AddEditQuestionScreenState extends State<AddEditQuestionScreen> {
  List<ChildCondition> childConditions;
  List<dynamic> selectedConditions = [];
  AppState appState;
  bool isSubmitting = false;

  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    appState = Provider.of<AppState>(context, listen: false);
    if (appState.childConditions != null) {
      childConditions = appState.childConditions;
    } else {
      appState.getChildConditionsList().then((data) {
        // print("Conditions: $data");
        if (mounted) {
          setState(() {
            childConditions = data;
          });
        }
      });
    }
    if (widget.question != null) {
      //  appState
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask a question"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            width: double.infinity,
            child: isSubmitting ? const LinearProgressIndicator() : Container(),
            color: Colors.black,
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
                  _showPageSubmitting(true);
                  appState
                      .askQuestion(
                    _controller.text,
                    selectedConditions,
                  )
                      .then((data) {
                    appState.fetchQuestions();
                    _showPageSubmitting(false);
                    AppUtils.showToast("${data['response']}");
                    print("Response: $data");
                  }).catchError((onError) {
                    _showPageSubmitting(false);
                    AppUtils.showToast('Somethng went wrong');
                  });
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

  _showPageSubmitting(bool showLoading) {
    setState(() {
      isSubmitting = showLoading;
    });
  }
}
