import 'package:flutter/foundation.dart';

/// Color print for debug mode
void colorPrint(String message) {
  if (kDebugMode) {
    print(
      '\x1B[31m $message \x1B[0m\n',
    );
  }
}
