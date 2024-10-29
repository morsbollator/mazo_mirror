import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';
import 'package:sizer/sizer.dart';
import 'package:test_cam/camera_start.dart';
class BoomPage extends StatefulWidget {
  const BoomPage({Key? key}) : super(key: key);

  @override
  State<BoomPage> createState() => _BoomPageState();
}

class _BoomPageState extends State<BoomPage> {
  int tapedCounter = 5;
  bool timerStart = false;
  Timer? t;
  bool taped = false;
  bool startDown = false;
  String? gif;
  late String outputPath;
  CountDownController controller = CountDownController();
  Future startRe()async{
    await CameraPlatform.instance.startVideoRecording(cameraIdPublic);
  }
  Future stopRe()async{
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
    final XFile file =
    await CameraPlatform.instance.stopVideoRecording(cameraIdPublic);
    String gifOut = 'C:\\Mirror\\boom${(DateTime.now().toIso8601String().split('.').first.replaceAll(':', '-'))}.gif';
    // var f = await Shell().run('ffmpeg -i ${file.path} -filter_complex "[0:v]reverse,split=3[r1][r2][r3];[0:v][r1][0:v][r2][0:v][r3] concat=n=6:v=1,transpose=3[v]" -map "[v]"  -preset ultrafast  D:\\Video\\boom${(DateTime.now().toIso8601String().split('.').first.replaceAll(':', '-'))}.mp4');
    outputPath = 'C:\\Mirror\\boom${(DateTime.now().toIso8601String().split('.').first.replaceAll(':', '-'))}.mp4';
    var v = await Shell().run('ffmpeg -i ${file.path} -filter_complex "[0:v]reverse,split=3[r1][r2][r3];[0:v][r1][0:v][r2][0:v][r3] concat=n=6:v=1,transpose=3,setpts=0.5*PTS,scale=1080:-1" -gifflags +transdiff -y -pix_fmt rgb24 $gifOut');
    var g = await Shell().run('ffmpeg -i ${file.path} -filter_complex "[0:v]reverse,split=3[r1][r2][r3];[0:v][r1][0:v][r2][0:v][r3] concat=n=6:v=1,transpose=3,setpts=0.5*PTS[v]" -map "[v]" -preset ultrafast $outputPath');


    gif = gifOut;
    Navigator.pop(context);
    setState(() {

    });
  }
  // Future<void> _recordTimed(int seconds) async {
  //   if (_initialized && _cameraId > 0 && !_recordingTimed) {
  //     CameraPlatform.instance
  //         .onVideoRecordedEvent(_cameraId)
  //         .first
  //         .then((VideoRecordedEvent event) async {
  //       if (mounted) {
  //         setState(() {
  //           _recordingTimed = false;
  //         });
  //
  //         _showInSnackBar('Video captured to: ${event.file.path}');
  //       }
  //     });
  //
  //     await CameraPlatform.instance.startVideoRecording(
  //       _cameraId,
  //       maxVideoDuration: Duration(seconds: seconds),
  //     );
  //
  //     if (mounted) {
  //       setState(() {
  //         _recordingTimed = true;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if(gif==null)Container(
            width: 100.w,
            height: 100.h,
            color: Colors.black.withOpacity(0.2),
            child: Transform.scale(
              scale: 0.7,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(185),
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(90 / 360),
                  child: Transform.scale(
                    // scale: 1,
                    scaleX: 2.38,
                    scaleY: 0.95,
                    child: SizedBox(width: 100.w,height: 100.h
                      ,child: buildPreview(),),
                  ),
                ),
              ),
            ),
          ),
          if(gif==null)if(!startDown)Positioned(
            top: 0.h,
            child: StatefulBuilder(
                builder: (context,set) {
                  if(tapedCounter==0&&t!=null){
                    t!.cancel();
                    startDown = false;
                    timerStart = true;
                    taped = false;
                    t = null;
                    setState(() {

                    });
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
                        startDown = true;
                        startRe();
                        timerStart = false;
                        taped = false;
                      }else{

                      }

                      setState(() {

                      });
                    });
                  }
                  return InkWell(
                    onTap: (){
                      if(!taped){
                        taped = true;
                        startDown = false;
                        tapedCounter = 3;
                        timerStart = false;
                        t = null;
                        setState(() {

                        });
                      }
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
                          if(!taped)Icon(Icons.video_call,
                            color: Colors.white.withOpacity(0.6),
                            size: 90,),
                          if(!taped)Text('Tap To Record',
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
          if(gif==null)Positioned(
            top: 3.h,
            left: 5.w,
            child: InkWell(
              onTap: ()async{
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white,width: 1.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                        child: Container(
                          color: Colors.white.withOpacity(0.1),
                          child: Center(
                            child: Icon(Icons.arrow_back,size: 35,color: Colors.white,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if(gif==null)if(startDown)Positioned.fill(
            child: Builder(
              builder: (context) {
                // Future.delayed(Duration(seconds: 1)).then((value) => controller.start());
                return Container(
                  width: 100.w,
                  height: 100.h,
                  child: Center(
                    child: CircularCountDownTimer(
                      duration: 2,
                      initialDuration: 0,
                      controller: controller,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 2,
                      ringColor: Colors.grey[300]!.withOpacity(0.5),
                      ringGradient: null,
                      fillColor: Colors.orangeAccent,
                      fillGradient: null,
                      backgroundColor: Colors.grey.
                      shade300.withOpacity(0.3),
                      backgroundGradient: null,
                      strokeWidth: 20.0,
                      strokeCap: StrokeCap.round,
                      textStyle: TextStyle(
                          fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
                      textFormat: CountdownTextFormat.S,
                      isReverse: false,
                      isReverseAnimation: false,
                      isTimerTextShown: true,
                      autoStart: true,
                      onStart: () {
                        debugPrint('Countdown Started');
                      },
                      onComplete: () {
                        stopRe();
                       setState(() {
                         taped = false;
                         startDown = false;
                         tapedCounter = 3;
                         timerStart = false;
                         t = null;
                       });
                      },
                      onChange: (String timeStamp) {
                        debugPrint('Countdown Changed $timeStamp');
                      },
                      timeFormatterFunction: (defaultFormatterFunction, duration) {
                        if (duration.inSeconds == 0) {
                          return duration.inSeconds.toString();
                        } else {
                          return Function.apply(defaultFormatterFunction, [duration]);
                        }
                      },
                    ),
                  ),
                );
              }
            ),
          ),

          if(gif!=null)Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(gif!)),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w,
                  vertical: 9.h),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context,outputPath);
                      },
                      child: Container(
                        width: 40.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text('طباعة',style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          gif = null;
                        });
                      },
                      child: Container(
                        width: 40.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text('التسجيل مجددا',style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
