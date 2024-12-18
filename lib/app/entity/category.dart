import 'package:sandra/app/core/db_helper/db_tables.dart';

import 'entity_manager.dart';

class CategoryManager extends EntityManager<Category> {
  CategoryManager()
      : super(
          DbTables().tableCategories,
          Category.fromJson,
          (e) => e.toJson(),
        );
}

class Category {
  int? categoryId;
  String? name;
  String? slug;

  Category({
    this.categoryId,
    this.name,
    this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
      'slug': slug,
    };
  }
}
