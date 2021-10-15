class NotificationModel {
  final int id;
  final String time;
  final String date;
  final String message;
  final String source;
  final String sourceType;
  final String sender;

  NotificationModel(
      {this.id,
      this.time,
      this.date,
      this.message,
      this.source,
      this.sourceType,
      this.sender});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel();
  }
}
