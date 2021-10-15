import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:vipepeo_app/widgets/description_textfield.dart';
import 'package:vipepeo_app/widgets/submit_button.dart';
import 'package:vipepeo_app/widgets/textfield.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class AddTopicScreen extends StatefulWidget {
  final String userToken;

  const AddTopicScreen({Key key, this.userToken}) : super(key: key);
  @override
  _AddTopicScreenState createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  List<ChildCondition> childConditions;
  String title, _desc;
  List selectedConditions = [];
  AppState appState;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Topic"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextfieldWidget(
                  onTextChange: (val) {
                    setState(() {
                      title = val;
                    });
                  },
                  hint: 'Title'),
              DescriptionTextfieldWidget(
                onTextChange: (val) {
                  setState(() {
                    _desc = val;
                  });
                },
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
              // childConditions != null
              //     ? _checklistConditions()
              //     : LoadingWidget(),
              const SizedBox(
                height: 10,
              ),
              SubmitButtonWidget(onPressed: () {
                Repository()
                    .addTopic(
                        token: appState.userToken,
                        title: title,
                        desc: _desc,
                        conditions: selectedConditions)
                    .then((data) {
                  AppUtils.showToast(data[Constants.KEY_RESPONSE]);
                  appState.fetchNotifications();
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
