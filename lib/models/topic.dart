class Topic {
  final int postBy;
  final String title;
  final String details;
  final String time;

  Topic({this.time, this.title, this.details, this.postBy});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
        title: json['title'],
        details: json['details'],
        time: json['time'],
        postBy: json['post_by']);
  }
}
