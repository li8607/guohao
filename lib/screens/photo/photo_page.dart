import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/widgets/result.dart';

import 'photo_list.dart';

class PhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogsBloc, BlogsState>(builder: (context, state) {
      if (state is BlogsLoadSuccess) {
        return PhotoListView(
          blogs: state.getBlogsHasPhoto(),
        );
      } else {
        return ResultView();
      }
    });
  }
}
