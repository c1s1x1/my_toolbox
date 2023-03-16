import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:my_toolbox/Projects/Sip/Ringing/ringing_page_view.dart';
import 'package:my_toolbox/Utils/HexColor.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../CustomWidget/CostPreferredSizeWidget.dart';
import '../../../Utils/AllSingleton.dart';
import 'dial_number_page_bloc.dart';
import 'dial_number_page_event.dart';
import 'dial_number_page_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Vendor/Sip_flutter/sip_ua.dart';
import 'package:signalr_core/signalr_core.dart';

class DialNumberPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _DialNumberPageState();
  }
}

class _DialNumberPageState extends State<DialNumberPage>  with TickerProviderStateMixin
    implements SipUaHelperListener {

  late AnimationController numPadController;
  late Animation<double> numPadOpacityAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorItemAnimation;

  late DialNumberPageBloc dialNumberPageBloc;

  ///Sip管理
  SIPUAHelper helper = SIPUAHelper();
  ///获取权限
  late SharedPreferences _preferences;
  ///账号
  String user = '';
  ///中继号
  String midNumber = '';
  Call? _call;
  late Timer _timer;
  RTCVideoRenderer? _localRenderer = RTCVideoRenderer();
  ///是否来电
  bool isRinging = false;
  String ringingNumber = '未知';
  /// 初始化HubConnection
  late HubConnection hubConnection;

  bool get _isAnimationRunningForwardsOrComplete{
    switch (numPadController.status) {
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        return true;
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        return false;
    }
  }

  @override
  void initState() {
    dialNumberPageBloc = BlocProvider.of<DialNumberPageBloc>(context);
    user = MySingleton().callerSeatBean?.callerSeatData?.callerSeatAccount??'';
    midNumber = MySingleton().callerSeatBean?.callerSeatData?.callerSeatCaller??'';
    hubConnection = HubConnectionBuilder().withUrl(MySingleton().callerSeatBean?.callerSeatData?.callerSeatUrl??'').build();
    ///拨号键盘动画控制器
    numPadController = AnimationController(value: 0.0, duration: const Duration(milliseconds: 400), vsync: this,);
    numPadController.addStatusListener((status) {
      print(status);
      dialNumberPageBloc.add(RefreshEvent());
    });
    ///拨号键盘透明度渐变
    numPadOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0,).animate(numPadController);
    ///按钮旋转角度
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.375).animate(numPadController);
    ///颜色转变
    _colorItemAnimation = ColorTween(begin: Colors.green,end: Colors.red).animate(numPadController);
    super.initState();
    ///监听状态
    helper.addSipUaHelperListener(this);
    ///配置注册信息
    UaSettings settings = UaSettings();

    settings.webSocketUrl = 'wss://${MySingleton().callerSeatBean?.callerSeatData?.callerSeatHost}:${MySingleton().callerSeatBean?.callerSeatData?.callerSeatPort}';
    settings.register = true;
    settings.uri = 'sip:C${MySingleton().callerSeatBean?.callerSeatData?.callerSeatCid}$user@example.com';
    settings.authorizationUser = 'C${MySingleton().callerSeatBean?.callerSeatData?.callerSeatCid}$user';
    settings.password = MySingleton().callerSeatBean?.callerSeatData?.callerSeatPassword??'';
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;
    helper.start(settings);
    ///登录
    _initSignalR();
  }

  ///登录
  void _initSignalR() async {
    print("Begin Connection");

    try {
      hubConnection.onclose((error) => print("Connection Closed"));
      await hubConnection.start();

      final result =  hubConnection.invoke('Login',args: <Object>[{
        'CID': MySingleton().callerSeatBean?.callerSeatData?.callerSeatCid??'',
        'Agent': '$user',
        'DN': '$user',
        'Password': MySingleton().callerSeatBean?.callerSeatData?.callerSeatPassword??''
      }]);
      print("Result: '$result");
      UISingleton().showBlueLog('登录成功');
    } catch (e) {
      print("连接失败");
    }
    ///响应来电
    hubConnection.on('Ringing', (ringing) async {
      UISingleton().showBlueLog('来电了');
      print("来电了Result: '${ringing?.first['callType']}");
      print("来电了Result: '${ringing?.first['callType'] == 0}");
      ///设置电话号码
      dialNumberPageBloc.state.number = ringing?.first['customer'];
      dialNumberPageBloc.add(RefreshEvent());
      ///判断是否是呼入
      ///0：呼出
      ///1：呼入
      if(ringing?.first['callType'] != 0){
        setState(() {
          ringingNumber = ringing?.first['customer'];
          isRinging = true;
        });
      }else{
        ///设置媒体流
        bool remoteHasVideo = _call?.remote_has_video??false;
        final mediaConstraints = <String, dynamic>{'audio': true, 'video': false};
        MediaStream mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
        ///应答
        _call?.answer(helper.buildCallOptions(!remoteHasVideo),
            mediaStream: mediaStream);
      }
    });
    
  }

  /// 发送消息
  void sendMsg() async {
    if(defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
      await Permission.microphone.request();
      await Permission.camera.request();
    }
    final result = await hubConnection.invoke("Callout", args: <Object>[{
      'Callee': dialNumberPageBloc.state.number,
      'Caller': midNumber,
      'Custom': ''
    }]);
    UISingleton().showBlueLog('打电话了');
    print("Result打电话了: '$result");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => dialNumberPageBloc..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('222223'),
      appBar: CostPreferredSizeWidget(
        title: '拨号',
        elevation: 0.1,
        preferredSize: Size.fromHeight(60.0),
        canActions: true,
        // leadingOnPressed: (){
        //   Navigator.pop(context);
        // },
        canBack: false,
        backgroundColor: HexColor.fromHex('222223'),
        assetPath: GestureDetector(
          onTap: () async {

          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 16.w),
            child: Text('注册:${EnumHelper.getName(helper.registerState.state)}',style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
      body: PageTransitionSwitcher(
        reverse: !isRinging,
        duration: Duration(seconds: 1),
        transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            ) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            fillColor: UISingleton().baseColors[UISingleton().colorsMenu],
            child: child,
          );
        },
        child: isRinging ? RingingPage(///响铃页面
          handUp: () async {
            UISingleton().showBlueLog('接电话了');
            setState(() {
              isRinging = false;
            });
            bool remoteHasVideo = _call?.remote_has_video??false;
            final mediaConstraints = <String, dynamic>{'audio': true, 'video': false};
            MediaStream mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
            _call?.answer(helper.buildCallOptions(!remoteHasVideo),
                mediaStream: mediaStream);
            numPadController.forward();
            _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
              Duration duration = Duration(seconds: timer.tick);
              if (mounted) {
                dialNumberPageBloc.state.timeLabel = [duration.inMinutes, duration.inSeconds]
                    .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
                    .join(':');
              } else {
                _timer.cancel();
              }
              dialNumberPageBloc.add(RefreshEvent());
            });
          },
          handDown: (){
            dialNumberPageBloc.state.number = '';
            dialNumberPageBloc.add(RefreshEvent());
            if(_call != null){
              _call!.hangup({'status_code': 603});
            }
            setState(() {
              isRinging = false;
            });
          },
          ringingNumber: ringingNumber,
        ) : GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            color: UISingleton().baseColors[UISingleton().colorsMenu],
            // height: 0.95.sh,
            padding: EdgeInsets.only(top: UISingleton().statusBarHeight),
            child: Column(
              children: [
                BlocBuilder<DialNumberPageBloc,DialNumberPageState>(
                    bloc: dialNumberPageBloc,
                    builder: (context,state){
                      ///电话号码
                      return Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 1.0.sw,
                                padding: EdgeInsets.only(right: 48.w,left: 48.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dialNumberPageBloc.state.number,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(40),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 8.w,
                                child: AnimatedBuilder(
                                  animation: numPadController,
                                  builder: (BuildContext context,Widget? child){
                                    return Opacity(
                                      opacity: dialNumberPageBloc.state.number == ''?0:numPadOpacityAnimation.value,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular((1.0.sw - 64.w - 32.w)/3),
                                        onLongPress: (){
                                          dialNumberPageBloc.state.number = '';
                                          dialNumberPageBloc.add(RefreshEvent());
                                        },
                                        onTap: (){
                                          dialNumberPageBloc.state.number = dialNumberPageBloc.state.number.substring(0,dialNumberPageBloc.state.number.length - 1);
                                          dialNumberPageBloc.add(RefreshEvent());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.w),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.delete,color: Colors.white,size: 24.w,),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          ///通话时间
                          AnimatedBuilder(
                            animation: numPadController,
                            builder: (BuildContext context,Widget? child){
                              return Opacity(
                                opacity: 1 - numPadOpacityAnimation.value,
                                child: Container(
                                  margin: EdgeInsets.only(top: 8.w),
                                  child: Text(
                                    dialNumberPageBloc.state.timeLabel,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 8.w),
                              child: Text(
                                dialNumberPageBloc.state.timeLabel,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                      // return textField(20.h, dialNumberPageBloc.state.numberTextController, (number) => context.read<DialNumberPageBloc>().add(NumberChanged(number)));
                    }
                ),
                ///拨号盘
                Expanded(
                  child: AnimatedBuilder(
                    animation: numPadController,
                    builder: (BuildContext context, Widget? child){
                      print('动画进度:${numPadController.value}');
                      return Opacity(
                        opacity: numPadOpacityAnimation.value,
                        child: Container(
                          padding: EdgeInsets.only(right: 32.w,top: 24.w,left: 32.w),
                          // color: Colors.green,
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1,
                                  // mainAxisSpacing: (1.0.sw - 32.w - 72.w*3)/2,
                                  crossAxisSpacing: 16.w
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dialNumberPageBloc.state.lables.keys.length,
                              itemBuilder: (BuildContext context,int index){
                                return _buildNumPad()[index];
                              }
                          ),
                        ),
                      );
                    },
                  ),
                ),

                ///拨号按钮
                AnimatedBuilder(
                    animation: numPadController,
                    builder: (BuildContext context, Widget? child){
                      return RotationTransition(
                        turns: _rotationAnimation,
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.all(32.w),
                          // color: Colors.blue,
                          child: IconButton(
                              alignment: Alignment.center,
                              iconSize: 40.w,
                              onPressed: (){
                                FocusScope.of(context).requestFocus(FocusNode());
                                if (_isAnimationRunningForwardsOrComplete) {
                                  ///挂断
                                  dialNumberPageBloc.state.number = '';
                                  dialNumberPageBloc.add(RefreshEvent());
                                  numPadController.reverse();
                                  _timer.cancel();
                                  if(_call != null){
                                    _call!.hangup({'status_code': 603});
                                  }
                                  dialNumberPageBloc.state.timeLabel = '00:00';
                                  dialNumberPageBloc.add(RefreshEvent());
                                } else {
                                  ///拨打电话
                                  if(dialNumberPageBloc.state.number == ''){
                                    ///当没有输入电话号码的时候
                                    UISingleton().showBlueLog('请输入要拨打的号码');
                                  }else{
                                    ///拨打
                                    numPadController.forward();
                                    sendMsg();
                                    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
                                      Duration duration = Duration(seconds: timer.tick);
                                      if (mounted) {
                                        dialNumberPageBloc.state.timeLabel = [duration.inMinutes, duration.inSeconds]
                                            .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
                                            .join(':');
                                      } else {
                                        _timer.cancel();
                                      }
                                      dialNumberPageBloc.add(RefreshEvent());
                                    });
                                  }
                                }
                              },
                              icon: Icon(Icons.phone,color: _colorItemAnimation.value)
                          ),
                        ),
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///输入框
  Widget textField(double top,TextEditingController textController,ValueChanged<String>? onChanged){
    return Container(
      margin: EdgeInsets.only(top: top,),
      child: TextField(
        inputFormatters: [LengthLimitingTextInputFormatter(11),FilteringTextInputFormatter.digitsOnly],//只允许输入数字
        autofocus: false,
        controller: textController,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(24),
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(14),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 16.w,
            minHeight: 16.w,
          ),
        ),
      ),
    );
  }

  ///每个拨号按钮
  List<Widget> _buildNumPad() {
    List<Widget> numPad = [];
    for(String key in dialNumberPageBloc.state.lables.keys){
      numPad.add(
          InkWell(
            borderRadius: BorderRadius.circular((1.0.sw - 64.w - 32.w)/3),
            onTap: (){
              print(key);
               if(numPadController.value == 0){
                FocusScope.of(context).requestFocus(FocusNode());
                dialNumberPageBloc.state.number = '${dialNumberPageBloc.state.number}$key';
                dialNumberPageBloc.add(RefreshEvent());
              }
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              // height: (1.0.sw - 64.w - 32.w)/3,
              // width: (1.0.sw - 64.w - 32.w)/3,
              // color: Colors.blue,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    key,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(32)
                    ),
                  ),
                  Offstage(
                    offstage: key == '*' || key == '#',
                    child:  Container(
                      margin: EdgeInsets.only(top: 8.w),
                      child: Text(
                        dialNumberPageBloc.state.lables[key]!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      );
    }
    return numPad;
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    setState(() {});
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  Future<void> callStateChanged(Call call, CallState callState) async {
    _call = call;
    print('电话状态:${callState.state}');
    switch (callState.state) {
      case CallStateEnum.STREAM:
        MediaStream? stream = callState.stream;
        if (_localRenderer != null) {
          await _localRenderer!.initialize();
        }
        if (callState.originator == 'local') {
          if (_localRenderer != null) {
            _localRenderer!.srcObject = stream;
          }
          if (!kIsWeb && !WebRTC.platformIsDesktop) {
            callState.stream?.getAudioTracks().first.enableSpeakerphone(false);
          }
        }
        break;
      case CallStateEnum.ENDED:
      case CallStateEnum.FAILED:
        UISingleton().showBlueLog('挂断了');
        setState(() {
          isRinging = false;
        });
        numPadController.reverse();
        _timer.cancel();
        if(_call != null) _call!.hangup({'status_code': 603});
        dialNumberPageBloc.state.timeLabel = '00:00';
        dialNumberPageBloc.add(RefreshEvent());
        break;
      case CallStateEnum.UNMUTED:
      case CallStateEnum.MUTED:
      case CallStateEnum.CONNECTING:

        break;
      case CallStateEnum.PROGRESS:
      case CallStateEnum.ACCEPTED:
      case CallStateEnum.CONFIRMED:
      case CallStateEnum.HOLD:
      case CallStateEnum.UNHOLD:
      case CallStateEnum.NONE:
      case CallStateEnum.CALL_INITIATION:
      case CallStateEnum.REFER:
        break;
    }
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    //Save the incoming message to DB
    String? msgBody = msg.request.body as String?;
  }

  @override
  void onNewNotify(Notify ntf) {

  }

  @override
  void dispose() {
    // TODO: implement dispose
    dialNumberPageBloc.state.numberTextController.text = '';
    dialNumberPageBloc.state.numberTextController = TextEditingController();
    dialNumberPageBloc.state.number = '';
    _timer.cancel();
    if (_localRenderer != null) {
      _localRenderer!.dispose();
      _localRenderer = null;
    }
    super.dispose();
  }
}

