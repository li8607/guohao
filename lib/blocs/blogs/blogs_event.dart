import 'package:equatable/equatable.dart';
import 'package:guohao/models/category.dart';
import 'package:guohao/repositorys/label/label_entity.dart';

class BlogsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadBlogs extends BlogsEvent {
  final int categoryId;
  LoadBlogs(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class BlogsRefreshed extends BlogsEvent {
  @override
  String toString() {
    return 'BlogsRefreshed';
  }
}

class BlogDeleted extends BlogsEvent {
  final int blogId;
  BlogDeleted(this.blogId);
}

class BlogTitleUpdated extends BlogsEvent {
  final int blogId;
  final String title;
  final List<String> photos;
  BlogTitleUpdated(this.blogId, this.title, this.photos);

  @override
  List<Object> get props => [blogId, title, photos];

  @override
  String toString() {
    return 'BlogTitleUpdated';
  }
}

class BlogCategoryUpdated extends BlogsEvent {
  final int blogId;
  final Category category;
  BlogCategoryUpdated(this.blogId, this.category);

  @override
  List<Object> get props => [blogId, category];

  @override
  String toString() {
    return 'BlogCategoryUpdated';
  }
}

class BlogTimeUpdated extends BlogsEvent {
  final int blogId;
  final int time;

  BlogTimeUpdated(this.blogId, this.time);

  @override
  List<Object> get props => [blogId, time];

  @override
  String toString() {
    return 'BlogTimeUpdated';
  }
}

class BlogDeviceUpdated extends BlogsEvent {
  final int blogId;

  BlogDeviceUpdated(this.blogId);

  @override
  List<Object> get props => [blogId];

  @override
  String toString() {
    return 'BlogDeviceUpdated';
  }
}

class BlogLocationUpdated extends BlogsEvent {
  final int blogId;

  BlogLocationUpdated(this.blogId);

  @override
  List<Object> get props => [blogId];

  @override
  String toString() {
    return 'BlogLocationUpdated';
  }
}

class BlogFavoriteUpdated extends BlogsEvent {
  final int blogId;
  final int favorite;

  BlogFavoriteUpdated(this.blogId, this.favorite);

  @override
  List<Object> get props => [blogId, favorite];

  @override
  String toString() {
    return 'BlogFavoriteUpdated {blogId : $blogId, favorite : $favorite}';
  }
}

class BlogInserted extends BlogsEvent {
  final DateTime createTime;

  BlogInserted({this.createTime});

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'BlogInserted';
  }
}

class LoadBlogsByTime extends BlogsEvent {
  final DateTime dateTime;
  LoadBlogsByTime(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class LoadBlogsByWord extends BlogsEvent {
  final String word;
  LoadBlogsByWord(this.word);

  @override
  List<Object> get props => [word];
}

class LoadBlogsLabel extends BlogsEvent {
  final String label;
  LoadBlogsLabel(this.label);

  @override
  List<Object> get props => [label];
}

class LoadBlogsByFavorite extends BlogsEvent {
  final int favorite;
  LoadBlogsByFavorite(this.favorite);

  @override
  List<Object> get props => [favorite];
}

class BlogLabelsUpdated extends BlogsEvent {
  final int blogId;
  final List<LabelEntity> labels;

  BlogLabelsUpdated({this.blogId, this.labels});

  @override
  List<Object> get props => [blogId, labels];

  @override
  String toString() {
    return 'BlogLabelsUpdated';
  }
}
