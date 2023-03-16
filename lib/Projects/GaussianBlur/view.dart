import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_toolbox/CustomWidget/Acrylic.dart';
import '../../CustomWidget/ClipOvalShadow.dart';
import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class GaussianBlurPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GaussianBlurPageBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<GaussianBlurPageBloc>(context);
    return BlocBuilder<GaussianBlurPageBloc,GaussianBlurPageState>(
      bloc: bloc,
      builder: (context,state){
        List<Widget> customBody = [Image.asset('assets/png/bgGaussian.png',fit: BoxFit.cover, width: double.infinity, height: double.infinity),];
        double width = 1.0.sw - 64.w;
        double top = 0.4.sh;
        late double height;
        double radius = 16.w;
        ///第一种写法
        if(state.states == GaussianBlurPageStatus.first){
          height = 0.5.sh;
          customBody.add(
            ///高斯主题
            Positioned(
              left: (1.0.sw - width)/2,
              top: top - 0.2.sh,
              child: ClipOvalShadow(
                radius: radius,
                ///阴影设置
                shadow: BoxShadow(
                    color: Color.fromRGBO(22, 23, 26, 0.5),
                    offset: Offset(1.0, 1.0),
                    blurRadius: 20,
                    blurStyle: BlurStyle.outer///外部阴影，内部不填充
                ),
                ///路径
                clipper: CustomClipperOval(radius: radius,width: width,height: height),
                child: ClipRRect(
                  child:BackdropFilter(///背景过滤器
                    filter: ImageFilter.blur(sigmaX: 10.0,sigmaY: 10.0),///整体模糊度
                    child: Container(///主体背景
                      width: width,
                      height: height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(175, 175, 175, 0.1),///背景透明度
                        borderRadius: BorderRadius.all(Radius.circular(radius)),
                      ),
                      child: Text(
                        '高斯模糊',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        ///第二种写法
        if(state.states == GaussianBlurPageStatus.second){
          height = 0.3.sh;
          customBody.add(
            ///高斯主题
            Positioned(
              left: (1.0.sw - width)/2,
              top: top - 0.3.sh,
              child: AbsorbPointer(
                absorbing: true,
                child: SizedBox(
                  height: 0.8.sh,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: height,
                        width: width,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(radius)),
                            boxShadow: [BoxShadow(
                                color: Color.fromRGBO(22, 23, 26, 0.5),
                                offset: Offset(1.0, 1.0),
                                blurRadius: 20,
                                blurStyle: BlurStyle.outer///外部阴影，内部不填充
                            )]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(radius)),
                          child: BackdropFilter(///背景过滤器
                            filter: ImageFilter.blur(sigmaX: 10.0,sigmaY: 10.0),///模糊度
                            child: Container(///主体背景
                              height: height,
                              width: width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(175, 175, 175, 0.1),
                                borderRadius: BorderRadius.all(Radius.circular(16.w)),
                              ),
                              child: Text(
                                '高斯模糊',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Acrylic(
                          height: height,
                          width: width,
                          borderRadius: BorderRadius.all(Radius.circular(radius)),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '高斯模糊',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        ///全屏样式
        if(state.states == GaussianBlurPageStatus.fullScreen){
          height = 0.5.sh;
          customBody.add(
            ///高斯主题
            AbsorbPointer(
              absorbing: true,
              child: BackdropFilter(///背景过滤器
                filter: ImageFilter.blur(sigmaX: 8.0,sigmaY: 8.0),///整体模糊度
                child: Container(///主体背景
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(175, 175, 175, 0.1),///背景色透明度
                    borderRadius: BorderRadius.all(Radius.circular(16.w)),
                  ),
                  child: Container(
                    height: width/3,
                    width: width/3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(radius)),
                      boxShadow: [BoxShadow(
                          color: Color.fromRGBO(22, 23, 26, 0.5),
                          offset: Offset(1.0, 1.0),
                          blurRadius: 20,
                          blurStyle: BlurStyle.outer///外部阴影，内部不填充
                      )]
                    ),
                    child: Text(
                      '高斯模糊',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        ///功能按钮
        customBody.addAll(
          [
            ///返回
            Positioned(
              left: 16.w,
              top: 32.w,
              child: IconButton(
                icon: Icon(Icons.keyboard_backspace,color: Colors.white,),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            ///侧边栏
            Positioned(
              right: 16.w,
              top: 32.w,
              child: Builder(
                builder: (BuildContext context){
                  return IconButton(
                    icon: Icon(Icons.settings,color: Colors.white,),
                    onPressed: (){
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
          ]
        );
        return Scaffold(
          drawer: Acrylic(
              height: 1.0.sh,
              width: 260.w,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.w),
                bottomRight: Radius.circular(20.w)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.w)),
                child: Drawer(///侧边栏
                  width: 260.w,
                  elevation: 20,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    height: 1.0.sh,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.w)),
                      color: Colors.transparent,
                    ),
                    child: Container(///选择分类
                      margin: EdgeInsets.only(top: 16.h,bottom: 16.h),
                      padding: EdgeInsets.only(left: 16.w,right: 16.w),
                      alignment: Alignment.center,
                      height: 0.5.sh,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12.w)),
                        color: Colors.transparent,
                        boxShadow: [BoxShadow(color: Color.fromRGBO(24, 51, 91, 0.07), blurRadius: 10.w)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          siftItem('第一种',GaussianBlurPageStatus.first,bloc),
                          ///分割线
                          siftItem('第二种',GaussianBlurPageStatus.second,bloc),
                          ///分割线
                          siftItem('全屏幕',GaussianBlurPageStatus.fullScreen,bloc),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ),
          body: Stack(
            children: customBody,
          ),
        );
      },
    );
  }

  Widget siftItem(String title,GaussianBlurPageStatus state,GaussianBlurPageBloc gaussianBlurPageBloc){
    return Builder(
      builder: (BuildContext context){
        return GestureDetector(
          onTap: (){
            debugPrint('选择了$state');
            gaussianBlurPageBloc.state.states = state;
            gaussianBlurPageBloc.add(RefreshEvent());
            ///关闭侧边栏
            Scaffold.of(context).openEndDrawer();
          },
          child: Container(
            padding: EdgeInsets.only(top: 12.h,bottom: 12.h),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Text(title,style: TextStyle(color: gaussianBlurPageBloc.state.states == state?Color.fromRGBO(59, 130, 246, 1):Color.fromRGBO(230, 230, 230, 1)),),
                ),
                SizedBox(
                  width: 12.w,
                  height: 12.w,
                  child: Image.asset('assets/png/跳转.png'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

