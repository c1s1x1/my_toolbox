import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';

class GaussianBlurPageBloc extends Bloc<GaussianBlurPageEvent, GaussianBlurPageState> {
  GaussianBlurPageBloc() : super(GaussianBlurPageState().init()) {
    on<InitEvent>(_init);
    on<RefreshEvent>(refresh);
  }

  void _init(InitEvent event, Emitter<GaussianBlurPageState> emit) async {
    emit(state.clone());
  }

  void refresh(RefreshEvent event, Emitter<GaussianBlurPageState> emit) async {
    emit(state.clone());
  }

}
