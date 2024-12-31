import 'package:dropdown_flutter/custom_dropdown.dart';

class BusinessType with CustomDropdownListFilter {
  String? appSlug;
  String? name;

  BusinessType({this.appSlug, this.name});

  factory BusinessType.fromJson(Map<String, dynamic> json) {
    return BusinessType(
      appSlug: json['app_slug'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_slug': appSlug,
      'name': name,
    };
  }

  @override
  bool filter(String query) {
    return name!.toLowerCase().contains(query.toLowerCase());
  }
}
