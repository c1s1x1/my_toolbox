import 'dart:async';
import '../../Utils/AllSingleton.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';


///bloc
import 'HttpUtils.dart';

class APIUtils {

  static APIUtils? _instance;

  ///调度中心，各页面bloc
  void initAPIUtils(BuildContext context){

  }

  ///获取电话注册具体信息
  static Future<Map<String,dynamic>?> callerSeatPost ({orgId,seat,timeStamp,signature}) async {
    HttpUtils.dio.options.baseUrl = HttpUtils.sentences;
    var result = await HttpUtils.request(
      'third/caller/seat',
      data: {"orgId":orgId,"seat":seat},
      header: {
        "X-SIMCRM-API-APP-ID":"cs1500313469059104",
        "X-SIMCRM-API-TIMESTAMP":"$timeStamp",
        "X-SIMCRM-API-SIGNATURE":"$signature"
      },
      method: HttpUtils.POST,
    );
    if(result['code'] == 200){
      print(result);
    }
    return result;
  }

  ///单例基础设置
  APIUtils._() {
    // initialization and stuff
  }

  APIUtils._internal();

  static APIUtils getInstance() {
    if (_instance == null) {
      _instance = APIUtils._internal();
    }
    return _instance!;
  }

  ///Tinode全局单例
  factory APIUtils() {
    if (_instance== null) {
      _instance = APIUtils._();
    }
    // since you are sure you will return non-null value, add '!' operator
    return _instance!;
  }

  ///初始化
  static void reset() {
    _instance = null;
  }

}