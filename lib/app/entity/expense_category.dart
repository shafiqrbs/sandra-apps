import '/app/core/db_helper/db_tables.dart';

import 'entity_manager.dart';

class ExpenseCategoryManager extends EntityManager<ExpenseCategory> {
  ExpenseCategoryManager()
      : super(
          DbTables().tableExpenseCategory,
          ExpenseCategory.fromJson,
          (e) => e.toJson(),
        );
}

class ExpenseCategory {
  int? categoryId;
  String? name;

  ExpenseCategory({
    this.categoryId,
    this.name,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      categoryId: json['category_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
    };
  }
}
