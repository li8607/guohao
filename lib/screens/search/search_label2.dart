import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/screens/search/search_result.dart';
import 'package:guohao/widgets/result.dart';

class SearchLabelPage extends StatefulWidget {
  final String label;

  const SearchLabelPage({Key key, this.label}) : super(key: key);

  @override
  _SearchLabelPageState createState() => _SearchLabelPageState();
}

class _SearchLabelPageState extends State<SearchLabelPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BlogsBloc>(context).add(LoadBlogsLabel(widget.label));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogsBloc, BlogsState>(builder: (context, state) {
      if (state is BlogsLoadSuccess) {
        return SearchResult(blogs: state.getBlogsByLabel(widget.label));
      } else {
        return ResultView();
      }
    });
  }
}
