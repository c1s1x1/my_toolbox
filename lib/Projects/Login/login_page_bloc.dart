import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:my_toolbox/Bean/CallerSeatBean.dart';
import '../../Utils/APIUtils.dart';
import '../../Utils/AllSingleton.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'login_page_event.dart';
import 'login_page_state.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc() : super(LoginPageState().init()) {
    on<InitEvent>(_init);
    on<LoginNameChanged>(loginNameChanged);
    on<LoginPasswordChanged>(loginPasswordChanged);
    on<RefreshEvent>(refresh);
    on<ResetEvent>(resetData);
  }

  void _init(InitEvent event, Emitter<LoginPageState> emit) async {
    emit(state.init());
  }

  void loginNameChanged(LoginNameChanged event, Emitter<LoginPageState> emit) async {
    state.userName = event.name;
    emit(state.clone());
  }

  void loginPasswordChanged(LoginPasswordChanged event, Emitter<LoginPageState> emit) async {
    state.password = event.password;
    emit(state.clone());
  }

  void refresh(RefreshEvent event, Emitter<LoginPageState> emit) async {
    emit(state.clone());
  }

  void resetData(ResetEvent event, Emitter<LoginPageState> emit) async {
    state.reset();
  }

  ///第一-登录
  Future<void> toLoginPost(BuildContext context,{orgId,seat}) async {
      ///回调周期
      const period =  Duration(seconds: 1);
      Timer.periodic(period, (timer) {
        ///到时回调
        state.progress = state.progress + 25;
        debugPrint('afterTimer=${DateTime.now()}');
        debugPrint('state.progress:${state.progress}');
        if (state.progress >= 100) { // 需要手动取消
          //取消定时器，避免无限回调
          timer.cancel();
          add(RefreshEvent());
        }
        add(RefreshEvent());
      });

  }

  ///Matrix4.compose(v.Vector3(0.5.sw, 0.2.sh, 0.0), v.Quaternion.euler(0, 0, -pi/21), v.Vector3(1.0, 1.0, 0.6))
  ///x轴、y轴、z轴的正反向偏移量
  ///x轴、y轴、原点的正反向旋转度，此时X轴对应的是→，y轴对应↑，z轴对应↓
  ///x轴、y轴、z轴的正反向缩放量
  LoginPageState onTapHandle(bool isUserName) {
    if(isUserName){
      state.userNameTransform = Matrix4.compose(v.Vector3(0.0, 0.0, 0.0), v.Quaternion.euler(0, 0, 0), v.Vector3(0.01, 1.0, 1.0));
    }
    state.passwordTransform = Matrix4.compose(v.Vector3(0.0, 0.0, 0.0), v.Quaternion.euler(0, 0, 0), v.Vector3(0.01, 1.0, 1.0));
    return state.clone();
  }
}
