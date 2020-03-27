import 'package:equatable/equatable.dart';
import 'package:guohao/models/category.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object> get props => [];
}

class LoadCategorys extends CategoryEvent {

}

class CategorySwitched extends CategoryEvent {

  final Category category;
  CategorySwitched(this.category);

}

class AddCategory extends CategoryEvent {
  final Category category;

  AddCategory(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'AddCategory { category: $category }';
}

class UpdateCategory extends CategoryEvent {}

class DeleteCategory extends CategoryEvent {}
