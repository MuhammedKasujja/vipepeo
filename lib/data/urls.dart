// ignore_for_file: constant_identifier_names

class Urls {
  Urls._();
  // static const BASE_URL = "http://vipepeo.herokuapp.com";
  static const BASE_URL = "http://vipepeo.pythonanywhere.com";

  // {/auth/} urls
  static const _PATH_AUTH = BASE_URL + "/accounts/auth";
  static const REGISTER = _PATH_AUTH + "/signup/";
  static const LOGIN = _PATH_AUTH + "/login/";
  static const USER_PROFILE = _PATH_AUTH + "/user-profile/";
  static const PROFILE_UPDATE = _PATH_AUTH + "/profile-update/";
  static const PHOTO_UPDATE = _PATH_AUTH + "/photo-update/";
  static const CHANGE_PASSWORD = _PATH_AUTH + "/change-password/";
  static const ADD_PROFESSION = _PATH_AUTH + "/add-profession/";

  // {/snd/} urls
  static const _PATH_SND = BASE_URL + "/snd";
  static const ADD_MEETUP = _PATH_SND + "/add-meetup/";
  static const ADD_CHILD = _PATH_SND + "/add-child/";
  static const MY_MEETUPS = _PATH_SND + "/my-meetups/";
  static const SUGGESTED_MEETUPS = _PATH_SND + "/suggested-meetups/";
  static const SAVED_MEETUPS = _PATH_SND + "/saved-meetups/";
  static const MY_GROUPS = _PATH_SND + "/my-groups/";
  static const CHILD_CONDITIONS = _PATH_SND + "/show-conditions/";
  static const ADD_COMMUNITY = _PATH_SND + "/add-community/";
  static const ADD_TOPICS = _PATH_SND + "/new-topics/";
  static const MY_TOPICS = _PATH_SND + "/my-topics/";

  static const LIST_GROUP_COMMENTS = _PATH_SND + "/make-grp-comment";
  static const LIST_MEETUP_COMMENTS = _PATH_SND + "/make-meetup-comment";
  static const JOIN_LEAVE_GROUP = _PATH_SND + "/group-toggle";
  static const ATTEND_DONT_ATTEND_MEETUP = _PATH_SND + "/attend-meetup";
  static const SAVE_REMOVE_MEETUP = _PATH_SND + "/save-meetup";
  static const EDIT_MEETUP = _PATH_SND + "/meetup-edit";
  static const EDIT_COMMUNITY = _PATH_SND + "/group-edit";

  // {Hepler / Questions} urls
  static const _PATH_HELPER = BASE_URL + "/helper";
  static const QUESTIONS = _PATH_HELPER + "/questions/";
  static const QUESTION_ANSWER = _PATH_HELPER + "/answers-to-question";
  static const APPROVE_ANSWER = _PATH_HELPER + "/approve-answer";
}
