import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:guohao/repositorys/category/category_entity.dart';

import 'blog/blog_entity.dart';
import 'blog_label/blog_label_entity.dart';
import 'label/label_entity.dart';
import 'location/location_entity.dart';
import 'photo/photo_entity.dart';

class AppDatabase {
  static final AppDatabase _appDatabase = AppDatabase._internal();

  AppDatabase._internal();

  static AppDatabase get() {
    return _appDatabase;
  }

  bool didInit = false;

  Database _database;

  Future<Database> getDb() async {
    if (!didInit) await _init();
    return _database;
  }

  Future _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'diray.db');
    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await _createCategoryTable(db);
      await _createLocationTable(db);
      await _createPhotoTable(db);
      await _createBlogTable(db);
      await _createLabelTable(db);
    }, onUpgrade: (db, ov, nv) async {
      await db.execute('DROP TABLE ${CategoryEntity.tblProject}');
      await db.execute('DROP TABLE ${LocationEntity.tblLocation}');
      await db.execute('DROP TABLE ${PhotoEntity.tblPhoto}');
      await db.execute('DROP TABLE ${BlogEntity.tblBlog}');
      await db.execute('DROP TABLE ${LabelEntity.tblLabel}');
      await db.execute('DROP TABLE ${BlogLabelEntity.tblBlogLabel}');
      await _createCategoryTable(db);
      await _createLocationTable(db);
      await _createPhotoTable(db);
      await _createBlogTable(db);
      await _createLabelTable(db);
    });
    didInit = true;
  }

  Future _createPhotoTable(Database db) {
    return db.transaction((txn) async {
      txn.execute("CREATE TABLE ${PhotoEntity.tblPhoto} ("
          "${PhotoEntity.dbId} TEXT PRIMARY KEY,"
          "${PhotoEntity.dbMd5} TEXT,"
          "${PhotoEntity.dbType} TEXT,"
          "${PhotoEntity.dbPhoto} BLOB,"
          "${PhotoEntity.dbHeight} INTEGER,"
          "${PhotoEntity.dbWidth} INTEGER,"
          "${PhotoEntity.dbCreateTime} LONG,"
          "${PhotoEntity.dbBlogId} LONG,"
          "FOREIGN KEY(${PhotoEntity.dbBlogId}) REFERENCES ${BlogEntity.tblBlog}(${BlogEntity.dbId}) ON DELETE CASCADE);");
    });
  }

  Future _createLocationTable(Database db) {
    return db.transaction((txn) async {
      txn.execute("CREATE TABLE ${LocationEntity.tblLocation} ("
          "${LocationEntity.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${LocationEntity.dbName} TEXT,"
          "${LocationEntity.dbLongitude} REAL,"
          "${LocationEntity.dbLatitude} REAL);");
    });
  }

  Future _createLabelTable(Database db) {
    return db.transaction((txn) {
      txn.execute("CREATE TABLE ${LabelEntity.tblLabel} ("
          "${LabelEntity.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${LabelEntity.dbName} TEXT UNIQUE,"
          "${LabelEntity.dbColorName} TEXT,"
          "${LabelEntity.dbColorCode} INTEGER);");
      txn.execute("CREATE TABLE ${BlogLabelEntity.tblBlogLabel} ("
          "${BlogLabelEntity.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${BlogLabelEntity.dbBlogId} INTEGER,"
          "${BlogLabelEntity.dbLabelId} INTEGER,"
          "FOREIGN KEY(${BlogLabelEntity.dbBlogId}) REFERENCES ${BlogEntity.tblBlog}(${BlogEntity.dbId}) ON DELETE CASCADE,"
          "FOREIGN KEY(${BlogLabelEntity.dbLabelId}) REFERENCES ${LabelEntity.tblLabel}(${LabelEntity.dbId}) ON DELETE CASCADE);");
    });
  }

  Future _createCategoryTable(Database db) {
    return db.transaction((txn) async {
      txn.execute("CREATE TABLE ${CategoryEntity.tblProject} ("
          "${CategoryEntity.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${CategoryEntity.dbName} TEXT,"
          "${CategoryEntity.dbColorName} TEXT,"
          "${CategoryEntity.dbColorCode} INTEGER);");
      txn.rawInsert('INSERT INTO '
          '${CategoryEntity.tblProject}(${CategoryEntity.dbId},${CategoryEntity.dbName},${CategoryEntity.dbColorName},${CategoryEntity.dbColorCode})'
          ' VALUES(1, "Inbox", "Grey", ${Colors.grey.value});');
    });
  }

  Future _createBlogTable(Database db) {
    return db.execute("CREATE TABLE ${BlogEntity.tblBlog} ("
        "${BlogEntity.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${BlogEntity.dbTitle} TEXT,"
        "${BlogEntity.dbComment} TEXT,"
        "${BlogEntity.dbDueDate} LONG,"
        "${BlogEntity.dbPriority} LONG,"
        "${BlogEntity.dbProjectID} LONG,"
        "${BlogEntity.dbLocationID} LONG,"
        "${BlogEntity.dbStatus} LONG,"
        "${BlogEntity.dbDeviceName} TEXT,"
        "${BlogEntity.dbFavorite} LONG,"
        "FOREIGN KEY(${BlogEntity.dbLocationID}) REFERENCES ${LocationEntity.tblLocation}(${LocationEntity.dbId}) ON DELETE CASCADE,"
        "FOREIGN KEY(${BlogEntity.dbProjectID}) REFERENCES ${CategoryEntity.tblProject}(${CategoryEntity.dbId}) ON DELETE CASCADE);");
  }
}
