class Parser {
  Parser();

  static num? parseNum(dynamic value) {
    if (value is num) {
      return value;
    } else if (value is String) {
      return num.tryParse(value) ?? 0;
    } else {
      return 0;
    }
  }

  static String? parseString(dynamic value) {
    if (value is String) {
      return value;
    } else {
      return '';
    }
  }
}
