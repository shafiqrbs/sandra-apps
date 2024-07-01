import 'package:flutter/material.dart';

class DrawIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;

  const DrawIcon({
    required this.icon,
    this.color = Colors.black,
    this.size = 24,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size,
    );
  }
}

class IconProperty {
  final IconData icon;
  final Color? color;
  final double? size;

  const IconProperty({
    required this.icon,
    this.color = Colors.black,
    this.size = 24,
  });

  //copyWith method
  IconProperty copyWith({
    IconData? icon,
    Color? color,
    double? size,
  }) {
    return IconProperty(
      icon: icon ?? this.icon,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}
