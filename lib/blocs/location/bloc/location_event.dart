part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
}

class Locationed extends LocationEvent {
  final bool init;

  const Locationed({this.init: true});

  @override
  List<Object> get props => [init];
}

class LocationUpdated extends LocationEvent {
  final LocationEntity location;

  const LocationUpdated({this.location});

  @override
  List<Object> get props => [location];
}

class LocationLoaded extends LocationEvent {
  @override
  List<Object> get props => [];
}
