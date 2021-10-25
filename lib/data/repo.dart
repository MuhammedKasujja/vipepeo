import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vipepeo_app/data/urls.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:dio/dio.dart';
//
// Uploading media files
//
import 'package:http_parser/http_parser.dart';

class Repository {
  Dio dio = Dio();
  Repository({token}) {
    if (token != null) {
      dio.options.headers.addAll({
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      });
    }
  }
  Future<SingleResponse> register(
      {name, email, password, country, city}) async {
    var res = await http.post(Uri.parse(Urls.REGISTER), body: {
      "email": email,
      "password1": password,
      "password2": password,
      "name": name,
      "country": country,
      "city": city
    }).catchError((onError) {
      print("$onError");
    });
    var data = json.decode(res.body);
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<SingleResponse<User>> login({email, password}) async {
    var res = await http.post(Uri.parse(Urls.LOGIN), body: {
      "email": email,
      "password": password,
    });
    var data = json.decode(res.body);

    if (data['code'] == 0) {
      return SingleResponse<User>(success: false, message: data['response']);
    }

    await savePrefs(data['token'], email);
    try {
      var user = await getUserProfile(token: data['token']);
      return SingleResponse<User>(
          success: true, message: data['response'], data: user);
    } catch (error) {
      return SingleResponse<User>(success: false, error: error.toString());
    }
  }

  Future<User> loadPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    final user = User(
      token: prefs.getString(Constants.USER_TOKEN),
      email: prefs.getString(Constants.KEY_EMAIL),
    );
    return user;
  }

  Future logout() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  Future savePrefs(token, email) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.USER_TOKEN, token);
    prefs.setString(Constants.KEY_EMAIL, email);
  }

  Future<bool> photoPrefs(photoUrl) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString(Constants.KEY_PROFILE_PHOTO, photoUrl);
  }

  Future<SingleResponse> changePassword({oldPassword, newPassword}) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    var res = await http.put(Uri.parse(Urls.CHANGE_PASSWORD), headers: {
      HttpHeaders.authorizationHeader: 'Token $token'
    }, body: {
      'old_password': oldPassword,
      'new_password1': newPassword,
      'new_password2': newPassword
    });

    var data = json.decode(res.body);

    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<User> getUserProfile({token}) async {
    dio = Dio();
    if (token == null) {
      var prefs = await SharedPreferences.getInstance();
      token = prefs.getString(Constants.USER_TOKEN);
    }
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.get(Urls.USER_PROFILE);
    // print(res.data);
    var user = User.fromJson(res.data);

    return user;
  }

  //////////////////////////////////Starting////////////////////////

  Future<SingleResponse> addProfession({token, prof, desc, spec}) async {
    var dio = Dio();
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.post(Urls.ADD_PROFESSION, data: {
      'prof': prof,
      'any_info': desc,
      'spec': [1, 2]
    });
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<SingleResponse> approveAnswer(answerID) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.get(Urls.APPROVE_ANSWER + "/$answerID/");
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "approved", message: data['response']);
  }

  Future<SingleResponse> addEditEvent(
      {Event event, PostData postType = PostData.Save, eventId}) async {
    // print(event.photo);
    // print('Map: ${event.toMap()}');
    Response res;
    var formData = FormData.fromMap({
      'theme': event.theme,
      "start_date": event.startDate,
      "start_time": event.startTime,
      "location_district": event.locDistrict,
      "building_street": event.street,
      "speaker": event.speaker,
      "end_date": event.endDate,
      "organizer": event.organizer,
      "end_time": event.endTime,
      "location_country": event.country,
      "photo": await _createMultipartFile(event.photo),
    });
    if (postType == PostData.Update) {
      var prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.USER_TOKEN);
      dio.options.headers.addAll({
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      res = await dio
          .put(Urls.EDIT_MEETUP + "/$eventId/", data: formData)
          .catchError((onError) {
        print('UpdatingData:  $onError');
      });
    }
    if (postType == PostData.Save) {
      res =
          await dio.post(Urls.ADD_MEETUP, data: formData).catchError((onError) {
        print(onError);
      });
    }
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<SingleResponse> addEditCommunity(
      {Community community,
      PostData postType = PostData.Save,
      communityId}) async {
    print(community.image);
    var formData = FormData.fromMap({
      "name": community.name,
      'describe': community.description,
      'location_district': community.locDistrict,
      'topics': [1, 2],
      // 'topics': List<int>.from(community.topics),
      'location_country': community.country,
      'photo': await _createMultipartFile(community.image),
    });
    Response res;
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    if (postType == PostData.Update) {
      res =
          await dio.put(Urls.EDIT_COMMUNITY + "/$communityId/", data: formData);
    } else {
      res = await dio.post(Urls.ADD_COMMUNITY, data: formData);
    }

    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<SingleResponse> addTopic({title, desc, conditions}) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.post(Urls.ADD_TOPICS, data: {
      "title": title,
      'details': desc,
      'condition': conditions,
    });
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<SingleResponse> addChild(
      {firstname, lastname, gender, dob, conditions}) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    Response res = await dio.post(Urls.ADD_CHILD, data: {
      "full_name": "$firstname $lastname",
      "gender": gender,
      "dob": "2019-06-23",
      "condition": conditions
    });
    // Response is returned as a Map
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<SingleResponse> updateProfile({name, email, String filePath}) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var formData = FormData.fromMap({
      // "name": name,
      // "email": email,
      "photo": await _createMultipartFile(filePath),
    });
    var res = await dio.put(Urls.PHOTO_UPDATE, data: formData);
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<SingleResponse> askQuestion(question, List topics) async {
    print({'Topics': topics});
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var formData = FormData.fromMap({
      "quest": question,
      "topics": topics,
    });
    var res =
        await dio.post(Urls.QUESTIONS, data: formData).catchError((onError) {
      print("Catch Error: $onError");
    });
    print(res.data);
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<List<Question>> fetchQuestions() async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio
        .get(
      Urls.QUESTIONS,
    )
        .catchError((onError) {
      print("Catch Error: $onError");
    });
    var listQuestions = (res.data['response'] as List).map((m) {
      return Question.fromJson(m);
    }).toList();
    print('Questions: ${res.data}');
    return listQuestions;
  }

  Future<SingleResponse> answerQuestion({answer, questioID}) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.post(Urls.QUESTION_ANSWER + "/$questioID/",
        data: {'text': answer}).catchError((onError) {
      print("Catch Error: $onError");
    });
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<List<Answer>> fetchQuestionAnswers(questioID) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio
        .get(
      Urls.QUESTION_ANSWER + "/$questioID/",
    )
        .catchError((onError) {
      print("Catch Error: $onError");
    });
    print('Answers: ${res.data}');
    var listAnswers = (res.data['response'] as List).map((m) {
      return Answer.fromJson(m);
    }).toList();
    return listAnswers;
  }

  Future<List<Event>> getMyMeetups(EventType eventType) async {
    String url;
    if (eventType == EventType.Going) url = Urls.MY_MEETUPS;
    if (eventType == EventType.Saved) url = Urls.SAVED_MEETUPS;
    if (eventType == EventType.Suggested) url = Urls.SUGGESTED_MEETUPS;
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.get(url).catchError((onError) {
      print("Catch Error: $onError");
    });
    print('Events: ${res.data}');
    var listEvents = (res.data['results'] as List).map((m) {
      if (eventType == EventType.Saved) m['is_saved'] = true;
      return Event.fromJson(m);
    }).toList();
    return listEvents;
  }

  Future<List<Community>> getMyGroups() async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.get(Urls.MY_GROUPS);
    print('Groups: ${res.data}');
    return (res.data['response'] as List)
        .map((m) => Community.fromJson(m))
        .toList();
  }

  Future<List<ChildCondition>> getChildConditions() async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.get(Urls.CHILD_CONDITIONS);
    var conditions = (res.data['response'] as List)
        .map((m) => ChildCondition.fromJson(m))
        .toList();
    return conditions;
  }

  Future<List<EventComment>> groupComment(groupId) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.get(Urls.LIST_GROUP_COMMENTS + "/$groupId/");
    var comments = (res.data['comments'] as List)
        .map((m) => EventComment.fromJson(m))
        .toList();
    return comments;
  }

  Future<List<EventComment>> eventComment(eventId) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var url = Urls.LIST_MEETUP_COMMENTS + "/$eventId/";
    var res = await dio.get(url);
    var comments = (res.data['comments'] as List)
        .map((m) => EventComment.fromJson(m))
        .toList();
    return comments;
  }

  Future<List<EventComment>> fetchComments(eventId, CommentType type) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var url = type == CommentType.event
        ? Urls.LIST_MEETUP_COMMENTS
        : Urls.LIST_GROUP_COMMENTS;
    url = url + "/$eventId/";
    var res = await dio.get(url);
    var comments = (res.data['comments'] as List)
        .map((m) => EventComment.fromJson(m))
        .toList();
    return comments;
  }

  Future<SingleResponse> makeEventComment(eventId, text) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var url = Urls.LIST_MEETUP_COMMENTS + "/$eventId/";
    var res = await dio.post(url, data: {'text': text});
    // print(res.data);
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<SingleResponse> makeGroupComment(groupId, text) async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    final url = Urls.LIST_GROUP_COMMENTS + "/$groupId/";
    var res = await dio.post(url, data: {'text': text});
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<List<Topic>> fetchTopics() async {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.get(Urls.MY_TOPICS);
    var listTopics =
        (res.data['results'] as List).map((m) => Topic.fromJson(m)).toList();
    return listTopics;
  }

  Future<MultipartFile> _createMultipartFile(String filePath) async {
    var fileName = filePath.split('/').last;
    var ext = fileName.split(".")[1];
    var futureFile = await MultipartFile.fromFile(filePath,
        filename: fileName, contentType: MediaType('image', ext));
    return futureFile;
  }

  Future<SingleResponse> attendOrDontAttendEvent(eventId) async {
    var url = Urls.ATTEND_DONT_ATTEND_MEETUP + "/$eventId/";
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.get(
      url,
    );
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<SingleResponse> saveRemoveEvent(eventId) async {
    var url = Urls.SAVE_REMOVE_MEETUP + "/$eventId/";
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.get(
      url,
    );
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<SingleResponse> joinOrLeaveGroup(groupId) async {
    var url = Urls.JOIN_LEAVE_GROUP + "/$groupId/";
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.get(url);
    var data = res.data;
    return SingleResponse(
        success: data['response'] == "Submitted successfully",
        message: data['response']);
  }

  Future<Dio> _getHost() async {
    dio ??= Dio();
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.USER_TOKEN);
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    return dio;
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
