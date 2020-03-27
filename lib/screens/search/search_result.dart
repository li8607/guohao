import 'package:flutter/material.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/screens/blog/scroll_widget.dart';

class SearchResult extends StatelessWidget {
  final List<BlogEntity> blogs;

  const SearchResult({Key key, this.blogs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    Settings _settings = Settings();
    return ScrollWidget(
      settings: _settings,
      scrollController: _scrollController,
      mapBlogs: mapBlogsFromList(blogs),
    );
  }

  Map<int, List<BlogEntity>> mapBlogsFromList(List<BlogEntity> blogs) {
    Map<int, List<BlogEntity>> mapBlogs = {};
    try {
      for (var item in blogs) {
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(item.dueDate);
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
        int time = dateTime.millisecondsSinceEpoch;
        if (mapBlogs.containsKey(time)) {
          mapBlogs[time].add(item);
        } else {
          mapBlogs[time] = [];
          mapBlogs[time].add(item);
        }
      }
    } catch (e) {}
    return mapBlogs;
  }
}
