part of 'photo_bloc.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();
}

class PhotoInitial extends PhotoState {
  @override
  List<Object> get props => [];
}

class PhotoLoadsInProgress extends PhotoState {
  @override
  List<Object> get props => [];
}

class PhotoLoadsSuccess extends PhotoState {
  final List<PhotoEntity> photos;

  PhotoLoadsSuccess({this.photos});

  @override
  List<Object> get props => [photos];
}

class PhotoLoadsFailure extends PhotoState {
  @override
  List<Object> get props => [];
}
