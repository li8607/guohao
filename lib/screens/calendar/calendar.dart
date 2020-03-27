import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/repositorys/blog/blog_repository.dart';
import 'package:guohao/screens/blog/add_blog.dart';
import 'package:guohao/screens/search/search_time.dart';
import 'package:guohao/styles/styles.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CalendarPage extends StatefulWidget {
  final InfiniteScrollController controller;

  const CalendarPage({Key key, this.controller}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  ProgressDialog loadDialog;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogsBloc, BlogsState>(listener: (context, state) {
      // if (state is BlogInsertSuccess) {
      //   loadDialog?.hide();
      //   Navigator.push(context, MaterialPageRoute(builder: (context) {
      //     return AddBlogPage(
      //       blogId: state.blogId,
      //     );
      //   }));
      // } else if (state is BlogInsertInProgress) {
      //   loadDialog = new ProgressDialog(context);
      //   loadDialog.update(message: '正在初始化数据');
      //   loadDialog.show();
      // } else if (state is BlogInsertFailure) {
      //   loadDialog?.hide();
      // }
    }, builder: (context, state) {
      List<BlogEntity> list = [];
      if (state is BlogsLoadSuccess) {
        list = state.blogs ?? [];
      }
      zero = true;
      return _buildChild(list
              .map(
                  (value) => DateTime.fromMillisecondsSinceEpoch(value.dueDate))
              .toList() ??
          []);
    });
  }

  DateTime _dateTime;
  bool zero = true;
  InfiniteScrollController _infiniteController;
  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _infiniteController = widget.controller;
  }

  Widget _buildChild(List<DateTime> list) {
    return InfiniteListView.separated(
      controller: _infiniteController,
      itemBuilder: (BuildContext context, int index) {
        DateTime dateTime = DateTime(_dateTime.year, _dateTime.month + index);
        return _buildMonth(dateTime, list);
      },
      separatorBuilder: (BuildContext context, int index) {
        if (index == 0) {
          if (!zero) {
            index += 1;
          }
          zero = false;
        } else if (index > 0) {
          index += 1;
        }
        DateTime dateTime = DateTime(_dateTime.year, _dateTime.month + index);
        String text = DateUtil.formatDate(dateTime, format: 'yyyy年MM月');
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.centerLeft,
            color: kCalendarBackgroundColor,
            padding: const EdgeInsets.all(8),
            child: Text(
              text,
              style: calendarPrimaryText,
            ));
      },
      anchor: 0.5,
    );
  }

  _buildMonth(DateTime dateTime, List<DateTime> blogDateTimes) {
    int week = dateTime.weekday - 1;
    int count = DateTime(dateTime.year, dateTime.month + 1, 0).day;
    count += week;
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: count,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            childAspectRatio: 1.0),
        itemBuilder: (context, index) {
          int day = index - week + 1;
          DateTime time = blogDateTimes.firstWhere((value) {
            return value.year == dateTime.year &&
                value.month == dateTime.month &&
                value.day == day;
          }, orElse: () => null);
          return PopupMenuButton(
              child: _buildDay(day, time != null),
              onSelected: (String value) {
                showMenuSelection(
                    value,
                    DateTime(dateTime.year, dateTime.month, day,
                        DateTime.now().hour, DateTime.now().minute));
              },
              itemBuilder: (context) {
                return <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Container(
                        child: Text(
                      '${DateUtil.formatDate(DateTime(dateTime.year, dateTime.month, day), format: "yyyy年MM月dd日")}',
                      style: calendarPrimaryText,
                    )),
                  ),
                  if (time != null)
                    PopupMenuItem<String>(
                      value: 'look',
                      child: Text('查看日记'),
                    ),
                  PopupMenuItem<String>(
                    value: 'create',
                    child: Text('添加日记'),
                  ),
                ];
              });
        });
  }

  void showMenuSelection(String value, DateTime dayTime) {
    if (value == 'create') {
      BlocProvider.of<BlogsBloc>(context)
          .add(BlogInserted(createTime: dayTime));
    } else if (value == 'look') {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SearchTime(
          dateTime: dayTime,
        );
      }));
    }
  }

  _buildDay(int day, bool selector) {
    if (day <= 0) {
      return SizedBox();
    }
    return Container(
      decoration: BoxDecoration(
          color: selector
              ? Theme.of(context).primaryColor
              : kCalendarBackgroundColor,
          borderRadius: BorderRadius.circular(4)),
      alignment: Alignment.center,
      child: Text(
        '$day',
        style: calendarSecondaryText.copyWith(
          color: selector ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}
