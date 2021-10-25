import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class AddChilScreen extends StatefulWidget {
  final Function(Child child) onChildAdded;

  const AddChilScreen({Key key, this.onChildAdded}) : super(key: key);
  @override
  _AddChilScreenState createState() => _AddChilScreenState();
}

class _AddChilScreenState extends State<AddChilScreen> {
  String gender, firstname, lastname, dob;
  List<ChildCondition> childConditions;
  List selectedConditions = [];
  @override
  void initState() {
    final _childConditionsBloc = BlocProvider.of<ChildConditionsBloc>(context);
    if (_childConditionsBloc.state.data == null) {
      _childConditionsBloc.add(FetchChildConditions());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Child"),
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Tell us about your child',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextfieldWidget(
                    inputType: TextInputType.text,
                    onTextChange: (value) {
                      setState(() {
                        firstname = value;
                      });
                    },
                    hint: 'Firstname'),
                TextfieldWidget(
                    inputType: TextInputType.text,
                    onTextChange: (value) {
                      setState(() {
                        lastname = value;
                      });
                    },
                    hint: 'Lastname'),
                Row(
                  children: const <Widget>[
                    Text(
                      "Gender",
                      style: TextStyle(
                        color: AppTheme.PrimaryDarkColor,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    FlatButton.icon(
                      splashColor: Colors.transparent,
                      label: const Text('Male'),
                      icon: Radio(
                        value: 'M',
                        groupValue: gender,
                        onChanged: _changeGender,
                      ),
                      onPressed: () {
                        _changeGender('M');
                      },
                    ),
                    FlatButton.icon(
                      splashColor: Colors.transparent,
                      label: const Text("Female"),
                      icon: Radio(
                        value: 'F',
                        groupValue: gender,
                        onChanged: _changeGender,
                      ),
                      onPressed: () {
                        _changeGender('F');
                      },
                    ),
                  ],
                ),
                CustomDateOfBirth(
                  onDateChanged: ({day, month, year}) {
                    setState(() {
                      dob = '$day/$month/$year';
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: const [
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
                ChildConditionWidget(
                  onselectedConditions: (conditions) {
                    // setState(() {
                    selectedConditions = conditions;
                    // });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.status != AppStatus.loading) {
                      AppUtils.showToast(state.message);
                    }
                    if (state.success) {
                      Navigator.pop(context);
                    }
                  },
                  child: SubmitButtonWidget(onPressed: () {
                    if (_validateFields()) {
                      BlocProvider.of<AuthBloc>(context).add(AddChild(
                        firstname: firstname,
                        lastname: lastname,
                        dob: dob,
                        gender: gender,
                        conditions: selectedConditions,
                      ));
                    } else {
                      AppUtils.showToast(Constants.HINT_FILL_ALL_FIELDS);
                    }
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _changeGender(value) {
    setState(() {
      gender = value;
    });
  }

  bool _validateFields() {
    return firstname != null &&
        firstname.isNotEmpty &&
        lastname != null &&
        lastname.isNotEmpty &&
        gender != null &&
        gender.isNotEmpty &&
        dob != null &&
        dob.isNotEmpty;
  }
}
