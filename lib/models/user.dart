import 'package:vipepeo_app/models/child.dart';

class User {
  final String image;
  final String name;
  final String country;
  final String email;
  final String city;
  final String token;
  final List<Child> children;

  User(
      {this.city,
      this.image,
      this.name,
      this.country,
      this.email,
      this.token,
      this.children});

  factory User.fromJson(Map<String, dynamic> json) {
    var userdata = json['response'];
    return User(
        email: userdata['email'],
        country: userdata['country'],
        name: userdata['name'],
        city: userdata['city'],
        children:
            (json['children'] as List).map((m) => Child.fromJson(m)).toList());
  }

  Map toMap() {
    var map = {
      'email': email,
      'country': country,
      'name': name,
      'image': image
    };
    return map;
  }
}
