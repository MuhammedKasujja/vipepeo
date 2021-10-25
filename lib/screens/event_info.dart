import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/screens/add_edit_event.dart';
import 'package:vipepeo_app/screens/event_comments.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/screens/view_full_image.dart';

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

  @override
  void initState() {
    isSaved = widget.event.isSaved;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Event Details"),
            actions: <Widget>[
              state.data.email == widget.event.createdBy
                  ? IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        AppUtils(context).nextPage(
                            page: AddEditEventScreen(
                          event: widget.event,
                          updateEvent: _updateEvent,
                        ));
                      })
                  : Container(),
              IconButton(
                  tooltip: 'Event conmments',
                  icon: const Icon(
                    Icons.comment,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    AppUtils(context).nextPage(
                        page: EventCommentsScreen(event: widget.event));
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height -
                      (kToolbarHeight + kBottomNavigationBarHeight),
                ),
                GestureDetector(
                  child: Hero(
                    tag: widget.event.photo,
                    child: CachedNetworkImage(
                        imageUrl: widget.event.photo,
                        imageBuilder: (context, imageProvider) => Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image: imageProvider)),
                            )),
                  ),
                  onTap: () {
                    AppUtils(context).nextPage(
                        page: ViewFullImageScreen(
                      imageUrl: widget.event.photo,
                    ));
                  },
                ),
                Positioned(
                  top: 220,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30))),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  const Text(
                                    "Speaker",
                                    style: TextStyle(
                                        color: AppTheme.PrimaryDarkColor),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.event.speaker ?? "Muhammed Kasujja",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              // Stack(
                              //   children: <Widget>[
                              //     InkWell(
                              //       child: Chip(
                              //         label: Text(
                              //           isGoing ? "Leave Event" : 'Attend Event',
                              //           style: TextStyle(color: Colors.white),
                              //         ),
                              //         backgroundColor: AppTheme.PrimaryDarkColor,
                              //       ),
                              //       onTap: () {
                              //         _joinLeaveEvent();
                              //       },
                              //     ),
                              //     isGoingLoading
                              //         ? Positioned.fill(
                              //             child: Container(
                              //                 child: Center(
                              //                     child: Container(
                              //                         width: 15,
                              //                         height: 15,
                              //                         child:
                              //                             CircularProgressIndicator()))))
                              //         : Container()
                              //   ],
                              // ),
                              // Stack(
                              //   children: <Widget>[
                              //     InkWell(
                              //       child: Chip(
                              //         label: Text(
                              //           isSaved ? "Remove Event" : 'Save Event',
                              //           style: TextStyle(color: Colors.white),
                              //         ),
                              //         backgroundColor: AppTheme.PrimaryDarkColor,
                              //       ),
                              //       onTap: _saveRemoveEvent,
                              //     ),
                              //     isSavedLoading
                              //         ? Positioned.fill(
                              //             child: Container(
                              //                 child: Center(
                              //                     child: Container(
                              //                         width: 15,
                              //                         height: 15,
                              //                         child:
                              //                             CircularProgressIndicator()))))
                              //         : Container()
                              //   ],
                              // )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.event_available,
                                    size: 15,
                                    color: AppTheme.APP_COLOR,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: textPadding),
                                    child: Text(
                                        '${widget.event.startDate}  *  ${widget.event.endDate}'),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    FontAwesomeIcons.newspaper,
                                    size: 15,
                                    color: AppTheme.APP_COLOR,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: textPadding),
                                    child: Text(
                                      widget.event.theme,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.location_on,
                                    size: 15,
                                    color: AppTheme.APP_COLOR,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: textPadding),
                                    child: Text(widget.event.locDistrict ?? ''),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.home,
                                    size: 15,
                                    color: AppTheme.APP_COLOR,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: textPadding),
                                    child: Text(widget.event.street),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.timer,
                                    size: 15,
                                    color: AppTheme.APP_COLOR,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: textPadding),
                                    child: Text(
                                        '''${widget.event.startTime.replaceRange(5, 8, '')}  -  ${widget.event.endTime.replaceRange(5, 8, '')}'''),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text('Created by'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  widget.event.createdBy,
                                  style: const TextStyle(color: Colors.grey),
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
          ),
          bottomNavigationBar: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                    flex: 1,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: double.infinity,
                          child: OutlineButton(
                            hoverColor: Colors.green,
                            onPressed: null, // _joinLeaveEvent,
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
                        SizedBox(
                          width: double.infinity,
                          child: OutlineButton(
                            onPressed: null, // _saveRemoveEvent,
                            child: Text(
                              isSaved ? "Saved" : 'Save Event',
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
      },
    );
    // bottomSheet: CommentWidget(onSendClicked: null));
  }

  // _joinLeaveEvent() {
  //   setState(() {
  //     isGoingLoading = true;
  //   });
  //   appState.attendOrDontAttendEvent(widget.event.id).then((value) {
  //     print(value);
  //     if (mounted)
  //       setState(() {
  //         isGoing = !isGoing;
  //         isGoingLoading = false;
  //       });
  //   }).catchError((onError) {
  //     if (mounted)
  //       setState(() {
  //         isGoingLoading = false;
  //       });
  //     print(onError);
  //   });
  // }

  // _saveRemoveEvent() {
  //   setState(() {
  //     isSavedLoading = true;
  //   });
  //   appState.saveRemoveEvent(widget.event.id).then((value) {
  //     print(value);
  //     if (mounted)
  //       setState(() {
  //         isSaved = !isSaved;
  //         isSavedLoading = false;
  //       });
  //     appState.loadInitialData();
  //   }).catchError((onError) {
  //     if (mounted)
  //       setState(() {
  //         isSavedLoading = false;
  //       });
  //     print(onError);
  //   });
  // }

  Widget _loadingIcon() {
    return const Positioned.fill(
        child: Center(
            child: SizedBox(
                width: 15, height: 15, child: CircularProgressIndicator())));
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
}
