import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_toolbox/Utils/AllSingleton.dart';

import 'ringing_page_bloc.dart';
import 'ringing_page_event.dart';
import 'ringing_page_state.dart';

class RingingPage extends StatefulWidget{

  final void Function() handUp;
  final void Function() handDown;
  final String ringingNumber;

  RingingPage({
    required this.handUp,
    required this.handDown,
    required this.ringingNumber
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ringingPageState();
  }
}

class _ringingPageState extends State<RingingPage> {



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RingingPageBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<RingingPageBloc>(context);

    return Container(
      height: 1.0.sh,
      color: UISingleton().baseColors[UISingleton().colorsMenu],
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 48.w,top: UISingleton().statusBarHeight,left: 48.w),
            child: Text(
              widget.ringingNumber,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(40),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.all(32.w),
                    child: IconButton(
                        alignment: Alignment.center,
                        iconSize: 40.w,
                        onPressed: widget.handUp,
                        icon: Icon(Icons.phone,color: Colors.green)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(32.w),
                    child: IconButton(
                        alignment: Alignment.center,
                        iconSize: 40.w,
                        onPressed: widget.handDown,
                        icon: Icon(Icons.phone,color: Colors.red)
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

