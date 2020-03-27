part of 'lever_bloc.dart';

abstract class LeverState extends Equatable {
  const LeverState();
}

class LeverInitial extends LeverState {
  @override
  List<Object> get props => [];
}

class LeverLoadInProgress extends LeverState {
  @override
  List<Object> get props => [];
}

class LeverLoadSuccess extends LeverState {
  final List<Lever> levers;

  LeverLoadSuccess({this.levers});

  @override
  List<Object> get props => [levers];
}

class LeverLoadFailure extends LeverState {
  @override
  List<Object> get props => [];
}
