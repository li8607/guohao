import 'package:guohao/repositorys/category/category_entity.dart';

class Category {
  final int id, colorValue;
  final String name, colorName;
  Category({this.id, this.colorName, this.colorValue, this.name});

  CategoryEntity toEntity() {
    return CategoryEntity(
        id: id, colorValue: colorValue, colorName: colorName, name: name);
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
        id: entity.id,
        colorName: entity.colorName,
        colorValue: entity.colorValue,
        name: entity.name);
  }

    @override
  int get hashCode =>
      id.hashCode ^ colorValue.hashCode ^ name.hashCode ^ colorName.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          colorValue == other.colorValue &&
          colorName == other.colorName &&
          name == other.name;


  @override
  String toString() {
    return 'Category{id: $id, colorValue: $colorValue, colorName: $colorName, name: $name}';
  }
}
