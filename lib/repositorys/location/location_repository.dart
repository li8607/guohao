import 'package:sqflite/sqflite.dart';
import 'package:guohao/repositorys/location/location_entity.dart';

import '../app_database.dart';

class LocationRepository {
  static final LocationRepository _locationRepository =
      LocationRepository._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  LocationRepository._internal(this._appDatabase);

  static LocationRepository get() {
    return _locationRepository;
  }

  Future<int> insertOrReplace(LocationEntity entity) async {
    var db = await _appDatabase.getDb();
    return db.transaction((Transaction txn) async {
      return txn.rawInsert('INSERT OR REPLACE INTO '
          '${LocationEntity.tblLocation}(${LocationEntity.dbId},${LocationEntity.dbName},${LocationEntity.dbLongitude},${LocationEntity.dbLatitude})'
          ' VALUES(${entity.id},"${entity.name}", ${entity.longitude}, "${entity.latitude}")');
    });
  }

  Future<int> getLocationId(LocationEntity entity) async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery(
        "SELECT * FROM ${LocationEntity.tblLocation} WHERE ${LocationEntity.dbName} LIKE '${entity.name}'");
    if (result.length == 0) {
      return insertOrReplace(entity);
    } else {
      return result.first[LocationEntity.dbId] as int;
    }
  }

  Future<bool> isLocationExits(LocationEntity entity) async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery(
        "SELECT * FROM ${LocationEntity.tblLocation} WHERE ${LocationEntity.dbName} LIKE '${entity.name}'");
    if (result.length == 0) {
      return await updateLocation(entity).then((value) {
        return false;
      });
    } else {
      return true;
    }
  }

  Future updateLocation(LocationEntity entity) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawInsert('INSERT OR REPLACE INTO '
          '${LocationEntity.tblLocation}(${LocationEntity.dbName},${LocationEntity.dbLongitude},${LocationEntity.dbLatitude})'
          ' VALUES("${entity.name}", ${entity.longitude}, "${entity.latitude}")');
    });
  }

  Future<List<LocationEntity>> loadLocations() async {
    var db = await _appDatabase.getDb();
    var result =
        await db.rawQuery('SELECT * FROM ${LocationEntity.tblLocation}');
    List<LocationEntity> list = [];
    for (var item in result) {
      var entity = LocationEntity.fromJson(item);
      list.add(entity);
    }
    return list;
  }
}
