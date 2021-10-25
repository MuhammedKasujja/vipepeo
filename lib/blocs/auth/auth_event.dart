part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Logout extends AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;

  const Login(
    this.email,
    this.password,
  );
  @override
  List<Object> get props => [email, password];
}

class Register extends AuthEvent {
  final String email;
  final String name;
  final String password;
  final String country;
  final String city;

  const Register({
    this.email,
    this.password,
    this.name,
    this.city,
    this.country,
  });
  @override
  List<Object> get props => [
        email,
        password,
        name,
        city,
        country,
      ];
}

class ChangePassword extends AuthEvent {
  final String newPassword;
  final String oldPassword;

  const ChangePassword(
    this.oldPassword,
    this.newPassword,
  );
  @override
  List<Object> get props => [
        newPassword,
        oldPassword,
      ];
}

class UpdateProfile extends AuthEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String gender;
  final String deviceToken;
  final String deviceType;
  final String countryCode;

  const UpdateProfile(
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.gender,
    this.deviceToken,
    this.deviceType,
    this.countryCode,
  );
  @override
  List<Object> get props => [
        email,
        firstName,
        lastName,
        phone,
        gender,
        deviceToken,
        deviceType,
        countryCode
      ];
}

///// adding child to user /////

class AddChild extends AuthEvent {
  final String firstname;
  final String lastname;
  final String dob;
  final String gender;
  final List conditions;

  const AddChild(
      {this.firstname, this.lastname, this.dob, this.gender, this.conditions});
  @override
  List<Object> get props => [
        firstname,
        lastname,
        dob,
        gender,
        conditions,
      ];
}

class AddProfession extends AuthEvent {
  final String prof;
  final String spec;
  final String desc;

  const AddProfession(this.prof, this.spec, this.desc);
  @override
  List<Object> get props => [
        prof,
        spec,
        desc,
      ];
}

class GetUserProfile extends AuthEvent {}
