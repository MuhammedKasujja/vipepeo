import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/screens/home.dart';
import 'package:vipepeo_app/screens/register.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

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
                  BlocConsumer<AuthBloc, AuthState>(
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
                    builder: (context, state) {
                      return SubmitButtonWidget(onPressed: () {
                        if (_validateFields()) {
                          BlocProvider.of<AuthBloc>(context)
                              .add(Login(email, password));
                        } else {
                          AppUtils.showToast(Constants.HINT_FILL_ALL_FIELDS);
                        }
                      });
                    },
                  ),
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
                      BlocProvider.of<GroupsBloc>(context).add(FetchGroups());
                      // Navigator.push(context, MaterialPageRoute(builder: (_) {
                      //   return const RegisterScreen();
                      // }));
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
}
