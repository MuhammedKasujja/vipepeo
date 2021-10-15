class Child {
  int id;
  String name;
  String gender;
  int age;

  Child({this.id, this.name, this.gender, this.age});

  Child.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['full_name'];
    gender = json['gender'];
    age = json['age'];
  }
}
