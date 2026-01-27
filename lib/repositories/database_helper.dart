import 'package:chabo/models/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'constant.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), Constant.database);

    if (kDebugMode) {
      await deleteDatabase(path);
    }

    return await openDatabase(
      path,
      version: Constant.databaseVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS ${Constant.tableAlarmClock} (
            ${Constant.columnId} TEXT PRIMARY KEY,
            ${Constant.columnHour} INTEGER NOT NULL,
            ${Constant.columnMinute} INTEGER NOT NULL,
            ${Constant.columnPeriod} INTEGER NOT NULL,
            ${Constant.columnName} TEXT NOT NULL,
            ${Constant.columnWeekdays} INTEGER NOT NULL,
            ${Constant.columnStatus} INTEGER NOT NULL,
            ${Constant.columnVibration} INTEGER NOT NULL,
            ${Constant.columnRingtoneName} TEXT NOT NULL,
            ${Constant.columnRingtoneUri} TEXT NOT NULL
          );
        ''');
      },
    );
  }

  Future<Database> close() async {
    await _database?.close();
    _database = null;
    return _database!;
  }

  Future<AlarmClock> insertAlarmClock(AlarmClock clock) async {
    try {
      final conn = await database;
      await conn.insert(Constant.tableAlarmClock, clock.toMap());
      return clock;
    } catch (e) {
      rethrow;
    }
  }

  Future<AlarmClock> updateAlarmClock(AlarmClock clock) async {
    try {
      final conn = await database;
      await conn.update(
        Constant.tableAlarmClock,
        clock.toMap(),
        where: '${Constant.columnId} = ?',
        whereArgs: [clock.id],
      );
      return clock;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AlarmClock>> listAlarmClocks({String? id}) async {
    try {
      final conn = await database;
      final result = await conn.query(
        Constant.tableAlarmClock,
        where: id == null ? null : '${Constant.columnId} = ?',
        whereArgs: id == null ? null : [id],
      );
      return result.map((alarmClock) => AlarmClock.fromMap(alarmClock)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAlarmClock(String id) async {
    try {
      final conn = await database;
      await conn.delete(Constant.tableAlarmClock, where: '${Constant.columnId} = ?', whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }
}
