import 'package:sandra/app/core/importer.dart';

extension OutlineInputBorderExtensions on OutlineInputBorder {
  static OutlineInputBorder fromJson(Map<String, dynamic> json) {
    final BorderRadius borderRadius =
        BorderRadius.circular(json['border_radius'] ?? 4.0);

    final Color borderSideColor = Color(int.tryParse(
        json['border_side_color'] ??
            Colors.black.value.toString())!); // Default value
    final double borderSideWidth =
        json['border_side_width'] ?? 2; // Default value

    final BorderSide borderSide = BorderSide(
      color: borderSideColor,
      width: borderSideWidth,
    );

    return OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    );
  }
}
