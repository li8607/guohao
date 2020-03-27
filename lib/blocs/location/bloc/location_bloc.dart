import 'dart:async';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guohao/repositorys/location/location_entity.dart';
import 'package:guohao/repositorys/location/location_repository.dart';
import 'package:permission_handler/permission_handler.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepository;

  LocationBloc({this.locationRepository});

  @override
  LocationState get initialState => LocationInitial();

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is Locationed) {
      yield* _mapLocationedToState(event);
    } else if (event is LocationUpdated) {
      yield* _mapLocationUpdatedToState(event);
    } else if (event is LocationLoaded) {
      yield* _mapLocationLoadedToState(event);
    }
  }

  Stream<LocationState> _mapLocationLoadedToState(LocationLoaded event) async* {
    try {
      LocationSuccess currentState;
      if (state is LocationSuccess) {
        currentState = state as LocationSuccess;
      } else {
        currentState = LocationSuccess();
      }
      List<LocationEntity> locations = await locationRepository.loadLocations();
      yield currentState.copyWith(locations: locations);
    } catch (e) {
      yield LocationFailure();
    }
  }

  Stream<LocationState> _mapLocationUpdatedToState(
      LocationUpdated event) async* {
    try {
      if (state is LocationSuccess) {
        yield (state as LocationSuccess)
            .copyWith(location: event.location.copyWith());
      } else {
        yield LocationSuccess(location: event.location.copyWith());
      }
    } catch (e) {
      yield LocationFailure();
    }
  }

  Stream<LocationState> _mapLocationedToState(Locationed event) async* {
    try {
      LocationSuccess currentState;
      if (state is LocationSuccess) {
        currentState = state as LocationSuccess;
      } else {
        currentState = LocationSuccess();
      }

      yield LocationInProgress();

      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.location);
      if (permission == null) {
        if (!event.init) {
          final permissions = await PermissionHandler()
              .requestPermissions([PermissionGroup.location]);
          if (permissions[PermissionGroup.location] !=
              PermissionStatus.granted) {
            throw ArgumentError();
          }
        } else {
          throw ArgumentError();
        }
      }
      final location = await AmapLocation.fetchLocation();
      var latlng = await location.latLng;
      if (latlng.latitude < 1 && latlng.longitude < 1) {
        throw ArgumentError();
      }
      LocationEntity locationEntity = LocationEntity(
          latitude: latlng.latitude,
          longitude: latlng.longitude,
          name: await location.poiName);
      int id = await locationRepository.getLocationId(locationEntity);

      yield currentState.copyWith(location: locationEntity.copyWith(id: id));
    } catch (e) {
      yield LocationFailure();
    }
  }

  LocationEntity getLocation() {
    if (state is LocationSuccess) {
      return (state as LocationSuccess).location;
    }
    return null;
  }
}
