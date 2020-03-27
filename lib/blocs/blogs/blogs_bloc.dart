import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:guohao/blocs/category/category_bloc.dart';
import 'package:guohao/blocs/category/category_state.dart';
import 'package:guohao/blocs/home/home_bloc.dart';
import 'package:guohao/blocs/label/label_bloc.dart';
import 'package:guohao/blocs/label/label_state.dart';
import 'package:guohao/blocs/location/bloc/location_bloc.dart';
import 'package:guohao/models/category.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/repositorys/blog/blog_repository.dart';
import 'package:guohao/repositorys/blog_label/blog_label_entity.dart';
import 'package:guohao/repositorys/blog_label/blog_label_repositorys.dart';
import 'package:guohao/repositorys/location/location_entity.dart';
import 'package:guohao/repositorys/location/location_repository.dart';
import 'package:guohao/repositorys/photo/photo_repository.dart';
import 'package:guohao/tools/device_utils.dart';
import 'package:guohao/tools/location_utils.dart';
import 'blogs_event.dart';
import 'blogs_state.dart';

class BlogsBloc extends Bloc<BlogsEvent, BlogsState> {
  final BlogRepository blogRepository;
  final HomeBloc homeBloc;
  final CategoryBloc categoryBloc;
  final BlogLabelRepository blogLabelRepository;
  final PhotoRepository photoRepository;
  final LocationRepository locationRepository;

  final LocationBloc locationBloc;

  final LabelBloc labelBloc;

  BlogsBloc copyWith(
      {BlogRepository blogRepository,
      HomeBloc homeBloc,
      CategoryBloc categoryBloc,
      BlogLabelRepository blogLabelRepository,
      PhotoRepository photoRepository,
      LocationBloc locationBloc,
      LabelBloc labelBloc}) {
    return BlogsBloc(
        blogRepository: blogRepository ?? this.blogRepository,
        homeBloc: homeBloc ?? this.homeBloc,
        categoryBloc: categoryBloc ?? this.categoryBloc,
        photoRepository: photoRepository ?? this.photoRepository,
        labelBloc: labelBloc ?? this.labelBloc,
        locationBloc: locationBloc ?? this.locationBloc,
        locationRepository: locationRepository ?? this.locationRepository,
        blogLabelRepository: blogLabelRepository ?? this.blogLabelRepository);
  }

  StreamSubscription categoryStreamSubscription;
  StreamSubscription labelStreamSubscription;
  BlogsBloc(
      {@required this.blogRepository,
      this.homeBloc,
      this.categoryBloc,
      this.blogLabelRepository,
      this.labelBloc,
      this.locationBloc,
      this.locationRepository,
      this.photoRepository}) {
    categoryStreamSubscription = categoryBloc?.listen((state) {
      if (state is CategoryLoaded) {
        Category category = state.currentCategory();
        add(LoadBlogs(category?.id));
      }
    });

    labelStreamSubscription = labelBloc?.listen((labelState) {
      if (labelState is LabelDeleteSuccess && state is BlogsLoadSuccess) {
        var currentState = state as BlogsLoadSuccess;
        add(LoadBlogs(currentState.categoryId));
      }
    });
  }

  @override
  Future<void> close() {
    categoryStreamSubscription?.cancel();
    labelStreamSubscription?.cancel();
    return super.close();
  }

  @override
  BlogsState get initialState => BlogLoading();

  @override
  Stream<BlogsState> mapEventToState(BlogsEvent event) async* {
    if (event is LoadBlogs) {
      yield* _mapLoadBlogsToState(event);
    } else if (event is BlogsRefreshed) {
      yield* _mapBlogsRefreshedToState(event);
    } else if (event is BlogDeleted) {
      yield* _mapBlogDeletedToState(event);
    } else if (event is BlogInserted) {
      yield* _mapBlogInsertedToState(event);
    } else if (event is BlogTitleUpdated) {
      yield* _mapBlogTitleUpdatedToState(event);
    } else if (event is BlogCategoryUpdated) {
      yield* _mapBlogCategoryUpdatedToState(event);
    } else if (event is BlogTimeUpdated) {
      yield* _mapBlogTimeUpdatedToState(event);
    } else if (event is BlogDeviceUpdated) {
      yield* _mapBlogDeviceUpdatedToState(event);
    } else if (event is BlogFavoriteUpdated) {
      yield* _mapBlogFavoriteUpdatedToState(event);
    } else if (event is BlogLocationUpdated) {
      yield* _mapBlogLocationUpdatedToState(event);
    } else if (event is LoadBlogsByTime) {
      yield* _mapLoadBlogsByTimeToState(event);
    } else if (event is LoadBlogsLabel) {
      yield* _mapLoadBlogsByLabelToState(event);
    } else if (event is BlogLabelsUpdated) {
      yield* _mapLoadBlogLabelsUpdatedToState(event);
    } else if (event is LoadBlogsByFavorite) {
      yield* _mapLoadBlogsByFavoriteToState(event);
    }
  }

  Stream<BlogsState> _mapLoadBlogsByFavoriteToState(
      LoadBlogsByFavorite event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        var currentState = state as BlogsLoadSuccess;
        yield BlogLoadByFavoriteInProgress();
        await Future.value(Duration(milliseconds: 400));
        yield BlogLoadByFavoriteSuccess();
        yield currentState.copyWith();
      }
    } catch (_) {
      yield BlogLoadByFavoriteFailure();
    }
  }

  Stream<BlogsState> _mapLoadBlogLabelsUpdatedToState(
      BlogLabelsUpdated event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        var currentState = state as BlogsLoadSuccess;
        yield BlogLabelsUpdateInProgress();
        await Future.value(Duration(milliseconds: 400));

        int blogId = event.blogId;

        List<String> labels = event.labels.map((value) => value.name).toList();
        List<BlogEntity> blogs = [];
        currentState.blogs.forEach((item) {
          if (item.id == blogId) {
            item.labelList = labels;
          }
          blogs.add(item);
        });
        await blogLabelRepository.batchDelete(blogId);
        await blogLabelRepository.batchInsert(event.labels
            .map((value) => BlogLabelEntity.create(blogId, value.id))
            .toList());

        yield BlogLabelsUpdateSuccess();
        yield currentState.copyWith(blogs: blogs);
      }
    } catch (_) {
      yield BlogLabelsUpdateFailure();
    }
  }

  Stream<BlogsState> _mapLoadBlogsByLabelToState(LoadBlogsLabel event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        var currentState = state as BlogsLoadSuccess;
        yield BlogLoadByLabelInProgress();
        await Future.value(Duration(milliseconds: 400));
        yield BlogLoadByLabelSuccess();
        yield currentState.copyWith();
      }
    } catch (_) {
      yield BlogLoadByLabelFailure();
    }
  }

  Stream<BlogsState> _mapLoadBlogsByTimeToState(LoadBlogsByTime event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        var currentState = state as BlogsLoadSuccess;
        await Future.value(Duration(milliseconds: 400));
        yield currentState.copyWith();
      }
    } catch (_) {
      yield BlogsLoadFailure(categoryBloc.getCategoryId());
    }
  }

  Stream<BlogsState> _mapBlogLocationUpdatedToState(
      BlogLocationUpdated event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        LocationEntity location = await LocationUtil.getLocation();

        int id = await locationRepository.getLocationId(location);
        location = location.copyWith(id: id);

        locationBloc?.add(LocationUpdated(location: location));

        final currentState = (state as BlogsLoadSuccess);
        List<BlogEntity> blogs = currentState.blogs.map((e) {
          if (e.id == event.blogId) {
            return e.copyWith(location: location);
          }
          return e;
        }).toList();

        yield BlogLocationUpdateInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        await blogRepository.updateLocation(event.blogId, location);
        yield BlogLocationUpdateSuccess();

        yield currentState.copyWith(blogs: blogs);
      }
    } catch (e) {
      yield BlogLocationUpdateFailure();
    }
  }

  Stream<BlogsState> _mapBlogFavoriteUpdatedToState(
      BlogFavoriteUpdated event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        final currentState = (state as BlogsLoadSuccess);
        List<BlogEntity> blogs = currentState.blogs.map((e) {
          if (e.id == event.blogId) {
            return e.copyWith(favorite: event.favorite);
          }
          return e;
        }).toList();

        yield BlogFavoriteUpdateInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        await blogRepository.updateFavorite(event.blogId, event.favorite);
        yield BlogFavoriteUpdateSuccess(favorite: event.favorite);
        yield currentState.copyWith(blogs: blogs);
      }
    } catch (e) {
      yield BlogFavoriteUpdateFailure();
    }
  }

  Stream<BlogsState> _mapBlogDeviceUpdatedToState(
      BlogDeviceUpdated event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        String deviceName = await DeviceUtil.getDeviceName();
        final currentState = (state as BlogsLoadSuccess);
        List<BlogEntity> blogs = currentState.blogs.map((e) {
          if (e.id == event.blogId) {
            return e.copyWith(deviceName: deviceName);
          }
          return e;
        }).toList();

        yield BlogDeviceUpdateInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        await blogRepository.updateDevice(event.blogId, deviceName);
        yield BlogDeviceUpdateSuccess();

        yield currentState.copyWith(blogs: blogs);
      }
    } catch (e) {
      yield BlogDeviceUpdateFailure();
    }
  }

  Stream<BlogsState> _mapBlogTimeUpdatedToState(BlogTimeUpdated event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        final currentState = (state as BlogsLoadSuccess);
        List<BlogEntity> blogs = currentState.blogs.map((e) {
          if (e.id == event.blogId) {
            return e.copyWith(dueDate: event.time);
          }
          return e;
        }).toList();

        yield BlogTimeUpdateInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        await blogRepository.updateTime(event.blogId, event.time);
        yield BlogTimeUpdateSuccess();
        blogs.sort((a, b) => (b.dueDate).compareTo(a.dueDate));
        yield currentState.copyWith(blogs: blogs);
      }
    } catch (e) {
      yield BlogTimeUpdateFailure();
    }
  }

  Stream<BlogsState> _mapBlogCategoryUpdatedToState(
      BlogCategoryUpdated event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        final currentState = (state as BlogsLoadSuccess);
        List<BlogEntity> blogs = currentState.blogs.map((e) {
          if (e.id == event.blogId) {
            return e.copyWith(
              categoryId: event.category.id,
              categoryName: event.category.name,
              categoryColor: event.category.colorValue,
            );
          }
          return e;
        }).toList();

        yield BlogCategoryUpdateInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        await blogRepository.updateCategory(event.blogId, event.category.id);
        yield BlogCategoryUpdateSuccess();
        yield currentState.copyWith(blogs: blogs);
      }
    } catch (e) {
      yield BlogCategoryUpdateFailure();
    }
  }

  Stream<BlogsState> _mapBlogTitleUpdatedToState(
      BlogTitleUpdated event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        final currentState = (state as BlogsLoadSuccess);
        var blogs = currentState.blogs.map((e) {
          if (e.id == event.blogId) {
            return e.copyWith(
                title: event.title,
                photos: event.photos ?? [],
                photoCreateTimes: []);
          }
          return e;
        }).toList();

        yield BlogTitleUpdateInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        await blogRepository.updateTitle(event.blogId, event.title);

        await photoRepository.labelDeleteToBlog(event.blogId);
        await photoRepository.photoAddToBlog(event.blogId, event.photos);

        yield BlogTitleUpdateSuccess();
        yield currentState.copyWith(blogs: blogs);
      }
    } catch (e) {
      yield BlogTitleUpdateFailure();
    }
  }

  Stream<BlogsState> _mapBlogInsertedToState(BlogInserted event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        final currentState = (state as BlogsLoadSuccess);
        int categoryId = currentState.categoryId;
        LocationEntity location = locationBloc?.getLocation();
        BlogEntity blogEntity = BlogEntity(
            categoryId: categoryId,
            deviceName: '设备名称',
            locationId: location?.id,
            location: location,
            dueDate: event.createTime != null
                ? event.createTime.millisecondsSinceEpoch
                : DateTime.now().millisecondsSinceEpoch);

        yield BlogInsertInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        int blodId = await blogRepository.insertOrReplace(blogEntity);
        print('bbbb   $blodId');
        yield BlogInsertSuccess(blogId: blodId);

        blogEntity.id = blodId;

        List<BlogEntity> blogs = List.from(currentState.blogs)
          ..insert(0, blogEntity);

        blogs.sort((a, b) => (b.dueDate).compareTo(a.dueDate));

        yield currentState.copyWith(blogs: blogs);
      }
    } catch (e) {
      yield BlogInsertFailure();
    }
  }

  Stream<BlogsState> _mapBlogDeletedToState(BlogDeleted event) async* {
    try {
      if (state is BlogsLoadSuccess) {
        BlogsLoadSuccess currentState = state;
        List<BlogEntity> blogs = [];
        currentState.blogs.forEach((value) {
          if (value.id != event.blogId) {
            blogs.add(value);
          }
        });
        yield BlogDeleteInProgress();
        await Future.delayed(Duration(milliseconds: 400));
        await blogRepository.deleteBlog(event.blogId);
        yield BlogDeleteSuccess();
        yield currentState.copyWith(blogs: blogs);
      }
    } catch (e) {
      yield BlogDeleteFailure();
    }
  }

  Stream<BlogsState> _mapBlogsRefreshedToState(BlogsRefreshed event) async* {
    int categoryId;
    try {
      if (state is BlogsLoadSuccess) {
        categoryId = (state as BlogsLoadSuccess).categoryId;
      } else if (state is BlogsLoadFailure) {
        categoryId = (state as BlogsLoadFailure).categoryId;
      }

      yield BlogsLoadInProgress();
      if (categoryId == null) {
        yield BlogsLoadFailure(categoryId);
        return;
      }
      final blogs = await blogRepository.loadBlogs(categoryId);

      yield BlogsLoadSuccess(categoryId: categoryId, blogs: blogs);
    } catch (_) {
      yield BlogsLoadFailure(categoryId);
    }
  }

  Stream<BlogsState> _mapLoadBlogsToState(LoadBlogs event) async* {
    try {
      if (event.categoryId == null) {
        yield BlogsLoadFailure(event.categoryId);
        return;
      }
      final blogs = await blogRepository.loadBlogs(event.categoryId);
      yield BlogsLoadSuccess(categoryId: event.categoryId, blogs: blogs);
    } catch (_) {
      yield BlogsLoadFailure(event.categoryId);
    }
  }
}
