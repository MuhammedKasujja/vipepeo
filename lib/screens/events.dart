import 'package:flutter/material.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/screens/add_edit_community.dart';
import 'package:vipepeo_app/screens/add_edit_event.dart';
import 'package:vipepeo_app/screens/commuties_list.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/widgets/add_icon.dart';
import 'package:vipepeo_app/widgets/category_item.dart';
import 'package:vipepeo_app/widgets/event_type_icon.dart';
import 'package:vipepeo_app/widgets/eventlist.dart';
import 'package:vipepeo_app/utils/constants.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  var currentEventIndex = 0;
  var selectedColor = AppTheme.PrimaryDarkColor;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        const CommunityListWidget(),
        Center(
          child: InkWell(
            child: const Text(
              "+ New Group",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            onTap: () {
              AppUtils(context).nextPage(page: const AddCommunityScreen());
            },
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 16,
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Events",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: AddIcon(
                page: AddEditEventScreen(),
              ),
            ),
          ],
        ),
        CategoryWidget(),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              EventTypeIcon(
                  textColor:
                      currentEventIndex == 0 ? Colors.white : selectedColor,
                  color: currentEventIndex == 0 ? selectedColor : Colors.white,
                  type: Constants.EVENT_TYPE_SUGGESTED,
                  onSelected: () {
                    setState(() {
                      currentEventIndex = 0;
                    });
                  }),
              EventTypeIcon(
                  textColor:
                      currentEventIndex == 1 ? Colors.white : selectedColor,
                  color: currentEventIndex == 1 ? selectedColor : Colors.white,
                  type: Constants.EVENT_TYPE_SAVED,
                  onSelected: () {
                    setState(() {
                      currentEventIndex = 1;
                    });
                  }),
              EventTypeIcon(
                textColor:
                    currentEventIndex == 2 ? Colors.white : selectedColor,
                color: currentEventIndex == 2 ? selectedColor : Colors.white,
                type: Constants.EVENT_TYPE_GOING,
                onSelected: () {
                  setState(() {
                    currentEventIndex = 2;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        IndexedStack(
          index: currentEventIndex,
          children: const <Widget>[
            EventItemListScreen(
              key: Key("items1"),
              eventType: EventType.Suggested,
            ),
            EventItemListScreen(
              key: Key("items2"),
              eventType: EventType.Saved,
            ),
            EventItemListScreen(
              key: Key("items3"),
              eventType: EventType.Going,
            ),
          ],
        )
      ],
    );
  }
}
