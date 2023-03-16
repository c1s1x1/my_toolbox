import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class FailurePage extends StatefulWidget{
  final String errorMessage;
  final VoidCallback? onPressed;

  const FailurePage(
      {
        required this.errorMessage,
        required this.onPressed,
      }
      );

  @override
  State<FailurePage> createState() {
    return FailurePageState();
  }

}

class FailurePageState extends State<FailurePage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255,255,255,1),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Align(
            alignment: Alignment.center,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // failedImage(state.name),
                SizedBox(
                  width: 0.3.sw,
                  height: 0.3.sw,
                  child: Image.asset('assets/png/${widget.errorMessage}.png'),
                ),
                Container(
                  margin: EdgeInsets.only(top: 48.h),
                  child: Text(
                    widget.errorMessage,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: ScreenUtil().setSp(16.0)
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}