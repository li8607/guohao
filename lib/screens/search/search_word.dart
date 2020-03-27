import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/widgets/result.dart';

import 'search_result.dart';

class SearchWordPage extends StatefulWidget {
  final String word;

  const SearchWordPage({Key key, this.word}) : super(key: key);
  @override
  _SearchWordPageState createState() => _SearchWordPageState();
}

class _SearchWordPageState extends State<SearchWordPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BlogsBloc>(context).add(LoadBlogsByWord(widget.word));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogsBloc, BlogsState>(builder: (context, state) {
      if (state is BlogsLoadSuccess) {
        return SearchResult(
          blogs: state.getBlogsByWord(widget.word),
        );
      } else {
        return ResultView();
      }
    });
  }
}
