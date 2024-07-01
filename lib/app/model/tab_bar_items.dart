import 'package:flutter/material.dart';

class TabBarItem {
  String name;
  String slug;
  String icon;
  Widget view;

  TabBarItem({
    required this.name,
    required this.slug,
    required this.icon,
    required this.view,

  });
}
