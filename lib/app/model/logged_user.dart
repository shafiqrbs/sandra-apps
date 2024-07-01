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
      ..username = json['username']
      ..fullName = json['fullName']
      ..email = json['email']
      ..password = json['password']
      ..roles = json['roles'];
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'username': username,
        'fullName': fullName,
        'email': email,
        'password': password,
        'roles': roles,
      };
}
