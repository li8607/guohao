import 'package:sqflite/sqflite.dart';
import 'package:guohao/repositorys/app_database.dart';
import 'package:guohao/repositorys/blog_label/blog_label_entity.dart';
import 'label_entity.dart';

class LabelRepository {
  AppDatabase _appDatabase;

  LabelRepository._internal(this._appDatabase);

  static final LabelRepository _labelRepository =
      LabelRepository._internal(AppDatabase.get());

  static LabelRepository get() {
    return _labelRepository;
  }

  Future<List<LabelEntity>> loadLabels() async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery('SELECT * FROM ${LabelEntity.tblLabel}');
    List<LabelEntity> labels = [];
    for (var item in result) {
      var categoryEntity = LabelEntity.fromJson(item);
      labels.add(categoryEntity);
    }
    return labels;
  }

  Future<List<LabelEntity>> loadLabelsByBlogId(int blogId) async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery('SELECT ${LabelEntity.tblLabel}.* '
        'FROM ${LabelEntity.tblLabel} LEFT JOIN ${BlogLabelEntity.tblBlogLabel} ON ${BlogLabelEntity.tblBlogLabel}.${BlogLabelEntity.dbLabelId}=${LabelEntity.tblLabel}.${LabelEntity.dbId} '
        'WHERE ${BlogLabelEntity.tblBlogLabel}.${BlogLabelEntity.dbBlogId}=$blogId;');
    List<LabelEntity> labels = [];
    for (var item in result) {
      var categoryEntity = LabelEntity.fromJson(item);
      labels.add(categoryEntity);
    }
    return labels;
  }

  Future<bool> isLabelExits(LabelEntity label) async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery(
        "SELECT * FROM ${LabelEntity.tblLabel} WHERE ${LabelEntity.dbName} LIKE '${label.name}'");
    if (result.length == 0) {
      return false;
      // return await updateLabels(label).then((value) {
      //   return false;
      // });
    } else {
      return true;
    }
  }

  Future<int> insertOrReplace(LabelEntity label) async {
    var db = await _appDatabase.getDb();
    return db.transaction((Transaction txn) async {
      return txn.rawInsert('INSERT OR REPLACE INTO '
          '${LabelEntity.tblLabel}(${LabelEntity.dbName},${LabelEntity.dbColorCode},${LabelEntity.dbColorName})'
          ' VALUES("${label.name}", ${label.colorValue}, "${label.colorName}")');
    });
  }

  Future<void> labelAddToBlog(BlogLabelEntity entity) async {
    int blogId = entity.blogId;
    int labelId = entity.labelId;
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      txn.rawInsert('INSERT OR REPLACE INTO '
          '${BlogLabelEntity.tblBlogLabel}(${BlogLabelEntity.dbId},${BlogLabelEntity.dbBlogId},${BlogLabelEntity.dbLabelId})'
          ' VALUES(null, $blogId, $labelId)');
    });
  }

  Future<void> labelDeleteToBlog(BlogLabelEntity entity) async {
    int blogId = entity.blogId;
    int labelId = entity.labelId;
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawDelete(
          'DELETE FROM ${BlogLabelEntity.tblBlogLabel} WHERE ${BlogLabelEntity.dbBlogId}==$blogId AND ${BlogLabelEntity.dbLabelId}==$labelId;');
    });
  }

  deleteLabel(int labelId) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawDelete(
          'DELETE FROM ${LabelEntity.tblLabel} WHERE ${LabelEntity.dbId}=$labelId;');
    });
  }
}
