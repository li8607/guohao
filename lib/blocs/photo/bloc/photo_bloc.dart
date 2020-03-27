import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guohao/repositorys/photo/photo_entity.dart';
import 'package:guohao/repositorys/photo/photo_repository.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository photoRepository;

  PhotoBloc({this.photoRepository});

  @override
  PhotoState get initialState => PhotoInitial();

  @override
  Stream<PhotoState> mapEventToState(
    PhotoEvent event,
  ) async* {
    if (event is PhotoLoaded) {
      yield* _mapPhotoLoadedToState();
    }
  }

  Stream<PhotoState> _mapPhotoLoadedToState() async* {
    try {
      yield PhotoLoadsInProgress();
      await Future.delayed(Duration(milliseconds: 300));
      List<PhotoEntity> photos = await photoRepository.loadPhotos();
      yield PhotoLoadsSuccess(photos: photos);
    } catch (e) {
      yield PhotoLoadsFailure();
    }
  }
}
