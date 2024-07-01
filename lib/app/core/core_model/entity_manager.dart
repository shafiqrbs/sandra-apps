import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/db_helper/db_helper.dart';

class EntityManager<T> {
  /// Table name in the database
  final String tableName;

  /// Function to convert a map to an entity object
  final T Function(Map<String, dynamic>) fromJson;

  /// Function to convert an entity object to a map
  final Map<String, dynamic> Function(T) toJson;

  /// Text controller for the search field of this entity
  final searchTextController = TextEditingController().obs;

  /// All items in the database
  final allItems = Rx<List<T>?>(null);

  /// Items that match the search query
  final searchedItems = Rx<List<T>?>(null);

  /// The selected item
  final selectedItem = Rx<T?>(null);

  /// Scroll controller for the entity
  final scrollController = ScrollController();

  /// Database helper
  final dbHelper = DbHelper.instance;

  /// Constructor
  EntityManager(this.tableName, this.fromJson, this.toJson) {
    scrollController.addListener(_scrollListener);
  }

  // Pagination listener
  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // Reached the bottom, load more data
      // You can adjust this condition based on your pagination logic
      // For example, you might want to load more data when you are near the bottom, not exactly at the bottom
      // Add your pagination logic here

      await getAll();

      allItems.refresh();
    }
  }

  Future<void> getAll() async {
    try {
      final items = await dbHelper.getAll(
        tbl: tableName,
      );
      allItems.value = items.map((e) => fromJson(e)).toList();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error fetching all items: $e');
      }
    }
  }

  Future<void> searchItemsByName(String query) async {
    if (kDebugMode) {
      print('Searching items by name: $query');
    }
    try {
      if (query.isEmpty) {
        await getAll();
        return;
      }

      final value = await dbHelper.getAllWhr(
        tbl: tableName,
        where: "name LIKE '%$query%'",
        whereArgs: [],
        limit: 500,
      );
      searchedItems.value = value.map((e) => fromJson(e)).toList();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error searching items by name: $e');
      }
    }
  }

  Future<void> searchItemsByNameOnAllItem(String query) async {
    if (kDebugMode) {
      print('Searching items by name: $query');
    }
    try {
      if (query.isEmpty) {
        allItems.value?.clear();
        final items = await dbHelper.getAll(
          tbl: tableName,
          limit: 10,
          offset: allItems.value?.length ?? 0,
        );
        allItems
          ..value = items.map((e) => fromJson(e)).toList()
          ..refresh();
        return;
      }

      final value = await dbHelper.getAllWhr(
        tbl: tableName,
        where: "name LIKE '%$query%'",
        whereArgs: [],
        limit: 500,
      );
      allItems
        ..value = value.map((e) => fromJson(e)).toList()
        ..refresh();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error searching items by name: $e');
      }
    }
  }

  Future<void> insertItem(T item) async {
    if (kDebugMode) {
      print('Inserting item: $item');
    }
    try {
      final id = await dbHelper.insertList(
        deleteBeforeInsert: false,
        tableName: tableName,
        dataList: [toJson(item)],
      );
      if (kDebugMode) {
        print('Item inserted ');
      }
      //await getAllItems(fillSearchListOnly: false);
      //await fillAsController();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error inserting item: $e');
      }
    }
  }
}
