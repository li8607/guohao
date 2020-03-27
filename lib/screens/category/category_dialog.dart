import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/category/category_bloc.dart';
import 'package:guohao/blocs/category/category_state.dart';
import 'package:guohao/widgets/loading.dart';
import 'package:guohao/widgets/result.dart';

class CategoryDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      if (state is CategoryLoading) {
        return LoadingView();
      } else if (state is CategoryLoaded) {
        return SimpleDialog(
          title: const Text('分类'),
          children: state.categorys
              .map((e) => DialogDemoItem(
                    text: e.name,
                    onPressed: () {
                      Navigator.of(context).pop(e);
                    },
                    color: Colors.red,
                  ))
              .toList(),
        );
      } else {
        return ResultView();
      }
    });
  }
}

class DialogDemoItem extends StatelessWidget {
  const DialogDemoItem({Key key, this.color, this.text, this.onPressed})
      : super(key: key);

  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.book, size: 36.0, color: color),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
