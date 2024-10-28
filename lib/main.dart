import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mazo/home_page.dart';
import 'package:mazo/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'image_provider.dart';
import 'api.dart';
import 'constants.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await startSharedPref();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom]);
  await ApiHandel.getInstance.init();

  runApp(MyApp());
  // await DesktopWindow.setWindowSize(Size(350*2,623*2));
}

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {


  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ImgProvider()),
          ChangeNotifierProvider(create: (context) => OrderProvider()),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            print(100.w);
            print(100.h);
            return MaterialApp(
                // title: 'MAZO',
                debugShowCheckedModeBanner: false,
                navigatorObservers: [routeObserver],
                navigatorKey: Constants.navState,
                builder: (context, child) {
                  return Container(
                    color: Colors.white,
                    child: SizedBox(width: 100.w, height: 100.h, child: Stack(children: [
                      child!,
                    ],),),
                  );
                },

                home:  const HomePage());
          },
        ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
