import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/routes/routes.dart';
import 'package:vipepeo_app/screens/add_child.dart';
import 'package:vipepeo_app/screens/add_profession.dart';
import 'package:vipepeo_app/screens/change_password.dart';
import 'package:vipepeo_app/screens/edit_user_profile.dart';
import 'package:vipepeo_app/screens/login.dart';
import 'package:vipepeo_app/screens/view_full_image.dart';
import 'package:vipepeo_app/utils/utils.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final String _defaultImage = "assets/meddie.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(Constants.PROFILE),
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
          _showPopupMenu(),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        color: AppTheme.PrimaryDarkColor,
                        height: 80,
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            child: Hero(
                              tag: state.data.image ?? _defaultImage,
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
                                            image: state.data.image != null
                                                ? CachedNetworkImageProvider(
                                                    state.data.image)
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
                              String imageUrl =
                                  state.data.image ?? _defaultImage;
                              var type = state.data.image != null ? 0 : 1;
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
                                    state.data.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  // InkWell(
                                  //   child: Icon(Icons.edit),
                                  // )
                                ],
                              ),
                              Text(state.data.email ?? ''),
                              const SizedBox(
                                height: 4,
                              ),
                              RaisedButton(
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                        color: AppTheme.PrimaryDarkColor),
                                  ),
                                  onPressed: () {
                                    AppUtils(context).nextPage(
                                        page: const EditUserProfileScreen());
                                  })
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlineButton(
                              onPressed: null,
                              child: Text(state.data.country ?? ''),
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlineButton(
                              onPressed: null,
                              child: Text(state.data.city ?? ''),
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Children",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          child: const Chip(
                              avatar: Icon(Icons.add),
                              label: Text("Add child"),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.PrimaryDarkColor)),
                          onTap: () {
                            AppUtils(context).nextPage(page: AddChilScreen(
                              onChildAdded: (child) {
                                // setState(() {
                                //   listChildren.insert(0, child);
                                // });
                              },
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                  _tableChildren(state.data.children),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _showPopupMenu() => PopupMenuButton<int>(
      onSelected: (index) {
        if (index == 4) {
          AppUtils(context).nextPage(page: const ChangePasswordScreen());
        }
        if (index == 5) {
          Repository().logout().then((onValue) {
            // Remove all the previous Routes from the [Route] tree
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                (route) => false);
          });
        }
        if (index == 3) {
          AppUtils(context).nextPage(page: const StackBottom());
        }
        if (index == 6) {
          AppUtils(context).nextPage(page: const AddProfessionScreen());
        }
      },
      itemBuilder: (context) => [
            const PopupMenuItem(
              child: Text(
                'Account Settings',
                style: TextStyle(color: AppTheme.PrimaryDarkColor),
              ),
              value: 1,
            ),
            const PopupMenuItem(
                child: Text('Notifications',
                    style: TextStyle(color: AppTheme.PrimaryDarkColor)),
                value: 2),
            const PopupMenuItem(
                child: Text('Add Profession',
                    style: TextStyle(color: AppTheme.PrimaryDarkColor)),
                value: 6),
            const PopupMenuItem(
                child: Text('Help',
                    style: TextStyle(color: AppTheme.PrimaryDarkColor)),
                value: 3),
            const PopupMenuItem(
                child: Text('Change password',
                    style: TextStyle(color: AppTheme.PrimaryDarkColor)),
                value: 4),
            PopupMenuItem(
              child: const Text('Logout',
                  style: TextStyle(color: AppTheme.PrimaryDarkColor)),
              value: 5,
              onTap: () {
                BlocProvider.of<AuthBloc>(context).add(Logout());
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.login, (route) => false);
              },
            )
          ]);

  Widget _tableChildren(List<Child> listChidren) {
    return DataTable(
        columns: const [
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
