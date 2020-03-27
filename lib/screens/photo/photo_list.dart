import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/repositorys/photo/photo_repository.dart';
import 'package:guohao/screens/blog/add_blog.dart';

class PhotoListView extends StatelessWidget {
  final List<BlogEntity> blogs;

  const PhotoListView({Key key, this.blogs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PhotoItem> list = [];
    try {
      for (var blog in blogs) {
        for (var i = 0; i < blog.photos.length; i++) {
          list.add(PhotoItem(
            blogId: blog.id,
            photo: blog.photos[i],
            // createTime: blog.photoCreateTimes[i]
          ));
        }
      }
    } catch (e) {
      print('bbb   $e');
    }

    return Container(
      child: GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8),
          itemBuilder: (context, index) {
            PhotoItem photo = list[index];
            return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddBlogPage(blogId: photo.blogId);
                  }));
                },
                child: FutureBuilder(
                    initialData: null,
                    future: PhotoRepository.get()
                        .getPhotoFromIdentifier(photo.photo),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return SizedBox();
                      } else {
                        return Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.memory(
                                    snapshot.data,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )),
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(4),
                                          bottomRight: Radius.circular(4))),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            '${DateUtil.formatDateMs(photo.createTime, format: "dd日")}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2
                                                .copyWith(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                        SizedBox(height: 4),
                                        Text(
                                          '${DateUtil.formatDateMs(photo.createTime, format: "yyyy年MM月")}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .body2
                                              .copyWith(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                        ),
                                        SizedBox(height: 4),
                                      ]))
                            ]);
                      }
                    }));
          }),
    );
  }
}

class PhotoItem {
  final String photo;
  final int createTime;
  final int blogId;

  PhotoItem({this.photo, this.createTime, this.blogId});
}
