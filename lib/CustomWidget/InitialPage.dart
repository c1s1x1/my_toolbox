import 'package:flutter/material.dart';
import 'CostPreferredSizeWidget.dart';

class InitialPage extends StatefulWidget{
  final String title;
  final Widget? bottom;
  final bool haveBottom;
  final Widget body;

  const InitialPage(
      {
        required this.title,
        required this.haveBottom,
        this.bottom,
        required this.body
      }
      );

  @override
  State<InitialPage> createState() {
    return InitialPageState();
  }

}

class InitialPageState extends State<InitialPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CostPreferredSizeWidget(
        title: widget.title,
        elevation: 0.1,
        preferredSize: Size.fromHeight(60.0),
        leadingOnPressed: (){
          Navigator.pop(context);
        },
        canBack: true,
        canActions: false,
        haveBottom: widget.haveBottom,
        bottom: widget.bottom,
      ),
      body:widget.body,
    );
  }
}