class ChildCondition {
  final int id;
  final String name;
  final String description;

  ChildCondition({this.id, this.name, this.description});

  factory ChildCondition.fromJson(Map<String, dynamic> json) {
    return ChildCondition(
        id: json['id'], name: json['name'], description: json['desc']);
  }
}
