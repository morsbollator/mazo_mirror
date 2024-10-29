import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:test_cam/navigation.dart';
import 'package:test_cam/sig.dart';

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'camera_start.dart';
import 'models/mirror.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScreenshotController screenshotController = ScreenshotController();
  double x1 = 100.0, x2 = 200.0, y1 = 100.0,
      y2 = 200.0, x1Prev = 100.0, x2Prev = 200.0, y1Prev = 100.0,
      y2Prev = 100.0;
  int selected = -1;
  CarouselController filtersScroll = CarouselController();
  var img = AssetImage('assets/success.gif');
  bool revers = false;

  double right = -20.w;
  DateTime now = DateTime.now();
  bool tap = false;
  bool taped = false;
  Timer? increase;
  double zoom = 1;

  List<String> lastFilter = [];
  XFile? file;


  int tapedCounter = 5;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 10)).then((value) {
      setState(() {

      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      // await windowManager.ensureInitialized();
      // await WindowManager.instance.setFullScreen(true);
      // await windowManager.setAsFrameless();
      Future.delayed(Duration(seconds: 10)).then((value) {
        setState(() {

        });
      });
      // await windowManager.hide();
    });
  }

  Future captu()async{
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Row(
            children: [
              Text('Processing...',
                style: TextStyle(color: Colors.black,
                    fontSize: 12.sp),),
              SizedBox(width: 5.w,),
              CircularProgressIndicator(),
            ],
          ),
        );
      }
    );

    file = await CameraPlatform.instance.takePicture(cameraIdPublic);
    Uint8List im = await file!.readAsBytes();
    // Navigator.pop(context);
    // Navigator.push(context, MaterialPageRoute(builder:
    //     (ctx)=>ImagePreview(image: im))).then((value) async{
    //   await clickList(lastFilter);
    //   selected = -1;
    //   setState(() {
    //
    //   });
    // });
    // Navigator.pop(context);
    // Navigator.push(context, MaterialPageRoute(builder:
    //     (ctx)=>ImagePreview(image: im))).then((value) async{
    //   await clickList(lastFilter);
    //   selected = -1;
    //   setState(() {
    //
    //   });
    // });
    screenshotController
        .captureFromWidget(body(false))
        .then((capturedImage) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder:
          (ctx)=>ImagePreview(image: capturedImage))).then((value) async{
        await clickList(lastFilter);
            selected = -1;
            setState(() {

            });
      });

    });
  }
  bool hiddenZoom = true;
  List<Map> imojies = [];
  bool timerStart = false;
  double pos = 0;
  // double pos = -100;
  Timer? t;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: body(true),

    );
  }
  Widget body(bool show){
    print(zoom);
    return Stack(
      children: [


        if(show)Positioned(
          top: pos,
          child: Container(
            width: 100.w,
            height: 100.h,
            color: Colors.black.withOpacity(0.2),
            child: Transform.scale(
              scale: zoom,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(185),
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(90 / 360),
                  child: Transform.scale(
                    // scale: 1,
                    scaleX: 1.765,
                    scaleY: 0.6,
                    child: SizedBox(width: 100.w,height: 100.h
                      ,child: buildPreview(),),
                  ),
                ),
              ),
            ),
          ),
        ),

        if(!show)Positioned(
          top: pos,
          child: Container(
            width: 100.w,
            height: 100.h,
            color: Colors.black.withOpacity(0.2),
            child: Transform.scale(
              scale: zoom,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(185),
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(270 / 360),
                  child: Transform.scale(
                    // scale: 1,
                    scaleX: 1.765,
                    scaleY: 0.6,
                    child: SizedBox(width: 100.w,height: 100.h
                      ,child: Image.file(File(file!.path),width: 100.w,
                        height: 100.h,fit: BoxFit.fill,),),
                  ),
                ),
              ),
            ),
          ),
        ),
        if(show&&mirror.order!=null)Positioned(
          top: 0.h,
          child: StatefulBuilder(
            builder: (context,set) {
              if(tapedCounter==0&&t!=null){
                t!.cancel();
                timerStart = false;
                taped = false;
                t = null;
                // captu();

              }
              if(taped&&!timerStart){
                timerStart = true;

                t = Timer.periodic(Duration(seconds: 1), (timer) async{
                  if(tapedCounter>0){
                    tapedCounter--;
                  }
                  if(tapedCounter==0){
                    timer.cancel();
                    await captu();
                    timerStart = false;
                    taped = false;
                  }else{

                  }
                  set(() {

                  });
                });
              }
              return InkWell(
                onTap: (){
                  if(!taped){
                    taped = true;
                    tapedCounter = 5;
                    set((){

                    });
                  }
                },
                onDoubleTap: (){
                  setState((){
                    hiddenZoom = !hiddenZoom;
                  });
                },
                onLongPress: (){
                  navPop();
                },
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(taped)AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          tapedCounter.toString(),
                          key: ValueKey<int>(tapedCounter),
                          style: TextStyle(color:
                          Colors.white.withOpacity(0.6),
                              fontSize: 130.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      // if(taped)Text(tapedCounter.toString(),style: TextStyle(color:
                      // Colors.white.withOpacity(0.6),fontSize: 70.sp,
                      //     fontWeight: FontWeight.bold),),
                      if(taped)SizedBox(height: 10.h,),
                      if(!taped)Icon(Icons.camera,
                        color: Colors.white.withOpacity(0.6),
                      size: 90,),
                      if(!taped)Text('Tap To Capture',
                        style: TextStyle(color: Colors.white.withOpacity(0.6),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              );
            }
          ),
        ),
        if(show&&mirror.order!=null)Positioned(
          top: 9.h,
          child: Container(
            height: 10.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: StatefulBuilder(
                builder: (context,set) {
                  return CarouselSlider(
                    carouselController: filtersScroll,
                    options: CarouselOptions(
                      viewportFraction: 0.12,
                      enableInfiniteScroll: true,
                      autoPlay: false,
                    ),
                    items: List.generate(mirror.order!.filters.length, (i) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        overlayColor: MaterialStateProperty
                            .all(Colors.transparent),
                        highlightColor: Colors.transparent,
                        onTap: ()async{
                          if(!tap&&!taped){
                            tap = true;
                            List<String> list = [];
                            list.add(mirror.order!.filters[i].key1);
                            if(mirror.order!.filters[i].key2!=null){
                              list.add(mirror.order!.filters[i].key2!);
                            }
                            if(mirror.order!.filters[i].key3!=null){
                              list.add(mirror.order!.filters[i].key3!);
                            }
                            list.add(mirror.order!.filters[i].key4);
                            lastFilter = list;
                            await clickList(list);
                            if(selected==i){
                              lastFilter = [];
                              set(() {
                                selected = -1;
                              });
                            }else{
                              filtersScroll.animateToPage(i,duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                              set(() {
                                selected = i;
                              });
                            }
                            tap = false;
                          }

                        },
                        onDoubleTap: ()async{
                          if(!tap&&!taped){
                            tap = true;
                            await clickList(lastFilter);
                            set(() {
                              lastFilter = [];
                              selected = -1;
                            });
                            tap = false;
                          }
                        },
                        child: Padding(
                          padding: selected==i?EdgeInsets.only(bottom: 3.h):EdgeInsets.zero,
                          child: Container(
                            width: selected==i?12.w:10.w,
                            height: selected==i?12.w:10.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white,width:
                              selected==i?5:1),
                              // color: Colors.red
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(selected==i?8:12),
                              child: Image.network(mirror.order!.filters[i].image),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }
            ),
          ),
        ),
        if(show&&hiddenZoom)Positioned(
          top: 3.5.h,
          child: SizedBox(
            width: 100.w,
            child: Slider(
              value: zoom,
              min: 1,
              max: 3,
              activeColor: Colors.white,
              divisions: 10,
              onChanged: (double value) {
                // pos = -100;
                zoom = value;
                // if(pos>zoom*200){
                //   pos = zoom*200;
                // }
                while(pos>zoom*200){
                  pos -= 30;
                }
                while(pos<zoom*-200){
                  pos += 30;
                }
                setState(() {

                });
              },
            ),
          ),
        ),
        if(show&&hiddenZoom)Positioned(
          top: 20.h,
          right: 3.w,
          child: RotatedBox(
            quarterTurns: 3,
            child: SizedBox(
              width: 70.h,
              height: 5.w,
              child: Slider(
                value: pos,
                min: zoom*-200,
                max: zoom*200,
                activeColor: Colors.white,
                divisions: 30,
                onChanged: (double value) {
                  setState(() {
                    pos = value;
                  });
                },
              ),
            ),
          ),
        ),


      ],
    );
  }


}
Future clickList(List<String> buttons)async{
  print('hamza click');

  for(var b in buttons){
    click(data[b]??0, false);

  }
  for(var b in buttons){

    click(data[b]??0, true);

  }
}

void click(int key,bool up){
  try{
    final pInputs = calloc<INPUT>();
    pInputs.ref.type = INPUT_KEYBOARD;
    pInputs.ref.ki.wVk = key;
    pInputs.ref.ki.dwFlags = up?KEYEVENTF_KEYUP:0;
    SendInput(1, pInputs, sizeOf<INPUT>());
    calloc.free(pInputs);
  }catch(e){
    print(e);
  }
}
List<String> cher = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
];
Map<String,int> data = {
  "SHIFT":16,
  "Enter":13,
  "SPACE":32,
  "CTRL":17,
  "ALT":18,
  "TAB":9,
  "UP":38,
  "0":48,
  "1":49,
  "2":50,
  "3":51,
  "4":52,
  "5":53,
  "6":54,
  "7":55,
  "8":56,
  "9":57,
  "A":65,
  "B":66,
  "C":67,
  "D":68,
  "E":69,
  "F":70,
  "G":71,
  "H":72,
  "I":73,
  "J":74,
  "K":75,
  "L":76,
  "M":77,
  "N":78,
  "O":79,
  "P":80,
  "Q":81,
  "R":82,
  "S":83,
  "T":84,
  "U":85,
  "V":86,
  "W":87,
  "X":88,
  "Y":89,
  "Z":90,
  "0N":96,
  "1N":97,
  "2N":98,
  "3N":99,
  "4N":100,
  "5N":101,
  "6N":102,
  "7N":103,
  "8N":104,
  "9N":105,
  "F1":112,
  "F2":113,
  "F3":114,
  "F4":115,
  "F5":116,
  "F6":117,
  "F7":118,
  "F8":119,
  "F9":120,
  "F10":121,
  "F11":122,
  "F12":123,
  "F13":124,
  "F14":125,
  "F15":126,
  "F16":127,
};
