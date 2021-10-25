import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String oldPass, newPass, confPass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.status == AppStatus.failure) {
                    AppUtils.showToast(state.error);
                  }
                  if (state.status == AppStatus.loaded) {
                    AppUtils.showToast(state.message);
                  }
                },
                child: SubmitButtonWidget(onPressed: () {
                  if (_validateFields()) {
                    if (_validatePassword()) {
                      BlocProvider.of<AuthBloc>(context).add(ChangePassword(
                        oldPass,
                        newPass,
                      ));
                    } else {
                      AppUtils.showToast('Passwords do not match');
                    }
                  } else {
                    AppUtils.showToast(Constants.HINT_FILL_ALL_FIELDS);
                  }
                }),
              )
            ],
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
