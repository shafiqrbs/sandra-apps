import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String _dbName = 'terminalbd.db';
  static const _dbVersion = 1;
  static var status = '';

  String? dbpath;

  // This is a common pattern used in implementing a Singleton in Dart.
  // This is useful when only a single instance of a class is allowed to exist.
  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final String path = join(databasePath, _dbName);
    dbpath = path;

    //Check existing
    final exists = await databaseExists(path);
    if (!exists) {
      status = 'Creating Database';

      //If not exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } on FileSystemException catch (_) {
        // Handle the exception
      }

      //copy database
      final ByteData data = await rootBundle.load(join('assets/db', _dbName));
      final List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      //Write
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      status = 'Opening existing database';
      if (kDebugMode) {
        print('Opening existing database');
      }
    }

    return openDatabase(path, version: _dbVersion);
  }

  Future<bool> _tableExists(Database db, String tableName) async {
    final tables = await db.query(
      'sqlite_master',
      where: 'type = ? AND name = ?',
      whereArgs: ['table', tableName],
    );
    return tables.isNotEmpty;
  }

  Future<void> insertList({
    required bool deleteBeforeInsert,
    required String tableName,
    required List<Map<String, dynamic>> dataList,
  }) async {
    final Database? db = await instance.database;
    if (db != null) {
      if (kDebugMode) {
        print('Inserting data to $tableName');
      }

      if (!await _tableExists(db, tableName)) {
        return;
      }

      final Batch batch = db.batch();

      if (deleteBeforeInsert) {
        await deleteAll(tbl: tableName);
      }

      for (final data in dataList) {
        batch.insert(
          tableName,
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      batch.commit(
        continueOnError: true,
        noResult: true,
      );
    }
  }

  Future<List> getAll({
    required String tbl,
    int? limit,
    int? offset,
    String? orderBy,
  }) async {
    final Database? db = await instance.database;
    if (db != null) {
      if (!await _tableExists(db, tbl)) {
        return [];
      }

      final result = await db.query(
        tbl,
        limit: limit,
        offset: offset,
        orderBy: orderBy,
      );
      return result.toList();
    }
    return [];
  }

  Future<int> deleteAll({required String tbl}) async {
    final Database? db = await instance.database;
    if (db != null) {
      if (!await _tableExists(db, tbl)) {
        return 0;
      }
      return db.rawDelete('DELETE FROM $tbl');
    }
    return 0;
  }

  Future<int> deleteAllWhr({
    required String tbl,
    required String where,
    required List whereArgs,
  }) async {
    final Database? db = await instance.database;
    if (db != null) {
      if (!await _tableExists(db, tbl)) {
        return 0;
      }
      return db.rawDelete(
        'DELETE FROM $tbl WHERE $where',
        whereArgs,
      );
    }
    return 0;
  }

  Future<List<Map<String, dynamic>>> getAllWhr({
    required String tbl,
    required String where,
    required List<dynamic> whereArgs,
    int? limit,
    int? offset,
  }) async {
    if (kDebugMode) {
      print('Where Clause: $where');
    }

    final Database? db = await instance.database;
    if (db != null) {
      final sql = StringBuffer('SELECT * FROM $tbl WHERE $where');
      if (limit != null) {
        sql.write(' LIMIT $limit');
      }
      if (offset != null) {
        sql.write(' OFFSET $offset');
      }
      return db.rawQuery(sql.toString(), whereArgs);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getLocalFinancialData({
    required String tbl,
    required String where,
    required List<dynamic> whereArgs,
    int? limit,
    int? offset,
  }) async {
    if (kDebugMode) {
      print(where);
    }
    final Database? db = await instance.database;
    if (db != null) {
      final sql = StringBuffer(
        'SELECT SUM(net_total) as total, SUM(received) as received,(SUM(net_total) - SUM(received)) as due, method_id FROM sales WHERE is_hold is null or is_hold == 0 GROUP BY method_id',
      );
      return db.rawQuery(sql.toString(), whereArgs);
    }
    return [];
  }

  Future<int> updateWhere({
    required String tbl,
    required Map<String, dynamic> data,
    required String where,
    required List whereArgs,
  }) async {
    final Database? db = await instance.database;
    if (db != null) {
      if (!await _tableExists(db, tbl)) {
        return 0;
      }
      return db.update(
        tbl,
        data,
        where: where,
        whereArgs: whereArgs,
      );
    }
    return 0;
  }

  // get item count from table
  Future<int> getItemCount({
    String? tableName,
    int? limit,
  }) async {
    final Database? db = await instance.database;
    if (db != null && tableName != null) {
      if (!await _tableExists(db, tableName)) {
        return 0;
      }

      if (limit == null) {
        final result = await db.rawQuery(
          'SELECT COUNT(*) FROM $tableName',
        );
        return Sqflite.firstIntValue(result) ?? 0;
      } else {
        final result = await db.rawQuery(
          'SELECT COUNT(*) FROM $tableName LIMIT $limit',
        );
        return Sqflite.firstIntValue(result) ?? 0;
      }
    }
    return 0;
  }

  Future<List<Map<String, Object?>>> getTotalCountAndSum({
    required String tableName,
  }) async {
    final Database? db = await instance.database;
    if (db != null) {
      final result = await db.rawQuery(
        'SELECT COUNT(id) as count, '
        'ROUND(SUM(price * orderedQuantity)) as total '
        'FROM $tableName',
      );
      if (kDebugMode) {
        print(result);
      }
      return result;
    }
    return [];
  }

  Future<List> find(String tbl, String whr, List whrArgs) async {
    final Database? db = await instance.database;
    if (db != null) {
      if (!await _tableExists(db, tbl)) {
        return [];
      }
      final result = await db.query(tbl, where: whr, whereArgs: whrArgs);
      return result.toList();
    }
    return [];
  }
}
