import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/category/category_bloc.dart';
import 'package:guohao/blocs/category/category_event.dart';
import 'package:guohao/blocs/category/category_state.dart';
import 'package:guohao/constant/routers.dart';
import 'package:guohao/models/category.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
        condition: (pstate, cstate) {
      return cstate is CategoryLoaded;
    }, builder: (context, state) {
      if (state is CategoryLoading) {
        return CircularProgressIndicator();
      } else if (state is CategoryLoaded) {
        return CategoryExpansionTileWidget(state.categorys);
      } else {
        return Container();
      }
    });
  }
}

class CategoryExpansionTileWidget extends StatelessWidget {
  final List<Category> _category;

  CategoryExpansionTileWidget(this._category);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.book),
      title: Text(
        '分类',
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      children: buildCategorys(context),
    );
  }

  List<Widget> buildCategorys(BuildContext context) {
    List<Widget> categoryWidgetList = [];
    _category
        .forEach((element) => categoryWidgetList.add(CategoryRow(element)));
    categoryWidgetList.add(ListTile(
      leading: Icon(Icons.add),
      title: Text('添加分类'),
      onTap: () {
        Navigator.pushNamed(context, CategoryRouters.addCategory);
      },
    ));
    return categoryWidgetList;
  }
}

class CategoryRow extends StatelessWidget {
  final Category category;

  CategoryRow(this.category);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        BlocProvider.of<CategoryBloc>(context).add(CategorySwitched(category));
        Navigator.pop(context);
      },
      leading: Container(
        width: 24.0,
        height: 24.0,
      ),
      title: Text(category.name),
      trailing: Container(
          height: 10.0,
          width: 10.0,
          child: CircleAvatar(
            backgroundColor: Colors.red,
          )),
    );
  }
}
