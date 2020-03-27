import 'package:guohao/repositorys/location/location_entity.dart';

class BlogEntity {
  static final tblBlog = "Blogs";
  static final dbId = "id";
  static final dbTitle = "title";
  static final dbComment = "comment";
  static final dbDueDate = "dueDate";
  static final dbPriority = "priority";
  static final dbStatus = "status";
  static final dbProjectID = "projectId";
  static final dbLocationID = "locationId";
  static final dbDeviceName = "deviceName";
  static final dbFavorite = "favorite";

  String title, comment, categoryName;
  int id, dueDate, categoryId, priority, status, categoryColor, locationId;
  String deviceName;
  int favorite;
  List<String> labelList;
  List<String> photos;
  List<int> photoCreateTimes;
  LocationEntity location;

  BlogEntity({
    this.title,
    this.comment,
    this.id,
    this.dueDate,
    this.categoryId,
    this.locationId,
    this.location,
    this.priority,
    this.status,
    this.categoryName,
    this.categoryColor,
    this.deviceName,
    this.favorite: 0,
    this.labelList,
    this.photos,
    this.photoCreateTimes,
  });

  Map<String, Object> toJson() {
    return {
      'title': title,
      'comment': comment,
      'id': id,
      'dueDate': dueDate,
      'categoryId': categoryId,
      'locationId': locationId,
      'location': location.toJson(),
      'priority': priority,
      'status': status,
      'categoryName': categoryName,
      'categoryColor': categoryColor,
      'deviceName': deviceName,
      'favorite': favorite,
      'labelList': labelList,
      'photos': photos,
      'photoCreateTImes': photoCreateTimes
    };
  }

  static BlogEntity fromJson(Map<String, Object> json) {
    return BlogEntity(
        id: json['id'] as int,
        dueDate: json['dueDate'] as int,
        categoryId: json['projectId'] as int,
        locationId: json[BlogEntity.dbLocationID] as int,
        location: json['location'] as LocationEntity,
        priority: json['priority'] as int,
        status: json['status'] as int,
        title: json['title'] as String,
        deviceName: json['deviceName'] as String,
        favorite: json['favorite'] as int,
        comment: json['comment'] as String);
  }

  BlogEntity copyWith(
      {int id,
      int categoryId,
      int locationId,
      LocationEntity location,
      int categoryColor,
      int dueDate,
      String title,
      String comment,
      List<String> labelList,
      List<String> photos,
      List<int> photoCreateTimes,
      String photo,
      String deviceName,
      int favorite,
      String categoryName}) {
    return BlogEntity(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        locationId: locationId ?? this.locationId,
        location: location ?? this.location,
        categoryColor: categoryColor ?? this.categoryColor,
        dueDate: dueDate ?? this.dueDate,
        title: title ?? this.title,
        comment: comment ?? this.comment,
        labelList: labelList ?? this.labelList,
        photos: photos ?? this.photos,
        photoCreateTimes: photoCreateTimes ?? this.photoCreateTimes,
        categoryName: categoryName ?? this.categoryName,
        favorite: favorite ?? this.favorite,
        deviceName: deviceName ?? this.deviceName);
  }
}
