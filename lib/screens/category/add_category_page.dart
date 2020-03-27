import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/category/category_bloc.dart';
import 'package:guohao/blocs/category/category_event.dart';
import 'package:guohao/blocs/category/category_state.dart';
import 'package:guohao/models/category.dart';
import 'package:guohao/tools/color_utils.dart';
import 'package:guohao/tools/dialog.dart';
import 'package:guohao/tools/toast.dart';
import 'package:guohao/widgets/collapsable_expand_tile.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final expansionTile = GlobalKey<CollapsibleExpansionTileState>();
  final _formState = GlobalKey<FormState>();

  String categoryName;
  ColorPalette colorPalette;
  @override
  void initState() {
    super.initState();
    categoryName = "";
    colorPalette = ColorPalette("Grey", Colors.grey.value);
  }

  @override
  Widget build(BuildContext context) {
    CategoryBloc categoryBloc = BlocProvider.of(context);
    return BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) async {
          if (state is AddCategoryInProgress) {
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => LoadingDialog(text: '添加分类...'));
          } else if (state is AddCategorySuccess) {
            Navigator.of(context).pop();
            ToastUtil.show('分类添加成功');
            Navigator.of(context).pop();
          } else if (state is AddCategoryFailure) {
            Navigator.of(context).pop();
            ToastUtil.show('分类添加失败,请重试');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("添加分类"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    if (_formState.currentState.validate()) {
                      _formState.currentState.save();
                      var category = Category(
                          name: categoryName,
                          colorValue: colorPalette.colorValue,
                          colorName: colorPalette.colorName);
                      categoryBloc.add(AddCategory(category));
                    }
                  })
            ],
          ),
          body: ListView(
            children: <Widget>[
              Form(
                  key: _formState,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: '分类名称'),
                      maxLength: 20,
                      validator: (value) {
                        return value.isEmpty ? '分类名称不能位空' : null;
                      },
                      onSaved: (value) {
                        categoryName = value;
                      },
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: CollapsibleExpansionTile(
                  key: expansionTile,
                  leading: Container(
                    width: 12.0,
                    height: 12.0,
                    child: CircleAvatar(
                      backgroundColor: Color(colorPalette.colorValue),
                    ),
                  ),
                  title: Text(colorPalette.colorName),
                  children: buildMaterialColors(),
                ),
              )
            ],
          ),
        ));
  }

  List<Widget> buildMaterialColors() {
    List<Widget> categoryWidgetList = [];
    colorsPalettes.forEach((element) {
      categoryWidgetList.add(
        Builder(builder: (context) {
          return ListTile(
            leading: Container(
                width: 12.0,
                height: 12.0,
                child: CircleAvatar(
                  backgroundColor: Color(element.colorValue),
                )),
            title: Text(element.colorName),
            onTap: () {
              expansionTile.currentState.collapse();
              colorPalette =
                  ColorPalette(element.colorName, element.colorValue);
              setState(() {});
            },
          );
        }),
      );
    });
    return categoryWidgetList;
  }
}
