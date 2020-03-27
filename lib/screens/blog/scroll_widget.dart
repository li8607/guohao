import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/tools/dialog.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';

import 'add_blog.dart';
import 'blog_list_tile.dart';

class ScrollWidget extends StatelessWidget {
  final ScrollController scrollController;
  final Settings settings;
  final Map<int, List<BlogEntity>> mapBlogs;

  const ScrollWidget(
      {Key key, this.scrollController, this.settings, this.mapBlogs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfiniteList(
        key: Key(settings.scrollDirection.toString()),
        scrollDirection: settings.scrollDirection,
        anchor: settings.anchor,
        controller: scrollController,
        direction: settings.multiDirection
            ? InfiniteListDirection.multi
            : InfiniteListDirection.single,
        minChildCount: mapBlogs == null ? 0 : mapBlogs.length,
        maxChildCount: mapBlogs == null ? 0 : mapBlogs.length,
        builder: (context, index) {
          List<BlogEntity> list = mapBlogs.values.toList()[index];
          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              mapBlogs.keys.toList()[index]);
          String month = DateUtil.formatDateMs(mapBlogs.keys.toList()[index],
              format: "MM月");
          return InfiniteListItem(
            headerAlignment: settings.alignment,
            headerStateBuilder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .primaryColor
                      .withOpacity(1 - state.position),
                ),
                height: 70,
                width: 70,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      date.day.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 21),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      month ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 17, height: .7),
                    )
                  ],
                ),
              );
            },
            contentBuilder: (context) => Container(
              margin: settings.contentMargin,
              width: settings.contentWidth,
              child: Column(
                children: list.map((e) {
                  return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: BlogListTile(
                        blog: e,
                      ));
                }).toList(),
              ),
            ),
            minOffsetProvider: (state) => 80,
          );
        });
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

  // _buildItemCard(
  //   BuildContext context,
  //   BlogEntity blogEntity,
  //   int index,
  // ) {
  //   return Card(
  //       margin: index == 0 ? null : const EdgeInsets.only(top: 8),
  //       child: InkWell(
  //           onTap: () {
  //             openAddPage(context, blogEntity);
  //           },
  //           child: Container(
  //               height: 100,
  //               child: BlogListTile(
  //                 blogEntity: blogEntity,
  //               ))));
  // }

  openAddPage(BuildContext context, BlogEntity blogEntity) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddBlogPage(blogId: blogEntity.id);
    }));
  }
}

class BlogEntityGroupByDay {
  final List<BlogEntity> list;
  final DateTime day;
  BlogEntityGroupByDay(this.list, this.day);
}

class Settings {
  int minCount;
  int maxCount;
  bool multiDirection;
  HeaderAlignment alignment;
  double anchor;
  Axis scrollDirection;

  bool get scrollVertical => scrollDirection == Axis.vertical;

  double get contentHeight {
    if (scrollVertical) {
      return 300;
    }

    return double.infinity;
  }

  double get contentWidth {
    if (scrollVertical) {
      return double.infinity;
    }

    return 300;
  }

  EdgeInsets get contentMargin {
    if (scrollVertical) {
      if ([HeaderAlignment.topRight, HeaderAlignment.bottomRight]
          .contains(this.alignment)) {
        return EdgeInsets.only(
          left: 10,
          top: 5,
          bottom: 5,
          right: 90,
        );
      }

      return EdgeInsets.only(
        left: 90,
        right: 10,
      );
    }

    if ([HeaderAlignment.topRight, HeaderAlignment.topLeft]
        .contains(this.alignment)) {
      return EdgeInsets.only(
        left: 5,
        top: 90,
        bottom: 10,
        right: 5,
      );
    }

    return EdgeInsets.only(
      left: 5,
      bottom: 90,
      top: 10,
      right: 5,
    );
  }

  Settings({
    this.minCount,
    this.maxCount,
    this.alignment = HeaderAlignment.topLeft,
    this.multiDirection = false,
    this.anchor = 0,
    this.scrollDirection = Axis.vertical,
  });
}

// class BlogListTile extends StatelessWidget {
//   final BlogEntity blogEntity;

//   BlogListTile({Key key, this.blogEntity}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String title;
//     try {
//       NotusDocument document =
//           NotusDocument.fromDelta(Delta.fromJson(jsonDecode(blogEntity.title)));
//       title = document.toPlainText();
//     } catch (e) {
//       title = blogEntity.title;
//     }
//     return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Expanded(
//             flex: 1,
//             child: ClipRRect(
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
//               child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 1),
//                   child: Image.network(
//                     'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
//                     height: double.infinity,
//                     fit: BoxFit.fitHeight,
//                   )),
//             ),
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Expanded(
//               flex: 2,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     title ?? "",
//                     maxLines: 3,
//                     style: Theme.of(context)
//                         .textTheme
//                         .body1
//                         .copyWith(fontSize: 16),
//                   ),
//                   Expanded(child: SizedBox()),
//                   Text(
//                     getBottomText(blogEntity),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   )
//                 ],
//               )),
//           SizedBox(
//             width: 8,
//           ),
//         ]);
//   }

//   String getBottomText(BlogEntity blogEntity) {
//     String time;
//     if (blogEntity.dueDate != null) {
//       time = DateUtil.formatDateMs(blogEntity.dueDate, format: 'HH:mm');
//     }
//     String location;
//     if (blogEntity.location != null) {
//       location = blogEntity.location.name;
//     }
//     String label;
//     if (blogEntity.labelList != null) {
//       label = blogEntity.labelList.join(',');
//     }
//     String text = "";
//     if (label != null) {
//       text = text + label + "·";
//     }

//     if (time != null) {
//       text = text + time + "·";
//     }

//     if (location != null) {
//       text = text + location + "·";
//     }
//     return text;
//   }
// }
