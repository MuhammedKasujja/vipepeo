import 'package:flutter/material.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:vipepeo_app/widgets/submit_button.dart';
import 'package:vipepeo_app/widgets/textfield.dart';

class AddProfessionScreen extends StatefulWidget {
  final String userToken;

  const AddProfessionScreen({Key key, @required this.userToken})
      : super(key: key);
  @override
  _AddProfessionScreenState createState() => _AddProfessionScreenState();
}

class _AddProfessionScreenState extends State<AddProfessionScreen> {
  TextEditingController infoController = TextEditingController();
  String prof, spec;
  // List listProfs = ['Select', 'Doctor', 'Teacher', 'Nurse', ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Profession"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // DropdownButton(items: null, onChanged: null)
              TextfieldWidget(
                  onTextChange: (value) {
                    setState(() {
                      prof = value;
                    });
                  },
                  hint: 'Profession'),
              TextField(
                controller: infoController,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'More info',
                    labelStyle: TextStyle(color: AppTheme.PrimaryDarkColor)),
              ),
              SizedBox(
                height: 10,
              ),
              TextfieldWidget(
                  onTextChange: (value) {
                    setState(() {
                      spec = value;
                    });
                  },
                  hint: 'Specifications'),
              SubmitButtonWidget(onPressed: () {
                Repository()
                    .addProfession(
                        token: widget.userToken,
                        prof: prof,
                        spec: spec,
                        desc: infoController.text)
                    .then((data) {
                  AppUtils.showToast("${data[Constants.KEY_RESPONSE]}");
                });
              })
            ],
          ),
        ),
      ),
    );
  }
}
