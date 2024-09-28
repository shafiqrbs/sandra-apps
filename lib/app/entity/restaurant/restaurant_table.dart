class RestaurantTable {
  int? id;
  String? tableName;

  RestaurantTable({
    this.id,
    this.tableName,
  });

  // fromJson method
  factory RestaurantTable.fromJson(Map<String, dynamic> json) {
    return RestaurantTable(
      id: json['id'] as int?,
      tableName: json['table_name'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_name': tableName,
    };
  }
}
