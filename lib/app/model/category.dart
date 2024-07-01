import 'entity_manager.dart';

class CategoryManager extends EntityManager<Category> {
  CategoryManager() : super('categories', Category.fromJson,(e) => e.toJson(),);
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

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json['category_id'],
    name: json['name'],
    slug: json['slug'],
  );

  Map<String, dynamic> toJson() => {
    'category_id': categoryId,
    'name': name,
    'slug': slug,
  };
}
