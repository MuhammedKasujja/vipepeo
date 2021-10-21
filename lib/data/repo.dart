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
  Dio dio;
  Repository({token}) {
    if (token != null) {
      dio = Dio();
      dio.options.headers.addAll({
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      });
    }
  }
  Future<Map> register({name, email, password, country, city}) async {
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
    print(data);
    return data;
  }

  Future<Map> login({email, password}) async {
    var res = await http.post(Uri.parse(Urls.LOGIN), body: {
      "email": email,
      "password": password,
    }).catchError((onError) {
      print("$onError");
    });
    var data = json.decode(res.body);
    // _savePrefs(data['token']);
    print(data);
    //var map
    return data;
  }

  Future<Map<String, dynamic>> loadPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = {
      Constants.USER_TOKEN: prefs.getString(Constants.USER_TOKEN),
      Constants.KEY_EMAIL: prefs.getString(Constants.KEY_EMAIL),
      Constants.KEY_PROFILE_PHOTO: prefs.getString(Constants.KEY_PROFILE_PHOTO),
    };
    return map;
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

  Future changePassword({token, oldPassword, newPassword}) async {
    var res = await http.put(Uri.parse(Urls.CHANGE_PASSWORD), headers: {
      HttpHeaders.authorizationHeader: 'Token $token'
    }, body: {
      'old_password': oldPassword,
      'new_password1': newPassword,
      'new_password2': newPassword
    });

    return json.decode(res.body);
  }

  Future<User> getUserProfile() async {
    var res = await dio.get(Urls.USER_PROFILE);
    //  print('Profile: ${res.data}');
    var user = User.fromJson(res.data);
    print(user.email);
    print(user.children.length);
    return user;
  }

  //////////////////////////////////Starting////////////////////////

  Future<Map> addProfession({token, prof, desc, spec}) async {
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
    return res.data;
  }

  Future<Map> approveAnswer(answerID) async {
    var res = await dio.get(Urls.APPROVE_ANSWER + "/$answerID/");
    return res.data;
  }

  Future<Map> addEditEvent(
      {Event event, PostData postType = PostData.Save, eventId}) async {
    print(event.photo);
    print("EventID: $eventId");
    // print('Map: ${event.toMap()}');
    var res;
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
      // var url = Urls.EDIT_MEETUP + "/$eventId/";
      // print(url);
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
    // print(res.data);
    return res.data;
  }

  Future<Map> addEditCommunity(
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
    var res;
    if (postType == PostData.Update) {
      res =
          await dio.put(Urls.EDIT_COMMUNITY + "/$communityId/", data: formData);
    } else {
      res = await dio.post(Urls.ADD_COMMUNITY, data: formData);
    }

    return res.data;
  }

  Future<Map> addTopic({token, title, desc, conditions}) async {
    var dio = Dio();
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var res = await dio.post(Urls.ADD_TOPICS, data: {
      "title": title,
      'details': desc,
      'condition': conditions,
    }).catchError((onError) {
      print(onError);
    });

    return res.data;
  }

  Future<Map> addChild(
      {token, firstname, lastname, gender, dob, conditions}) async {
    var dio = Dio();
    dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    Response res = await dio.post(Urls.ADD_CHILD, data: {
      "full_name": "$firstname $lastname",
      "gender": gender,
      "dob": "2019-06-23",
      "condition": conditions
    }).catchError((onError) {
      print('Catch error: $onError');
    });
    // Response is returned as a Map
    var data = res.data;
    print(data);
    return data;
  }

  Future<Map> updateProfile({name, email, String filePath}) async {
    var formData = FormData.fromMap({
      // "name": name,
      // "email": email,
      "photo": await _createMultipartFile(filePath),
    });
    var res =
        await dio.put(Urls.PHOTO_UPDATE, data: formData).catchError((onError) {
      print("Catch Error: $onError");
    });
    return res.data;
  }

  Future<Map> askQuestion({question, List topics}) async {
    var formData = FormData.fromMap({
      "quest": question,
      "topics": topics,
    });
    var res =
        await dio.post(Urls.QUESTIONS, data: formData).catchError((onError) {
      print("Catch Error: $onError");
    });
    print(res.data);
    return res.data;
  }

  Future<List<Question>> fetchQuestions() async {
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

  Future<Map> answerQuestion({answer, questioID}) async {
    var res = await dio.post(Urls.QUESTION_ANSWER + "/$questioID/",
        data: {'text': answer}).catchError((onError) {
      print("Catch Error: $onError");
    });
    print(res.data);
    return res.data;
  }

  Future<List<Answer>> fetchQuestionAnswers(questioID) async {
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
    var url;
    if (eventType == EventType.Going) url = Urls.MY_MEETUPS;
    if (eventType == EventType.Saved) url = Urls.SAVED_MEETUPS;
    if (eventType == EventType.Suggested) url = Urls.SUGGESTED_MEETUPS;
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
    var res = await dio.get(Urls.MY_GROUPS).catchError((onError) {
      print("GroupsError: $onError");
      print("Catch Error: $onError");
    });
    print('Groups: ${res.data}');
    return (res.data['response'] as List)
        .map((m) => Community.fromJson(m))
        .toList();
  }

  Future<List<ChildCondition>> getChildConditions() async {
    var res = await dio.get(Urls.CHILD_CONDITIONS).catchError((onError) {
      print("Catch Error: $onError");
    });
    var conditions = (res.data['response'] as List)
        .map((m) => ChildCondition.fromJson(m))
        .toList();
    print("Total: ${conditions.length}");
    return conditions;
  }

  Future<List<EventComment>> groupComment(groupId) async {
    var res = await dio
        .get(Urls.LIST_GROUP_COMMENTS + "/$groupId/")
        .catchError((onError) {
      print("Catch Error: $onError");
    });
    var comments = (res.data['comments'] as List)
        .map((m) => EventComment.fromJson(m))
        .toList();
    return comments;
  }

  Future<List<EventComment>> eventComment(eventId) async {
    var url = Urls.LIST_MEETUP_COMMENTS + "/$eventId/";
    var res = await dio.get(url).catchError((onError) {
      print("Catch Error: $onError");
    });
    var comments = (res.data['comments'] as List)
        .map((m) => EventComment.fromJson(m))
        .toList();
    return comments;
  }

  Future<Map> makeEventComment(eventId, text) async {
    var url = Urls.LIST_MEETUP_COMMENTS + "/$eventId/";
    var res = await dio.post(url, data: {'text': text}).catchError((onError) {
      print("Catch Error: $onError");
    });
    // print(res.data);
    return res.data;
  }

  Future<Map> makeGroupComment(groupId, text) async {
    var url = Urls.LIST_GROUP_COMMENTS + "/$groupId/";
    var res = await dio.post(url, data: {'text': text}).catchError((onError) {
      print("Catch Error: $onError");
    });
    // print(res.data);
    return res.data;
  }

  Future<List<Topic>> fetchTopics() async {
    var res = await dio.get(Urls.MY_TOPICS).catchError((onError) {
      print("Catch Error: $onError");
    });
    print(res.data);
    var listTopics =
        (res.data['results'] as List).map((m) => Topic.fromJson(m)).toList();
    return listTopics;
  }

  Future<MultipartFile> _createMultipartFile(String filePath) async {
    var fileName = filePath.split('/').last;
    var ext = fileName.split(".")[1];
    var futureFile = await MultipartFile.fromFile(filePath,
        filename: fileName, contentType: MediaType('image', '$ext'));
    return futureFile;
  }

  Future<Map> attendOrDontAttendEvent(eventId) async {
    var url = Urls.ATTEND_DONT_ATTEND_MEETUP + "/$eventId/";
    var res = await dio
        .get(
      url,
    )
        .catchError((onError) {
      print("Catch Error: $onError");
    });
    print(res.data);
    return res.data;
  }

  Future<Map> saveRemoveEvent(eventId) async {
    var url = Urls.SAVE_REMOVE_MEETUP + "/$eventId/";
    var res = await dio
        .get(
      url,
    )
        .catchError((onError) {
      print("Catch Error: $onError");
    });
    print(res.data);
    return res.data;
  }

  Future<Map> joinOrLeaveGroup(groupId) async {
    var url = Urls.JOIN_LEAVE_GROUP + "/$groupId/";
    var res = await dio
        .get(
      url,
    )
        .catchError((onError) {
      print("Catch Error: $onError");
    });
    return res.data;
  }
}
