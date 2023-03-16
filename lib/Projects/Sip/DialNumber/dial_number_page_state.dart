import 'package:flutter/material.dart';
import 'package:my_toolbox/Utils/AllSingleton.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../Vendor/Sip_flutter/sip_ua.dart';

class DialNumberPageState {

  ///账号控制器
  TextEditingController numberTextController = TextEditingController();

  ///当前电话号码
  String number = '';

  ///拨号盘
  Map lables = {
      '1': '',
      '2': 'abc',
      '3': 'def',
      '4': 'ghi',
      '5': 'jkl',
      '6': 'mno',
      '7': 'pqrs',
      '8': 'tuv',
      '9': 'wxyz',
      '*': '',
      '0': '+',
      '#': '',
  };
  ///通话时间
  String timeLabel = '00:00';

  DialNumberPageState init() {
    return DialNumberPageState();
  }

  DialNumberPageState clone() {
    return DialNumberPageState()
      .. numberTextController = numberTextController
      .. number = number
      .. lables = lables
      .. timeLabel = timeLabel;
  }

}
