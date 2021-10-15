import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/event_fancy.dart';
import 'package:vipepeo_app/widgets/burning_text.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(
      context,
    );
    return Container(
      color: AppTheme.PrimaryColor,
      width: MediaQuery.of(context).size.width - 60,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Container(
                height: 200,
                decoration: const BoxDecoration(color: AppTheme.PrimaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: appState.user != null
                                  ? appState.user.image != null
                                      ? CachedNetworkImageProvider(
                                          appState.user.image)
                                      : const AssetImage(
                                          'assets/meddie.jpg',
                                        )
                                  : const AssetImage(
                                      'assets/meddie.jpg',
                                    ),
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(appState.user != null ? appState.user.email : '')
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Events',
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
              ),
              _drawerTile('Saved',
                  page: FancyEvent(),
                  total: appState.savedEvents != null
                      ? appState.savedEvents.length
                      : 0),
              _drawerTile('Going',
                  page: const BurningTextWidget(),
                  total: appState.interestedEvents != null
                      ? appState.interestedEvents.length
                      : 0),
              const Divider(),
              _drawerTile('Account Settings'),
              _drawerTile('Notification'),
              _drawerTile('Add Profession'),
              _drawerTile('Help'),
              _drawerTile('Change Password'),
              _drawerTile('Logout'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerTile(String title, {page, total}) {
    return ListTile(
        title: Text(title),
        onTap: () {
          Navigator.pop(context);
          if (page != null) {
            AppUtils(context).nextPage(page: page);
          }
        },
        trailing: total != null
            ? Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  const Icon(
                    Icons.notifications,
                    size: 30,
                    color: Colors.red,
                  ),
                  Positioned(
                    right: -4,
                    top: -6,
                    child: CircleAvatar(
                      radius: 10,
                      child: Text(
                        '$total',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                ],
              )
            : const Opacity(
                opacity: 0.0,
              ));
  }
}
