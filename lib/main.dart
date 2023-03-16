import 'package:animations/animations.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_toolbox/Projects/GaussianBlur/bloc.dart';
import 'package:my_toolbox/Projects/Login/login_page_bloc.dart';
import 'package:my_toolbox/Projects/Login/login_page_view.dart';
import 'CustomWidget/CostPreferredSizeWidget.dart';
import 'Projects/BottomBar/ScaleBottomNavigationBar.dart';
import 'Projects/CustomerServiceCenter/Home/csc_home_page_bloc.dart';
import 'Projects/CustomerServiceCenter/Login/csclogin_page_bloc.dart';
import 'Projects/CustomerServiceCenter/Login/csclogin_page_view.dart';
import 'Projects/GaussianBlur/view.dart';
import 'Projects/Sip/DialNumber/dial_number_page_bloc.dart';
import 'package:sp_util/sp_util.dart';
import 'Projects/Sip/DialNumber/dial_number_page_view.dart';
import 'Utils/AllSingleton.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // debugProfileBuildsEnabled = true;
  await SpUtil.getInstance();
  runApp(MultiBlocProvider(
    providers: [
      ///登录bloc
      BlocProvider<DialNumberPageBloc>(
        create: (BuildContext context) => DialNumberPageBloc(),
      ),
      BlocProvider<CscHomePageBloc>(
        create: (BuildContext context) => CscHomePageBloc(),
      ),
      BlocProvider<CscLoginPageBloc>(
        create: (BuildContext context) => CscLoginPageBloc(),
      ),
      BlocProvider<LoginPageBloc>(
        create: (BuildContext context) => LoginPageBloc(),
      ),
      BlocProvider<GaussianBlurPageBloc>(
        create: (BuildContext context) => GaussianBlurPageBloc(),
      ),
    ],
    child: ScreenUtilInit(
      designSize: const Size(375, 813),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData.from(
            colorScheme: const ColorScheme.light(),
          ).copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            ),
          ),
          home: HomePage(),
        );
      },
    ),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: DialNumberPageBloc(),

        /// ignore: non_constant_identifier_names
        builder: (_, InitialState) {
          ///警告:不要随意调整调用BotToastInit函数的位置
          final botToastBuilder = BotToastInit();

          ///1.调用BotToastInit
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: '医脉相诚',
                theme: ThemeData(fontFamily: 'MicrosoftYaHei'),
                debugShowCheckedModeBanner: false,
                home:Scaffold(
                  appBar: CostPreferredSizeWidget(
                    title: '我的工具箱',
                    elevation: 0.1,
                    preferredSize: Size.fromHeight(60.0),
                    assetPath: GestureDetector(
                      onTap: () async {
                
                      },
                      child: Container(
                        height: 24.w,
                        width: 24.w,
                        margin: EdgeInsets.only(right: 16.w),
                        // color: Colors.blue,
                        child: Image.asset('assets/png/icon_delete.png'),
                      ),
                    ),
                  ),
                  body: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            HomeListOpenContainer(
                                transitionType: ContainerTransitionType.fade,
                                openBuilder: (BuildContext _, VoidCallback openContainer) {
                                  return ScaleBottomNavigationBar();
                                },
                                title: '缩放底部导航栏'
                            ),
                            HomeListOpenContainer(
                                transitionType: ContainerTransitionType.fade,
                                openBuilder: (BuildContext _, VoidCallback openContainer) {
                                  return DialNumberPage();
                                },
                                title: 'Sip网络电话'
                            ),
                            HomeListOpenContainer(
                                transitionType: ContainerTransitionType.fade,
                                openBuilder: (BuildContext _, VoidCallback openContainer) {
                                  return CscLoginPage();
                                },
                                title: 'Web端客服中心'
                            ),
                            HomeListOpenContainer(
                                transitionType: ContainerTransitionType.fade,
                                openBuilder: (BuildContext _, VoidCallback openContainer) {
                                  return LoginPage();
                                },
                                title: '登录动画'
                            ),
                            HomeListOpenContainer(
                                transitionType: ContainerTransitionType.fade,
                                openBuilder: (BuildContext _, VoidCallback openContainer) {
                                  return GaussianBlurPage();
                                },
                                title: '高斯模糊'
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // home: LoginPage(),

                navigatorObservers: [BotToastNavigatorObserver()],
                builder: (BuildContext context, Widget? child) {
                  child = botToastBuilder(context, child);

                  UISingleton().statusBarHeight =
                      MediaQuery.of(context).padding.top;
                  UISingleton().safeHeight = 1.0.sh;
                  return child;
                },
                routes: <String, WidgetBuilder>{
                  "/home": (BuildContext context) => HomePage(),
                },
              );
            },
          );
        });
  }
}

class HomeListOpenContainer extends StatelessWidget {
  const HomeListOpenContainer({
    required this.transitionType,
    required this.openBuilder,
    required this.title,
  });

  final ContainerTransitionType transitionType;
  final CloseContainerBuilder openBuilder;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: OpenContainer<bool>(
        transitionType: transitionType,
        openElevation: 8.0,
        transitionDuration: const Duration(milliseconds: 700),
        openShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        // openColor: Color.fromRGBO(24, 25, 31, 1),
        openBuilder: openBuilder,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.w),
            child: Text(title),
          );
        },
        // closedColor: Colors.red,
        closedElevation: 4.0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
