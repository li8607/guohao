import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/label/label_bloc.dart';
import 'package:guohao/blocs/label/label_event.dart';
import 'package:guohao/blocs/label/label_state.dart';
import 'package:guohao/repositorys/label/label_entity.dart';
import 'package:guohao/tools/toast.dart';
import 'package:guohao/widgets/loading.dart';
import 'package:guohao/widgets/result.dart';

class LabelDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LabelBloc labelBloc = BlocProvider.of(context);
    return BlocConsumer<LabelBloc, LabelState>(
        listener: (context, state) {},
        buildWhen: (pstate, cstate) {
          return cstate is LabelLoadedInProgress ||
              cstate is LabelLoadedSuccess ||
              cstate is LabelLoadedFailure;
        },
        builder: (context, state) {
          if (state is LabelLoadedInProgress) {
            return LoadingView();
          } else if (state is LabelLoadedSuccess) {
            List<LabelEntity> selectors = state.selectorsLabels;
            final List<Widget> children = [];
            if (state.labels != null) {
              List<Widget> list = state.labels
                  .map((e) => CheckboxListTile(
                        title: Text(e.name),
                        value: selectors?.contains(e) ?? false,
                        onChanged: (value) {
                          if (value) {
                            labelBloc.add(BlogLabelInserted(state.blogId, e));
                          } else {
                            labelBloc.add(BlogLabelDeleted(state.blogId, e));
                          }
                        },
                      ))
                  .toList();
              children.addAll(list);
            }
            children.add(ListTile(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return BlocProvider.value(
                          value: labelBloc, child: AddLabelDialog());
                    });
              },
              leading: Icon(Icons.add),
              title: Text('创建新标签'),
            ));
            return SimpleDialog(
              title: const Text('标签'),
              children: children,
            );
          } else {
            return ResultView();
          }
        });
  }
}

class AddLabelDialog extends StatelessWidget {
  AddLabelDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    LabelBloc labelBloc = BlocProvider.of(context);
    return BlocConsumer<LabelBloc, LabelState>(buildWhen: (pstate, cstate) {
      return !(cstate is LabelInsertSuccess);
    }, builder: (context, state) {
      if (state is LabelInsertInProgress) {
        return LoadingView();
      } else {
        return AlertDialog(
          title: Text('标签名称'),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('取消')),
            FlatButton(
                onPressed: () {
                  String text = controller.text;
                  labelBloc.add(LabelInserted(label: text));
                },
                child: Text('确定'))
          ],
        );
      }
    }, listener: (context, state) {
      if (state is LabelInsertFailure &&
          state.message != null &&
          state.message.isNotEmpty) {
        ToastUtil.show(state.message);
      } else if (state is LabelInsertSuccess) {
        Navigator.of(context).pop();
      }
    });
  }
}
