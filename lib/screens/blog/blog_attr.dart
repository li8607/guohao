import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/label/label_bloc.dart';
import 'package:guohao/blocs/label/label_state.dart';
import 'package:guohao/screens/label/label_list.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/models/category.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/screens/category/category_dialog.dart';
import 'package:guohao/tools/dialog.dart';
import 'package:guohao/tools/toast.dart';
import 'package:guohao/widgets/date_list_tile.dart';
import 'package:guohao/widgets/result.dart';
import 'package:guohao/repositorys/label/label_entity.dart';

class BlogAttrPage extends StatefulWidget {
  final int blogId;

  BlogAttrPage({Key key, this.blogId}) : super(key: key);

  @override
  _BlogAttrPageState createState() => _BlogAttrPageState();
}

class _BlogAttrPageState extends State<BlogAttrPage> {
  ProgressDialog loadingDialog;

  @override
  Widget build(BuildContext context) {
    //分类//标签
    return BlocConsumer<BlogsBloc, BlogsState>(listener: (context, state) {
      if (state is BlogCategoryUpdateInProgress) {
        if (loadingDialog == null) {
          loadingDialog = ProgressDialog(context);
          loadingDialog.update(message: '正在修改分类...');
        }
        loadingDialog.show();
      } else if (state is BlogCategoryUpdateSuccess) {
        loadingDialog?.hide();
        ToastUtil.show('修改分类成功。');
      } else if (state is BlogCategoryUpdateFailure) {
        loadingDialog?.hide();
        ToastUtil.show('修改分类失败。');
      } else if (state is BlogTimeUpdateInProgress) {
        if (loadingDialog == null) {
          loadingDialog = ProgressDialog(context);
          loadingDialog.update(message: '正在修改日期...');
        }
        loadingDialog.show();
      } else if (state is BlogTimeUpdateSuccess) {
        loadingDialog?.hide();
        ToastUtil.show('更新日期成功。');
      } else if (state is BlogTimeUpdateFailure) {
        loadingDialog?.hide();
        ToastUtil.show('更新日期失败。');
      } else if (state is BlogDeviceUpdateInProgress) {
        if (loadingDialog == null) {
          loadingDialog = ProgressDialog(context);
          loadingDialog.update(message: '正在修改设备...');
        }
        loadingDialog.show();
      } else if (state is BlogDeviceUpdateSuccess) {
        loadingDialog?.hide();
        ToastUtil.show('更新设备信息成功。');
      } else if (state is BlogDeviceUpdateFailure) {
        loadingDialog?.hide();
        ToastUtil.show('更新设备信息失败。');
      } else if (state is BlogFavoriteUpdateInProgress) {
        if (loadingDialog == null) {
          loadingDialog = ProgressDialog(context);
          loadingDialog.update(message: '正在修改收藏状态...');
        }
        loadingDialog.show();
      } else if (state is BlogFavoriteUpdateSuccess) {
        loadingDialog?.hide();
        ToastUtil.show('${state.favorite == 1 ? "已收藏" : "取消收藏"}');
      } else if (state is BlogFavoriteUpdateFailure) {
        loadingDialog?.hide();
        ToastUtil.show('添加收藏失败。');
      } else if (state is BlogLocationUpdateInProgress) {
        if (loadingDialog == null) {
          loadingDialog = ProgressDialog(context);
          loadingDialog.update(message: '正在修改位置...');
        }
        loadingDialog.show();
      } else if (state is BlogLocationUpdateSuccess) {
        loadingDialog?.hide();
        ToastUtil.show('修改位置成功。');
      } else if (state is BlogLocationUpdateFailure) {
        loadingDialog?.hide();
        ToastUtil.show('修改位置失败。');
      }
    }, buildWhen: (pstate, cstate) {
      return cstate is BlogsLoadSuccess || cstate is BlogsLoadFailure;
    }, builder: (context, state) {
      if (state is BlogsLoadSuccess) {
        BlogEntity blogEntity = state.blogs
            .firstWhere((blog) => blog.id == widget.blogId, orElse: () => null);

        String categoryName = blogEntity?.categoryName;

        String date;
        if (blogEntity?.dueDate != null) {
          date = DateUtil.formatDateMs(blogEntity?.dueDate,
              format: 'yyyy年MM月dd日 HH:mm');
        }
        int id = blogEntity?.id;

        String labelName;
        if (blogEntity?.labelList != null) {
          labelName = blogEntity?.labelList?.join(',');
        }

        String deviceName = blogEntity?.deviceName;
        int favorite = blogEntity?.favorite;

        String locationName;
        if (blogEntity?.location != null) {
          locationName = blogEntity?.location?.name;
        }

        ThemeData theme = Theme.of(context);
        return Scaffold(
            appBar: AppBar(title: Text('属性')),
            body: blogEntity == null
                ? ResultView()
                : ListView(
                    children: <Widget>[
                      ListTile(
                        onTap: _updateLocation,
                        leading: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text('位置'),
                        subtitle: locationName == null
                            ? null
                            : Text(
                                locationName,
                                style: theme.textTheme.body2
                                    .copyWith(color: theme.primaryColor),
                              ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.wb_sunny,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text('天气'),
                      ),
                      Divider(
                        height: 30,
                        thickness: 30,
                      ),
                      ListTile(
                        onTap: () {
                          _updateDate(blogEntity.dueDate);
                        },
                        leading: Icon(
                          Icons.alarm,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text('日期'),
                        subtitle: date == null
                            ? null
                            : Text(
                                '$date',
                                style: theme.textTheme.body2
                                    .copyWith(color: theme.primaryColor),
                              ),
                      ),
                      ListTile(
                        onTap: _updateDevice,
                        leading: Icon(
                          Icons.devices,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text('设备'),
                        subtitle: deviceName == null
                            ? null
                            : Text(
                                deviceName,
                                style: theme.textTheme.body2
                                    .copyWith(color: theme.primaryColor),
                              ),
                      ),
                      Divider(
                        height: 30,
                        thickness: 30,
                      ),
                      ListTile(
                          onTap: _updateCategory,
                          leading: Icon(
                            Icons.book,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            '分类',
                          ),
                          subtitle: categoryName == null
                              ? null
                              : Text(
                                  categoryName,
                                  style: theme.textTheme.body2
                                      .copyWith(color: theme.primaryColor),
                                )),
                      ListTile(
                        onTap: () {
                          _updateLabels(blogEntity?.labelList);
                        },
                        leading: Icon(
                          Icons.label,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text('标签'),
                        subtitle: labelName == null || labelName.isEmpty
                            ? null
                            : Text(
                                labelName,
                                style: theme.textTheme.body2
                                    .copyWith(color: theme.primaryColor),
                              ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.note,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text('统计'),
                      ),
                      ListTile(
                        onTap: () {
                          BlocProvider.of<BlogsBloc>(context).add(
                              BlogFavoriteUpdated(
                                  blogEntity.id, favorite != 1 ? 1 : 0));
                        },
                        leading: Icon(
                          favorite == 1
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).errorColor,
                        ),
                        title: Text('收藏'),
                        subtitle: Text('${favorite == 1 ? "已标记为收藏" : "标记为收藏"}'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.link,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text('ID'),
                        subtitle: id == null ? null : Text('$id'),
                      ),
                      Divider(
                        height: 30,
                        thickness: 30,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.share,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text('分享'),
                      ),
                      ListTile(
                        onTap: () async {
                          var result = await DialogUtil.showAleartDialog(
                              context, '确定删除日记？');
                          if (result != null && result) {
                            BlocProvider.of<BlogsBloc>(context)
                                .add(BlogDeleted(id));
                            Navigator.of(context).pop(true);
                          }
                        },
                        leading: Icon(
                          Icons.close,
                          color: Theme.of(context).errorColor,
                        ),
                        title: Text('删除'),
                      ),
                    ],
                  ));
      } else {
        return ResultView();
      }
    });
  }

  _updateLocation() async {
    bool result = await DialogUtil.showAleartDialog(context, '确定要重新定位吗？');
    if (result) {
      BlocProvider.of<BlogsBloc>(context)
          .add(BlogLocationUpdated(widget.blogId));
    }
  }

  _updateDate(int saveTime) async {
    try {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(saveTime);
      int time = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            DateTime _dateTime = dateTime;
            return SimpleDialog(
              title: Text("日期"),
              children: <Widget>[
                DateListTile(
                  dateTime,
                  onChange: (value) {
                    _dateTime = DateTime(value.year, value.month, value.day,
                        _dateTime.hour, _dateTime.minute);
                  },
                ),
                TimeListTile(
                  dateTime,
                  onChange: (value) {
                    _dateTime = DateTime(_dateTime.year, _dateTime.month,
                        _dateTime.day, value.hour, value.minute);
                  },
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('取消')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(_dateTime.millisecondsSinceEpoch);
                        },
                        child: Text('确定'))
                  ],
                )
              ],
            );
          });

      if (time != null) {
        BlocProvider.of<BlogsBloc>(context)
            .add(BlogTimeUpdated(widget.blogId, time));
      }
    } catch (e) {
      ToastUtil.show('无法修改时间。');
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
      print('ssss  $activeLabels');
      BlocProvider.of<BlogsBloc>(context)
          .add(BlogLabelsUpdated(blogId: widget.blogId, labels: activeLabels));
    }
  }

  _updateDevice() async {
    bool result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('更新设备信息？'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('取消')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('确定'))
            ],
          );
        });

    if (result != null && result) {
      BlocProvider.of<BlogsBloc>(context).add(BlogDeviceUpdated(widget.blogId));
    }
  }
}
