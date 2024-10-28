class StockDetails {
  final num? id;
  final String? name;
  final num? categoryId;
  final String? categoryName;
  final num? brandId;
  final String? brandName;
  final num? minQuantity;
  final String? unitId;
  final String? unitName;
  final String? description;
  final num? remainingQuantity;
  final String? salesPrice;
  final String? purchasePrice;
  final String? avgPurchasePrice;
  final String? avgSalesPrice;
  final num? salesQuantity;
  final num? purchaseQuantity;
  final num? openingQuantity;
  final num? damageQuantity;
  final num? salesReturnQuantity;
  final num? purchaseReturnQuantity;
  final num? adjustQuantity;
  final num? bonusQuantity;

  StockDetails({
    this.id,
    this.name,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
    this.minQuantity,
    this.unitId,
    this.unitName,
    this.description,
    this.remainingQuantity,
    this.salesPrice,
    this.purchasePrice,
    this.avgPurchasePrice,
    this.avgSalesPrice,
    this.salesQuantity,
    this.purchaseQuantity,
    this.openingQuantity,
    this.damageQuantity,
    this.salesReturnQuantity,
    this.purchaseReturnQuantity,
    this.adjustQuantity,
    this.bonusQuantity,
  });

  factory StockDetails.fromJson(Map<String, dynamic> json) {
    return StockDetails(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'] is num ? json['category_id'] : null,
      categoryName: json['category_name'],
      brandId: json['brand_id'],
      brandName: json['brand_name'],
      minQuantity: json['min_quantity'],
      unitId: json['unit_id'],
      unitName: json['unit_name'],
      description: json['description'],
      remainingQuantity: json['remaining_quantity'] is num ? json['remaining_quantity'] : null,
      salesPrice: json['sales_price'],
      purchasePrice: json['purchase_price'],
      avgPurchasePrice: json['avg_purchase_price'],
      avgSalesPrice: json['avg_sales_price'],
      salesQuantity: json['sales_quantity'],
      purchaseQuantity: json['purchase_quantity'],
      openingQuantity: json['opening_quantity'],
      damageQuantity: json['damage_quantity'],
      salesReturnQuantity: json['sales_return_quantity'],
      purchaseReturnQuantity: json['purchase_return_quantity'],
      adjustQuantity: json['adjust_quantity'],
      bonusQuantity: json['bonus_quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'category_name': categoryName,
      'brand_id': brandId,
      'brand_name': brandName,
      'min_quantity': minQuantity,
      'unit_id': unitId,
      'unit_name': unitName,
      'description': description,
      'remaining_quantity': remainingQuantity,
      'sales_price': salesPrice,
      'purchase_price': purchasePrice,
      'avg_purchase_price': avgPurchasePrice,
      'avg_sales_price': avgSalesPrice,
      'sales_quantity': salesQuantity,
      'purchase_quantity': purchaseQuantity,
      'opening_quantity': openingQuantity,
      'damage_quantity': damageQuantity,
      'sales_return_quantity': salesReturnQuantity,
      'purchase_return_quantity': purchaseReturnQuantity,
      'adjust_quantity': adjustQuantity,
      'bonus_quantity': bonusQuantity,
    };
  }
}
