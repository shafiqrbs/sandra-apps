import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/core/advance_select/advance_select_controller.dart';
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

  /// Dropdown controller for the entity
  final asController = ASController<T>([]);

  /// Scroll controller for the entity
  final scrollController = ScrollController();

  /// Constructor
  EntityManager(this.tableName, this.fromJson, this.toJson) {
    scrollController.addListener(_scrollListener);
  }

  DbHelper dbHelper = DbHelper.instance;

  // Pagination listener
  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // Reached the bottom, load more data
      // You can adjust this condition based on your pagination logic
      // For example, you might want to load more data when you are near the bottom, not exactly at the bottom
      // Add your pagination logic here
      print('Reached the bottom');
      await getAllItems(fillSearchListOnly: false);
      print('Loaded more items');
      print('Total items: ${allItems.value?.length}');
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

  Future<void> getAllItems({
    required bool fillSearchListOnly,
    bool isReverse = false,
  }) async {
    if (kDebugMode) {
      print('Fetching all items from the database');
    }
    try {
      final items = await dbHelper.getAll(
        tbl: tableName,
        limit: 10,
        offset: allItems.value?.length ?? 0,
        // orderBy: 'sales_id DESC',
      );
      if (fillSearchListOnly) {
        searchedItems.value ??= <T>[];
        searchedItems.value?.clear();
        searchedItems.value = items.map((e) => fromJson(e)).toList();
      } else {
        allItems.value ??= <T>[];
        allItems..value!.addAll(items.map((e) => fromJson(e)).toList());
        if (isReverse) {
          allItems.value = allItems.value!.reversed.toList();
        }
        allItems.refresh();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error fetching all items: $e');
      }
    }
  }

  Future<void> fillAsController() async {
    try {
      final items = await dbHelper.getAll(
        tbl: tableName,
      );
      asController.items = items.map((e) => fromJson(e)).toList();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error filling ASController: $e');
      }
    }
  }

  Future<void> searchItemsByName(String query) async {
    if (kDebugMode) {
      print('Searching items by name: $query');
    }
    try {
      if (query.isEmpty) {
        await getAllItems(fillSearchListOnly: true);
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
