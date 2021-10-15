class Event {
  int id;
  String startDate;
  String endDate;
  String theme;
  String street;
  String startTime;
  String endTime;
  String photo;
  String speaker;
  String locDistrict;
  String organizer;
  String country;
  bool isSaved;
  String createdBy;

  Event(
      {this.id,
      this.startTime,
      this.endTime,
      this.startDate,
      this.endDate,
      this.theme,
      this.street,
      this.photo,
      this.speaker,
      this.locDistrict,
      this.organizer,
      this.country,
      this.isSaved = false,
      this.createdBy});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        theme: json['theme'],
        photo: json['photo'],
        speaker: json['speaker'],
        locDistrict: json['location_district'],
        organizer: json['organizer'],
        street: json['building_street'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        country: json['location_country'],
        isSaved: json['is_saved'] ?? false,
        createdBy: json['created_by']);
  }

  Map toMap() {
    var map = {
      'theme': theme,
      'speaker': speaker,
      'location_district': locDistrict,
      'organizer': organizer,
      'building_street': street,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startTime,
      'end_time': endTime,
      'location_country': country,
      'photo': photo,
    };
    return map;
  }
}
