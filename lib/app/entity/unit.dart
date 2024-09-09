import '/app/core/db_helper/db_tables.dart';

import 'entity_manager.dart';

class UnitManager extends EntityManager<Unit> {
  UnitManager()
      : super(
          DbTables().tableUnits,
          Unit.fromJson,
          (e) => e.toJson(),
        );
}

class Unit {
  int? unitId;
  String? name;

  Unit({
    this.unitId,
    this.name,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        unitId: json['unit_id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'unit_id': unitId,
        'name': name,
      };
}
