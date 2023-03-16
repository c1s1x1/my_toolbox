import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../Utils/AllSingleton.dart';
import '../../main.dart';
import '../Sip/DialNumber/dial_number_page_view.dart';
import 'login_page_bloc.dart';
import 'login_page_event.dart';
import 'login_page_state.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{
  ///登录页bloc
  late LoginPageBloc loginPageBloc;
  ///账号底部线动画
  late AnimationController userNameLineAnimationController;
  late Animation<double> userNameLineAnimation;
  ///账号提示文字动画
  late AnimationController userNameTextAnimationController;
  late Animation<double> userNameTextAnimation;
  ///密码底部线
  late AnimationController passwordLineAnimationController;
  late Animation<double> passwordLineAnimation;
  ///密码提示文字动画
  late AnimationController passwordTextAnimationController;
  late Animation<double> passwordTextAnimation;
  ///登录动画
  late AnimationController loginAnimationController;
  late Animation<double> loginDxAnimation;///X轴动画
  late Animation<double> loginDyAnimation;///Y轴动画
  late Animation<double> loginWidthAnimation;///宽度动画
  late Animation<double> loginHeightAnimation;///高度动画
  late Animation<double> loginRadiusAnimation;///圆角动画
  late Animation<double> loginTopAnimation;///距离顶部动画

  ///下一步登录图标渐隐动画
  late AnimationController nextIconAnimationController;
  late Animation<double> nextIconAnimation;
  ///等待gif展开和渐显动画
  late AnimationController loadingOpacityAnimationController;
  late Animation<double> loadingOpacityAnimation;
  ///完成gif渐显动画
  late AnimationController completedOpacityAnimationController;
  late Animation<double> completedOpacityAnimation;
  ///请求控制器
  bool _isCan = true;
  ///是否显示密码
  bool _isHidePassWord = true;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    print('初始化');
    loginPageBloc = BlocProvider.of<LoginPageBloc>(context);
    ///账号底部线动画
    userNameLineAnimationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    userNameLineAnimation = Tween<double>(begin: 0.0,end: 1.0).animate(userNameLineAnimationController)
      ..addListener(() {
        setState(() {

        });
      });
    ///账号提示文字动画
    userNameTextAnimationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    userNameTextAnimation = Tween<double>(begin: 7,end: 0).animate(userNameTextAnimationController)
      ..addListener(() {
        setState(() {

        });
      });
    ///密码底部线
    passwordLineAnimationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    passwordLineAnimation = Tween<double>(begin: 0.0,end: 1.0).animate(passwordLineAnimationController)
      ..addListener(() {
        setState(() {

        });
      });
    ///密码提示文字动画
    passwordTextAnimationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    passwordTextAnimation = Tween<double>(begin: 7,end: 0).animate(passwordTextAnimationController)
      ..addListener(() {
        setState(() {

        });
      });

    ///登录动画
    loginAnimationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    ///X轴位移动画
    loginDxAnimation = Tween<double>(begin: 1.0.sw,end: 0).animate(loginAnimationController)
      ..addListener(() {
        setState(() {

        });
      });
    ///Y轴位移动画
    loginDyAnimation = Tween<double>(begin: 1.0.sh,end: 0).animate(loginAnimationController);
    ///宽度动画
    loginWidthAnimation = Tween<double>(begin: 1.0.sw - 64.h - 24.h,end: 1.0.sw).animate(loginAnimationController)
      ..addListener(() {
        setState(() {

        });
      });
    ///高度动画
    loginHeightAnimation = Tween<double>(begin: 52.h,end: 1.0.sh).animate(loginAnimationController)
      ..addListener(() {

        print("登录高度动画${nextIconAnimationController.status}");
        setState(() {

        });
      });
    ///圆角动画
    loginRadiusAnimation = Tween<double>(begin: 97.w,end: 0).animate(loginAnimationController)
      ..addListener(() {
        setState(() {

        });
      });
    ///距离顶部动画
    loginTopAnimation = Tween<double>(begin: 37.h,end: 0).animate(loginAnimationController)
      ..addListener(() {
        setState(() {

        });
      });

    ///下一步登录图标渐隐动画
    nextIconAnimationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    nextIconAnimation = Tween<double>(begin: 1.0,end: 0.0).animate(nextIconAnimationController)
      ..addListener(() {
        print("下一步登录动画${nextIconAnimationController.status}");
        if(nextIconAnimationController.status == AnimationStatus.completed){
          print('开启loading动画');
          loadingOpacityAnimationController.forward();
        }

        setState(() {

        });
      });

    ///等待gif渐显动画
    loadingOpacityAnimationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    loadingOpacityAnimation = Tween<double>(begin: 0.0,end: 1.0).animate(loadingOpacityAnimationController)
      ..addListener(() {
        print("等待gif渐显动画${loadingOpacityAnimationController.status}");
        if(loadingOpacityAnimationController.status == AnimationStatus.dismissed){
          print('关闭loading动画');
          if(nextIconAnimationController.status == AnimationStatus.dismissed){
            print('登录失败，没有完成动画');
          }else{
            print('登录成功，开始完成动画');
            completedOpacityAnimationController.forward();

          }
        }
        setState(() {

        });
      });

    ///完成gif渐显动画
    completedOpacityAnimationController = AnimationController(vsync: this,duration: Duration(milliseconds: 800));
    completedOpacityAnimation = Tween<double>(begin: 0.0,end: 1.0).animate(completedOpacityAnimationController)
      ..addListener(() {
        setState(() {
          if(completedOpacityAnimation.status == AnimationStatus.completed){
            Timer(Duration.zero, () {
              print('完成completed动画');
              // ///跳转首页
              // Navigator.pop(context);
              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DialNumberPage()
              // ), (route) => false);
              UISingleton().showBlueLog('登录完成，返回');
              loginAnimationController.reverse();
              nextIconAnimationController.reverse();
              loadingOpacityAnimationController.reverse();
              completedOpacityAnimationController.reverse();
            });
          }
        });
      });
    /// 在控件渲染完成后执行的回调
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginDyAnimation = Tween<double>(begin: _key.currentContext != null?(_key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy:1.0.sh,end: 0).animate(loginAnimationController)
        ..addListener(() {
          loginPageBloc.add(RefreshEvent());
          setState(() {

          });
        });
      loginDxAnimation = Tween<double>(begin: _key.currentContext != null?(_key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dx:1.0.sw,end: 0).animate(loginAnimationController)
        ..addListener(() {
          loginPageBloc.add(RefreshEvent());
          setState(() {

          });
        });
    });
  }

  @override
  Widget build(BuildContext context) {


    // print('当前时间戳：$timeStamp\n加密文本：$md5Data\n加密签名：${digest.toString()}');
    return Scaffold(
        body: BlocBuilder<LoginPageBloc,LoginPageState>(
            bloc: loginPageBloc,
            builder: (context,state){
              print('进度为${loginPageBloc.state.progress}');
              ///进度为100，表示登录，个人信息，配置信息全部获取成功
              if(loginPageBloc.state.progress == 100){
                print('关闭等待动画');
                Timer(Duration(milliseconds: 1000), () {
                  loadingOpacityAnimationController.reverse();
                });
                loginPageBloc.state.progress = 200;
              }else if(loginPageBloc.state.progress == -100){
                ///进度为-100，表示登录，个人信息，配置信息中有一个不成功
                Timer(Duration(milliseconds: 1000), () {
                  loginAnimationController.reverse();
                  nextIconAnimationController.reverse();
                  loadingOpacityAnimationController.reverse();
                  completedOpacityAnimationController.reverse();
                });
              }
              // if(loginPageBloc.state.loginButtonDx == 1.0.sw){
                // print('找到定位X:${_key.currentContext != null?(_key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dx:1.0.sw}\nY:${_key.currentContext != null?(_key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy:1.0.sh}');
                // loginDyAnimation = Tween<double>(begin: _key.currentContext != null?(_key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy:1.0.sh,end: 0).animate(loginAnimationController)
                //   ..addListener(() {
                //     setState(() {
                //
                //     });
                //   });
                // loginDxAnimation = Tween<double>(begin: _key.currentContext != null?(_key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dx:1.0.sw,end: 0).animate(loginAnimationController)
                //   ..addListener(() {
                //     setState(() {
                //
                //     });
                //   });
                // loginPageBloc.state.loginButtonDx = _key.currentContext != null?(_key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dx:1.0.sw;
                // loginPageBloc.state.loginButtonDy = _key.currentContext != null?(_key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy:1.0.sh;
              // }
              return Scaffold(
                body:SingleChildScrollView(
                  child: GestureDetector(
                    ///自己和子组件都可以获取事件
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      if(loginPageBloc.state.userNameTextController.text == ''){
                        userNameLineAnimationController.reverse();
                        userNameTextAnimationController.reverse();
                      }
                      if(loginPageBloc.state.passwordTextController.text == ''){
                        passwordLineAnimationController.reverse();
                        passwordTextAnimationController.reverse();
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 1.0.sw,
                          height: 1.0.sh,
                          decoration: BoxDecoration(
                            gradient: UISingleton().loginBgPositiveColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ///logo
                              Container(
                                margin: EdgeInsets.only(top: 93.h),
                                height: 61.w,
                                width: 61.w,
                                child: Image.asset('assets/png/医脉素材库.png'),
                              ),
                              ///APP名字
                              Container(
                                margin: EdgeInsets.only(top:22.w,bottom: 72.h),
                                child: Text(
                                  '医脉SHARE',
                                  style: TextStyle(
                                      color: UISingleton().textColor,
                                      fontSize: ScreenUtil().setSp(32),
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(12.h),
                                  padding: EdgeInsets.all(32.h),
                                  width: 1.0.sw,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(24.0))
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ///欢迎中文
                                      Text(
                                        '欢迎来到医脉 SHARE',
                                        style: TextStyle(
                                            color: UISingleton().textColor,
                                            fontSize: ScreenUtil().setSp(20),
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      ///欢迎英文
                                      Container(
                                        margin: EdgeInsets.only(top: 10.h),
                                        child: Text(
                                          'welcome to yimai share',
                                          style: TextStyle(
                                              color: UISingleton().textColor,
                                              fontSize: ScreenUtil().setSp(13),
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),

                                      ///账号输入框
                                      textField(20.h,'assets/png/icon_account.png','请输入账号', loginPageBloc.state.userNameTextController, (username) => context.read<LoginPageBloc>().add(LoginNameChanged(username))),
                                      textField(12.h,'assets/png/icon_password.png','请输入密码', loginPageBloc.state.passwordTextController, (password) => context.read<LoginPageBloc>().add(LoginPasswordChanged(password))),
                                      ///登录按钮
                                      GestureDetector(
                                        onTap: (){
                                          if (_isCan) {
                                            _isCan = false;

                                            debugPrint('点击登录按钮了${nextIconAnimationController.status}');
                                            if(loginPageBloc.state.userNameTextController.text == '' || loginPageBloc.state.passwordTextController.text == ''){
                                              UISingleton().showBlueLog('账号或者密码不能为空');
                                            }else{
                                              setState(() {
                                                loginDyAnimation = Tween<double>(begin: _key.currentContext != null?(_key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy:1.0.sh,end: 0).animate(loginAnimationController)
                                                  ..addListener(() {
                                                    setState(() {

                                                    });
                                                  });
                                                loginDxAnimation = Tween<double>(begin: _key.currentContext != null?(_key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dx:1.0.sw,end: 0).animate(loginAnimationController)
                                                  ..addListener(() {
                                                    setState(() {

                                                    });
                                                  });
                                                // ///宽度动画
                                                // loginWidthAnimation = Tween<double>(begin: (_key.currentContext?.findRenderObject() as RenderBox).size.width,end: 1.0.sw).animate(loginAnimationController)
                                                //   ..addListener(() {
                                                //     setState(() {
                                                //
                                                //     });
                                                //   });
                                                // ///高度动画
                                                // loginHeightAnimation = Tween<double>(begin: (_key.currentContext?.findRenderObject() as RenderBox).size.height,end: 1.0.sh).animate(loginAnimationController)
                                                //   ..addListener(() {
                                                //
                                                //     print("登录高度动画${nextIconAnimationController.status}");
                                                //     setState(() {
                                                //
                                                //     });
                                                //   });
                                              });
                                              // print('开始登录动画');
                                              if(loginAnimationController.status == AnimationStatus.dismissed){
                                                loginAnimationController.forward();
                                                nextIconAnimationController.forward();

                                              }
                                              loginPageBloc.toLoginPost(context,orgId: loginPageBloc.state.userNameTextController.text,seat: loginPageBloc.state.passwordTextController.text);
                                            }

                                            // 2000 毫秒内 不能多次点击
                                            Future.delayed(Duration(milliseconds: 3000), () {
                                              _isCan = true;
                                            });
                                          }
                                        },
                                        child: Opacity(
                                          opacity: 1,
                                          child: Container(
                                            key: _key,
                                            height: 52.h,
                                            width: 1.0.sw,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(top: 37.h),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(97.w)),
                                              gradient: UISingleton().loginPositiveColor,
                                              // color: UISingleton().loginButton,
                                            ),
                                            child: Text(
                                              '登录',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: ScreenUtil().setSp(16)
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ///登录按钮
                        Positioned(
                          left: loginDxAnimation.value,
                          top: loginDyAnimation.value,
                          child: GestureDetector(
                            onTap: () async {

                            },
                            child: Offstage(
                              offstage: loginAnimationController.status == AnimationStatus.dismissed,
                              child: Container(
                                height: loginHeightAnimation.value,
                                width: loginWidthAnimation.value,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: loginTopAnimation.value,),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(loginRadiusAnimation.value)),
                                  gradient: UISingleton().loginPositiveColor,
                                ),
                                child: Opacity(
                                  opacity: nextIconAnimation.value,
                                  child: Text(
                                    '登录',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: ScreenUtil().setSp(16)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ///loading动画
                        Positioned(
                          left: 0,
                          top: (1.0.sh - 0.5.sw)/2,
                          child: IgnorePointer(
                            child: Offstage(
                              offstage: loadingOpacityAnimation.value == 0.0,
                              child: Opacity(
                                opacity: loadingOpacityAnimation.value,
                                child: SizedBox(
                                  height: 0.5.sw,
                                  width: 1.0.sw,
                                  child: Lottie.asset(
                                    'assets/json/loadingRound.json',
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ///完成动画
                        Positioned(
                          left: 0,
                          top: (1.0.sh - 0.5.sw)/2,
                          child: IgnorePointer(
                            child: Offstage(
                              offstage: completedOpacityAnimation.value == 0.0,
                              child: Opacity(
                                opacity: completedOpacityAnimation.value,
                                child: SizedBox(
                                  height: 0.5.sw,
                                  width: 1.0.sw,
                                  child: Lottie.asset(
                                    'assets/json/completed.json',
                                    controller: completedOpacityAnimationController,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ///进度条
                        Positioned(
                          bottom: 0.3.sw,
                          left: 0.3.sw,
                          child: Offstage(
                            offstage: loadingOpacityAnimation.value == 0.0,
                            child: Opacity(
                              opacity: loadingOpacityAnimation.value,
                              child: SizedBox(
                                ///限制进度条的高度
                                height: 6.0,
                                ///限制进度条的宽度
                                width: 0.4.sw,
                                child: LinearProgressIndicator(
                                  ///0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
                                    value: loginPageBloc.state.progress/100,
                                    ///背景颜色
                                    backgroundColor: Colors.white,
                                    ///进度颜色
                                    valueColor: AlwaysStoppedAnimation<Color>(UISingleton().loginButton)),
                              ),
                            ),
                          ),
                        ),
                        ///返回按钮
                        Positioned(
                          left: 16.w,
                          top: 32.w,
                          child: IconButton(
                            icon: Icon(Icons.keyboard_backspace),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
        )
    );
  }

  Widget title(String title){
    return Container(
      margin: EdgeInsets.only(top:128.w),
      child: Text(
        title,
        style: TextStyle(
            color: Color.fromRGBO(197, 200, 204, 1),
            fontSize: ScreenUtil().setSp(32),
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  ///输入框
  Widget textField(double top,String icon,String title,TextEditingController textController,ValueChanged<String>? onChanged){
    return Container(
      margin: EdgeInsets.only(top: top,),
      child: TextField(
        autofocus: false,
        controller: textController,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        obscureText: title == '请输入密码'?_isHidePassWord:false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            /*边角*/
            borderRadius: BorderRadius.all(
              Radius.circular(6), //边角为30
            ),
            borderSide: BorderSide(
              color: UISingleton().inputBoxEnabledBorderColor, //边框颜色为绿色
              width: 1, //边线宽度为2
            ),
          ),
          focusedBorder: OutlineInputBorder(
            /*边角*/
              borderRadius: BorderRadius.all(
                Radius.circular(20), //边角为30
              ),
              borderSide: BorderSide(
                color: UISingleton().inputBoxFocusedBorderColor, //边框颜色为绿色
                width: 1, //宽度为5
              )),
          // errorText: "errorText",
          hintText: title,
          hintStyle: TextStyle(
            color: UISingleton().textColor,
            fontSize: ScreenUtil().setSp(14),
          ),
          suffixIcon: title != '请输入密码'?null:IconButton(
            onPressed: () {
              // //判断TextFormField是否处于获得焦点的状态，如果没有，当点击图标时禁止TextFormField获取焦点，也就不会弹出软键盘了，当TextFormField获取焦点时，点击图标，不关闭软键盘
              // if (!_focusNode.hasFocus) {
              //   _focusNode.canRequestFocus = false;
              //   Future.delayed(Duration(milliseconds: 500), () {
              //     _focusNode.canRequestFocus = true;
              //   });
              // }
              setState(() {
                _isHidePassWord = !_isHidePassWord;
              });
            },
            icon: Icon(_isHidePassWord
                ? Icons.visibility_off
                : Icons.visibility),
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(16.w),
            height: 16.w,
            width: 16.w,
            child: Image.asset(icon),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 16.w,
            minHeight: 16.w,
          ),
        ),
      ),
    );
  }

  ///输入框底部线
  Widget line(Animation<double> lineAnimation){
    return Container(
      height: 5.w,
      width: 1.0.sw - 128.w - 8.w,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 16.w,bottom: 64.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.w)),
          color: UISingleton().baseColors[UISingleton().colorsMenu]
      ),
      child: Container(
        height: 5.w,
        width: (1.0.sw - 128.w - 8.w)*lineAnimation.value,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.w)),
            color: UISingleton().baseColors[UISingleton().colorsMenu]
        ),
      ),
    );
  }

  @override
  void dispose() {
    // debugPrint('登录页释放');

    super.dispose();
    loginPageBloc.state.reset();
    ///账号底部线动画
    userNameLineAnimationController.dispose();
    ///账号提示文字动画
    userNameTextAnimationController.dispose();
    ///密码底部线
    passwordLineAnimationController.dispose();
    ///密码提示文字动画
    passwordTextAnimationController.dispose();
    ///登录动画
    loginAnimationController.dispose();
    ///下一步登录图标渐隐动画
    nextIconAnimationController.dispose();
    ///等待gif展开和渐显动画
    loadingOpacityAnimationController.dispose();
    ///完成gif渐显动画
    completedOpacityAnimationController.dispose();
  }

}

