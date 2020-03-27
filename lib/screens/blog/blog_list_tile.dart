import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/screens/blog/blog_detail.dart';
import 'package:guohao/styles/styles.dart';
import 'package:guohao/tools/dialog.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';

import 'add_blog.dart';

class BlogListTile extends StatefulWidget {
  final BlogEntity blog;

  const BlogListTile({Key key, this.blog}) : super(key: key);

  @override
  _BlogListTileState createState() => _BlogListTileState();
}

class _BlogListTileState extends State<BlogListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dismissible(
          key: ObjectKey(widget.blog),
          direction: DismissDirection.endToStart,
          background: Container(
            child: const Center(
              child: ListTile(
                trailing: Icon(Icons.delete, color: Colors.red, size: 36.0),
              ),
            ),
          ),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart)
              _handleDelete(context, widget.blog);
          },
          confirmDismiss: (DismissDirection dismissDirection) async {
            return await _confirmDismiss(context, dismissDirection);
          },
          child: Card(
              margin: EdgeInsets.zero,
              child: InkWell(
                  onTap: () {
                    openAddPage(context, widget.blog);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      child: _buildChild(widget.blog))))),
    );
  }

  openAddPage(BuildContext context, BlogEntity blogEntity) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlogDetailPage(blogId: blogEntity.id);
    }));
  }

  _handleDelete(BuildContext context, BlogEntity blogEntity) {
    BlocProvider.of<BlogsBloc>(context).add(BlogDeleted(blogEntity?.id));
  }

  _confirmDismiss(
      BuildContext context, DismissDirection dismissDirection) async {
    switch (dismissDirection) {
      case DismissDirection.endToStart:
        return await DialogUtil.showAleartDialog(context, '确定删除日记？');
      case DismissDirection.startToEnd:
      case DismissDirection.horizontal:
      case DismissDirection.vertical:
      case DismissDirection.up:
      case DismissDirection.down:
        assert(false);
    }
    return false;
  }

  Widget _buildChild(BlogEntity blogEntity) {
    String title;
    try {
      NotusDocument document =
          NotusDocument.fromDelta(Delta.fromJson(jsonDecode(blogEntity.title)));
      title = document.toPlainText();
    } catch (e) {
      title = blogEntity.title;
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? "",
            maxLines: 5,
            style: blogCardPrimaryText.copyWith(wordSpacing: 1.2),
          ),
          SizedBox(height: 8),
          Container(
              height: 80,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
                    ),
                  ),
                ],
              )),
          SizedBox(height: 8),
          Text(
            getBottomText(blogEntity),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: blogCardSecondaryText,
          ),
        ]);
  }

  String getBottomText(BlogEntity blogEntity) {
    String time;
    if (blogEntity.dueDate != null) {
      time = DateUtil.formatDateMs(blogEntity.dueDate, format: 'HH:mm');
    }
    String location;
    if (blogEntity.location != null) {
      location = blogEntity.location.name;
    }
    String label;
    if (blogEntity.labelList != null) {
      label = blogEntity.labelList.join(',');
    }
    String text = "";
    if (label != null) {
      text = text + label + "·";
    }

    if (time != null) {
      text = text + time + "·";
    }

    if (location != null) {
      text = text + location + "·";
    }
    return text;
  }
}
