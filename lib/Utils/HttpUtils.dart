import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/adapter.dart';
import '../../Utils/AllSingleton.dart';
import 'package:sp_util/sp_util.dart';

import 'package:dio/dio.dart';

class HttpUtils {



  /// global dio object
  static Dio dio = Dio();

  /// default options
  static const String sentences = 'http://192.168.10.234:8901/';///电话
  static const String version = '/v1';
  static const int CONNECT_TIMEOUT = 5000;
  static const int RECEIVE_TIMEOUT = 5000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  /// request method
  static Future<Map<String,dynamic>> request (
      String url,
      { data, queryParams, method, header }) async {

    String token = SpUtil.getString('token')??'';




    data = data ?? {};
    queryParams = queryParams ?? {};
    method = method ?? 'GET';

    Map<String, dynamic> queryParameters = <String, dynamic>{};

    /// restful 请求处理
    /// /gysw/search/hist/:user_id        user_id=27
    /// 最终生成 url 为     /gysw/search/hist/27
    queryParams.forEach((key, value) {
      queryParameters[key] = queryParams[key];
      if (url.contains(key)) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    /// 打印请求相关信息：请求地址、请求方式、请求参数
    print('请求地址：【' + method + '  ' + url + '】');
    print('请求参数：' + queryParameters.toString());
    print('POST参数：' + data.toString());
    // print('调用HttpUtils了');

    Dio dio = createInstance();
    // if(sentences == 'http://192.168.10.234/api' || sentences == 'https://share.51ymxc.com/api'){
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     //这一段是解决安卓https抓包的问题
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) {
    //       return Platform.isAndroid;
    //     };
    //     client.findProxy = (uri) {
    //       return findProxy;
    //     };
    //   };
    // }
    var result, code;
    bool isOK = false;
    try {
      Response response = await dio.request(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(
              method: method,
              headers: header??{'X-Res-Authorization':token}));
      result = response.data.toString() == '[]'? null:response.data;
      code = response.data['code'];

      /// 打印响应相关信息
      // print('响应数据：' + url + response.toString());
      // print('响应数据是否为空：${result == null}');
      isOK = true;
    } on DioError catch (e) {
      /// 打印请求失败相关信息
      // print('请求出错：' + e.message.toString());
      isOK = false;
      if (e.type == DioErrorType.response) {
        if(e.response?.data.runtimeType == String){
          UISingleton().showBlueLog('服务器故障');
        }
        result = (e.response?.data.runtimeType is Map)?e.response?.data:{'message':e.response?.data};
        code = result['code']??e.error;
      } else {
        UISingleton().showBlueLog(e.message.toString());
      }

    }

    return {"success":isOK, 'res':result, 'code':code};
  }

  /// upload method
  static Future<Map<String,dynamic>> upload (
      String url,
      { fileName, fileData, method, header }) async {

    method = method ?? 'POST';

    /// 打印请求相关信息：请求地址、请求方式、请求参数
    print('请求地址：【' + method + '  ' + url + '】');
    // print('POST参数：' + fileData);
    // print('调用HttpUtils了');
    String token = SpUtil.getString('token')??'';
    Dio dio = createInstance();
    // if(sentences == 'http://192.168.10.234/api' || sentences == 'https://share.51ymxc.com/api'){
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     //这一段是解决安卓https抓包的问题
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) {
    //       return Platform.isAndroid;
    //     };
    //     client.findProxy = (uri) {
    //       return findProxy;
    //     };
    //   };
    // }
    var result, code;
    bool isOK = false;
    var cancel = BotToast.showLoading();
    try {
      dio.interceptors.add(LogInterceptor());

      Response response = await dio.post(
        url,
        data: await FormData.fromMap({
          'file': await MultipartFile.fromBytes(
            fileData,
            filename: fileName,
          ),
        }),
        options: Options(
            method: method,
            headers: header??{'X-Res-Authorization':token}),
        onSendProgress: (received, total) {
          if (total != -1) {

            print((received / total * 100).toStringAsFixed(0) + '%');
            UISingleton().showBlueLog((received / total * 100).toStringAsFixed(0) + '%');
          }
        },
      );

      result = response.data.toString() == '[]'? null:response.data;
      code = response.data['code'];
      cancel();
    } on DioError catch (e) {
      cancel();
      /// 打印请求失败相关信息
      // print('请求出错：' + e.message.toString());
      isOK = false;
      if (e.type == DioErrorType.response) {
        result = e.response?.data;
        code = e.response?.data['code']??e.error;
      } else {
        UISingleton().showBlueLog(e.message.toString());
      }

    }

    return {"success":isOK, 'res':result, 'code':code};
  }

  /// post method
  static Future<Map<String,dynamic>> post (
      String url,
      { required Map<String,dynamic> data, method, header }) async {

    method = method ?? 'POST';

    /// 打印请求相关信息：请求地址、请求方式、请求参数
    print('请求地址：【' + method + '  ' + url + '】');
    // print('POST参数：' + fileData);
    // print('调用HttpUtils了');
    String token = SpUtil.getString('token')??'';
    Dio dio = createInstance();
    // if(sentences == 'http://192.168.10.234/api' || sentences == 'https://share.51ymxc.com/api'){
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     //这一段是解决安卓https抓包的问题
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) {
    //       return Platform.isAndroid;
    //     };
    //     client.findProxy = (uri) {
    //       return findProxy;
    //     };
    //   };
    // }
    var result, code;
    bool isOK = false;
    var cancel = BotToast.showLoading();
    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
            contentType: 'application/json',
            method: method,
            headers: header??{'X-Res-Authorization':token}),
      );

      result = response.data.toString() == '[]'? null:response.data;
      code = response.data['code'];
      cancel();
    } on DioError catch (e) {
      cancel();
      /// 打印请求失败相关信息
      // print('请求出错：' + e.message.toString());
      isOK = false;
      if (e.type == DioErrorType.response) {
        result = e.response?.data;
        code = e.response?.data['code']??e.error;
      } else {
        UISingleton().showBlueLog(e.message.toString());
      }

    }

    return {"success":isOK, 'res':result, 'code':code};
  }

  /// 创建 dio 实例对象
  static Dio createInstance () {
    if (dio.options.baseUrl == '') {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = BaseOptions(
        baseUrl: sentences,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      dio = Dio(options);
    }
    return dio;

  }

  /// 清空 dio 对象
  static clear () {
    dio = Dio();
  }

  static get(path) {
    return createInstance().get(path);
  }


}