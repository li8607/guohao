part of 'lever_bloc.dart';

abstract class LeverEvent extends Equatable {
  const LeverEvent();
}

class LeverLoaded extends LeverEvent {
  @override
  List<Object> get props => [];
  
}