import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:common_utils/common_utils.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:sqflite/sqflite.dart';
import 'package:guohao/repositorys/photo/photo_entity.dart';
import '../app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

var uuid = Uuid();

class PhotoRepository {
  AppDatabase _appDatabase;

  PhotoRepository._internal(this._appDatabase);

  static final PhotoRepository _photoRepository =
      PhotoRepository._internal(AppDatabase.get());

  static PhotoRepository get() {
    return _photoRepository;
  }

  Future<String> insertOrReplace(File file, {int blogId}) async {
    File compressedFile = await FlutterNativeImage.compressImage(file.path);
    //获取文件名
    String fileName = file.uri.toFilePath();
    String caselsh = fileName.substring(0, fileName.lastIndexOf("."));
    String fileTyle =
        fileName.substring(fileName.lastIndexOf("."), fileName.length);

    Uint8List photoBlog = await compressedFile.readAsBytes();
    PhotoEntity photo = PhotoEntity(
        createTime: DateTime.now().millisecondsSinceEpoch,
        identifier: uuid.v1(),
        md5: generateMd5(caselsh),
        type: fileTyle,
        blogId: blogId,
        height: 0,
        width: 0);

    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      int id = await txn.rawInsert('INSERT OR REPLACE INTO '
          '${PhotoEntity.tblPhoto}(${PhotoEntity.dbId},${PhotoEntity.dbMd5},${PhotoEntity.dbType},${PhotoEntity.dbHeight},${PhotoEntity.dbWidth},${PhotoEntity.dbPhoto},${PhotoEntity.dbBlogId},${PhotoEntity.dbCreateTime})'
          ' VALUES("${photo.identifier}", "${photo.md5}", "${photo.type}", ${photo.height}, ${photo.width},"${photoBlog.toString()}", ${photo.blogId}, ${photo.createTime})');
    });
    return photo.identifier;
  }

  // md5 加密
  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  Future<Uint8List> getPhotoFromIdentifier(String id) async {
    try {
      var db = await _appDatabase.getDb();
      var result = await db
          .rawQuery('SELECT ${PhotoEntity.tblPhoto}.${PhotoEntity.dbPhoto} '
              'FROM ${PhotoEntity.tblPhoto} '
              'WHERE ${PhotoEntity.tblPhoto}.${PhotoEntity.dbId}="$id";');
      String photos = result.first['photo'];
      List<dynamic> photosd = json.decode(photos);
      List<int> list = photosd.map((e) => e as int).toList();
      return Uint8List.fromList(list);
    } catch (e) {}
    return null;
  }

  Future<List<PhotoEntity>> loadPhotos() async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery(
        'SELECT * FROM ${PhotoEntity.tblPhoto} ORDER BY ${PhotoEntity.tblPhoto}.${PhotoEntity.dbCreateTime} DESC');
    List<PhotoEntity> entitys = [];
    for (var item in result) {
      var entity = PhotoEntity.fromJson(item);
      entitys.add(entity);
    }
    return entitys;
  }

  Future<void> labelDeleteToBlog(int blogId) async {
    var db = await _appDatabase.getDb();
    return await db.transaction((Transaction txn) async {
      return await txn.rawInsert(r'UPDATE'
          ' ${PhotoEntity.tblPhoto} SET ${PhotoEntity.dbBlogId}=""'
          ' WHERE ${PhotoEntity.dbBlogId}=$blogId');
    });
  }

  Future<void> photoAddToBlog(int blogId, List<String> photoIds) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      for (var photoId in photoIds) {
        await txn.rawInsert(r'UPDATE'
            ' ${PhotoEntity.tblPhoto} SET ${PhotoEntity.dbBlogId}=$blogId'
            ' WHERE ${PhotoEntity.dbId}="$photoId"');
      }
    });
  }

  Future<void> deletePhotoNotBlogId() async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawDelete(
          'DELETE FROM ${PhotoEntity.tblPhoto} WHERE ${PhotoEntity.dbBlogId} IS NULL;');
    });
  }
}
