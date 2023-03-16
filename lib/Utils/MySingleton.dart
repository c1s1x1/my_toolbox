import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../Bean/CallerSeatBean.dart';
import 'UISingleton.dart';

///UI全局单例
class MySingleton {
  // make this nullable by adding '?'
  static MySingleton? _instance;
  ///当前国际化？
  late MaterialLocalizations localizations;

  ///包信息
  late PackageInfo packageInfo;

  ///电话信息
  CallerSeatBean callerSeatBean = CallerSeatBean(0, '', null);

  ///单例基础设置
  MySingleton._() {
    // initialization and stuff
  }

  MySingleton._internal();

  static MySingleton getInstance() {
    if (_instance == null) {
      _instance = MySingleton._internal();
    }
    return _instance!;
  }

  ///UI全局单例
  factory MySingleton() {
    if (_instance== null) {
      _instance = MySingleton._();
    }
    // since you are sure you will return non-null value, add '!' operator
    return _instance!;
  }

  ///初始化
  static void reset() {
    _instance = null;
  }
}