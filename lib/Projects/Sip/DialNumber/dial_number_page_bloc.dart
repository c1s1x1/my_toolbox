import 'package:bloc/bloc.dart';

import 'dial_number_page_event.dart';
import 'dial_number_page_state.dart';

class DialNumberPageBloc extends Bloc<DialNumberPageEvent, DialNumberPageState> {
  DialNumberPageBloc() : super(DialNumberPageState().init()) {
    on<InitEvent>(_init);
    on<NumberChanged>(numberChanged);
    on<RefreshEvent>(refresh);
  }

  void _init(InitEvent event, Emitter<DialNumberPageState> emit) async {
    emit(state.clone());
  }

  void numberChanged(NumberChanged event, Emitter<DialNumberPageState> emit) async {
    state.number = event.number;
    emit(state.clone());
  }

  void refresh(RefreshEvent event, Emitter<DialNumberPageState> emit) async {
    emit(state.clone());
  }

}
