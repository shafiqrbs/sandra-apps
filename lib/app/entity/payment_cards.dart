import 'entity_manager.dart';

class PaymentCardsManager extends EntityManager<PaymentCards> {
  PaymentCardsManager()
      : super(
          'payment_cards',
          PaymentCards.fromJson,
          (e) => e.toJson(),
        );
}

class PaymentCards {
  int? itemId;
  String? name;

  PaymentCards({
    this.itemId,
    this.name,
  });

  factory PaymentCards.fromJson(Map<String, dynamic> json) => PaymentCards(
        itemId: json['item_id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'item_id': itemId,
        'name': name,
      };
}
