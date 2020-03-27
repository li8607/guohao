import 'package:flutter/cupertino.dart';

class LabelEntity {
  static final tblLabel = 'labels';
  static final dbId = 'id';
  static final dbName = 'name';
  static final dbColorCode = 'colorCode';
  static final dbColorName = 'colorName';

  int id, colorValue;
  String name, colorName;

  LabelEntity({this.id, this.name, this.colorValue, this.colorName});

  LabelEntity.create(this.name, this.colorValue, this.colorName);

  LabelEntity.update(
      {@required this.id, name = '', colorValue = '', colorName = ''}) {
    if (name != '') {
      this.name = name;
    }
    if (colorValue != '') {
      this.colorValue = colorValue;
    }
    if (colorName != '') {
      this.colorName = colorName;
    }
  }

  @override
  bool operator ==(o) =>
      o is LabelEntity &&
      o.id == id &&
      o.name == name &&
      o.colorValue == colorValue &&
      o.colorName == colorName;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ colorName.hashCode ^ colorValue.hashCode;

  LabelEntity.fromJson(Map<String, dynamic> map)
      : this.update(
            id: map[dbId],
            name: map[dbName],
            colorValue: map[dbColorCode],
            colorName: map[dbColorName]);

  LabelEntity copyWith(
      {int id, int colorValue, String name, String colorName}) {
    return LabelEntity(
        id: id ?? this.id,
        colorValue: colorValue ?? this.colorValue,
        name: name ?? this.name,
        colorName: colorName ?? this.colorName);
  }
}
