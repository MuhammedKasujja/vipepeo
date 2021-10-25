import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name, email, password, confirmPassword, _country = "UG", _city;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(Constants.REGISTER),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: BlocBuilder<AuthBloc, AuthState>(
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
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.status == AppStatus.loaded) {
                      AppUtils.showToast(state.message);
                      if (state.success) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      }
                    }
                    if (state.status == AppStatus.failure) {
                      if (state.error != null) {
                        AppUtils.showToast(state.error);
                      }
                    }
                  },
                  child: SubmitButtonWidget(onPressed: _registerUser),
                ),
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
    if (_validateFields()) {
      if (_validatePassword()) {
        BlocProvider.of<AuthBloc>(context).add(Register(
            name: name,
            password: password,
            email: email,
            country: _country,
            city: _city));
      } else {
        AppUtils.showToast("Passwords do not match");
      }
    } else {
      AppUtils.showToast(Constants.HINT_FILL_ALL_FIELDS);
    }
  }

  bool _validatePassword() {
    return password == confirmPassword;
  }
}
