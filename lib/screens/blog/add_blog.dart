import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/label/label_bloc.dart';
import 'package:guohao/blocs/label/label_state.dart';
import 'package:guohao/models/category.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/repositorys/label/label_entity.dart';
import 'package:guohao/screens/category/category_dialog.dart';
import 'package:guohao/screens/label/label_list.dart';
import 'package:guohao/tools/dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/screens/blog/blog_attr.dart';
import 'package:guohao/tools/toast.dart';
import 'package:guohao/widgets/editor_page.dart';
import 'package:guohao/widgets/result.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';

class AddBlogPage extends StatefulWidget {
  final int blogId;
  AddBlogPage({Key key, this.blogId}) : super(key: key);

  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final editorPage = GlobalKey<EditorPageState>();

  @override
  Widget build(BuildContext context) {
    ProgressDialog loadingDialog;
    return BlocConsumer<BlogsBloc, BlogsState>(
      buildWhen: (pstate, cstate) {
        return cstate is BlogsLoadSuccess || cstate is BlogsLoadFailure;
      },
      builder: (context, state) {
        if (state is BlogsLoadSuccess) {
          final blogEntity = state.blogs.firstWhere(
              (blog) => blog.id == widget.blogId,
              orElse: () => null);

          return Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: AppBar(
              title: Text('编辑日记'),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      _stopEditing(blogEntity);
                    },
                    icon: Icon(Icons.save)),
                PopupMenuButton(onSelected: (value) {
                  _onSelected(value, blogEntity);
                }, itemBuilder: (context) {
                  return [
                    PopupMenuItem(value: 8, child: Text('保存')),
                    PopupMenuItem(value: 7, child: Text('删除')),
                  ];
                })
              ],
            ),
            body: blogEntity == null
                ? ResultView()
                : EditorPage(
                    key: editorPage,
                    eidt: true,
                    content: blogEntity.title,
                  ),
          );
        } else {
          return ResultView();
        }
      },
      listener: (context, state) {
        if (state is BlogTitleUpdateInProgress) {
          if (loadingDialog == null) {
            loadingDialog = new ProgressDialog(context);
            loadingDialog.update(message: '正在保存数据');
          }
          loadingDialog.show();
        } else if (state is BlogTitleUpdateSuccess) {
          loadingDialog?.hide();
          Navigator.of(context).pop();
        } else if (state is BlogTitleUpdateSuccess) {
          loadingDialog?.hide();
          ToastUtil.show('日记保存失败。');
        }
      },
    );
  }

  void _stopEditing(BlogEntity blogEntity) {
    try {
      NotusDocument document = editorPage.currentState.getDocument();

      List<Operation> list = document.toDelta().toList();
      List<String> photoIds = [];
      if (list != null) {
        for (var item in list) {
          if (item.attributes != null && item.hasAttribute('embed')) {
            NotusStyle ns = NotusStyle.fromJson(item.attributes);
            EmbedAttribute e = ns.get(NotusAttribute.embed);
            photoIds.add(e.value['source']);
          }
        }
      }
      BlocProvider.of<BlogsBloc>(context)
          .add(BlogTitleUpdated(blogEntity.id, jsonEncode(document), photoIds));
      Navigator.of(context).pop();
    } catch (e) {}
  }

  _onSelected(value, BlogEntity blogEntity) async {
    if (value == 8) {
      _stopEditing(blogEntity);
    } else if (value == 7) {
      var result = await DialogUtil.showAleartDialog(context, '确定删除日记？');
      if (result != null && result) {
        BlocProvider.of<BlogsBloc>(context).add(BlogDeleted(blogEntity.id));
        Navigator.of(context).pop(true);
      }
    }
  }
}
