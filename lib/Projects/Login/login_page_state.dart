import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class LoginPageState {

  ///进度
  int progress = 0;

  ///账号
  String userName = '';

  ///密码
  String password = '';

  ///账号底部线的进度
  double userNameLineProgress = 0.0;

  ///密码底部线的进度
  double passwordLineProgress = 0.0;

  ///登录按钮的坐标
  // double loginButtonDx = 1.0.sw;
  // double loginButtonDy = 1.0.sh;

  ///两个变换矩阵，账号和密码提示语句
  Matrix4 userNameTransform = Matrix4.compose(v.Vector3(0.0, 0.0, 0.0), v.Quaternion.euler(0, 0, 0), v.Vector3(0.001, 1.0, 1.0));///账号
  Matrix4 passwordTransform = Matrix4.compose(v.Vector3(0.0, 0.0, 0.0), v.Quaternion.euler(0, 0, 0), v.Vector3(0.001, 1.0, 1.0));///密码

  ///账号控制器
  TextEditingController userNameTextController = TextEditingController();
  ///密码控制器
  TextEditingController passwordTextController = TextEditingController();

  ///错误号
  String code = '';

  ///错误信息
  String message = '';

  LoginPageState init() {
    return LoginPageState();
  }

  LoginPageState clone() {
    return LoginPageState()
    ..userName = userName
    ..password = password
    ..userNameLineProgress = userNameLineProgress
    ..passwordLineProgress = passwordLineProgress
    // ..loginButtonDx = loginButtonDx
    // ..loginButtonDy = loginButtonDy
    ..userNameTransform = userNameTransform
    ..passwordTransform = passwordTransform
    ..userNameTextController = userNameTextController
    ..passwordTextController = passwordTextController
    ..progress = progress
    ..code = code
    ..message = message;
  }

  void reset() {
    progress = 0;
    userName = '';
    password = '';
    userNameLineProgress = 0.0;
    passwordLineProgress = 0.0;
    // loginButtonDx = 1.0.sw;
    // loginButtonDy = 1.0.sh;
    userNameTransform = Matrix4.compose(v.Vector3(0.0, 0.0, 0.0), v.Quaternion.euler(0, 0, 0), v.Vector3(0.001, 1.0, 1.0));
    passwordTransform = Matrix4.compose(v.Vector3(0.0, 0.0, 0.0), v.Quaternion.euler(0, 0, 0), v.Vector3(0.001, 1.0, 1.0));
    userNameTextController = TextEditingController();
    passwordTextController = TextEditingController();
    code = '';
    message = '';
  }
}
