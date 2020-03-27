import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/screens/search/search_result.dart';
import 'package:guohao/widgets/result.dart';

class BlogFavoritePage extends StatefulWidget {
  final int favorite;

  const BlogFavoritePage({Key key, this.favorite});

  @override
  _BlogFavoritePageState createState() => _BlogFavoritePageState();
}

class _BlogFavoritePageState extends State<BlogFavoritePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BlogsBloc>(context)
        .add(LoadBlogsByFavorite(widget.favorite));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogsBloc, BlogsState>(builder: (context, state) {
      if (state is BlogsLoadSuccess) {
        return Scaffold(
          appBar: AppBar(title: Text('收藏')),
          body: SearchResult(blogs: state.getBlogsByFavorite(widget.favorite)),
        );
      } else {
        return ResultView();
      }
    });
  }
}
