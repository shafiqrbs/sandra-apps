import 'entity_manager.dart';

class UserManager extends EntityManager<User> {
  UserManager()
      : super(
          'users',
          User.fromJson,
          (e) => e.toJson(),
        );
}

class User {
  int? userId;
  String? username;
  String? fullName;
  String? email;
  String? password;
  String? roles;

  User({
    this.userId,
    this.username,
    this.fullName,
    this.email,
    this.password,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['user_id'],
        username: json['user_name'],
        fullName: json['full_name'],
        email: json['email'],
        password: json['password'],
        roles: json['roles'] is List ? json['roles'].join(',') : json['roles'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_name': username,
        'full_name': fullName,
        'email': email,
        'password': password,
        'roles': roles,
      };
}
