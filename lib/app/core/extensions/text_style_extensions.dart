import 'package:sandra/app/core/importer.dart';
import 'package:google_fonts/google_fonts.dart';

extension TextStyleExtension on TextStyle {
  static TextStyle fromJson(Map<String, dynamic> json) {
    return TextStyle(
      fontSize: double.tryParse(json['font_size'] ?? '18.0'),
      color: Color(int.parse(json['color'] ?? '0xFF000000')),
      backgroundColor:
          Color(int.parse(json['background_color'] ?? '0x00FFFFFF')),
      fontWeight: defaultFontWeight[json['font_weight']] ?? FontWeight.normal,
      fontStyle:
          json['font_style'] == 'italic' ? FontStyle.italic : FontStyle.normal,
      letterSpacing: double.tryParse(json['letter_spacing'] ?? '1.5'),
      fontFamily: json['font_family'] ?? GoogleFonts.aBeeZee.toString(),
      overflow: json['text_overflow'] == 'ellipsis'
          ? TextOverflow.ellipsis
          : TextOverflow.visible,
    );
  }
}

extension TextStyleSerialization on TextStyle {
  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'fontWeight': fontWeight.toString().split('.').last,
      'color': color?.value,
    };
  }
}

Map<int, FontWeight> defaultFontWeight = {
  100: FontWeight.w100,
  200: FontWeight.w200,
  300: FontWeight.w300,
  400: FontWeight.w400,
  500: FontWeight.w500,
  600: FontWeight.w600,
  700: FontWeight.w700,
  800: FontWeight.w800,
  900: FontWeight.w900,
};
