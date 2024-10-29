

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sound_record_platform_interface/flutter_sound_record_platform_interface.dart';
import 'package:sizer/sizer.dart';
import 'package:test_cam/home.dart';
import 'package:test_cam/input_view.dart';
import 'package:test_cam/models/mirror.dart';
import 'package:test_cam/var.dart';

import 'package:window_manager/window_manager.dart';

import 'camera_start.dart';

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}
void main() async{
  await Mirror.getMirror();
  runApp(const MyApp());
}

/// Example app for Camera Windows plugin.
class MyApp extends StatefulWidget {
  /// Default Constructor
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    fetchCameras();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await windowManager.ensureInitialized();
      await WindowManager.instance.setFullScreen(true);
      await windowManager.setAsFrameless();
      // FlutterSoundRecordPlatform.instance = MyFlutterSoundRecordPlatform();
      // FlutterSoundRecordPlatform.instance ;
      // await windowManager.hide();
    });
  }
  @override
  Widget build(BuildContext context) {


    return Sizer(
      builder: (context,orientation, deviceType) {
        return MaterialApp(
          navigatorKey: GlobalVariable.navState,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(

              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child:  Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              ),
            );
          },
          home: InputView(),
        );
      }
    );
  }
}

