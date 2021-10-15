import 'package:vipepeo_app/models/child.dart';

class User {
  final String image;
  final String name;
  final String country;
  final String email;
  final String city;
  final List<Child> children;

  User(
      {this.city,
      this.image,
      this.name,
      this.country,
      this.email,
      this.children});

  factory User.fromJson(Map<String, dynamic> json) {
    var userdata = json['response'];
    return User(
        email: userdata['email'],
        country: userdata['country'],
        name: userdata['name'],
        city: userdata['city'],
        children: (json['children'] as List)
            .map((m) => new Child.fromJson(m))
            .toList());
  }

  Map toMap() {
    var map = {
      'email': this.email,
      'country': this.country,
      'name': this.name,
      'image': this.image
    };
    return map;
  }
}
