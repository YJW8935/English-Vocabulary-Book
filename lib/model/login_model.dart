import 'dart:convert';

class LoginModel {
  final String password;
  final String id;

  LoginModel(this.id, this.password);

  LoginModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'password': password,
      };
}
