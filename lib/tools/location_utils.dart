import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:guohao/repositorys/location/location_entity.dart';

class LocationUtil {
  static location() async {
    if (await requestPermission()) {
      final location = await AmapLocation.fetchLocation();
      return location;
    }
  }

  static Future<bool> requestPermission() async {
    final permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<LocationEntity> getLocation() async {
    try {
      Location location = await LocationUtil.location();
      LatLng latLng = await location.latLng;
      return LocationEntity(
          name: await location.poiName,
          longitude: latLng.longitude,
          latitude: latLng.latitude);
    } catch (e) {
      return null;
    }
  }
}
