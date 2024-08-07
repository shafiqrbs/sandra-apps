//singleton of logged user
class LoggedUser {
  factory LoggedUser() {
    return _instance;
  }
  LoggedUser._privateConstructor();
  static final LoggedUser _instance = LoggedUser._privateConstructor();

  int? userId;
  String? username;
  String? fullName;
  String? email;
  String? password;
  String? roles;

  factory LoggedUser.fromJson(Map<String, dynamic> json) {
    return LoggedUser()
      ..userId = json['user_id']
      ..username = json['user_name']
      ..fullName = json['full_name']
      ..email = json['email']
      ..password = json['password']
      ..roles = json['roles'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': username,
      'full_name': fullName,
      'email': email,
      'password': password,
      'roles': roles,
    };
  }
}
