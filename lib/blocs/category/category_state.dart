import 'package:equatable/equatable.dart';
import 'package:guohao/models/category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categorys;
  final int index;

  const CategoryLoaded({this.index, this.categorys = const []});

  Category currentCategory() {
    try {
      return categorys[index];
    } catch (e) {
      return null;
    }
  }

  CategoryLoaded copyWith({int index, List<Category> categorys}) {
    return CategoryLoaded(index: index, categorys: categorys);
  }

  @override
  List<Object> get props => [index, categorys];
}

class CategoryNotLoaded extends CategoryState {}

class AddCategorySuccess extends CategoryState {
  @override
  String toString() => 'AddCategorySuccess';
}

class AddCategoryFailure extends CategoryState {
  @override
  String toString() => 'AddCategoryFailure';
}

class AddCategoryInProgress extends CategoryState {
  @override
  String toString() => 'AddCategoryInProgress';
}

class CategorySwitchSuccess extends CategoryState {
  @override
  String toString() => 'CategorySwitchSuccess';
}

class CategorySwitchFailure extends CategoryState {
  @override
  String toString() => 'CategorySwitchFailure';
}

class CategorySwitchInProgress extends CategoryState {
  @override
  String toString() => 'CategorySwitchInProgress';
}
