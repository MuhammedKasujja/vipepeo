import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vipepeo_app/models/event.dart';
import 'package:vipepeo_app/screens/event_details.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';

const textPadding = 6.0;

class EventItemWidget extends StatelessWidget {
  final Event event;

  const EventItemWidget({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
              left: BorderSide(
                //                   <--- left side
                color: AppTheme.PrimaryDarkColor,
                width: 3.0,
              ),
            )),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(event.photo),
                            fit: BoxFit.fill)),
                  ),
                ),
                Column(
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
                          padding: const EdgeInsets.only(left: textPadding),
                          child: Text(event.startDate ?? 'Wed, Nov 28'),
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
                          padding: const EdgeInsets.only(left: textPadding),
                          child: Text(
                            event.theme ?? "How to make your child fit in",
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                          padding: const EdgeInsets.only(left: textPadding),
                          child: Text(
                              event.locDistrict ?? "Special parents Mukono"),
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
                          padding: const EdgeInsets.only(left: textPadding),
                          child:
                              Text(event.street ?? "4 PM, Abba House, Lumuli."),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        AppUtils(context).nextPage(page: EventDetailsScreen(event: event));
      },
    );
  }
}
