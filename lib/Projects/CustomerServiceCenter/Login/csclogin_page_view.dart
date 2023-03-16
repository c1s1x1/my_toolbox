import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_toolbox/Utils/AllSingleton.dart';
import 'package:my_toolbox/Utils/HexColor.dart';

import 'csclogin_page_bloc.dart';
import 'csclogin_page_event.dart';
import 'csclogin_page_state.dart';

class CscLoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CscLoginPageState();
  }
}
class _CscLoginPageState extends State<CscLoginPage> {

  ///是否显示密码
  bool _isHidePassWord = true;
  ///账号控制器
  TextEditingController userNameTextController = TextEditingController();
  ///密码控制器
  TextEditingController passwordTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CscLoginPageBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<CscLoginPageBloc>(context);

    return Scaffold(
      body: GestureDetector(
        ///自己和子组件都可以获取事件
        behavior: HitTestBehavior.translucent,
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: UISingleton().baseGradientColor(UISingleton().baseColors[UISingleton().colorsMenu]),
              ),
            ),
            Positioned(
              right: 88,
              top: 88,
              child: Builder(
                builder: (BuildContext context){
                  return GestureDetector( 
                    onTap: (){
                      BotToast.showAttachedWidget(
                          targetContext: context,
                          preferDirection: PreferDirection.bottomRight,
                          // verticalOffset: 25,
                          attachedBuilder: (cancel)=>(
                              // Card(
                              //   child: ElevatedButton(
                              //     onPressed: (){
                              //
                              //     },
                              //     child: Text('确认'),
                              //   ),
                              // )
                              Container(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        child: Text('确认'),
                                      ),
                                    )
                                  ],
                                ),
                              )
                          )
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 16.w,
              top: 16.w,
              child: SizedBox(
                width: 76.h*3.53,
                height: 76.h,
                child: Image.asset('assets/png/WLogo.png',width: double.infinity,
                  height: double.infinity,fit: BoxFit.fill,),
              ),
            ),
            Container(
              // color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 0.4.sw,
                    height: 0.4.sw*0.72,
                    // color: Colors.white,
                    margin: EdgeInsets.only(right: 24.w),
                    child: Image.asset('assets/png/WLoginBg.png',width: double.infinity,
                      height: double.infinity,fit: BoxFit.fill,),
                  ),
                  Container(
                    height: 0.6.sh,
                    width: 0.6.sh*0.74,
                    constraints: BoxConstraints(
                        maxHeight: 555,
                        maxWidth: 416
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          // offset: Offset(0, 8),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(left: 32,top: 30,right: 32,bottom: 30),
                    child: Container(
                      // width: 0.8.sh*0.8,
                      // height: 0.8.sh,
                      // color: Colors.blue,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 90,
                              height: 50,
                              child: Image.asset('assets/png/WLogo2.png',width: double.infinity,
                                height: double.infinity,fit: BoxFit.fill,),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 18,bottom: 32),
                              child: Text(
                                '医脉相诚客户服务中心',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w900
                                ),
                              ),
                            ),
                            ///账号输入框
                            textField(16,'assets/png/userIcon.png','请输入您的账号', userNameTextController, (username){

                            }),
                            textField(32,'assets/png/passwordIcon.png','请输入您的密码', passwordTextController, (password){

                            }),
                            Container(
                              width: 0.5.sw,
                              height: 40,
                              margin: EdgeInsets.only(top: 32),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: UISingleton().baseGradientColor(UISingleton().baseColors[UISingleton().colorsMenu]),
                                  borderRadius: BorderRadius.all(Radius.circular(6))
                              ),
                              child: Text(
                                '登录',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(13),
                                    color: Colors.white
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///输入框
  Widget textField(double top,String icon,String title,TextEditingController textController,ValueChanged<String>? onChanged){
    return Container(
      margin: EdgeInsets.only(top: top,),
      constraints: BoxConstraints(
        maxHeight: 40
      ),
      child: TextField(
        autofocus: false,
        controller: textController,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        obscureText: title == '请输入密码'?_isHidePassWord:false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical:10),
          enabledBorder: OutlineInputBorder(
            /*边角*/
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
            borderSide: BorderSide(
              color: UISingleton().inputBoxEnabledBorderColor,
              width: 1, //边线宽度为2
            ),
          ),
          focusedBorder: OutlineInputBorder(
            /*边角*/
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: UISingleton().baseColors[UISingleton().colorsMenu],
                width: 1, //宽度为5
              )),
          // errorText: "errorText",

          hintText: title,
          hintStyle: TextStyle(
            color: UISingleton().hintTextColor,
            fontSize: ScreenUtil().setSp(13),
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
            margin: EdgeInsets.all(8),
            height: 16,
            width: 16,
            child: Image.asset(icon),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 8,
            minHeight: 8,
          ),
        ),
      ),
    );
  }
}

