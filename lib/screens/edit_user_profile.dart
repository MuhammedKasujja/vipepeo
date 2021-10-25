import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({Key key}) : super(key: key);

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  String fname, lname;
  final emailController = TextEditingController();

  var _image;
  String _photoUrl;

  @override
  void initState() {
    final _authState = BlocProvider.of<AuthBloc>(context).state;
    emailController.text = _authState.data.email;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.EDIT_PROFILE),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_photoUrl != null) {
                Repository().photoPrefs(_photoUrl).then((value) {
                  if (value) {}
                });
              }
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Repository()
                    .updateProfile(
                        email: emailController.text,
                        name: '$fname $lname',
                        filePath: _image.path)
                    .then((data) {
                  print("Data $data");
                  // AppUtils.showToast(data[Constants.KEY_RESPONSE]);
                  setState(() {
                    // _photoUrl = data['photo'];
                  });
                  AppUtils.showToast('Saved Successfully');
                });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.8,
                // height: 200,
                child: Center(child: CircularImageWidget(
                  onImageChanged: (image) {
                    setState(() {
                      _image = image;
                    });
                    print(image);
                  },
                )),
              ),
              TextfieldWidget(
                  onTextChange: (value) {
                    setState(() {
                      fname = value;
                    });
                  },
                  hint: Constants.HINT_FIRSTNAME),
              TextfieldWidget(
                  onTextChange: (value) {
                    setState(() {
                      lname = value;
                    });
                  },
                  hint: Constants.HINT_LASTNAME),
              Column(
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    // onChanged: this.onTextChange,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Constants.HINT_EMAIL,
                        labelStyle:
                            TextStyle(color: AppTheme.PrimaryDarkColor)),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
              // TextfieldWidget(
              //     onTextChange: (value) {
              //       setState(() {
              //         email = value;
              //       });
              //     },
              //     hint: Constants.HINT_EMAIL),
              //Spacer(),
              const SizedBox(height: 20),
              InkWell(
                child: const Text(
                  "I would love to help",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      //fontSize: 18,
                      color: Colors.grey),
                ),
                onTap: () {
                  print("object");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
