import 'package:flutter/material.dart';

class AppColors{
  Color primary = Colors.blue;
  Color secondary = Colors.blueAccent;

  AppColors({this.primary = Colors.blue, this.secondary = Colors.blueAccent});

  factory AppColors.fromJson(Map<String, dynamic> json) {
    return AppColors(
      primary: json['primary'],
      secondary: json['secondary'],
    );
  }


  Map<String, dynamic> toJson() => {
    'primary': primary,
    'secondary': secondary,
  };

}
