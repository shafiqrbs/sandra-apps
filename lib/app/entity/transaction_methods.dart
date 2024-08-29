import 'entity_manager.dart';

class TransactionMethodsManager extends EntityManager<TransactionMethods> {
  TransactionMethodsManager()
      : super(
          'transaction_methods',
          TransactionMethods.fromJson,
          (e) => e.toJson(),
        );
}

class TransactionMethods {
  int? methodId;
  String? methodName;
  String? methodMode;
  double? serviceCharge;
  String? imagePath;

  TransactionMethods({
    this.methodId,
    this.methodName,
    this.methodMode,
    this.serviceCharge,
    this.imagePath,
  });

  factory TransactionMethods.fromJson(Map<String, dynamic> json) {
    return TransactionMethods(
      methodId: json['method_id'],
      methodName: json['method_name'],
      methodMode: json['method_mode'],
      serviceCharge: double.tryParse(
        json['service_charge']?.toString() ?? '0',
      ),
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method_id': methodId,
      'method_name': methodName,
      'method_mode': methodMode,
      'service_charge': serviceCharge,
      'image_path': imagePath,
    };
  }
}
