class StoreSetup {
  String? appSlug;
  String? storeName;
  String? name;
  String? userName;
  String? mobile;
  String? email;
  int? isStock;
  String? address;
  int? termsCondition;
  String? password;

  StoreSetup({
    this.appSlug,
    this.storeName,
    this.name,
    this.userName,
    this.mobile,
    this.email,
    this.isStock,
    this.address,
    this.termsCondition,
    this.password,
  });

  factory StoreSetup.fromJson(Map<String, dynamic> json) {
    return StoreSetup(
      appSlug: json['app_slug'],
      storeName: json['store_name'],
      name: json['name'],
      userName: json['user_name'],
      mobile: json['mobile'],
      email: json['email'],
      isStock: json['is_stock'],
      address: json['address'],
      termsCondition: json['terms_condition'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_slug': appSlug,
      'store_name': storeName,
      'name': name,
      'user_name': userName,
      'mobile': mobile,
      'email': email,
      'is_stock': isStock,
      'address': address,
      'terms_condition': termsCondition,
      'password': password,
    };
  }
}
