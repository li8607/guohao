import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guohao/repositorys/lever/lever.dart';
import 'package:guohao/repositorys/lever/lever_repository.dart';

part 'lever_event.dart';
part 'lever_state.dart';

class LeverBloc extends Bloc<LeverEvent, LeverState> {
  LeverRepository leverRepository;

  LeverBloc({this.leverRepository});

  @override
  LeverState get initialState => LeverInitial();

  @override
  Stream<LeverState> mapEventToState(
    LeverEvent event,
  ) async* {
    if (event is LeverLoaded) {
      yield* _mapLeverLoadedToState(event);
    }
  }

  Stream<LeverState> _mapLeverLoadedToState(
    LeverEvent event,
  ) async* {
    try {
      yield LeverLoadInProgress();
      var levers = await leverRepository.loadLevers();
      yield LeverLoadSuccess(levers: levers);
    } catch (e) {
      yield LeverLoadFailure();
    }
  }
}
