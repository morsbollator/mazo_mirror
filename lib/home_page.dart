import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mazo/image_provider.dart';
import 'package:mazo/navigation.dart';
import 'package:mazo/order_provider.dart';
import 'package:mazo/select_gender.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player_win/video_player_win.dart';
import 'package:window_manager/window_manager.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WinVideoPlayerController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // await DesktopWindow.setWindowSize(Size(350,623));
    Provider.of<OrderProvider>(context,listen: false).getOrder();
    Provider.of<ImgProvider>(context,listen: false).loadLinks();
    controller = WinVideoPlayerController.file(File('C:\\mirror\\video.mp4'));

    // controller.setLooping(true);
    controller.initialize().then((value) {
      if (controller.value.isInitialized) {

        // controller.setLooping(true);
        controller.play();
        controller.setLooping(true);
        setState(() {

        });
        controller.addListener((){
          if(controller.value.duration.compareTo(controller.value.position).isNegative){
            controller.pause();
            controller.seekTo(Duration(milliseconds: 0)).then((val){
              controller.play();
            });

          }
        });
      } else {

      }
    }).catchError((e) {

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: (){
          navP(SelectGender());
        },
        child: Container(
          width: 100.w,
          height: 100.h,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/home.gif'),
          //     fit: BoxFit.fill,
          //   ),
          // ),
          child: controller.value.isInitialized?WinVideoPlayer(controller):SizedBox(),
        ),
      ),
    );
  }
}
