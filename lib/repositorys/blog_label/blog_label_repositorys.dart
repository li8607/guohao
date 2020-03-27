import 'package:guohao/repositorys/app_database.dart';
import 'package:sqflite/sqflite.dart';

import 'blog_label_entity.dart';

class BlogLabelRepository {
  AppDatabase _appDatabase;

  BlogLabelRepository._internal(this._appDatabase);

  static final BlogLabelRepository _labelRepository =
      BlogLabelRepository._internal(AppDatabase.get());

  static BlogLabelRepository get() {
    return _labelRepository;
  }

  Future<void> batchInsert(List<BlogLabelEntity> entitys) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      for (var entity in entitys) {
        await txn.rawInsert('INSERT OR REPLACE INTO '
            '${BlogLabelEntity.tblBlogLabel}(${BlogLabelEntity.dbId},${BlogLabelEntity.dbBlogId},${BlogLabelEntity.dbLabelId})'
            ' VALUES(null, ${entity.blogId}, ${entity.labelId})');
      }
    });
  }

  batchDelete(int blogId) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawDelete(
          'DELETE FROM ${BlogLabelEntity.tblBlogLabel} WHERE ${BlogLabelEntity.dbBlogId}=$blogId;');
    });
  }
}
