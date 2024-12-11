import 'dart:async';

import 'package:sandra/app/core/importer.dart';

import '/app/core/values/app_values.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({
    this.milliseconds = AppValues.defaultDebounceTimeInMilliSeconds,
  });

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(
      Duration(
        milliseconds: milliseconds,
      ),
      action,
    );
  }
}
