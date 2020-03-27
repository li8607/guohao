import 'package:sqflite/sqflite.dart';
import 'package:guohao/repositorys/category/category_entity.dart';
import '../app_database.dart';

class CategoryRepository {
  static final CategoryRepository _categoryRepository =
      CategoryRepository._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  CategoryRepository._internal(this._appDatabase);

  static CategoryRepository get() {
    return _categoryRepository;
  }

  Future<List<CategoryEntity>> loadCategorys() async {
    var db = await _appDatabase.getDb();
    var result =
        await db.rawQuery('SELECT * FROM ${CategoryEntity.tblProject}');
    List<CategoryEntity> categoryEntitys = [];
    for (var item in result) {
      var categoryEntity = CategoryEntity.fromJson(item);
      categoryEntitys.add(categoryEntity);
    }
    return categoryEntitys;
  }

  Future<void> insertOrReplace(CategoryEntity entity) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawInsert('INSERT OR REPLACE INTO '
          '${CategoryEntity.tblProject}(${CategoryEntity.dbId},${CategoryEntity.dbName},${CategoryEntity.dbColorCode},${CategoryEntity.dbColorName})'
          ' VALUES(${entity.id},"${entity.name}", ${entity.colorValue}, "${entity.colorName}")');
    });
  }

  Future<List<Map<String, dynamic>>> loadAll() async {
    var db = await _appDatabase.getDb();
    return db.rawQuery('SELECT ${CategoryEntity.tblProject}.* '
        'FROM ${CategoryEntity.tblProject};');
  }

  clear() async {
    var db = await _appDatabase.getDb();
    return db.delete(CategoryEntity.tblProject);
  }

  Future<void> batchInsert(List<CategoryEntity> entitys) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      for (var entity in entitys) {
        await txn.rawInsert('INSERT OR REPLACE INTO '
            '${CategoryEntity.tblProject}(${CategoryEntity.dbId},${CategoryEntity.dbName},${CategoryEntity.dbColorCode},${CategoryEntity.dbColorName})'
            ' VALUES(${entity.id},"${entity.name}", ${entity.colorValue}, "${entity.colorName}")');
      }
    });
  }
}
