import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class AddTopicScreen extends StatefulWidget {
  final String userToken;

  const AddTopicScreen({Key key, this.userToken}) : super(key: key);
  @override
  _AddTopicScreenState createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  List<ChildCondition> childConditions;
  String title, _desc;
  List selectedConditions = [];
  @override
  void initState() {
    final _childConditionsBloc = BlocProvider.of<ChildConditionsBloc>(context);
    if (_childConditionsBloc.state.data == null) {
      _childConditionsBloc.add(FetchChildConditions());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Topic"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextfieldWidget(
                  onTextChange: (val) {
                    setState(() {
                      title = val;
                    });
                  },
                  hint: 'Title'),
              DescriptionTextfieldWidget(
                onTextChange: (val) {
                  setState(() {
                    _desc = val;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MultiSelectDialog(
                title: 'Topics',
                onselectedConditions: (conditions) {
                  selectedConditions = conditions;
                },
              ),
              // childConditions != null
              //     ? _checklistConditions()
              //     : LoadingWidget(),
              const SizedBox(
                height: 10,
              ),
              BlocListener<TopicsBloc, TopicsState>(
                listener: (context, state) {
                  if (state.status == AppStatus.failure) {
                    AppUtils.showToast(state.error);
                  }
                  if (state.status == AppStatus.loaded) {
                    AppUtils.showToast(state.message);
                  }
                },
                child: SubmitButtonWidget(onPressed: () {
                  BlocProvider.of<TopicsBloc>(context)
                      .add(AddTopic(title, _desc, selectedConditions));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
