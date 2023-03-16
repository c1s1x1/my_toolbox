import '../Utils/AllSingleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///导航栏
class CostPreferredSizeWidget extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final double elevation;
  final Widget? assetPath;
  final VoidCallback? onPressed;
  final VoidCallback? leadingOnPressed;
  final Size preferredSize;
  final bool canBack;
  final bool canActions;
  final bool haveBottom;
  final Widget? bottom;
  final Color? backgroundColor;
  final Color? textColor;
//  final BuildContext pageContext;

  CostPreferredSizeWidget(
      {
        required this.title,
        required this.elevation,
        this.onPressed,
        this.leadingOnPressed,
        required this.preferredSize,
        this.canBack = false,
        this.haveBottom = false,
        this.assetPath,
        this.canActions = false,
        this.bottom,
        this.backgroundColor,
        this.textColor,
//        this.pageContext
      }
      );

  @override
  State<CostPreferredSizeWidget> createState() {
    return CostPreferredSizeWidgetState();
  }

}

class CostPreferredSizeWidgetState extends State<CostPreferredSizeWidget> {
  @override
  Widget build(BuildContext context) {
    // double height = widget.preferredSize.height+(AppBarTheme.of(context).toolbarHeight??56.0);
    return PreferredSize(
        preferredSize: widget.preferredSize,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
              color: widget.backgroundColor??UISingleton().baseColors[UISingleton().colorsMenu],
            ),
            Stack(
              children: [
                Container(
                  height: widget.preferredSize.height,
                  width: widget.preferredSize.width,
                  color: widget.backgroundColor??UISingleton().baseColors[UISingleton().colorsMenu],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.haveBottom?
                    [
                      Text(widget.title,style: TextStyle(color: widget.textColor??Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold)),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: widget.bottom!,
                      )
                    ]
                        :[Text(widget.title,style: TextStyle(color: widget.textColor??Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold)),],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: widget.canBack ? GestureDetector(
                    onTap: widget.leadingOnPressed,
                    child: Container(
                      padding: EdgeInsets.only(left: 16.w,top: 16.w,right: 16.w,bottom: 16.w),
                      child: SizedBox(
                        height: 50.w,
                        width: 50.w,
                        child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                      ),
                    ),
                  ):Container(),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: widget.canActions ? SizedBox(
                    height: widget.preferredSize.height,
                    child: widget.assetPath!,
                  ): Container(),
                ),
              ],
            )
          ],
        )
    );
  }

}