import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:guohao/blocs/home/home_bloc.dart';
import 'package:guohao/blocs/home/home_state.dart';
import 'package:guohao/models/category.dart';
import 'package:guohao/repositorys/category/category_repository.dart';
import 'category_state.dart';
import 'category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  final HomeBloc homeBloc;
  StreamSubscription streamSubscription;

  CategoryBloc({@required this.categoryRepository, this.homeBloc}) {
    streamSubscription = homeBloc?.listen((state) {
      if (state is AppStartSuccess) {
        add(LoadCategorys());
      }
    });
  }
  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }

  @override
  CategoryState get initialState => CategoryLoading();

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is LoadCategorys) {
      yield* _mapLoadCategorysToState();
    } else if (event is AddCategory) {
      yield* _mapAddCategoryToState(event);
    } else if (event is CategorySwitched) {
      yield* _mapCategorySwitchedToState(event);
    }
  }

  Stream<CategoryState> _mapCategorySwitchedToState(
      CategorySwitched event) async* {
    try {
      if (state is CategoryLoaded) {
        yield CategoryLoaded(
            index: (state as CategoryLoaded).categorys.indexOf(event.category),
            categorys: (state as CategoryLoaded).categorys);
      }
    } catch (_) {
      yield CategorySwitchFailure();
    }
  }

  Stream<CategoryState> _mapLoadCategorysToState() async* {
    try {
      final categorys = await categoryRepository.loadCategorys();
      List<Category> list = categorys.map(Category.fromEntity).toList();
      yield CategoryLoaded(index: 0, categorys: list);
    } catch (_) {
      yield CategoryNotLoaded();
    }
  }

  Stream<CategoryState> _mapAddCategoryToState(AddCategory event) async* {
    try {
      int index = 0;
      if (state is CategoryLoaded) {
        index = (state as CategoryLoaded).index;
      }

      yield AddCategoryInProgress();
      await categoryRepository.insertOrReplace(event.category.toEntity());
      yield AddCategorySuccess();

      final categorys = await categoryRepository.loadCategorys();
      List<Category> list = categorys.map(Category.fromEntity).toList();
      yield CategoryLoaded(index: index, categorys: list);
    } catch (_) {
      yield AddCategoryFailure();
    }
  }

  int getCategoryId() {
    if (state is CategoryLoaded) {
      CategoryLoaded categoryState = state;
      return categoryState.currentCategory().id;
    } else {
      return null;
    }
  }
}
