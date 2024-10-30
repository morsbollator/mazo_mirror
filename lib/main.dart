import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mazo/home_page.dart';
import 'package:mazo/navigation.dart';
import 'package:mazo/order_provider.dart';
import 'package:mazo/printing_page.dart';
import 'package:mazo/uploading_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:window_manager/window_manager.dart';

import 'image_provider.dart';
import 'api.dart';
import 'constants.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await startSharedPref();
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom]);
  await ApiHandel.getInstance.init();

  runApp(MyApp());
  // await DesktopWindow.setWindowSize(Size(350*2,623*2));
}

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatefulWidget {


  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await windowManager.ensureInitialized();
      await WindowManager.instance.setFullScreen(true);
      // await WindowManager.instance.setSize(Size(1080/3,1920/3));
      await windowManager.setAsFrameless();
      navP(HomePage());
      // FlutterSoundRecordPlatform.instance = MyFlutterSoundRecordPlatform();
      // FlutterSoundRecordPlatform.instance ;
      // await windowManager.hide();
    });
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ImgProvider()),
          ChangeNotifierProvider(create: (context) => OrderProvider()),
        ],
        child: LayoutBuilder(
          builder: (context,a) {
            return Sizer(
              builder: (context, orientation, deviceType) {
                print(100.w);
                print(100.h);
                return MaterialApp(
                    // title: 'MAZO',
                    debugShowCheckedModeBanner: false,
                    navigatorObservers: [routeObserver],
                    navigatorKey: Constants.navState,
                    builder: (context, child) {
                      return Stack(
                        children: [
                          child!,
                        ],
                      );
                    },

                    home:  Container(
                      width: 100.w,
                      height: 100.h,
                      color: Colors.black,
                    ));
              },
            );
          }
        ));
  }
}




class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
