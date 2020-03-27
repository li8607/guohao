import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/blocs/label/label_bloc.dart';
import 'package:guohao/blocs/label/label_state.dart';
import 'package:guohao/models/category.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/repositorys/label/label_entity.dart';
import 'package:guohao/screens/category/category_dialog.dart';
import 'package:guohao/screens/label/label_list.dart';
import 'package:guohao/styles/styles.dart';
import 'package:guohao/tools/dialog.dart';
import 'package:guohao/tools/notus_document_util.dart';
import 'package:guohao/widgets/app_zefyr_image_delegate.dart';
import 'package:guohao/widgets/result.dart';
import 'package:zefyr/zefyr.dart';

import 'add_blog.dart';
import 'blog_attr.dart';

class BlogDetailPage extends StatefulWidget {
  final int blogId;
  BlogDetailPage({Key key, this.blogId}) : super(key: key);

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogsBloc, BlogsState>(
        buildWhen: (pstate, cstate) {
          return cstate is BlogsLoadSuccess ||
              cstate is BlogsLoadFailure ||
              cstate is BlogsLoadInProgress;
        },
        builder: (context, state) {
          if (state is BlogsLoadSuccess) {
            final blogEntity = state.blogs.firstWhere(
                (blog) => blog.id == widget.blogId,
                orElse: () => null);
            var height = MediaQuery.of(context).size.height - 56;
            return Scaffold(
              appBar: AppBar(
                title: Text(''),
                actions: <Widget>[
                  IconButton(
                      onPressed: () {
                        _startEditing(context, blogEntity);
                      },
                      icon: Icon(Icons.edit)),
                  PopupMenuButton(onSelected: (value) {
                    _onSelected(context, blogEntity, value);
                  }, itemBuilder: (context) {
                    return [
                      PopupMenuItem(value: 1, child: Text('编辑')),
                      PopupMenuItem(
                          value: 2,
                          child: Text(blogEntity.favorite == 1 ? '已收藏' : "收藏")),
                      PopupMenuItem(value: 3, child: Text('标签')),
                      PopupMenuItem(value: 4, child: Text('分类')),
                      PopupMenuItem(value: 5, child: Text('分享')),
                      PopupMenuItem(value: 6, child: Text('属性')),
                      PopupMenuItem(value: 7, child: Text('删除')),
                    ];
                  })
                ],
              ),
              body: ListView(padding: const EdgeInsets.all(16.0), children: [
                Container(
                    constraints: BoxConstraints(
                      minHeight: height - 200,
                    ),
                    child: ZefyrView(
                      document: NotusDocumentUtil.getNotusDocumentFromString(
                          blogEntity.title),
                      imageDelegate: AppZefyrImageDelegate(),
                    )),
                _LabelListView(
                  labels: blogEntity.labelList,
                ),
                SizedBox(height: 60),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                SizedBox(height: 16),
                _BottomListView(
                  blogEntity: blogEntity,
                )
              ]),
            );
          } else {
            return ResultView();
          }
        },
        listener: (context, state) {});
  }

  void _startEditing(BuildContext context, BlogEntity blogEntity) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddBlogPage(blogId: blogEntity.id);
    }));
  }

  _onSelected(BuildContext context, BlogEntity blogEntity, int value) async {
    if (value == 1) {
      _startEditing(context, blogEntity);
    } else if (value == 2) {
      BlocProvider.of<BlogsBloc>(context).add(
          BlogFavoriteUpdated(blogEntity.id, blogEntity.favorite != 1 ? 1 : 0));
    } else if (value == 3) {
      _updateLabels(blogEntity.labelList);
    } else if (value == 4) {
      _updateCategory();
    } else if (value == 4) {
      //Todo 分享
    } else if (value == 6) {
      bool result =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BlogAttrPage(
          blogId: blogEntity.id,
        );
      }));
      if (result != null && result) {
        Navigator.of(context).pop();
      }
    } else if (value == 7) {
      var result = await DialogUtil.showAleartDialog(context, '确定删除日记？');
      if (result != null && result) {
        BlocProvider.of<BlogsBloc>(context).add(BlogDeleted(blogEntity.id));
        Navigator.of(context).pop(true);
      }
    }
  }

  _updateCategory() async {
    Category category = await showDialog(
        context: context, builder: (context) => CategoryDialog());
    if (category != null) {
      BlocProvider.of<BlogsBloc>(context)
          .add(BlogCategoryUpdated(widget.blogId, category));
    }
  }

  _updateLabels(List<String> labels) async {
    List<LabelEntity> activeLabels =
        await showModalBottomSheet<List<LabelEntity>>(
            context: context,
            builder: (context) {
              return BlocBuilder<LabelBloc, LabelState>(
                  condition: (pstate, cstate) {
                return cstate is LabelLoadedSuccess ||
                    cstate is LabelLoadedInProgress ||
                    cstate is LabelLoadedFailure;
              }, builder: (context, state) {
                if (state is LabelLoadedSuccess) {
                  List<LabelEntity> activeLabels = [];
                  if (labels != null) {
                    state.labels.forEach((value) {
                      if (labels.contains(value.name)) {
                        activeLabels.add(value);
                      }
                    });
                  }
                  return Column(children: [
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('取消')),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop(activeLabels);
                            },
                            child: Text('确定'))
                      ],
                    ),
                    Expanded(
                        child: LabelListView(
                      labels: state.labels ?? [],
                      activeLabels: activeLabels,
                      singleItem: false,
                      onChange: (value) {
                        activeLabels = value;
                      },
                    ))
                  ]);
                } else {
                  return ResultView();
                }
              });
            });

    if (activeLabels != null) {
      BlocProvider.of<BlogsBloc>(context)
          .add(BlogLabelsUpdated(blogId: widget.blogId, labels: activeLabels));
    }
  }
}

class _LabelListView extends StatelessWidget {
  final List<String> labels;

  _LabelListView({Key key, this.labels: const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // 主轴(水平)方向间距
      runSpacing: 4.0, // 纵轴（垂直）方向间距
      alignment: WrapAlignment.start, //沿主轴方向居中
      children: labels == null
          ? []
          : labels.map((value) => Chip(label: Text(value))).toList(),
    );
  }
}

class _BottomListView extends StatelessWidget {
  final BlogEntity blogEntity;

  const _BottomListView({Key key, this.blogEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        _BottomListItemView(
          title: Text(
            DateUtil.formatDateMs(blogEntity.dueDate, format: 'HH:mm') ?? "",
            style: blogBottomPrimaryText,
          ),
          subTitle: Text(
            blogEntity.categoryName ?? "",
            style: blogBottomSecondaryText,
          ),
        ),
        SizedBox(width: 16),
        _BottomListItemView(
          title: Text(
            '${blogEntity?.photos?.length ?? "0"}',
            style: blogBottomPrimaryText,
          ),
          subTitle: Text(
            '照片',
            style: blogBottomSecondaryText,
          ),
        ),
        SizedBox(width: 16),
        // _BottomListItemView(
        //   title: Text(
        //     '2',
        //     style: blogBottomPrimaryText,
        //   ),
        //   subTitle: Text(
        //     '段落',
        //     style: blogBottomSecondaryText,
        //   ),
        // ),
        // SizedBox(width: 16),
        _BottomListItemView(
          title: Text(
            '${NotusDocumentUtil.getTitle(blogEntity.title)?.length ?? "0"}',
            style: blogBottomPrimaryText,
          ),
          subTitle: Text(
            '字数',
            style: blogBottomSecondaryText,
          ),
        ),
        SizedBox(width: 16),
        _BottomListItemView(
          title: Icon(blogEntity.favorite == 1
              ? Icons.favorite
              : Icons.favorite_border),
          subTitle: Text(
            blogEntity.favorite == 1 ? '已收藏' : '收藏',
            style: blogBottomSecondaryText,
          ),
        )
      ]),
    );
  }
}

class _BottomListItemView extends StatelessWidget {
  final Widget title;
  final Widget subTitle;

  const _BottomListItemView({Key key, this.title, this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[title, subTitle],
    );
  }
}
