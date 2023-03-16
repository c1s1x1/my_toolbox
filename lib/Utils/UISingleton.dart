import 'dart:core';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Utils/AllSingleton.dart';
import 'HexColor.dart';

///UI全局单例
class UISingleton {
  // make this nullable by adding '?'
  static UISingleton? _instance;
  ///状态栏高度
  double statusBarHeight = 0.0;///39.2
  ///安全高度
  double safeHeight = 0.0;

  ///主要色彩
  Map<String,Color> mainColors = {
    '主色': Color.fromRGBO(59, 130, 246, 1),///按钮主色
    '提示': Color.fromRGBO(153, 153, 153, 1),///提示文字
    '阴影': Color.fromRGBO(24, 51, 91, 0.07),///阴影颜色
    '底线': Color.fromRGBO(230, 230, 230, 1),///导航底部边框和分割线
    '1级标题': Color.fromRGBO(39, 39, 40, 1),///1级标题颜色
    '2级标题': Color.fromRGBO(83, 85, 88, 1),///2级标题颜色
    '3级标题': Color.fromRGBO(114, 115, 118, 1),///3级标题颜色
    '背景底色': Color.fromRGBO(247, 247, 247, 1)///背景底色颜色
  };

  ///动画效果
  Curve animationCurve = Curves.decelerate;

  ///当前选择的渐变颜色
  LinearGradient baseGradientColor (Color baseColor){
    LinearGradient gradientColor = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight, // 10% of the width, so there are ten blinds.
      colors: [ Color.fromRGBO(baseColor.red+12, baseColor.green+31, baseColor.blue+11, 1),baseColor], // red to yellow
      tileMode: TileMode.repeated, // repeats the gradient over the canvas
    );
    return gradientColor;
  }

  LinearGradient loginButtonColor = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight, // 10% of the width, so there are ten blinds.
    colors: [ Color.fromRGBO(59, 130, 246, 1),Color.fromRGBO(37, 99, 235, 1)], // red to yellow
    tileMode: TileMode.repeated, // repeats the gradient over the canvas
  );

  ///登录动画中登录按钮的的渐变正颜色
  LinearGradient loginPositiveColor = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight, // 10% of the width, so there are ten blinds.
    colors: [ Color.fromRGBO(253,242,80,1), Color.fromRGBO(244,181,62,1)], // red to yellow
    tileMode: TileMode.repeated, // repeats the gradient over the canvas
  );

  ///当前选择的渐变正颜色
  LinearGradient loginBgPositiveColor = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight, // 10% of the width, so there are ten blinds.
    colors: [ Color.fromRGBO(253,242,80,1), Color.fromRGBO(244,181,62,1)], // red to yellow
    tileMode: TileMode.repeated, // repeats the gradient over the canvas
  );

  ///字体颜色
  Color textColor = Colors.black;
  Color hintTextColor = Color.fromRGBO(184, 188, 201, 1);

  ///输入框边框颜色
  Color inputBoxEnabledBorderColor = Color.fromRGBO(184, 188, 201, 1);///未触发
  Color inputBoxFocusedBorderColor = Color.fromRGBO(255, 232, 48, 1);///触发

  ///登录按钮颜色
  Color loginButton = Color.fromRGBO(255, 232, 48, 1);

  ///主题色key
  int colorsMenu = 0;

  List<Color> baseColors = [
    HexColor.fromHex('222223'),
    Color.fromRGBO(28, 147, 153, 1),
    Color.fromRGBO(202, 91, 79, 1),
    Color.fromRGBO(44, 56, 133, 1),
    Color.fromRGBO(14, 41, 73, 1),
  ];

  ///当前
  bool isNight = false;
  ///夜晚模式
  Color nightModel = Color.fromRGBO(36,40,44,1);
  ///白天模式
  Color dayModel = Color.fromRGBO(233,238,241,1);

  ///根据模式选颜色
  Color whichModel(){
    return isNight?nightModel:dayModel;
  }

  ///显示蓝底白字提示框
  void showBlueLog(String msg){
    BotToast.showCustomText(
      duration: Duration(seconds: 2),
      onlyOne: true,
      clickClose: true,
      crossPage: true,
      ignoreContentClick: true,
      animationDuration: Duration(milliseconds: 200),
      animationReverseDuration: Duration(milliseconds: 200,),
      toastBuilder: (_) => Align(
        alignment: const Alignment(0, 0.8),
        child: Card(
          color: Color.fromRGBO(244,181,62,1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ///logo
              Container(
                margin: EdgeInsets.all(8.h),
                height: 16.w,
                width: 16.w,
                child: Image.asset('assets/png/医脉素材库.png'),
              ),
              Container(
                margin: EdgeInsets.all(8.h),
                width: 0.8.sw,
                child: Text(
                  msg,
                  maxLines: 4,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///文本整体宽高
  ///
  ///value: 文本内容
  ///fontSize : 文字的大小
  ///fontWeight：文字权重
  ///maxWidth：文本框的最大宽度
  ///maxLines：文本支持最大多少行
  ///locale：当前手机语言
  ///textScaleFactor：手机系统可以设置字体大小（默认1.0）
  static TextPainter calculateTextPainter(String value, fontSize, FontWeight fontWeight, double maxWidth, int maxLines,BuildContext context) {
    value = filterText(value);
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    TextPainter painter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        locale: WidgetsBinding.instance!.window.locale,
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        textScaleFactor: textScaleFactor, //字体缩放大小
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )
        )
    );
    painter.layout(maxWidth: maxWidth);
    ///文字的宽度:painter.width
    return painter;
  }

  ///解决text截断文字，数字字母整段缩略
  String breakWord(String word) {
    if (word == null || word.isEmpty) {
      return word;
    }
    String breakWord = ' ';
    word.runes.forEach((element) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    });
    return breakWord;
  }

  static String filterText(String text) {
    String tag = '<br>';
    while (text.contains('<br>')) {
      // flutter 算高度,单个\n算不准,必须加两个
      text = text.replaceAll(tag, '\n\n');
    }
    return text;
  }

  ///渐变色数组
  List<List<String>> solidColourGradient = [
    ["FDEB71", "F8D800"],
    ["ABDCFF", "0396FF"],
    ["FEB692", "EA5455"],
    ["CE9FFC", "7367F0"],
    ["90F7EC", "32CCBC"],
    ["FFF6B7", "F6416C"],
    ["81FBB8", "28C76F"],
    ["E2B0FF", "9F44D3"],
    ["F97794", "623AA2"],
    ["FCCF31", "F55555"],
    ["F761A1", "8C1BAB"],
    ["43CBFF", "9708CC"],
    ["5EFCE8", "736EFE"],
    ["FAD7A1", "E96D71"],
    ["FFD26F", "3677FF"],
    ["A0FE65", "FA016D"],
    ["FFDB01", "0E197D"],
    ["FEC163", "DE4313"],
    ["92FFC0", "002661"],
    ["EEAD92", "6018DC"],
    ["F6CEEC", "D939CD"],
    ["52E5E7", "130CB7"],
    ["F1CA74", "A64DB6"],
    ["E8D07A", "5312D6"],
    ["EECE13", "B210FF"],
    ["79F1A4", "0E5CAD"],
    ["FDD819", "E80505"],
    ["FFF3B0", "CA26FF"],
    ["FFF5C3", "9452A5"],
    ["F05F57", "360940"],
    ["2AFADF", "4C83FF"],
    ["FFF886", "F072B6"],
    ["97ABFF", "123597"],
    ["F5CBFF", "C346C2"],
    ["FFF720", "3CD500"],
    ["FF6FD8", "3813C2"],
    ["EE9AE5", "5961F9"],
    ["FFD3A5", "FD6585"],
    ["C2FFD8", "465EFB"],
    ["FD6585", "0D25B9"],
    ["FD6E6A", "FFC600"],
    ["65FDF0", "1D6FA3"],
    ["6B73FF", "000DFF"],
    ["FF7AF5", "513162"],
    ["F0FF00", "58CFFB"],
    ["FFE985", "FA742B"],
    ["FFA6B7", "1E2AD2"],
    ["FFAA85", "B3315F"],
    ["72EDF2", "5151E5"],
    ["FF9D6C", "BB4E75"],
    ["F6D242", "FF52E5"],
    ["69FF97", "00E4FF"],
    ["3B2667", "BC78EC"],
    ["70F570", "49C628"],
    ["3C8CE7", "00EAFF"],
    ["FAB2FF", "1904E5"],
    ["81FFEF", "F067B4"],
    ["FFA8A8", "FCFF00"],
    ["FFCF71", "2376DD"],
    ["FF96F9", "C32BAC"]
  ];

  ///单例基础设置
  UISingleton._() {
    // initialization and stuff
  }

  UISingleton._internal();

  static UISingleton getInstance() {
    if (_instance == null) {
      _instance = UISingleton._internal();
    }
    return _instance!;
  }

  ///UI全局单例
  factory UISingleton() {
    if (_instance== null) {
      _instance = UISingleton._();
    }
    // since you are sure you will return non-null value, add '!' operator
    return _instance!;
  }

  ///初始化
  static void reset() {
    _instance = null;
  }
}