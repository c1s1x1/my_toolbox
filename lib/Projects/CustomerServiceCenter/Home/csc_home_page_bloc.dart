import 'package:bloc/bloc.dart';

import 'csc_home_page_event.dart';
import 'csc_home_page_state.dart';

class CscHomePageBloc extends Bloc<CscHomePageEvent, CscHomePageState> {
  CscHomePageBloc() : super(CscHomePageState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<CscHomePageState> emit) async {
    emit(state.clone());
  }
}
