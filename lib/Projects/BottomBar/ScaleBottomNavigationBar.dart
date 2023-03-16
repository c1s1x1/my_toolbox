import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DetailText.dart';

class ScaleBottomNavigationBar extends StatefulWidget {
  const ScaleBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<ScaleBottomNavigationBar> createState() =>
      _ScaleBottomNavigationBarState();
}

class _ScaleBottomNavigationBarState extends State<ScaleBottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bgAnimation;
  late Animation<double> _aButtonToCenter;
  late AnimationController _rotationAnimationController;
  late Animation<double> _rotationAnimation;
  late Animation _sizeAnimation1;
  late Animation _sizeAnimation2;
  late Animation _sizeAnimation3;


  late AnimationController _itemSelectController;
  late Animation<double> _selectSizeItemAnimation1;
  late Animation<double> _selectSizeItemAnimation2;
  late Animation<double> _selectSizeItemAnimation3;
  late Animation<Color?> _selectColorItemAnimation;

  late AnimationController _itemUnSelectController;
  late Animation<double> _selectUnSizeItemAnimation;
  late Animation<double> _selectUnColorItemAnimation;

  int selectIndex = 0;

  // bool hidden = true;
  @override
  void initState() {
    ///背景动画控制器
    _controller = AnimationController(value: 0.0, duration: const Duration(milliseconds: 400), vsync: this,);
    ///背景透明度渐变
    _bgAnimation = Tween<double>(begin: 1.0, end: 0.0,).animate(_controller);

    ///内部按钮距离中心的距离
    _aButtonToCenter = Tween<double>(begin: 1.0, end: 0.0,).animate(_controller);

    ///按钮旋转控制器
    _rotationAnimationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this,);
    ///按钮旋转角度
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(_controller);

    ///旋转过程中的缩放三阶段
    _sizeAnimation1 = Tween(begin: 40.0, end: 20.0).animate(CurvedAnimation(parent: _rotationAnimationController, curve: Interval(0.0, 0.15)));///缩小
    _sizeAnimation2 = Tween(begin: 20.0, end: 60.0).animate(CurvedAnimation(parent: _rotationAnimationController, curve: Interval(0.15, 0.5)));///放大
    _sizeAnimation3 = Tween(begin: 60.0, end: 40.0).animate(CurvedAnimation(parent: _rotationAnimationController, curve: Interval(0.5, 1.0)));///缩小

    ///选择的item放大控制器
    _itemSelectController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this,)..addStatusListener((status) {
      if(status == AnimationStatus.completed) _itemSelectController.reset();
    });
    ///item的缩放三阶段
    _selectSizeItemAnimation1 = Tween(begin: 24.w, end: 16.w).animate(CurvedAnimation(parent: _itemSelectController, curve: Interval(0.0, 0.25)));///缩小
    _selectSizeItemAnimation2 = Tween(begin: 16.w, end: 32.w).animate(CurvedAnimation(parent: _itemSelectController, curve: Interval(0.25, 0.5)));///放大
    _selectSizeItemAnimation3 = Tween(begin: 32.w, end: 24.w).animate(CurvedAnimation(parent: _itemSelectController, curve: Interval(0.5, 1.0)));///缩小

    _selectColorItemAnimation = ColorTween(begin: Colors.white,end: Colors.deepPurpleAccent).animate(_itemSelectController);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationAnimationController.dispose();
    super.dispose();
  }

  bool get _isAnimationRunningForwardsOrComplete{
    switch (_controller.status) {
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        return true;
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        return false;
    }
  }

  static  final List<Widget> _bodyView = <Widget>[
    MyHomePage(key: PageStorageKey<String>('1'),title: '一'),
    MyHomePage(key: PageStorageKey<String>('2'),title: '二'),
    MyHomePage(key: PageStorageKey<String>('3'),title: '三'),
    MyHomePage(key: PageStorageKey<String>('4'),title: '四'),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(24, 25, 31, 1),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageTransitionSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation,) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              duration: const Duration(milliseconds: 1000),
              reverse: true,
              child:_bodyView[selectIndex],
            ),
            Positioned(
              bottom: 16.w,
                child:Container(
                  width: 1.0.sw,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 60.w),
                  child:Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 0.8.sw,
                        // color: Colors.blue,
                      ),
                      ///左右半区
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Row(
                          children: [
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (BuildContext context, Widget? child) {
                                return FadeTransition(
                                  opacity: _bgAnimation,
                                  child: ScaleTransition(
                                    alignment: Alignment.center,
                                    scale: _bgAnimation,
                                    child: child,
                                  ),
                                );
                              },
                              child: Container(
                                height: 80,
                                width: 0.8.sw,
                                padding: EdgeInsets.only(left: 20.w,right: 20.w),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(46, 47, 52, 1),
                                    borderRadius: BorderRadius.all( Radius.circular(40),)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ///左内部1按钮
                      Positioned(
                        right: 0.4.sw,
                        child: itemButton(0,Icons.home_filled),
                      ),
                      ///左内部2按钮
                      Positioned(
                        right: 0.4.sw,
                        child: itemButton(1,Icons.access_time_filled),
                      ),
                      ///右内部3按钮
                      Positioned(
                        left: 0.4.sw,
                        child: itemButton(2,Icons.add_alert_rounded),
                      ),
                      ///右内部4按钮
                      Positioned(
                        left: 0.4.sw,
                        child: itemButton(3,Icons.account_balance_sharp),
                      ),
                      ///按钮背景
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, Widget? child) {
                          return FadeTransition(
                            opacity: _bgAnimation,
                            child: RotationTransition(
                              turns: _rotationAnimation,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurpleAccent,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                  Container(
                                    height: 15,
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    height: 2,
                                    width: 15,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ///按钮十字
                      IgnorePointer(
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, Widget? child) {
                            return RotationTransition(
                              turns: _rotationAnimation,
                              child: Offstage(
                                offstage: _rotationAnimationController.value == 0.0,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                    ),
                                    Container(
                                      height: 15,
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      height: 2,
                                      width: 15,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      ///按钮外边框
                      IgnorePointer(
                        child: AnimatedBuilder(
                          animation: _rotationAnimationController,
                          builder: (BuildContext context, Widget? child) {
                            double size = 40.0;
                            if(_rotationAnimationController.value <= 0.3){
                              size = _sizeAnimation1.value;
                            }else if(_rotationAnimationController.value > 0.3 && _rotationAnimationController.value <= 0.6){
                              size = _sizeAnimation2.value;
                            }else{
                              size = _sizeAnimation3.value;
                            }
                            return RotationTransition(
                              turns: _rotationAnimation,
                              child: Offstage(
                                offstage: _rotationAnimationController.value == 0.0,
                                child: Container(///按钮
                                  height: size,
                                  width: size,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(Radius.circular(size/2)),
                                      border: Border.all(width: 3,color: Colors.white)
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      ///按钮十字
                      GestureDetector(
                        onTap: (){
                          if (_isAnimationRunningForwardsOrComplete) {
                            _controller.reverse();
                            _rotationAnimationController.reverse();
                          } else {
                            _controller.forward();
                            _rotationAnimationController.forward();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  ///item的按钮
  Widget itemButton(int index,IconData? icon){
    bool select = selectIndex == index;
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        double paddingWidth = (index == 1||index == 2)?((0.4.sw - 40.w - 20)/2)*_aButtonToCenter.value:(0.4.sw - 40.w - 20)*_aButtonToCenter.value;
        EdgeInsetsGeometry? margin = EdgeInsets.only(right: paddingWidth);
        if(index > 1){
          margin = EdgeInsets.only(left: paddingWidth);
        }
        return FadeTransition(
          opacity: _bgAnimation,
          child: GestureDetector(
            onTap: (){
              _itemSelectController.forward();
              setState(() {
                selectIndex  = index;
              });
            },
            child: AnimatedBuilder(
              animation: _itemSelectController,
              builder: (BuildContext context, Widget? child) {
                double size = 24.w;
                if(_itemSelectController.value <= 0.3){
                  size = _selectSizeItemAnimation1.value;
                }else if(_itemSelectController.value > 0.3 && _itemSelectController.value <= 0.6){
                  size = _selectSizeItemAnimation2.value;
                }else{
                  size = _selectSizeItemAnimation3.value;
                }
                return Container(
                  // color: Colors.deepPurpleAccent,
                  height: 32.w,
                  width: 32.w,
                  margin: margin,
                  alignment: Alignment.center,
                  child: Icon(icon,color: select?_itemSelectController.value == 0.0?Colors.deepPurpleAccent:_selectColorItemAnimation.value:Colors.white,size: select?size:24.w,),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

