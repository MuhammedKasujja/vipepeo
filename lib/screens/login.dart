import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/screens/home.dart';
import 'package:vipepeo_app/screens/register.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:vipepeo_app/widgets/loading.dart';
import 'package:vipepeo_app/widgets/other_option.dart';
import 'package:vipepeo_app/widgets/submit_button.dart';
import 'package:vipepeo_app/widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;
  bool isSubmitting = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.PrimaryDarkColor,
      child: SafeArea(
        child: Scaffold(
            body: ListView(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Align(
                    child: Text(
                      Constants.APP_NAME,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    alignment: Alignment.center,
                  ),
                  // Align(child: Icon(Icons.event_seat),)
                ],
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              decoration: const BoxDecoration(
                  color: AppTheme.PrimaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  isSubmitting ? const LoadingWidget() : Container(),
                  Row(
                    children: const [
                      Text(Constants.LOGIN,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextfieldWidget(
                    inputType: TextInputType.emailAddress,
                    hint: Constants.HINT_EMAIL,
                    onTextChange: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextfieldWidget(
                    hint: Constants.HINT_PASSWORD,
                    isPassword: true,
                    onTextChange: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SubmitButtonWidget(onPressed: () {
                    if (_validateFields()) {
                      _login();
                    } else {
                      AppUtils.showToast(Constants.HINT_FILL_ALL_FIELDS);
                    }
                  }),
                  const ORWidget(),
                  OutlineButton(
                    borderSide: const BorderSide(color: AppTheme.PrimaryColor),
                    highlightedBorderColor: AppTheme.PrimaryDarkColor,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        Constants.REGISTER,
                        style: TextStyle(color: AppTheme.PrimaryColor),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return RegisterScreen();
                      }));
                    },
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  bool _validateFields() {
    return email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
  }

  _login() {
    _pageSubmitting(true);
    Repository().login(password: password, email: email).then((data) {
      if (data['code'] == 0) {
        print(data['response']);
        AppUtils.showToast(data[Constants.KEY_RESPONSE]);
      } else {
        AppUtils.showToast(data[Constants.KEY_RESPONSE]);
        Repository().savePrefs(data['token'], email).then((value) {
          var appState = Provider.of<AppState>(context, listen: false);
          appState.loadPrefs().then((prefs) {
            print('UserToken: ${prefs[Constants.USER_TOKEN]}');
            if (prefs[Constants.USER_TOKEN] != null) {
              appState.getUserData();
              appState.loadInitialData();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            }
          });
        });
      }
      _pageSubmitting(false);
      print('ResponseCode: $data');
    }).catchError((onError) {
      AppUtils.showToast(Constants.NETWORK_ERROR);
      _pageSubmitting(false);
    });
  }

  _pageSubmitting(bool showLoading) {
    setState(() {
      isSubmitting = showLoading;
    });
  }
}
