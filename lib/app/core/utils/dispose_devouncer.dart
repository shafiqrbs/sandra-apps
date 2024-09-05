import 'dart:async';

class DisposeDebouncer {
  DisposeDebouncer({this.delay = const Duration(milliseconds: 1500)});

  final Duration delay;
  Timer? _timer;

  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
