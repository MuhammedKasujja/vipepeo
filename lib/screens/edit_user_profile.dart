import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:vipepeo_app/widgets/circular_image.dart';
import 'package:vipepeo_app/widgets/textfield.dart';

class EditUserProfileScreen extends StatefulWidget {
  final String userToken;
  final Function(String photoUrl) onPhotoChanged;

  const EditUserProfileScreen(
      {Key key, @required this.userToken, @required this.onPhotoChanged})
      : super(key: key);

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  String fname, lname;
  TextEditingController emailController = TextEditingController();
  var _image;
  String _photoUrl;
  var user;
  @override
  void initState() {
    user = Provider.of<AppState>(context, listen: false).user;
    emailController.text = user.email;
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
        title: Text(Constants.EDIT_PROFILE),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (_photoUrl != null) {
                Repository().photoPrefs(_photoUrl).then((value) {
                  if (value) {
                    widget.onPhotoChanged(_photoUrl);
                  }
                });
              }
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                Repository(token: widget.userToken)
                    .updateProfile(
                        email: emailController.text,
                        name: '$fname $lname',
                        filePath: _image.path)
                    .then((data) {
                  print("Data $data");
                  // AppUtils.showToast(data[Constants.KEY_RESPONSE]);
                  setState(() {
                    _photoUrl = data['photo'];
                  });
                  AppUtils.showToast('Saved Successfully');
                });
              })
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
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
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: Constants.HINT_EMAIL,
                          labelStyle:
                              TextStyle(color: AppTheme.PrimaryDarkColor)),
                    ),
                    SizedBox(
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
                SizedBox(height: 20),
                InkWell(
                  child: Text(
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
      ),
    );
  }
}
