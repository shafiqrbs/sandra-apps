class LoggedUser {
  factory LoggedUser() {
    return _instance;
  }
  LoggedUser._privateConstructor();
  static final LoggedUser _instance = LoggedUser._privateConstructor();

  String? userId;
  String? token;
  String? userEmail;
  String? userNiceName;
  String? userDisplayName;

  factory LoggedUser.fromJson(Map<String, dynamic> json) {
    return LoggedUser()
      ..userId = json['user_id']
      ..token = json['token']
      ..userEmail = json['user_email']
      ..userNiceName = json['user_nicename']
      ..userDisplayName = json['user_display_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'token': token,
      'user_email': userEmail,
      'user_nicename': userNiceName,
      'user_display_name': userDisplayName,
    };
  }
}
