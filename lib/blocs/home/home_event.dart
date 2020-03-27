import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends HomeEvent {
}

class AppExported extends HomeEvent {}

class AppImported extends HomeEvent {
  final String path;
  AppImported(this.path);

  @override
  List<Object> get props => [path];
}
