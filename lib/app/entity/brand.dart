import 'package:dropdown_flutter/custom_dropdown.dart';

import '/app/core/db_helper/db_tables.dart';

import 'entity_manager.dart';

class BrandManager extends EntityManager<Brand> {
  BrandManager()
      : super(
          DbTables().tableBrands,
          Brand.fromJson,
          (e) => e.toJson(),
        );
}

class Brand with CustomDropdownListFilter {
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

  @override
  bool filter(String query) {
    return name!.toLowerCase().contains(query.toLowerCase());
  }
}
