import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:vipepeo_app/widgets/submit_button.dart';
import 'package:vipepeo_app/widgets/textfield.dart';

class AddProfessionScreen extends StatefulWidget {
  const AddProfessionScreen({Key key}) : super(key: key);
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
        title: const Text("Add Profession"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
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
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'More info',
                    labelStyle: TextStyle(color: AppTheme.PrimaryDarkColor)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextfieldWidget(
                  onTextChange: (value) {
                    setState(() {
                      spec = value;
                    });
                  },
                  hint: 'Specifications'),
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
                  BlocProvider.of<AuthBloc>(context)
                      .add(AddProfession(prof, spec, infoController.text));
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
