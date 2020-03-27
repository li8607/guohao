import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/tools/toast.dart';
import 'package:guohao/widgets/loading.dart';
import 'package:guohao/widgets/result.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'add_blog.dart';
import 'scroll_widget.dart';

class BlogListPage extends StatefulWidget {
  BlogListPage({Key key}) : super(key: key);

  @override
  _BlogListPageState createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  Settings _settings = Settings();

  ProgressDialog loadDialog;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<BlogsBloc, BlogsState>(listener: (context, state) {
      if (state is BlogInsertInProgress) {
        if (loadDialog == null) {
          loadDialog = new ProgressDialog(context);
        }
        loadDialog.update(message: '正在初始化数据');
        loadDialog.show();
      } else if (state is BlogInsertFailure) {
        loadDialog?.hide();
      } else if (state is BlogInsertSuccess) {
        loadDialog?.hide();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddBlogPage(
            blogId: state.blogId,
          );
        }));
      } else if (state is BlogDeleteInProgress) {
        if (loadDialog == null) {
          loadDialog = new ProgressDialog(context);
        }
        loadDialog.update(message: '正在删除数据');
        loadDialog.show();
      } else if (state is BlogDeleteSuccess) {
        loadDialog?.hide();
        ToastUtil.show('删除成功');
      } else if (state is BlogDeleteFailure) {
        loadDialog?.hide();
        ToastUtil.show('删除失败');
      }
    }, buildWhen: (pstate, cstate) {
      return cstate is BlogsLoadSuccess ||
          cstate is BlogsLoadFailure ||
          cstate is BlogsLoadInProgress;
    }, builder: (context, state) {
      if (state is BlogsLoadInProgress) {
        return Scaffold(body: LoadingView());
      } else if (state is BlogsLoadSuccess) {
        return ScrollWidget(
          settings: _settings,
          scrollController: _scrollController,
          mapBlogs: state.mapBlogs(),
        );
      } else {
        return Scaffold(
          body: ResultView(),
        );
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
