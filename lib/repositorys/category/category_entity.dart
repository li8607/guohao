class CategoryEntity {
  static final tblProject = "projects";
  static final dbId = "id";
  static final dbName = "name";
  static final dbColorCode = "colorCode";
  static final dbColorName = "colorName";

  final int id, colorValue;
  final String name, colorName;
  CategoryEntity({this.id, this.colorValue, this.colorName, this.name});

  @override
  int get hashCode =>
      id.hashCode ^ colorValue.hashCode ^ name.hashCode ^ colorName.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          colorValue == other.colorValue &&
          colorName == other.colorName &&
          name == other.name;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'colorValue': colorValue,
      'colorName': colorName,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'TodoEntity{id: $id, colorValue: $colorValue, colorName: $colorName, name: $name}';
  }

  static CategoryEntity fromJson(Map<String, Object> json) {
    return CategoryEntity(
      id: json['id'] as int,
      colorValue: json['colorValue'] as int,
      colorName: json['colorName'] as String,
      name: json['name'] as String,
    );
  }
}
