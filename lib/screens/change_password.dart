import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:vipepeo_app/widgets/submit_button.dart';
import 'package:vipepeo_app/widgets/textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String oldPass, newPass, confPass;
  AppState appState;
  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextfieldWidget(
                    onTextChange: (value) {
                      setState(() {
                        oldPass = value;
                      });
                    },
                    hint: 'Old Password'),
                TextfieldWidget(
                    onTextChange: (value) {
                      setState(() {
                        newPass = value;
                      });
                    },
                    hint: 'New Password'),
                TextfieldWidget(
                    onTextChange: (value) {
                      setState(() {
                        confPass = value;
                      });
                    },
                    hint: 'Confirm New Password'),
                SubmitButtonWidget(onPressed: () {
                  if (_validateFields()) {
                    if (_validatePassword()) {
                      Repository()
                          .changePassword(
                              token: appState.userToken,
                              oldPassword: oldPass,
                              newPassword: newPass)
                          .then((data) {
                        AppUtils.showToast(data[Constants.KEY_RESPONSE]);
                      });
                    } else {
                      AppUtils.showToast('Passwords do not match');
                    }
                  } else {
                    AppUtils.showToast(Constants.HINT_FILL_ALL_FIELDS);
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validatePassword() {
    return newPass == confPass;
  }

  bool _validateFields() {
    return oldPass != null &&
        oldPass.isNotEmpty &&
        newPass != null &&
        newPass.isNotEmpty &&
        confPass != null &&
        confPass.isNotEmpty;
  }
}
