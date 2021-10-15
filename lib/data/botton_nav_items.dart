import 'package:flutter/material.dart';
import 'package:vipepeo_app/models/destination.dart';
import 'package:vipepeo_app/utils/constants.dart';

const List<Destination> allDestinations = <Destination>[
  Destination(Constants.HOME, Icons.home, Colors.teal),
  Destination(Constants.ARTICLES, Icons.move_to_inbox, Colors.teal),
  Destination(Constants.ASK, Icons.chat, Colors.cyan),
  Destination(Constants.NOTIFICATIONS, Icons.notifications, Colors.orange),
];
