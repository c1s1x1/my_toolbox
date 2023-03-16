import 'package:bloc/bloc.dart';

import 'ringing_page_event.dart';
import 'ringing_page_state.dart';

class RingingPageBloc extends Bloc<RingingPageEvent, RingingPageState> {
  RingingPageBloc() : super(RingingPageState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<RingingPageState> emit) async {
    emit(state.clone());
  }
}
