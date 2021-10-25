import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/widgets/loading.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    BlocProvider.of<NotificationsBloc>(context).add(FetchNotifications());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Notifications"),
        // ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state.status == AppStatus.loading) {
          return const LoadingWidget();
        }
        if (state.status == AppStatus.failure) {
          return const Text('Try Again');
        }
        if (state.data != null) {
          return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                // var bgColor = (index%2 ==0 ) ? Colors.blue[50] : Colors.white;
                var notification = state.data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          child: Text(
                              notification.sourceType == 'event' ? 'E' : 'G'),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 20),
                            child: RichText(
                              text: TextSpan(
                                text: '${notification.sender} Shared in ',
                                children: [
                                  TextSpan(
                                      text: '${notification.source} . ',
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // go to source page
                                          print('This sounds great');
                                        }),
                                  TextSpan(
                                    text: '${notification.time}h ago',
                                  )
                                ],
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 40),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      width: 0.1, color: Colors.black54)),
                              child: Text(
                                notification.message,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5),
                              ),
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                );
              });
        }
        return Container();
      },
    ));
  }
}
