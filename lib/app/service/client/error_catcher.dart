class ErrorCatcher {
  factory ErrorCatcher() {
    return _instance;
  }
  ErrorCatcher._privateConstructor();
  static final ErrorCatcher _instance = ErrorCatcher._privateConstructor();

  bool? hasError;
  int? statusCode;
  Exception? exception;
  StackTrace? stackTrace;

  factory ErrorCatcher.setError({
    required bool hasError,
    required statusCode,
    Exception? exception,
    StackTrace? stackTrace,
  }) {
    return ErrorCatcher()
      ..exception = exception
      ..stackTrace = stackTrace
      ..hasError = hasError
      ..statusCode = statusCode;
  }

  Map<String, dynamic> toJson() => {
        'exception': exception,
        'stackTrace': stackTrace,
        'hasError': hasError,
        'statusCode': statusCode,
      };
}
