class Config {
  factory Config() {
    return _instance;
  }
  Config._privateConstructor();
  static final Config _instance = Config._privateConstructor();

  String? purchaseMode;

  String? get name => purchaseMode;
  set name(String? value) => purchaseMode = value;
}
