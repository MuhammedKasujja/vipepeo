import 'package:flutter/material.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:vipepeo_app/widgets/country_dropdown.dart';
import 'package:vipepeo_app/widgets/submit_button.dart';
import 'package:vipepeo_app/widgets/textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name, email, password, confirmPassword, _country = "UG", _city;
  bool isSubmitting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(Constants.REGISTER),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: Container(
              width: double.infinity,
              child:
                  isSubmitting ? const LinearProgressIndicator() : Container(),
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                // AppIcon(),
                // Text(
                //   Constants.REGISTER,
                //   style:
                //       TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                // ),
                // SizedBox(height: 10,),
                TextfieldWidget(
                  hint: Constants.HINT_NAME,
                  onTextChange: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                CountryDropdownWidget(
                  onCountySelected: (country) {
                    print(country);
                    setState(() {
                      _country = country;
                    });
                  },
                ),
                TextfieldWidget(
                  hint: 'City',
                  onTextChange: (value) {
                    setState(() {
                      _city = value;
                    });
                  },
                ),
                TextfieldWidget(
                  hint: Constants.HINT_EMAIL,
                  inputType: TextInputType.emailAddress,
                  onTextChange: (value) {
                    setState(() {
                      email = value;
                    });
                  },
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
                TextfieldWidget(
                  hint: Constants.HINT_CONFIRM_PASSWORD,
                  isPassword: true,
                  onTextChange: (value) {
                    setState(() {
                      confirmPassword = value;
                    });
                  },
                ),
                SubmitButtonWidget(onPressed: () {
                  if (_validateFields()) {
                    if (_validatePassword()) {
                      _registerUser();
                    } else {
                      AppUtils.showToast("Passwords do not match");
                    }
                  } else {
                    AppUtils.showToast(Constants.HINT_FILL_ALL_FIELDS);
                  }
                }),
                // ORWidget(),
                // OutlineButton(
                //   highlightedBorderColor: AppTheme.PrimaryDarkColor,
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                //     child: Text(
                //       Constants.LOGIN,
                //     ),
                //   ),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                // )
              ],
            ),
          ),
        ));
  }

  bool _validateFields() {
    return email != null &&
        email.isNotEmpty &&
        name != null &&
        name.isNotEmpty &&
        password != null &&
        password.isNotEmpty &&
        confirmPassword != null &&
        confirmPassword.isNotEmpty;
  }

  _registerUser() {
    _pageSubmitting(true);
    Repository()
        .register(
            name: name,
            password: password,
            email: email,
            country: _country,
            city: _city)
        .then((data) {
      if (data[Constants.KEY_CODE] == 0) {
        AppUtils.showToast(data[Constants.KEY_ERROR]);
        print(data[Constants.KEY_ERROR]);
      } else {
        AppUtils.showToast(data[Constants.KEY_RESPONSE]);
        print(data[Constants.KEY_RESPONSE]);
      }
      _pageSubmitting(false);
    }).catchError((onError) {
      AppUtils.showToast(Constants.NETWORK_ERROR);
      print(onError);
      _pageSubmitting(false);
    });
  }

  bool _validatePassword() {
    return password == confirmPassword;
  }

  _pageSubmitting(bool showLoading) {
    setState(() {
      isSubmitting = showLoading;
    });
  }
}
