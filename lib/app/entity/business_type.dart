import 'package:dropdown_flutter/custom_dropdown.dart';

class BusinessType with CustomDropdownListFilter {
  String? appSlug;
  String? name;
  String? title;
  String? licenseNo;
  String? activeKey;
  String? userName;
  String? password;
  String? content;
  String? url;

  BusinessType({
    this.appSlug,
    this.name,
    this.title,
    this.licenseNo,
    this.activeKey,
    this.userName,
    this.password,
    this.content,
    this.url,
  });

  factory BusinessType.fromJson(Map<String, dynamic> json) {
    return BusinessType(
      appSlug: json['app_slug'],
      name: json['name'],
      title: json['title'],
      licenseNo: json['license_no'],
      activeKey: json['active_key'],
      userName: json['username'],
      password: json['password'],
      content: json['content'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_slug': appSlug,
      'name': name,
      'title': title,
      'license_no': licenseNo,
      'active_key': activeKey,
      'username': userName,
      'password': password,
      'content': content,
      'url': url,
    };
  }

  @override
  bool filter(String query) {
    return name!.toLowerCase().contains(query.toLowerCase());
  }
}
