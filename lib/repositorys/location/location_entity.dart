class LocationEntity {
  static final tblLocation = "locations";
  static final dbId = "id";
  static final dbName = "name";
  static final dbLongitude = 'longitude';
  static final dbLatitude = 'latitude';

  final int id;
  final double longitude, latitude;
  final String name;
  LocationEntity({this.id, this.longitude, this.latitude, this.name});

  @override
  int get hashCode =>
      id.hashCode ^ longitude.hashCode ^ name.hashCode ^ latitude.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          longitude == other.longitude &&
          latitude == other.latitude &&
          name == other.name;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'longitude': longitude,
      'latitude': latitude,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'TodoEntity{id: $id, longitude: $longitude, latitude: $latitude, name: $name}';
  }

  static LocationEntity fromJson(Map<String, Object> json) {
    return LocationEntity(
      id: json['id'] as int,
      longitude: json['longitude'] as double,
      latitude: json['latitude'] as double,
      name: json['name'] as String,
    );
  }

  LocationEntity copyWith(
      {int id, double longitude, double latitude, String name}) {
    return LocationEntity(
        id: id ?? this.id,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        name: name ?? this.name);
  }
}
