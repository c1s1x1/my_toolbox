import 'package:bloc/bloc.dart';

import 'csclogin_page_event.dart';
import 'csclogin_page_state.dart';

class CscLoginPageBloc extends Bloc<CscLoginPageEvent, CscLoginPageState> {
  CscLoginPageBloc() : super(CscLoginPageState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<CscLoginPageState> emit) async {
    emit(state.clone());
  }
}
