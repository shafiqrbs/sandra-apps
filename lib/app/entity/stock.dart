import 'entity_manager.dart';
import 'parser.dart';

class StockManager extends EntityManager<Stock> {
  StockManager()
      : super(
          'stocks',
          Stock.fromJson,
          (e) => e.toJson(),
        );
}

class Stock extends Parser {
  int? globalId;
  int? itemId;
  int? categoryId;
  String? categoryName;
  num? brandId;
  String? brandName;
  String? barcode;
  num? unitId;
  String? unit;
  String? name;
  String? printName;
  int? quantity;
  num? salesPrice;
  num? purchasePrice;
  String? printHidden;
  String? imagePath;

  Stock({
    this.globalId,
    this.itemId,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
    this.barcode,
    this.unitId,
    this.unit,
    this.name,
    this.printName,
    this.quantity,
    this.salesPrice,
    this.purchasePrice,
    this.printHidden,
    this.imagePath,
  });

  Stock.loading() : this(name: '...', salesPrice: 0);
  bool get isLoading => name == '...';

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      globalId: json['global_id'],
      itemId: json['item_id'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      brandId: json['brand_id'],
      brandName: json['brand_name'],
      barcode: json['barcode'],
      unitId: json['unit_id'],
      unit: json['unit'],
      name: json['name'],
      printName: json['print_name'],
      quantity: json['quantity'],
      salesPrice: Parser.parseNum(json['sales_price']),
      purchasePrice: Parser.parseNum(json['purchase_price']),
      printHidden: json['print_hidden'],
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'global_id': globalId,
      'item_id': itemId,
      'category_id': categoryId,
      'category_name': categoryName,
      'brand_id': brandId,
      'brand_name': brandName,
      'barcode': barcode,
      'unit_id': unitId,
      'unit': unit,
      'name': name,
      'print_name': printName,
      'quantity': quantity,
      'sales_price': salesPrice,
      'purchase_price': purchasePrice,
      'print_hidden': printHidden,
      'image_path': imagePath,
    };
  }
}
