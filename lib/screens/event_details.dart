import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/screens/add_edit_event.dart';
import 'package:vipepeo_app/screens/event_comments.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/screens/view_full_image.dart';
import 'package:vipepeo_app/widgets/circular_clipper.dart';

const textPadding = 8.0;

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({Key key, @required this.event}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isGoing = false;
  bool isSaved = false;
  bool isGoingLoading = false;
  bool isSavedLoading = false;
  AppState appState;
  @override
  void initState() {
    appState = Provider.of<AppState>(context, listen: false);
    print('EventSaved: ${widget.event.isSaved}');
    isSaved = widget.event.isSaved;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Event Details"),
      //   actions: <Widget>[
      //     appState.user.email == widget.event.createdBy
      //         ? IconButton(
      //             tooltip: 'Edit',
      //             icon: Icon(
      //               Icons.edit,
      //               color: Colors.white,
      //             ),
      //             onPressed: () {
      //               AppUtils(context).nextPage(
      //                   page: AddEditEventScreen(
      //                 event: widget.event,
      //                 updateEvent: this._updateEvent,
      //               ));
      //             })
      //         : Container(),
      //     IconButton(
      //         tooltip: 'Event conmments',
      //         icon: Icon(
      //           Icons.comment,
      //           color: Colors.white,
      //         ),
      //         onPressed: () {
      //           AppUtils(context)
      //               .nextPage(page: EventCommentsScreen(event: widget.event));
      //         }),
      //   ],
      // ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: 380,
                  transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                  child: Hero(
                    tag: this.widget.event.photo,
                    child: ClipShadowPath(
                      clipper: CircularClipper(),
                      shadow: Shadow(blurRadius: 20.0),
                      child: CachedNetworkImage(
                        imageUrl: this.widget.event.photo,
                        imageBuilder: (context, imageProvider) => Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: imageProvider)),
                        ),
                        errorWidget: (context, url, data) => Container(
                            color: Colors.grey[300],
                            width: double.infinity,
                            child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  AppUtils(context).nextPage(
                      page: ViewFullImageScreen(
                    imageUrl: this.widget.event.photo,
                  ));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      padding: EdgeInsets.only(left: 25.0),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      iconSize: 30.0,
                      onPressed: () => Navigator.pop(context)),
                  appState.user.email == widget.event.createdBy
                      ? IconButton(
                          tooltip: 'Edit',
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            AppUtils(context).nextPage(
                                page: AddEditEventScreen(
                              event: widget.event,
                              updateEvent: this._updateEvent,
                            ));
                          })
                      : Container(),
                ],
              ),
              Positioned.fill(
                  bottom: 15.0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: RawMaterialButton(
                      elevation: 12.0,
                      padding: EdgeInsets.all(15.0),
                      onPressed: () {
                        AppUtils(context).nextPage(
                            page: EventCommentsScreen(event: widget.event));
                      },
                      shape: CircleBorder(),
                      fillColor: AppTheme.PrimaryDarkColor,
                      child: Icon(
                        Icons.comment,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  )),
              Positioned(
                  bottom: 10.0,
                  left: 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.event_available,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${this.widget.event.startDate}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              Positioned(
                  bottom: 10.0,
                  right: 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.event_busy,
                        size: 18.0,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${this.widget.event.endDate}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              Positioned(
                  bottom: 100,
                  left: 25,
                  child: Text(
                    '${widget.event.theme}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.5),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Speaker",
                              style:
                                  TextStyle(color: AppTheme.PrimaryDarkColor),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              this.widget.event.speaker ?? "Muhammed Kasujja",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.newspaper,
                              size: 15,
                              color: AppTheme.APP_COLOR,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: textPadding),
                              child: Text(
                                this.widget.event.theme,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              size: 15,
                              color: AppTheme.APP_COLOR,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: textPadding),
                              child: Text(
                                  '''${_formatTime(this.widget.event.startTime)}  -  ${_formatTime(this.widget.event.endTime)}'''),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 15,
                              color: AppTheme.APP_COLOR,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: textPadding),
                              child: Text(
                                  '${this.widget.event.locDistrict}, ${this.widget.event.street} '),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Created by'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            widget.event.createdBy,
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
                flex: 1,
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: AppTheme.PrimaryDarkColor,
                      padding: EdgeInsets.all(0),
                      width: double.infinity,
                      child: OutlineButton(
                        hoverColor: Colors.green,
                        onPressed: _joinLeaveEvent,
                        child: Text(
                          isGoing ? "Attending" : 'Attend Event',
                        ),
                      ),
                    ),
                    isGoingLoading ? _loadingIcon() : Container()
                  ],
                )),
            Flexible(
                flex: 1,
                child: Stack(
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: _saveRemoveEvent,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all()),
                        child: Center(
                          child: Text(
                            isSaved ? "Saved" : 'Save Event',
                          ),
                        ),
                      ),
                    ),
                    isSavedLoading ? _loadingIcon() : Container()
                  ],
                )),
          ],
        ),
      ),
    );
    // bottomSheet: CommentWidget(onSendClicked: null));
  }

  _joinLeaveEvent() {
    setState(() {
      isGoingLoading = true;
    });
    appState.attendOrDontAttendEvent(widget.event.id).then((value) {
      print(value);
      if (mounted)
        setState(() {
          isGoing = !isGoing;
          isGoingLoading = false;
        });
    }).catchError((onError) {
      if (mounted)
        setState(() {
          isGoingLoading = false;
        });
      print(onError);
    });
  }

  _saveRemoveEvent() {
    setState(() {
      isSavedLoading = true;
    });
    appState.saveRemoveEvent(widget.event.id).then((value) {
      print(value);
      if (mounted)
        setState(() {
          isSaved = !isSaved;
          isSavedLoading = false;
        });
      appState.loadInitialData();
    }).catchError((onError) {
      if (mounted)
        setState(() {
          isSavedLoading = false;
        });
      print(onError);
    });
  }

  Widget _loadingIcon() {
    return Positioned.fill(
        child: Container(
            child: Center(
                child: Container(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator()))));
  }

  _updateEvent(Event event) {
    setState(() {
      widget.event.speaker = event.speaker;
      widget.event.endDate = event.endDate;
      widget.event.startDate = event.startDate;
      widget.event.locDistrict = event.locDistrict;
      widget.event.street = event.street;
      widget.event.theme = event.theme;
      widget.event.startTime = event.startTime;
      widget.event.endTime = event.endTime;
      widget.event.country = event.country;
      widget.event.organizer = event.organizer;
    });
  }

  String _formatTime(String time) {
    if (time.length > 5) {
      return time.replaceRange(5, 8, '');
    }
    return time;
  }
}
