import 'package:guohao/repositorys/photo/photo_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:guohao/repositorys/app_database.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/repositorys/blog_label/blog_label_entity.dart';
import 'package:guohao/repositorys/category/category_entity.dart';
import 'package:guohao/repositorys/label/label_entity.dart';
import 'package:guohao/repositorys/location/location_entity.dart';

class BlogRepository {
  AppDatabase _appDatabase;

  BlogRepository._internal(this._appDatabase);

  static final BlogRepository _blogRepository =
      BlogRepository._internal(AppDatabase.get());

  static BlogRepository get() {
    return _blogRepository;
  }

  Future<List<BlogEntity>> loadBlogs(int categoryId,
      {int startDate = 0, int endDate = 0}) async {
    var db = await _appDatabase.getDb();

    var whereClause = startDate > 0 && endDate > 0
        ? "WHERE ${BlogEntity.tblBlog}.${BlogEntity.dbDueDate} BETWEEN $startDate AND $endDate"
        : "";

    var blogWhereClause =
        "${BlogEntity.tblBlog}.${BlogEntity.dbProjectID}=$categoryId";

    whereClause = whereClause.isEmpty
        ? "WHERE $blogWhereClause"
        : "$whereClause AND $blogWhereClause";

    var result = await db.rawQuery('SELECT ${BlogEntity.tblBlog}.*, '
        '${CategoryEntity.tblProject}.${CategoryEntity.dbName},${CategoryEntity.tblProject}.${CategoryEntity.dbColorCode}, '
        '(${LocationEntity.tblLocation}.${LocationEntity.dbName}) as locationName,${LocationEntity.tblLocation}.${LocationEntity.dbLatitude},${LocationEntity.tblLocation}.${LocationEntity.dbLongitude}, '
        'group_concat(${LabelEntity.tblLabel}.${LabelEntity.dbName}) as labelNames, '
        'group_concat(${PhotoEntity.tblPhoto}.${PhotoEntity.dbId}) as photos, '
        'group_concat(${PhotoEntity.tblPhoto}.${PhotoEntity.dbCreateTime}) as photoCreateTime '
        'FROM ${BlogEntity.tblBlog} LEFT JOIN ${BlogLabelEntity.tblBlogLabel} ON ${BlogLabelEntity.tblBlogLabel}.${BlogLabelEntity.dbBlogId}=${BlogEntity.tblBlog}.${BlogEntity.dbId} '
        'LEFT JOIN ${LabelEntity.tblLabel} ON ${LabelEntity.tblLabel}.${LabelEntity.dbId}=${BlogLabelEntity.tblBlogLabel}.${BlogLabelEntity.dbLabelId} '
        'LEFT JOIN ${PhotoEntity.tblPhoto} ON ${PhotoEntity.tblPhoto}.${PhotoEntity.dbBlogId}=${BlogEntity.tblBlog}.${BlogEntity.dbId} '
        'LEFT JOIN ${LocationEntity.tblLocation} ON ${BlogEntity.tblBlog}.${BlogEntity.dbLocationID} = ${LocationEntity.tblLocation}.${LocationEntity.dbId} '
        'INNER JOIN ${CategoryEntity.tblProject} ON ${BlogEntity.tblBlog}.${BlogEntity.dbProjectID} = ${CategoryEntity.tblProject}.${CategoryEntity.dbId} $whereClause GROUP BY ${BlogEntity.tblBlog}.${BlogEntity.dbId} ORDER BY ${BlogEntity.tblBlog}.${BlogEntity.dbDueDate} DESC;');

    return _bindData(result);
  }

  List<BlogEntity> _bindData(List<Map<String, dynamic>> result) {
    List<BlogEntity> tasks = List();
    print('result $result');
    for (Map<String, dynamic> item in result) {
      var blog = BlogEntity.fromJson(item);
      blog.categoryName = item[CategoryEntity.dbName];
      blog.categoryColor = item[CategoryEntity.dbColorCode];
      var labelComma = item['labelNames'];
      if (labelComma != null) {
        blog.labelList = labelComma.toString().split(',');
      }
      var photos = item['photos'];
      if (photos != null) {
        blog.photos = photos.toString().split(',');
      }
      var photoCreateTimes = item['photoCreateTime'];
      if (photoCreateTimes != null) {
        blog.photoCreateTimes = photoCreateTimes
            .toString()
            .split(',')
            .map((value) => int.parse(value))
            .toList();
      }

      if (blog.locationId != null) {
        LocationEntity locationEntity = LocationEntity(
            name: item['locationName'],
            latitude: item[LocationEntity.dbLatitude] as double,
            longitude: item[LocationEntity.dbLongitude] as double);
        blog.location = locationEntity;
      }

      tasks.add(blog);
    }
    return tasks;
  }

  Future<int> insertOrReplace(BlogEntity entity) async {
    var db = await _appDatabase.getDb();
    return await db.transaction((Transaction txn) async {
      entity.title = entity.title?.replaceAll('"', '""');
      print('ddd   ${entity.deviceName}');
      return await txn.rawInsert(r'INSERT OR REPLACE INTO '
          '${BlogEntity.tblBlog}(${BlogEntity.dbId},${BlogEntity.dbTitle},${BlogEntity.dbProjectID},${BlogEntity.dbComment},${BlogEntity.dbDueDate},${BlogEntity.dbPriority},${BlogEntity.dbStatus},${BlogEntity.dbDeviceName},${BlogEntity.dbFavorite},${BlogEntity.dbLocationID})'
          ' VALUES(${entity.id}, "${entity.title}", ${entity.categoryId},"${entity.comment}", ${entity.dueDate},${entity.priority},${entity.status},"${entity.deviceName}",${entity.favorite},${entity.locationId})');
    });
  }

  Future<int> updateFavorite(int blogId, int favorite) async {
    var db = await _appDatabase.getDb();
    return await db.transaction((Transaction txn) async {
      return await txn.rawInsert(r'UPDATE'
          ' ${BlogEntity.tblBlog} SET ${BlogEntity.dbFavorite}=$favorite'
          ' WHERE ${BlogEntity.dbId}=$blogId');
    });
  }

  Future<void> batchInsert(List<BlogEntity> entitys) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      for (var entity in entitys) {
        entity.title = entity.title.replaceAll('"', '""');
        await txn.rawInsert(r'INSERT OR REPLACE INTO '
            '${BlogEntity.tblBlog}(${BlogEntity.dbId},${BlogEntity.dbTitle},${BlogEntity.dbProjectID},${BlogEntity.dbComment},${BlogEntity.dbDueDate},${BlogEntity.dbPriority},${BlogEntity.dbStatus},${BlogEntity.dbDeviceName},${BlogEntity.dbFavorite})'
            ' VALUES(${entity.id}, "${entity.title}", ${entity.categoryId},"${entity.comment}", ${entity.dueDate},${entity.priority},${entity.status},"${entity.deviceName}",${entity.favorite})');
      }
    });
  }

  Future<BlogEntity> getBlogByBlogId(int blogId) async {
    print('bbbb   $blogId');
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery(
        'SELECT ${BlogEntity.tblBlog}.*,${CategoryEntity.tblProject}.${CategoryEntity.dbName},${CategoryEntity.tblProject}.${CategoryEntity.dbColorCode},group_concat(${LabelEntity.tblLabel}.${LabelEntity.dbName}) as labelNames '
        'FROM ${BlogEntity.tblBlog} LEFT JOIN ${BlogLabelEntity.tblBlogLabel} ON ${BlogLabelEntity.tblBlogLabel}.${BlogLabelEntity.dbBlogId}=${BlogEntity.tblBlog}.${BlogEntity.dbId} '
        'LEFT JOIN ${LabelEntity.tblLabel} ON ${LabelEntity.tblLabel}.${LabelEntity.dbId}=${BlogLabelEntity.tblBlogLabel}.${BlogLabelEntity.dbLabelId} '
        'INNER JOIN ${CategoryEntity.tblProject} ON ${BlogEntity.tblBlog}.${BlogEntity.dbProjectID} = ${CategoryEntity.tblProject}.${CategoryEntity.dbId} WHERE ${BlogEntity.tblBlog}.${BlogEntity.dbId}=$blogId GROUP BY ${BlogEntity.tblBlog}.${BlogEntity.dbId} ORDER BY ${BlogEntity.tblBlog}.${BlogEntity.dbDueDate} ASC;');

    BlogEntity blogEntity = _bindData(result).first;
    if (blogEntity != null && blogEntity.locationId != null) {
      var locationEntity = await db.rawQuery(
          'SELECT * FROM ${LocationEntity.tblLocation} WHERE ${LocationEntity.dbId}=${blogEntity.locationId}');
      print('lll   $locationEntity');
      if (locationEntity != null && locationEntity.length > 0) {
        blogEntity.location = LocationEntity.fromJson(locationEntity.first);
      }
    }

    return blogEntity;
  }

  Future<List<Map<String, dynamic>>> loadAll() async {
    var db = await _appDatabase.getDb();
    return db.rawQuery('SELECT ${BlogEntity.tblBlog}.* '
        'FROM ${BlogEntity.tblBlog};');
  }

  clear() async {
    var db = await _appDatabase.getDb();
    return db.delete(BlogEntity.tblBlog);
  }

  Future<int> updateDevice(int blogId, String deviceName) async {
    var db = await _appDatabase.getDb();
    return await db.transaction((Transaction txn) async {
      return await txn.rawInsert(r'UPDATE'
          ' ${BlogEntity.tblBlog} SET ${BlogEntity.dbDeviceName}="$deviceName"'
          ' WHERE ${BlogEntity.dbId}=$blogId');
    });
  }

  Future<int> updateLocation(int blogId, LocationEntity location) async {
    var db = await _appDatabase.getDb();
    return await db.transaction((Transaction txn) async {
      return await txn.rawInsert(r'UPDATE'
          ' ${BlogEntity.tblBlog} SET ${BlogEntity.dbLocationID}=${location.id}'
          ' WHERE ${BlogEntity.dbId}=$blogId');
    });
  }

  Future<int> updateCategory(int blogId, int categoryId) async {
    var db = await _appDatabase.getDb();
    return await db.transaction((Transaction txn) async {
      return await txn.rawInsert(r'UPDATE'
          ' ${BlogEntity.tblBlog} SET ${BlogEntity.dbProjectID}=$categoryId'
          ' WHERE ${BlogEntity.dbId}=$blogId');
    });
  }

  Future<int> updateTime(int blogId, int time) async {
    var db = await _appDatabase.getDb();
    return await db.transaction((Transaction txn) async {
      return await txn.rawInsert(r'UPDATE'
          ' ${BlogEntity.tblBlog} SET ${BlogEntity.dbDueDate}=$time'
          ' WHERE ${BlogEntity.dbId}=$blogId');
    });
  }

  deleteBlog(int blogId) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawDelete(
          'DELETE FROM ${BlogEntity.tblBlog} WHERE ${BlogEntity.dbId}=$blogId;');
    });
  }

  updateTitle(int blogId, String title) async {
    var db = await _appDatabase.getDb();
    title = title?.replaceAll('"', '""');
    return await db.transaction((Transaction txn) async {
      return await txn.rawInsert(r'UPDATE'
          ' ${BlogEntity.tblBlog} SET ${BlogEntity.dbTitle}="$title"'
          ' WHERE ${BlogEntity.dbId}=$blogId');
    });
  }
}
