part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();
}

class LocationInitial extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationInProgress extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationSuccess extends LocationState {
  final LocationEntity location;
  final List<LocationEntity> locations;

  const LocationSuccess({this.location, this.locations});

  @override
  List<Object> get props => [location, locations];

  LocationSuccess copyWith(
      {LocationEntity location, List<LocationEntity> locations}) {
    return LocationSuccess(
        location: location ?? this.location,
        locations: locations ?? this.locations);
  }
}

class LocationFailure extends LocationState {
  @override
  List<Object> get props => [];
}
