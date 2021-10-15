import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/screens/add_child.dart';
import 'package:vipepeo_app/screens/add_profession.dart';
import 'package:vipepeo_app/screens/change_password.dart';
import 'package:vipepeo_app/screens/edit_user_profile.dart';
import 'package:vipepeo_app/screens/login.dart';
import 'package:vipepeo_app/screens/view_full_image.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:vipepeo_app/utils/stack_bottom.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<Child> listChildren;
  String name = "Kasujja Muhammed";
  String _profilePhoto;
  String _defaultImage = "assets/meddie.jpg";
  String email, country, city;
  AppState appState;
  @override
  void initState() {
    appState = Provider.of<AppState>(context, listen: false);

    if (appState.user != null) {
      listChildren = appState.user.children;
      name = appState.user.name;
      email = appState.user.email;
      country = appState.user.country;
      city = appState.user.city;
    } else {}

    Repository().loadPrefs().then((map) {
      if (map.containsKey(Constants.KEY_PROFILE_PHOTO) &&
          map[Constants.KEY_PROFILE_PHOTO] != null) {
        setState(() {
          _profilePhoto = map[Constants.KEY_PROFILE_PHOTO];
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(Constants.PROFILE),
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
          _showPopupMenu(),
        ],
      ),
      body: Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      color: AppTheme.PrimaryDarkColor,
                      height: 80,
                    ),
                    Container(
                      //height: MediaQuery.of(context).size.height / 4,
                      // height: 200,
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            child: Hero(
                              tag: _profilePhoto != null
                                  ? _profilePhoto
                                  : _defaultImage,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 12, top: 4),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: _profilePhoto != null
                                                ? CachedNetworkImageProvider(
                                                    _profilePhoto)
                                                : AssetImage(
                                                    _defaultImage,
                                                  ),
                                            fit: BoxFit.cover)),
                                    // child: Icon(
                                    //   Icons.add_a_photo,
                                    //   size: 65,
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              String imageUrl = _profilePhoto != null
                                  ? _profilePhoto
                                  : _defaultImage;
                              var type = _profilePhoto != null ? 0 : 1;
                              AppUtils(context).nextPage(
                                  page: ViewFullImageScreen(
                                imageUrl: imageUrl,
                                imageType: type,
                              ));
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  // InkWell(
                                  //   child: Icon(Icons.edit),
                                  // )
                                ],
                              ),
                              Text(email ?? ''),
                              SizedBox(
                                height: 4,
                              ),
                              RaisedButton(
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                        color: AppTheme.PrimaryDarkColor),
                                  ),
                                  onPressed: () {
                                    AppUtils(context).nextPage(
                                        page: EditUserProfileScreen(
                                      userToken: appState.userToken,
                                      onPhotoChanged: (photoUrl) {
                                        setState(() {
                                          _profilePhoto = photoUrl;
                                        });
                                      },
                                    ));
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          child: OutlineButton(
                            onPressed: null,
                            child: Text(country ?? 'country'),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          child: OutlineButton(
                            onPressed: null,
                            child: Text(city ?? 'city'),
                          ),
                        )),
                  ],
                ),
                // SizedBox(height: 20),
                // InkWell(
                //   child: Row(
                //     children: <Widget>[
                //       Padding(
                //         padding: const EdgeInsets.only(
                //           left: 8.0,
                //         ),
                //         child: Text(
                //           "Profession",
                //           style: TextStyle(color: Colors.black, fontSize: 17),
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(
                //           left: 4.0,
                //         ),
                //         child: AddIcon(
                //             page: AddProfessionScreen(
                //                 userToken: widget.userToken)),
                //       ),
                //     ],
                //   ),
                //   onTap: () {
                //     AppUtils(context).nextPage(
                //         page: AddProfessionScreen(userToken: widget.userToken));
                //   },
                // ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Children",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: InkWell(
                        child: Chip(
                            avatar: Icon(Icons.add),
                            label: Text("Add child"),
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.PrimaryDarkColor)),
                        onTap: () {
                          AppUtils(context).nextPage(
                              page: AddChilScreen(
                            userToken: appState.userToken,
                            onChildAdded: (child) {
                              setState(() {
                                listChildren.insert(0, child);
                              });
                            },
                          ));
                        },
                      ),
                    ),
                  ],
                ),
                listChildren != null
                    ? _tableChildren(listChildren)
                    : Container(),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showPopupMenu() => PopupMenuButton<int>(
      onSelected: (index) {
        if (index == 4) {
          AppUtils(context).nextPage(page: ChangePasswordScreen());
        }
        if (index == 5) {
          Repository().logout().then((onValue) {
            // Remove all the previous Routes from the [Route] tree
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (ctx) => LoginScreen()),
                (route) => false);
          });
        }
        if (index == 3) {
          AppUtils(context).nextPage(page: StackBottom());
        }
        if (index == 6) {
          AppUtils(context).nextPage(
              page: AddProfessionScreen(userToken: appState.userToken));
        }
      },
      itemBuilder: (context) => [
            PopupMenuItem(
              child: Text(
                'Account Settings',
                style: TextStyle(color: AppTheme.PrimaryDarkColor),
              ),
              value: 1,
            ),
            PopupMenuItem(
                child: Text('Notifications',
                    style: TextStyle(color: AppTheme.PrimaryDarkColor)),
                value: 2),
            PopupMenuItem(
                child: Text('Add Profession',
                    style: TextStyle(color: AppTheme.PrimaryDarkColor)),
                value: 6),
            PopupMenuItem(
                child: Text('Help',
                    style: TextStyle(color: AppTheme.PrimaryDarkColor)),
                value: 3),
            PopupMenuItem(
                child: Text('Change password',
                    style: TextStyle(color: AppTheme.PrimaryDarkColor)),
                value: 4),
            PopupMenuItem(
                child: Text('Logout',
                    style: TextStyle(color: AppTheme.PrimaryDarkColor)),
                value: 5)
          ]);

  Widget _tableChildren(List<Child> listChidren) {
    return DataTable(
        columns: [
          // DataColumn(label: Text("#")),
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Gender")),
          DataColumn(label: Text("Age")),
        ],
        rows: listChidren
            .map((child) => DataRow(
                  cells: [
                    // DataCell(InkWell(child: Icon(Icons.edit, size: 20,),)),
                    DataCell(
                      Text(child.name),
                      showEditIcon: false,
                    ),
                    DataCell(Text(child.gender.toString())),
                    DataCell(Text(child.age.toString())),
                  ],
                ))
            .toList());
  }
}
