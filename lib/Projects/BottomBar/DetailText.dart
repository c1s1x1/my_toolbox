// DetailText
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Utils/AllSingleton.dart';

class MyHomePage extends StatefulWidget {
  // 构造函数，用于接受调用者的参数
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // 声明了一个字符串类型的final变量，并在构造函数中初始化
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(54, 55, 61, 1),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('第${widget.title}页',style: TextStyle(color: Colors.white),),
            IconButton(
              icon: Icon(Icons.keyboard_backspace,color: Colors.white,),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}