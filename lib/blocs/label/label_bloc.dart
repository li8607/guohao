import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/home/home_bloc.dart';
import 'package:guohao/blocs/home/home_state.dart';
import 'package:guohao/blocs/label/label_event.dart';
import 'package:guohao/blocs/label/label_state.dart';
import 'package:guohao/models/label.dart';
import 'package:guohao/repositorys/blog_label/blog_label_entity.dart';
import 'package:guohao/repositorys/label/label_repository.dart';
import 'package:guohao/repositorys/label/label_entity.dart';

class LabelBloc extends Bloc<LabelEvent, LabelState> {
  BlogsBloc blogBloc;
  LabelRepository labelRepository;
  HomeBloc homeBloc;
  StreamSubscription streamSubscription;

  LabelBloc({this.blogBloc, this.labelRepository, this.homeBloc}) {
    streamSubscription = homeBloc?.listen((state) {
      if (state is AppStartSuccess) {
        add(LabelsLoaded());
      }
    });
  }

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }

  @override
  LabelState get initialState => LabelLoadedInitial();

  @override
  Stream<LabelState> mapEventToState(LabelEvent event) async* {
    if (event is LabelsLoaded) {
      yield* _mapLabelsLoadedToState();
    } else if (event is LabelLoaded) {
      yield* _mapBlogLoadedToState(event);
    } else if (event is LabelInserted) {
      yield* _mapLabelInsertedToState(event);
    } else if (event is BlogLabelInserted) {
      yield* _mapBlogLabelInsertedToState(event);
    } else if (event is BlogLabelDeleted) {
      yield* _mapBlogLabelDeletedToState(event);
    } else if (event is LabelsRefreshed) {
      yield* _mapLabelsRefreshedToState();
    } else if (event is LabelDeleted) {
      yield* _mapLabelDeletedToState(event);
    }
  }

  Stream<LabelState> _mapLabelsLoadedToState() async* {
    try {
      yield LabelLoadedInProgress();
      await Future.value(Duration(milliseconds: 300));
      List<LabelEntity> labelEntitys = await labelRepository.loadLabels();
      yield LabelLoadedSuccess(labels: labelEntitys);
    } catch (e) {
      yield LabelLoadedFailure();
    }
  }

  Stream<LabelState> _mapLabelsRefreshedToState() async* {
    // try {
    //   int blogId = blogBloc?.getBlogID();
    //   List<LabelEntity> labelEntitys = await labelRepository.loadLabels();
    //   List<LabelEntity> selectors =
    //       await labelRepository.loadLabelsByBlogId(blogId);
    //   yield LabelLoadedSuccess(labelEntitys, selectors, blogId);
    // } catch (e) {
    //   yield LabelLoadedFailure();
    // }
  }

  Stream<LabelState> _mapBlogLabelDeletedToState(
      BlogLabelDeleted event) async* {
    try {
      yield BlogLabelDeleteInProgress();
      await labelRepository.labelDeleteToBlog(
          BlogLabelEntity.create(event.blogId, event.label.id));
      yield BlogLabelDeleteSuccess();
      add(LabelsRefreshed());
      // blogBloc?.add(BlogRefreshed());
    } catch (e) {
      yield BlogLabelDeleteFailure();
    }
  }

  Stream<LabelState> _mapLabelDeletedToState(LabelDeleted event) async* {
    try {
      if (state is LabelLoadedSuccess) {
        var currentState = state as LabelLoadedSuccess;

        List<LabelEntity> labels = [];
        currentState.labels.forEach((item) {
          if (item.id != event.labelId) {
            labels.add(item);
          }
        });

        yield LabelDeleteInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        await labelRepository.deleteLabel(event.labelId);
        yield LabelDeleteSuccess();
        yield currentState.copyWith(labels: labels);
      }
    } catch (e) {
      yield LabelDeleteFailure();
    }
  }

  Stream<LabelState> _mapBlogLabelInsertedToState(
      BlogLabelInserted event) async* {
    try {
      yield BlogLabelInsertInProgress();
      await labelRepository
          .labelAddToBlog(BlogLabelEntity.create(event.blogId, event.label.id));
      yield BlogLabelInsertSuccess();
      add(LabelsRefreshed());
      // blogBloc?.add(BlogRefreshed());
    } catch (e) {
      yield BlogLabelInsertFailure();
    }
  }

  Stream<LabelState> _mapLabelInsertedToState(LabelInserted event) async* {
    try {
      if (state is LabelLoadedSuccess) {
        var currentState = state as LabelLoadedSuccess;

        LabelEntity labelEntity = currentState.labels.firstWhere((value) {
          return value.name == event.label;
        }, orElse: () => null);

        if (labelEntity != null) {
          throw ArgumentError('${event.label}"已存在');
        }

        yield LabelInsertInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        labelEntity = LabelEntity.create(event.label, 0, '');
        
        int labelId = await labelRepository.insertOrReplace(labelEntity);
        labelEntity.id = labelId;

        yield currentState.copyWith(
            labels: List.from(currentState.labels)..add(labelEntity));
      }
    } catch (e) {
      String message;
      if (e is ArgumentError) {
        message = e.message;
      }
      yield LabelInsertFailure(message);
    }
  }

  Stream<LabelState> _mapBlogLoadedToState(LabelLoaded event) async* {
    // try {
    //   yield LabelLoadedInProgress();
    //   List<LabelEntity> labelEntitys = await labelRepository.loadLabels();
    //   List<LabelEntity> selectors =
    //       await labelRepository.loadLabelsByBlogId(event.blogId);
    //   yield LabelLoadedSuccess(labelEntitys,
    //       selectorsLabels: selectors, blogId: event.blogId);
    // } catch (e) {
    //   yield LabelLoadedFailure();
    // }
  }
}
