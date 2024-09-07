import 'package:sandra/app/core/db_helper/db_tables.dart';

import 'entity_manager.dart';

class BrandManager extends EntityManager<Brand> {
  BrandManager()
      : super(
          DbTables().tableBrands,
          Brand.fromJson,
          (e) => e.toJson(),
        );
}

class Brand {
  int? brandId;
  String? name;
  String? slug;

  Brand({
    this.brandId,
    this.name,
    this.slug,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        brandId: json['brand_id'],
        name: json['name'],
        slug: json['slug'],
      );

  Map<String, dynamic> toJson() => {
        'brand_id': brandId,
        'name': name,
        'slug': slug,
      };
}
