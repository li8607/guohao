import 'package:equatable/equatable.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';

class BlogsState extends Equatable {
  @override
  List<Object> get props => [];
}

class BlogLoading extends BlogsState {}

class BlogLoaded extends BlogsState {
  final BlogEntity blog;

  BlogLoaded(this.blog);

  @override
  List<Object> get props => [blog];
}

class BlogAdding extends BlogsState {
  BlogAdding();

  @override
  List<Object> get props => [];
}

class BlogAddCompleted extends BlogsState {
  BlogAddCompleted();

  @override
  List<Object> get props => [];
}

class BlogsLoadSuccess extends BlogsState {
  final int categoryId;
  final List<BlogEntity> blogs;

  BlogsLoadSuccess({this.categoryId, this.blogs});

  Map<int, List<BlogEntity>> mapBlogs() {
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

  List<BlogEntity> getBlogsFromDayTime(DateTime time) {
    try {
      int startDate = DateTime(time.year, time.month, time.day, 0, 0)
          .millisecondsSinceEpoch;
      int endDate = DateTime(time.year, time.month, time.day, 23, 59, 59)
          .millisecondsSinceEpoch;

      List<BlogEntity> blogsFromTime = [];
      for (var item in blogs) {
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(item.dueDate);

        if (dateTime.millisecondsSinceEpoch >= startDate &&
            dateTime.millisecondsSinceEpoch <= endDate) {
          blogsFromTime.add(item);
        }
      }

      return blogsFromTime;
    } catch (e) {
      return null;
    }
  }

  List<BlogEntity> getBlogsByWord(String word) {
    try {
      List<BlogEntity> blogsByWord = [];
      for (var item in blogs) {
        if (item.title.contains(word)) {
          blogsByWord.add(item);
        }
      }
      return blogsByWord;
    } catch (e) {
      return null;
    }
  }

  List<BlogEntity> getBlogsHasPhoto() {
    try {
      List<BlogEntity> blogsHasPhoto = [];
      for (var item in blogs) {
        if (item.photos != null && item.photos.length > 0) {
          blogsHasPhoto.add(item.copyWith());
        }
      }
      return blogsHasPhoto;
    } catch (e) {
      return null;
    }
  }

  List<BlogEntity> getBlogsHasLocation() {
    try {
      List<BlogEntity> blogsHasLocation = [];
      for (var item in blogs) {
        if (item.location != null) {
          blogsHasLocation.add(item.copyWith());
        }
      }
      return blogsHasLocation;
    } catch (e) {
      return null;
    }
  }

  List<BlogEntity> getBlogsByLabel(String label) {
    try {
      List<BlogEntity> blogsByLabel = [];
      for (var item in blogs) {
        if (item.labelList != null && item.labelList.contains(label)) {
          blogsByLabel.add(item);
        }
      }
      return blogsByLabel;
    } catch (e) {
      return null;
    }
  }

  List<BlogEntity> getBlogsByLocation(int locaitonId) {
    try {
      List<BlogEntity> blogsByLocation = [];
      for (var item in blogs) {
        if (locaitonId != null && item.locationId == locaitonId) {
          blogsByLocation.add(item);
        }
      }
      return blogsByLocation;
    } catch (e) {
      return null;
    }
  }

  List<BlogEntity> getBlogsByFavorite(int favorite) {
    try {
      List<BlogEntity> blogsByFavorite = [];
      for (var item in blogs) {
        if (item.favorite == favorite) {
          blogsByFavorite.add(item);
        }
      }
      return blogsByFavorite;
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object> get props => [categoryId, blogs];

  @override
  String toString() {
    return 'BlogsLoadSuccess {categoryId : $categoryId}';
  }

  BlogsLoadSuccess copyWith({int categoryId, List<BlogEntity> blogs}) {
    return BlogsLoadSuccess(
        categoryId: categoryId ?? this.categoryId, blogs: blogs ?? this.blogs);
  }
}

class BlogsLoadFailure extends BlogsState {
  final int categoryId;
  BlogsLoadFailure(this.categoryId);

  @override
  String toString() {
    return 'BlogsLoadFailure {categoryId : $categoryId}';
  }
}

class BlogsLoadInProgress extends BlogsState {}

class BlogDeleteInProgress extends BlogsState {}

class BlogDeleteSuccess extends BlogsState {}

class BlogDeleteFailure extends BlogsState {}

class BlogInsertInProgress extends BlogsState {}

class BlogInsertFailure extends BlogsState {}

class BlogInsertSuccess extends BlogsState {
  final int blogId;

  BlogInsertSuccess({this.blogId});

  @override
  List<Object> get props => [blogId];

  @override
  String toString() {
    return 'BlogInsertSuccess';
  }
}

class BlogTitleUpdateInProgress extends BlogsState {}

class BlogTitleUpdateFailure extends BlogsState {}

class BlogTitleUpdateSuccess extends BlogsState {}

class BlogCategoryUpdateInProgress extends BlogsState {}

class BlogCategoryUpdateFailure extends BlogsState {}

class BlogCategoryUpdateSuccess extends BlogsState {}

class BlogTimeUpdateInProgress extends BlogsState {}

class BlogTimeUpdateFailure extends BlogsState {}

class BlogTimeUpdateSuccess extends BlogsState {}

class BlogDeviceUpdateInProgress extends BlogsState {}

class BlogDeviceUpdateFailure extends BlogsState {}

class BlogDeviceUpdateSuccess extends BlogsState {}

class BlogFavoriteUpdateInProgress extends BlogsState {}

class BlogFavoriteUpdateFailure extends BlogsState {}

class BlogFavoriteUpdateSuccess extends BlogsState {
  final int favorite;

  BlogFavoriteUpdateSuccess({this.favorite});

  @override
  List<Object> get props => [favorite];
}

class BlogLocationUpdateInProgress extends BlogsState {}

class BlogLocationUpdateFailure extends BlogsState {}

class BlogLocationUpdateSuccess extends BlogsState {}

class BlogLoadByLabelInProgress extends BlogsState {}

class BlogLoadByLabelFailure extends BlogsState {}

class BlogLoadByLabelSuccess extends BlogsState {}

class BlogLabelsUpdateInProgress extends BlogsState {}

class BlogLabelsUpdateFailure extends BlogsState {}

class BlogLabelsUpdateSuccess extends BlogsState {}

class BlogLoadByFavoriteInProgress extends BlogsState {}

class BlogLoadByFavoriteFailure extends BlogsState {}

class BlogLoadByFavoriteSuccess extends BlogsState {}
