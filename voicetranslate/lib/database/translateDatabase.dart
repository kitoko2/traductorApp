// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class DatabaseTraduction {
  DatabaseTraduction._();
  static final instance = DatabaseTraduction._();
  Database? db;
  Future<Database> get database async {
    if (db != null) {
      return db!;
    } else {
      db = await initDB();
      return db!;
    }
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), "traduit.db"),
      onCreate: (db, i) {
        return db.execute(
          "CREATE TABLE resultat(id INT,langueDepart TEXT,langueArriver TEXT,motEntrer TEXT,resultatTraduction TEXT)",
        );
      },
      version: 1,
    );
  }

  insert(TraduitResult traduitResult) async {
    final tdb = await database;
    return tdb.insert(
      "resultat",
      traduitResult.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  delete() async {
    final tdb = await database;
    return tdb.delete("resultat");
  } // tous supprimer dans la table resultat

  Future<List<TraduitResult>> mesResultats() async {
    final tdb = await database;
    List<Map<String, dynamic>> maps = await tdb.query("resultat");
    List<TraduitResult> r = List.generate(maps.length, (index) {
      return TraduitResult.fromMap(maps[index]);
    });
    return r;
  }
}

class TraduitResult {
  int? id;
  String? langueDepart;
  String? langueArriver;
  String? motEntrer;
  String? resultatTraduction;
  TraduitResult({
    this.id,
    this.langueDepart,
    this.langueArriver,
    this.motEntrer,
    this.resultatTraduction,
  });

  toMap() {
    return {
      "id": id,
      "langueDepart": langueDepart,
      "langueArriver": langueArriver,
      "motEntrer": motEntrer,
      "resultatTraduction": resultatTraduction,
    };
  }

  factory TraduitResult.fromMap(Map<String, dynamic> map) {
    return TraduitResult(
      id: map["id"],
      langueDepart: map["langueDepart"],
      langueArriver: map["langueArriver"],
      motEntrer: map["motEntrer"],
      resultatTraduction: map["resultatTraduction"],
    );
  }
}
