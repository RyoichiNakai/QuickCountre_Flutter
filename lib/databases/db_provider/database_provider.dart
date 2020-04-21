import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_countre/databases/model/database_model.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';


// データベース毎にこのクラスを継承したProviderを実装する
abstract class DatabaseProvider {
  Database db;
  String get databaseName;
  String get tableName;

  void init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, databaseName);
    //deleteDatabase(path);

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version){
        newDb.execute(
            """
               CREATE TABLE $tableName(
                "id" INTEGER PRIMARY KEY,
                "username" TEXT,
                "time" INTEGER,
                "format" TEXT
               )
            """
        );
      },
    );
  }

  //追加
  Future<void> insertScore(User user) async{
    print(user.toMap());
    await db.insert(
      tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //中に入っているデータを受け取る
  Future<List<Map<String, dynamic>>> getScore() async{
    final List<Map<String, dynamic>> maps
    = await db.query(tableName, orderBy: "time");
    return maps;
  }

  //検索用
  Future<List<Map<String, dynamic>>> getName(String name) async{
    final List<Map<String, dynamic>> maps
    = await db.query(tableName, where:"username = ?", whereArgs:[name]);
    return maps;
  }
}

