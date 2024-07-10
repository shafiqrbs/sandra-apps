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
  int? itemId;
  String? name;

  ExpenseCategory({
    this.itemId,
    this.name,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      itemId: json['item_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'name': name,
    };
  }
}
