import 'dart:ui';
import 'package:flutter/material.dart';

class Acrylic extends StatefulWidget {

  ///阴影颜色
  final Color shadowColor;
  ///背景颜色
  final Color bgColor;
  ///背景模糊度
  final double blur;
  ///组件高度
  final double height;
  ///组件宽度
  final double width;
  ///组件是否有圆角
  final BorderRadiusGeometry? borderRadius;
  ///阴影的高斯模糊
  final double blurRadius;
  ///子组件
  final Widget child;

  const Acrylic({
    Key? key,
    this.shadowColor = const Color.fromRGBO(22, 23, 26, 0.5),
    this.bgColor = const Color.fromRGBO(175, 175, 175, 0.1),
    this.blur = 10.0,
    required this.height,
    required this.width,
    this.borderRadius,
    this.blurRadius = 20.0,
    required this.child,
  }) : super(key: key);

  @override
  State<Acrylic> createState() => _AcrylicState();
}

class _AcrylicState extends State<Acrylic> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: widget.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: widget.borderRadius,
              boxShadow: [BoxShadow(
                  color: widget.shadowColor,
                  blurRadius: widget.blurRadius,
                  blurStyle: BlurStyle.outer///外部阴影，内部不填充
              )]
          ),
          child: ClipRRect(
            child:BackdropFilter(///背景过滤器
              filter: ImageFilter.blur(sigmaX: widget.blur,sigmaY: widget.blur),///模糊度
              child: Container(///主体背景
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                    color: widget.bgColor,
                    borderRadius: widget.borderRadius
                ),
                child: widget.child,
              ),
            ),
          ),
        ),

      ],
    );
  }
}


