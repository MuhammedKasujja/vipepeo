import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/utils/utils.dart';

import 'blocs/blocs.dart';
import 'routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _appBlocs,
      child: MaterialApp(
          title: Constants.APP_NAME,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // scaffoldBackgroundColor: Colors.grey[200],
            primaryColor: AppTheme.PrimaryColor,
            primaryColorDark: AppTheme.PrimaryDarkColor,
            primaryColorLight: AppTheme.PrimaryAssentColor,
            errorColor: AppTheme.ErrorColor,
            toggleableActiveColor: AppTheme.PrimaryColor,
            // primarySwatch: Colors.grey,
            // primarySwatch: const Color.fromRGBO(r, g, b, opacity),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textSelectionTheme: const TextSelectionThemeData(
                cursorColor: AppTheme.PrimaryDarkColor),
          ),
          initialRoute: Routes.splash,
          routes: appRoutes),
    );
  }
}

List<BlocProvider> get _appBlocs => [
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(),
      ),
      BlocProvider<ChildConditionsBloc>(
        create: (context) => ChildConditionsBloc(),
      ),
      BlocProvider<EventsBloc>(
        create: (context) => EventsBloc(),
      ),
      BlocProvider<GroupsBloc>(
        create: (context) => GroupsBloc(),
      ),
      BlocProvider<QuestionAnswersBloc>(
        create: (context) => QuestionAnswersBloc(),
      ),
      BlocProvider<QuestionsBloc>(
        create: (context) => QuestionsBloc(),
      ),
      BlocProvider<TopicsBloc>(
        create: (context) => TopicsBloc(),
      ),
      BlocProvider<CommentsBloc>(
        create: (context) => CommentsBloc(),
      ),
      BlocProvider<NotificationsBloc>(
        create: (context) => NotificationsBloc(),
      ),
    ];
