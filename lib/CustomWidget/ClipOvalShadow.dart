import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomClipperOval extends CustomClipper<RRect> {
  final double radius;
  final double width;
  final double height;

  CustomClipperOval({
    required this.radius,
    required this.width,
    required this.height,
  });
  ///此处应和你想要高斯模糊组件的大小一致
  @override
  RRect getClip(Size size) {
    ///左、上、右、下，圆角的两个半径，坐标原点是屏幕左上角，坐标系往右下
    ///因为外部设置了左边距，所以左起点要有边距距离，顶部为0，右边要去掉左部分边距
    return RRect.fromLTRBXY((1.0.sw - width)/2, 0, width - (1.0.sw - width)/2, height, radius, radius);
  }

  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) {
    return false;
  }
}

class ClipOvalShadow extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<RRect> clipper;
  final double radius;
  final Widget child;

  ClipOvalShadow({
    required this.shadow,
    required this.clipper,
    required this.radius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    ///开始自定义绘制
    return CustomPaint(
      ///画阴影
      painter: _ClipOvalShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      ///切割内部
      child: ClipRRect(clipper: clipper,borderRadius: BorderRadius.all(Radius.circular(radius)), child: child,),
    );
  }
}

class _ClipOvalShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<RRect> clipper;

  _ClipOvalShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    ///根据路径画阴影
    var clipRect = clipper.getClip(size).shift(Offset(0, 0));
    canvas.drawRRect(clipRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}