import 'entity_manager.dart';

class MobileAccountManager extends EntityManager<MobileAccount> {
  MobileAccountManager()
      : super(
          'mobile_accounts',
          MobileAccount.fromJson,
          (e) => e.toJson(),
        );
}

class MobileAccount {
  int? globalId;
  int? itemId;
  String? name;
  double? serviceCharge;

  MobileAccount({
    this.globalId,
    this.itemId,
    this.name,
    this.serviceCharge,
  });

  factory MobileAccount.fromJson(Map<String, dynamic> json) => MobileAccount(
        globalId: json['global_id'],
        itemId: json['item_id'],
        name: json['name'],
        serviceCharge: json['service_charge']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'global_id': globalId,
        'item_id': itemId,
        'name': name,
        'service_charge': serviceCharge,
      };
}
