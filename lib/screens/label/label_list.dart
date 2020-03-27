import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:guohao/blocs/label/label_bloc.dart';
import 'package:guohao/blocs/label/label_event.dart';
import 'package:guohao/repositorys/label/label_entity.dart';
import 'package:guohao/screens/search/search_label.dart';
import 'package:guohao/tools/dialog.dart';

class LabelListView extends StatelessWidget {
  final List<LabelEntity> labels;
  final List<LabelEntity> activeLabels;
  final bool singleItem;
  final ValueChanged<List<LabelEntity>> onChange;

  const LabelListView(
      {Key key,
      this.labels,
      this.activeLabels,
      this.singleItem: true,
      this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(8),
      child: Tags(
        textField: TagsTextField(
          autofocus: false,
          hintText: '添加标签',
          textStyle: TextStyle(fontSize: 18),
          enabled: true,
          constraintSuggestion: true,
          suggestions: null,
          onSubmitted: (String str) {
            BlocProvider.of<LabelBloc>(context).add(LabelInserted(label: str));
          },
        ),
        alignment: WrapAlignment.start,
        itemCount: labels.length,
        itemBuilder: (int index) {
          final item = labels[index];

          return ItemTags(
            key: Key(index.toString()),
            singleItem: singleItem,
            active: activeLabels?.contains(item),
            index: index,
            title: item.name,
            activeColor: Theme.of(context).primaryColor,
            colorShowDuplicate: Theme.of(context).errorColor,
            textStyle: TextStyle(
              fontSize: 18,
            ),
            combine: ItemTagsCombine.withTextBefore,
            removeButton: ItemTagsRemoveButton(
              backgroundColor: Theme.of(context).backgroundColor,
              onRemoved: () {
                DialogUtil.showAleartDialog(context, '确定要${item.name}删除吗？')
                    .then((value) {
                  if (value != null && value) {
                    BlocProvider.of<LabelBloc>(context)
                        .add(LabelDeleted(labelId: item.id));
                  }
                });
                return false;
              },
            ),
            onPressed: (tag) {
              if (singleItem) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchLabelPage(
                    label: tag.title,
                  );
                }));
              }

              if (tag.active) {
                activeLabels?.add(item.copyWith());
              } else {
                activeLabels?.remove(item);
              }

              if (onChange != null) {
                onChange(List.from(activeLabels));
              }
            },
            onLongPressed: (item) => print(item),
          );
        },
      ),
    ));
  }
}
