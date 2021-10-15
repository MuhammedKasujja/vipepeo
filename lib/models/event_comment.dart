class EventComment {
  final int id;
  final String text;
  final int replyCount;

  EventComment({this.id, this.text, this.replyCount});

  factory EventComment.fromJson(Map<String, dynamic> json) {
    return EventComment(
        id: json['id'], text: json['text'], replyCount: json['reply_count']);
  }
}
