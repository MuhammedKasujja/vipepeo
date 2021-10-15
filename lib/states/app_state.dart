import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/constants.dart';

class AppState with ChangeNotifier {
  List<Community> communities;
  Map<String, dynamic> userRefs = {};
  List<ChildCondition> _childConditions;
  List<Question> listQuestions;
  List<Topic> _topics;
  List<Topic> get topics => _topics;
  List<ChildCondition> get childConditions => _childConditions;
  Repository repo = Repository();
  List<Event> savedEvents;
  List<Event> suggestedEvents;
  List<Event> interestedEvents;
  String userToken;
  User user;

  AppState() {
    loadPrefs();
  }

  loadInitialData() {
    getMyGroups();
    getMyMeetups(EventType.Suggested);
    getMyMeetups(EventType.Saved);
    getMyMeetups(EventType.Going);
    getChildConditionsList();
  }

  Future<Map> loadPrefs() async {
    var refs = await repo.loadPrefs();
    userRefs = refs;
    userToken = userRefs[Constants.USER_TOKEN];
    print('Token: $userToken');
    repo = Repository(token: userToken);
    notifyListeners();
    return refs;
  }

  void getUserProfile() async {
    repo.getUserProfile().then((value) {
      print(value);
    });
  }

  void getChildConditions() async {
    var res = await repo.getChildConditions();
    _childConditions = res;
    notifyListeners();
  }

  Future<List<Topic>> fetchTopics() async {
    var res = await repo.fetchTopics().catchError((onError) {
      print(onError);
    });
    _topics = res;
    notifyListeners();
    return res;
  }

  Future<User> getUserData() async {
    var _user = await repo.getUserProfile();
    user = _user;
    print(user.city);
    return _user;
  }

  Future<List<Community>> getMyGroups() async {
    var _communities = await repo.getMyGroups().catchError((onError) {
      print(onError);
    });
    communities = _communities;
    notifyListeners();
    return _communities;
  }

  Future<List<EventComment>> groupComments(groupId) async {
    var data = await repo.groupComment(groupId).catchError((onError) {
      print(onError);
    });
    return data;
  }

  Future<List<EventComment>> eventComments(eventId) async {
    var data = await repo.eventComment(eventId).catchError((onError) {
      print(onError);
    });
    return data;
  }

  Future<Map> makeEventComment(eventId, comment) async {
    var data =
        await repo.makeEventComment(eventId, comment).catchError((onError) {
      print(onError);
    });
    return data;
  }

  Future<Map> makeGroupComment(groupId, comment) async {
    var data =
        await repo.makeGroupComment(groupId, comment).catchError((onError) {
      print(onError);
    });
    return data;
  }

  Future<Map> attendOrDontAttendEvent(eventId) async {
    var data =
        await repo.attendOrDontAttendEvent(eventId).catchError((onError) {
      print(onError);
    });
    return data;
  }

  Future<Map> saveRemoveEvent(eventId) async {
    var data = await repo.saveRemoveEvent(eventId).catchError((onError) {
      print(onError);
    });
    return data;
  }

  Future<Map> joinOrLeaveGroup(groupId) async {
    var data = await repo.joinOrLeaveGroup(groupId).catchError((onError) {
      print(onError);
    });
    return data;
  }

  Future<List<ChildCondition>> getChildConditionsList() async {
    var data = await repo.getChildConditions().catchError((onError) {
      print(onError);
    });
    _childConditions = data;
    notifyListeners();
    return data;
  }

  Future<List<Event>> getMyMeetups(EventType eventType) async {
    var data = await repo.getMyMeetups(eventType).catchError((onError) {
      print(onError);
    });
    if (eventType == EventType.Going) interestedEvents = data;
    if (eventType == EventType.Saved) savedEvents = data;
    if (eventType == EventType.Suggested) suggestedEvents = data;
    notifyListeners();
    return data;
  }

  Future<Map> addEditEvent(Event event,
      {PostData postType = PostData.Save, eventId}) async {
    // print(userToken);
    var res = await repo.addEditEvent(
        event: event, postType: postType, eventId: eventId);
    return res;
  }

  Future<Map> addEditCommunity(Community community,
      {PostData postType, communityId}) async {
    var res = await repo.addEditCommunity(
        community: community, postType: postType, communityId: communityId);
    return res;
  }

  Future<Map> askQuestion(question, topic) async {
    var res = await repo.askQuestion(question: question, topics: topics);
    return res;
  }

  Future<List<Question>> fetchQuestions() async {
    var res = await repo.fetchQuestions().catchError((onError) {
      print(onError);
    });
    listQuestions = res;
    notifyListeners();
    return res;
  }

  Future<List<Answer>> fetchQuestionAnswers(questionId) async {
    var res = await repo.fetchQuestionAnswers(questionId).catchError((onError) {
      print(onError);
    });
    return res;
  }

  Future<Map> answerQuestion(text, questionId) async {
    var res = await repo
        .answerQuestion(answer: text, questioID: questionId)
        .catchError((onError) {
      print(onError);
    });
    return res;
  }

  Future<Map> approveAnswer(answerID) async {
    var res = await repo.approveAnswer(answerID).catchError((onError) {
      print(onError);
    });
    return res;
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    var data = await Future.delayed(const Duration(seconds: 6), () {
      var notEvent = NotificationModel(
          id: 34,
          time: '8',
          date: '22/08/2020',
          sender: 'Ayyego',
          sourceType: 'event',
          source: 'Child Abuse',
          message:
              'This should not be done to any child because of their gender either');
      var notGroup = NotificationModel(
          id: 34,
          time: '3',
          date: '22/08/2020',
          sender: 'Muhammed',
          sourceType: 'group',
          source: 'Iwe',
          message: 'this is awesome but do u fee the same');

      var notifications = [
        notEvent,
        notGroup,
        notEvent,
        notEvent,
        notGroup,
        notEvent,
        notGroup,
        notEvent
      ];

      return notifications;
    });

    return data;
  }
}
