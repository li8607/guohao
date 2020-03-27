part of 'photo_bloc.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();
}

class PhotoLoaded extends PhotoEvent {
  @override
  List<Object> get props => [];
  
}