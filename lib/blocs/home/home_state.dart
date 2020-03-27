import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'HomeState';
}

class AppStartInitial extends HomeState {
  @override
  String toString() => 'AppStartInitial';
}

class AppStartInProgress extends HomeState {
  @override
  String toString() => 'AppStartInProgress';
}

class AppStartFailure extends HomeState {
  @override
  String toString() => 'AppStartFailure';
}

class AppStartSuccess extends HomeState {
  @override
  String toString() => 'AppStartSuccess';
}

class ExportAppInProgress extends HomeState {
  @override
  String toString() => 'ExportAppInProgress';
}

class ExportAppSuccess extends HomeState {
  final String path;

  ExportAppSuccess(this.path);

  @override
  List<Object> get props => [path];

  @override
  String toString() => 'ExportAppSuccess';
}

class ExportAppFailure extends HomeState {
  @override
  String toString() => 'ExportAppFailure';
}

class ImportAppSuccess extends HomeState {
  @override
  String toString() => 'ImportAppSuccess';
}

class ImportAppFailure extends HomeState {
  @override
  String toString() => 'ImportAppFailure';
}

class ImportAppInProgress extends HomeState {
  @override
  String toString() => 'ImportAppInProgress';
}
