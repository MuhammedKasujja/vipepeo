import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/widgets/event_widget.dart';

class EventItemListScreen extends StatefulWidget {
  final EventType eventType;

  const EventItemListScreen({Key key, this.eventType}) : super(key: key);
  @override
  _EventItemListScreenState createState() => _EventItemListScreenState();
}

class _EventItemListScreenState extends State<EventItemListScreen> {
  @override
  void initState() {
    BlocProvider.of<EventsBloc>(context).add(FetchEvents(widget.eventType));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        if (widget.eventType == EventType.Suggested &&
            state.suggested != null) {
          return _showData(state.suggested);
        }
        if (widget.eventType == EventType.Saved && state.saved != null) {
          return _showData(state.saved);
        }
        if (widget.eventType == EventType.Going && state.going != null) {
          return _showData(state.going);
        }
        if (state.status == AppStatus.loading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Loading data...',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          );
        }
        // if (state.status == AppStatus.loaded) {

        // }
        return const Center(child: Text('No data found'));
      },
    );
  }

  Widget noDataFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Please save some events',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showData(List<Event> snapshot) {
    if (snapshot.isEmpty) return noDataFound();
    return ListView.builder(
      itemCount: snapshot?.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return EventWidget(
          event: snapshot[index],
        );
      },
    );
  }
}
