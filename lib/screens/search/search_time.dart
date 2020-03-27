import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/widgets/result.dart';

import 'search_result.dart';

class SearchTime extends StatefulWidget {
  final DateTime dateTime;

  SearchTime({Key key, this.dateTime}) : super(key: key);

  @override
  _SearchTimeState createState() => _SearchTimeState();
}

class _SearchTimeState extends State<SearchTime> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogsBloc, BlogsState>(builder: (context, state) {
      if (state is BlogsLoadSuccess) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
                '${DateUtil.formatDate(widget.dateTime, format: "yyyy年MM月dd日")}'),
          ),
          body: SearchResult(
            blogs: state.getBlogsFromDayTime(widget.dateTime),
          ),
        );
      } else {
        return ResultView();
      }
    });
  }
}
