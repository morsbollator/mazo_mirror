import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_voice_recorder/flutter_voice_recorder.dart';
// import 'package:flutter_sound_record_platform_interface/flutter_sound_record_platform_interface.dart';
// import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:flutter_desktop_audio_recorder/flutter_desktop_audio_recorder.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:process_run/process_run.dart';
// import 'package:record/record.dart';
import 'package:record/record.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';
import 'package:test_cam/api.dart';
import 'package:test_cam/boom.dart';
import 'package:test_cam/input_view.dart';
import 'package:test_cam/models/mirror.dart';
import 'package:test_cam/navigation.dart';
import 'package:test_cam/var.dart';
import 'package:test_cam/widget.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import 'buttons.dart';

class ImagePreview extends StatefulWidget  {
  final Uint8List image;
  const ImagePreview({required this.image,Key? key}) : super(key: key);
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview>  with TickerProviderStateMixin{
  SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportPenColor: Colors.black,
  );
  Uint8List? capImg;
  ScreenshotController screenshotController = ScreenshotController();
  List<Map> imojies = [];
  int printCounter = 1;
  int selectedFrame = 0;
  double right = -20.w;
  Color color = Colors.black;
  double strok = 5;
  Timer? increase;
  File? audioSend;
  late String au;
  bool isRecord = false;
  final AudioRecorder record = AudioRecorder();
  // late FlutterVoiceRecorder recorder ;
  // FlutterDesktopAudioRecorder record = FlutterDesktopAudioRecorder();
  final player = AudioPlayer();
  bool recordTap = false;
  bool isPlaying = false;
  String? boomPath;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;


  late AnimationController _controller3;
  late AnimationController _controller2;
  late Animation<double> _translateAnimation;
  late Animation<double> _rotateAnimation;
  bool finish =false;
  String? qrAnimation;
  Future _record() async {
    // if (await record.hasPermission()) {
    //
    // }
    audioSend = null;
    duration = Duration.zero;
    position = Duration.zero;
    // Start recording
    au = 'C:\\Mirror\\audio${(DateTime.now().toIso8601String().split('.').first.replaceAll(':', '-'))}.m4a';
    // final Record record = Record();
    // bool hasPermission = await FlutterVoiceRecorder.hasPermissions;
    // print('hamza 3');
    // recorder = FlutterVoiceRecorder(au,audioFormat: AudioFormat.WAV); // .wav .aac .m4a
    // print('hamza 2');
    // await recorder.initialized;
    // await recorder.start();
    await record.start(
      const RecordConfig(),
      path: au,

      // fileName: 'mirror2',
      // encoder: AudioEncoder.wav, // by default
      // bitRate: 128000, // by default
      // samplingRate: 44100,// by default
    );

  }
  String formatTime(int seconds) {
    print("Duration(seconds: seconds)");
    print(Duration(seconds: seconds));
    return '${(Duration(seconds: seconds))}'.split('.')[0].substring(2).padLeft(1, '0');
  }
  Future _stop() async {
    String? path = await record.stop()??"";
    // Recording? result = await recorder.stop();
    // String path = result!.path;
    // File file = widget.localFileSystem.file(result!.path);
    File file = File(path);

    if (file.existsSync()) {
      print('File exists at $path');
    } else {
      print('File does not exist at $path');
    }
    print('hamza path $path');
    duration = Duration.zero;
    position = Duration.zero;
    var v = await Shell().run('ffmpeg -i ${au} -acodec mp3 -ab 192k ${au.replaceAll('m4a', 'mp3')}');
    print('hamza');
    au = au.replaceAll('m4a', 'mp3');
    audioSend = File(au);
    player.setSourceDeviceFile(au);
    await Future.delayed(Duration(seconds: 1));

  }
  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }
  Future toggleRecording() async {
    if (isRecord) {
      await _record();
    } else {
      await _stop();
    }

  }

  Future captu()async{
    loading(context);

    screenshotController
        .captureFromWidget(MediaQuery(
      data: MediaQueryData(),
          child: body(false,null),
        ))
        .then((capturedImage) async{

      final path = 'C:\\Mirror\\Screenshot_${(DateTime.now().toIso8601String().split('.').first.replaceAll(':', '-'))}.png';
      File(path).writeAsBytesSync(capturedImage);

      String? qr = await Mirror.uploadData(path, boomPath, audioSend);
      screenshotController
          .captureFromWidget(MediaQuery(
        data: MediaQueryData(),
        child: body(false,qr),
      ))
          .then((capturedImage2) async{


        try{
          final path = 'C:\\Mirror\\Ssscreenshot_${(DateTime.now().toIso8601String().split('.').first.replaceAll(':', '-'))}.png';
          File(path).writeAsBytesSync(capturedImage2);


          for(int i=0;i<printCounter;i++){
            Shell().run('rundll32 shimgvw.dll,ImageView_PrintTo /pt "$path" "mazo" /f 105 148.5');
          }
        }catch(e){
          print('hamza error e');
          print(e);
        }
        if(isBooth){
          navPRRU(InputView());
        }else{
          // qrAnimation = qr;
          // setState(() {
          //
          // });
          // navPop();
          // navPop();
          // _controller3.forward();
          // _controller2.forward();
          // _controller2.addStatusListener((status) {
          //   if (status == AnimationStatus.completed) {
          //     _controller2.stop();
          //
          //     setState(() {
          //
          //       finish = true;
          //     });
          //   }
          // });
        }
        // Navigator.popUntil(context, (route) => route.isFirst);
      });


      if(isBooth){

      }
      else{

        qrAnimation = qr;
        setState(() {

        });
        navPop();
        navPop();
        _controller3.forward();
        _controller2.forward();
        _controller2.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller2.stop();

            setState(() {

              finish = true;
            });
          }
        });
      }

    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller3 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _translateAnimation = Tween<double>(
      begin: 100.h,
      end: 50.h / 2-500,
    ).animate(_controller3);

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 6, // Number of rotations
    ).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.easeInOut, // Use a custom easing curve
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: body(true,null)
    );
  }
  Widget body(bool show,String? qr){
    return Transform.scale(
      // scale: 1,
      scale: show?1:1.45,
      child: Stack(
        children: [
          Center(
            child: StatefulBuilder(
                builder: (context,set) {
                  return Row(
                    children: [
                      // if(show&&mirror.order!.frames.isNotEmpty&&mirror.order!.frames.length>1)SizedBox(
                      //   width: 12.w,
                      //   child: InkWell(
                      //     onTap: ()async{
                      //       if(selectedFrame==mirror.order!.frames.length-1){
                      //         selectedFrame = 0;
                      //       }else{
                      //         selectedFrame++;
                      //       }
                      //       set((){});
                      //     },
                      //     child: Padding(
                      //       padding: EdgeInsets.all(2.w),
                      //       child: Container(
                      //         width: 6.w,
                      //         height: 6.w,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(8),
                      //           border: Border.all(color: Colors.white,width: 1.5),
                      //         ),
                      //         child: Padding(
                      //           padding: EdgeInsets.all(1.0),
                      //           child: ClipRect(
                      //             child: BackdropFilter(
                      //               filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      //               child: Container(
                      //                 color: Colors.white.withOpacity(0.1),
                      //                 child: Center(
                      //                   child: Icon(Icons.arrow_back,size: 35,color: Colors.white,),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Spacer(),
                      SizedBox(
                        width: 70.w,
                        height: 60.h,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 70.w,
                                  height: 60.h,
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: MemoryImage(widget.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // child: Transform(
                                  //   alignment: Alignment.center,
                                  //   transform: Matrix4.rotationY(0),
                                  //   child: RotationTransition(
                                  //     turns: const AlwaysStoppedAnimation(270 / 360),
                                  //     child: Transform.scale(
                                  //       scale: 1,
                                  //       // scaleX: 1.765,
                                  //       // scaleY: 0.6,
                                  //       child: Row(
                                  //         children: [
                                  //           Container(
                                  //             width:45.2.h,
                                  //             height: 41.7.w,
                                  //             decoration: BoxDecoration(
                                  //               color: Colors.blue,
                                  //               image: DecorationImage(
                                  //                 image: MemoryImage(widget.image),
                                  //                 fit: BoxFit.fill,
                                  //               ),
                                  //             ),),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 70.w,
                              height: 60.h,
                              child: Image.asset('assets/frame_local.png'
                                ,fit: BoxFit.fill,),
                            ),
                            // Positioned(
                            //   top: 0.8.h,
                            //   left: 10.w,
                            //   child: Padding(
                            //     padding: EdgeInsets.all(2.w),
                            //     child: Directionality(
                            //       textDirection: TextDirection.ltr,
                            //       child: Align(
                            //         alignment: Alignment.topRight,
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(8),
                            //           ),
                            //           child: ClipRRect(
                            //             borderRadius: BorderRadius.circular(16),
                            //             child: BackdropFilter(
                            //               filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                            //               child: Container(
                            //                 color: Colors.white.withOpacity(0.3),
                            //                 child: Padding(
                            //                   padding: EdgeInsets.
                            //                   symmetric(horizontal: 1.w,vertical: 0.5.h),
                            //                   child: Center(
                            //                     child: Text(convertDateTimeToString(),
                            //                     style: TextStyle(color: Colors.white,
                            //                     fontSize: 5.sp),),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Spacer(),
                      // if(selectedFrame>=1&&show)SizedBox(
                      //   width: 12.w,
                      //   child: InkWell(
                      //     onTap: ()async{
                      //       selectedFrame--;
                      //       set((){});
                      //     },
                      //     child: Padding(
                      //       padding: EdgeInsets.all(2.w),
                      //       child: Container(
                      //         width: 6.w,
                      //         height: 6.w,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(8),
                      //           border: Border.all(color: Colors.white,width: 1.5),
                      //         ),
                      //         child: Padding(
                      //           padding: EdgeInsets.all(1.0),
                      //           child: ClipRect(
                      //             child: BackdropFilter(
                      //               filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      //               child: Container(
                      //                 color: Colors.white.withOpacity(0.1),
                      //                 child: Center(
                      //                   child: Icon(Icons.arrow_forward_ios,size: 35,color: Colors.white,),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // if(!(selectedFrame>=1)&&show)SizedBox(width: 12.w,),

                    ],
                  );
                }
            ),
          ),
          Center(
            child: SizedBox(
              width: 70.w,
              height: 70.h,
              child: Signature(
                controller: _controller,
                width: 70.w,
                height: 70.h,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          if(!show&&qr!=null)MediaQuery(
            data: MediaQueryData(),
            child: Positioned(
              right: 20.25.w,
              bottom: 26.4.h,
              child: Row(
                children: [
                  SizedBox(
                    width: 10.5.w,
                    height: 10.5.w,
                    child: PrettyQr(
                      image: AssetImage('assets/logo.png'),
                      size: 20.w,
                      data: qr,
                      roundEdges: true,
                      // elementColor: Colors.white,
                    ),
                  ),

                ],
              ),
            ),
          ),
          ...List.generate(imojies.length, (i) {
            return AnimatedPositioned(
              duration: Duration(milliseconds: 1),
              left: imojies[i]['left'],
              top: imojies[i]['top'],
              child: Center(
                child: GestureDetector(
                  onPanDown:(d){
                    imojies[i]['leftP'] = imojies[i]['left'];
                    imojies[i]['topP'] = imojies[i]['top'];
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      imojies[i]['left'] = imojies[i]['leftP'] + details.localPosition.dx-(imojies[i]['size']/2);
                      imojies[i]['top'] = imojies[i]['topP'] + details.localPosition.dy-(imojies[i]['size']/2);
                    });
                  },
                  onDoubleTap: (){
                    setState(() {
                      imojies.removeAt(i);
                    });
                  },
                  onLongPressMoveUpdate: (det)async{
                    if(increase==null){
                      increase = Timer.periodic(Duration(milliseconds: 100), (timer) {
                        setState(() {
                          imojies[i]['size'] += 0.5.w;
                        });
                      });
                    }

                  },
                  onLongPressEnd: (det){
                    if(increase!=null){
                      increase!.cancel();
                      increase = null;
                    }
                    print('det5');
                  },
                  onLongPressCancel: (){
                    if(increase!=null){
                      increase!.cancel();
                      increase = null;
                    }
                    print('det6');
                  },
                  onLongPressUp: (){
                    if(increase!=null){
                      increase!.cancel();
                      increase = null;
                    }
                    print('det7');
                  },
                  onTap: (){
                    print('click');
                    setState(() {
                      imojies[i]['size'] -= 2.w;
                    });
                  },
                  child: Center(
                    child: AnimatedContainer(
                      duration: Duration(microseconds: 50),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imojies[i]['image']),
                          fit: BoxFit.fill,
                        ),
                      ),
                      width: imojies[i]['size'],
                      height: imojies[i]['size'],
                    ),
                  ),
                ),
              ),
            );
          }),
          if(show)Positioned(
            top: 8.8.h,
            left: 5.w,
            child: Container(
              width: 90.w,
              height: 6.h,
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
                        child:  Container(
                          width: 90.w,
                          height: 10.h,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
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
                              InkWell(
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (ctx){
                                        return AlertDialog(
                                          content: SingleChildScrollView(
                                            child: ColorPicker(
                                              pickerAreaBorderRadius: BorderRadius.circular(1000),
                                              pickerColor: color,
                                              onColorChanged: (c){
                                                setState(() {
                                                  color = c;
                                                });
                                                _controller = SignatureController(
                                                  penStrokeWidth: strok,
                                                  penColor: color,
                                                );
                                              },
                                            ),

                                          ),

                                        );
                                      }
                                  );
                                },
                                child: Container(
                                  width: 4.w,
                                  height: 4.w,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white,width: 5),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset('assets/sig_icon.png',color: Colors.white,scale:1,),
                                  SizedBox(width: 2.w,),
                                  SizedBox(
                                    width: 30.w,
                                    height: 5.h,
                                    child: Slider(
                                      onChanged: (v){
                                        setState(() {
                                          strok = v;
                                        });
                                        _controller = SignatureController(
                                          penStrokeWidth: strok,
                                          penColor: color,
                                        );
                                      },
                                      value: strok,
                                      min: 1,
                                      max: 10,
                                      activeColor: Colors.white,
                                      inactiveColor: color,
                                    ),
                                  ),
                                  SizedBox(width: 2.w,),
                                  Image.asset('assets/sig_icon.png',color: Colors.white,scale: 0.7,),
                                ],
                              ),
                              InkWell(
                                onTap: (){
                                  _controller.clear();
                                },
                                child: Icon(Icons.close,size: 25,color: Colors.white,),
                              ),
                              if(mirror.order!.imoji.isNotEmpty)InkWell(
                                onTap: (){
                                  if(right==1.5.w){
                                    right = -20.w;
                                  }else{
                                    right = 1.5.w;
                                  }
                                  setState(() {

                                  });
                                },
                                child: Image.asset('assets/imoji0.png'),
                              ),
                              InkWell(
                                onTap: ()async{



                                  if(isBooth){
                                    printCounter = 1;
                                    audioSend = null;
                                    au = '';
                                    isRecord = false;
                                    recordTap = false;
                                    boomPath = null;
                                    showModalBottomSheet(
                                        constraints: BoxConstraints(
                                          minHeight: 80.h,
                                          minWidth: 100.w,
                                          maxHeight: 80.h,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(70)),
                                        ),
                                        context: context,
                                        builder: (context){
                                          return SizedBox(
                                            height: 80.h,
                                            child: StatefulBuilder(
                                                builder: (context,set) {
                                                  return Container(
                                                    height: 80.h,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff111115),
                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(70)),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 5.h,),
                                                        Container(
                                                          width: 70.w,
                                                          height: 7.h,
                                                          decoration: BoxDecoration(
                                                            color: Colors.transparent,
                                                            borderRadius: BorderRadius.circular(8),
                                                            border: Border.all(color: Colors.white),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              InkWell(
                                                                onTap: ()async{
                                                                  if(printCounter<10){
                                                                    set((){
                                                                      printCounter++;
                                                                    });
                                                                  }
                                                                },
                                                                child: Container(
                                                                  width: 15.w,
                                                                  height: 7.h,
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
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            // color: Color(0xffffab00),
                                                                            color: Colors.white.withOpacity(0.1),
                                                                          ),
                                                                          // color: Colors.white.withOpacity(0.1),
                                                                          child: Center(
                                                                            child: Icon(Icons.add,size: 35,color: Colors.white,),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(printCounter.toString(),style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 25.sp
                                                              ),),
                                                              InkWell(
                                                                onTap: ()async{
                                                                  if(printCounter>1){
                                                                    set((){
                                                                      printCounter--;
                                                                    });
                                                                  }
                                                                },
                                                                child: Padding(
                                                                  padding: EdgeInsets.zero,
                                                                  child: Container(
                                                                    width: 15.w,
                                                                    height: 7.h,
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
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              // color: Color(0xffffab00),
                                                                              color: Colors.white.withOpacity(0.1),
                                                                            ),
                                                                            child: Center(
                                                                              child: Icon(Icons.remove,size: 35,color: Colors.white,),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 4.h,),
                                                        InkWell(
                                                          onTap: ()async{
                                                            captu();
                                                          },
                                                          child: Container(
                                                            width: 70.w,
                                                            height: 8.h,
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
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      // color: Color(0xffffab00),
                                                                      color: Colors.white.withOpacity(0.1),
                                                                    ),

                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(width: 5.w,),
                                                                        Icon(Icons.camera,color: Colors.white,size: 50,),
                                                                        Spacer(),
                                                                        Text('اطبع الصورة',style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 20.sp,
                                                                          height: 1,
                                                                        ),),
                                                                        SizedBox(width: 5.w,),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 4.h,),
                                                        if(mirror.order!.boom)InkWell(
                                                          onTap: ()async{
                                                            // createBoomerangVideo('D:\\Video\\boom.mp4', 'D:\\Video\\boom5.mp4', true);
                                                            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>BoomPage()))
                                                            .then((value) {
                                                              if(value is String){
                                                                boomPath = value;
                                                                set(() {

                                                                });
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            width: 70.w,
                                                            height: 8.h,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(8),
                                                              border: Border.all(color: boomPath!=null?Colors.green:Colors.white,width: 1.5),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(1.0),
                                                              child: ClipRect(
                                                                child: BackdropFilter(
                                                                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      // color: Color(0xffffab00),
                                                                      color: Colors.white.withOpacity(0.1),
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(width: 5.w,),
                                                                        Icon(Icons.video_call,color: boomPath!=null?Colors.green:Colors.white,size: 50,),
                                                                        Spacer(),
                                                                        Text(' ${'boomerang'.toUpperCase()}',style: TextStyle(
                                                                          color: boomPath!=null?Colors.green:Colors.white,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 15.sp,
                                                                          height: 1,
                                                                        ),),
                                                                        SizedBox(width: 5.w,),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        if(mirror.order!.audio)StatefulBuilder(
                                                          builder: (context,sett) {
                                                            return Column(
                                                              children: [
                                                                if(mirror.order!.boom)SizedBox(height: 2.h,),
                                                                if(audioSend==null)SizedBox(height: 2.h,),
                                                                if(audioSend!=null)SizedBox(
                                                                  width: 70.w,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      InkWell(
                                                                        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.white,
                                                                        size: 50,),
                                                                        onTap: () async{
                                                                          if(isPlaying){
                                                                            player.pause();
                                                                          }else{
                                                                            if(player.state==PlayerState.paused){
                                                                              player.resume();
                                                                            }else{
                                                                              player.play(DeviceFileSource(au));

                                                                              player.onPlayerStateChanged.listen((event) {
                                                                                if(mounted){
                                                                                  sett(() {
                                                                                    isPlaying = (event ==PlayerState.playing);
                                                                                  });
                                                                                }
                                                                              });
                                                                              player.onDurationChanged.listen((event) {
                                                                                if(mounted){
                                                                                  sett(() {
                                                                                    duration = event;
                                                                                  });
                                                                                }
                                                                              });
                                                                              player.onPositionChanged.listen((event) {
                                                                                if(mounted){
                                                                                  sett(() {
                                                                                    position = event;
                                                                                  });
                                                                                }
                                                                              });
                                                                            }

                                                                          }


                                                                        },
                                                                      ),
                                                                      Expanded(
                                                                        child: Container(
                                                                          width: 1,
                                                                          child: Slider(
                                                                            min: 0,
                                                                            max: duration.inSeconds.toDouble()<0?0:duration.inSeconds.toDouble(),
                                                                            value: position.inSeconds.toDouble(),
                                                                            onChanged: (value) {
                                                                              final position = Duration(seconds: value.toInt());
                                                                              player.seek(position);
                                                                              player.resume();
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 2.w,),
                                                                      Column(
                                                                        children: [
                                                                          Text(formatTime((duration - position).inSeconds),
                                                                            style: TextStyle(
                                                                                fontSize: 10.sp,
                                                                              color: Colors.white,
                                                                            ),),

                                                                        ],
                                                                      ),
                                                                      SizedBox(width: 2.w,),
                                                                      InkWell(onTap: (){
                                                                        sett(() {
                                                                          audioSend = null;
                                                                          au = '';
                                                                          isRecord = false;
                                                                          recordTap = false;
                                                                        });
                                                                      },child: Icon(Icons.delete,color: Colors.red,size: 25,)),
                                                                    ],
                                                                  ),
                                                                ),
                                                                if(audioSend!=null)SizedBox(height: 1.h,),
                                                                InkWell(
                                                                  onTap: ()async{
                                                                    if(audioSend!=null){
                                                                      captu();
                                                                    }else{
                                                                      if(!recordTap&&!isPlaying){
                                                                        recordTap = true;
                                                                        isRecord = !isRecord;
                                                                        await toggleRecording();
                                                                        recordTap = false;
                                                                        sett((){});
                                                                      }
                                                                    }

                                                                  },
                                                                  child: Container(
                                                                    width: 70.w,
                                                                    height: 8.h,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      border: Border.all(color: isRecord?Colors.green:audioSend!=null?Colors.orangeAccent:Colors.white,width: 1.5),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.all(1.0),
                                                                      child: ClipRect(
                                                                        child: BackdropFilter(
                                                                          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              // color: Color(0xffffab00),
                                                                              color: Colors.white.withOpacity(0.1),
                                                                            ),
                                                                            child: Row(
                                                                              children: [
                                                                                SizedBox(width: 5.w,),
                                                                                Icon(Icons.mic,color: isRecord?Colors.green:audioSend!=null?Colors.orangeAccent:Colors.white,size: 50,),
                                                                                Spacer(),
                                                                                Text('${isRecord?'ايقاف ال':
                                                                                audioSend!=null?'احفظ ال':'سجل '}رسالة صوتية',style: TextStyle(
                                                                                  color: isRecord?Colors.green:audioSend!=null?Colors.orangeAccent:Colors.white,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: isRecord||audioSend!=null?18.sp:20.sp,
                                                                                  height: 1,
                                                                                ),),
                                                                                SizedBox(width: 5.w,),

                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                            ),
                                          );
                                        }
                                    );
                                  }else{
                                    TextEditingController textEditingController = TextEditingController();
                                    showModalBottomSheet(
                                        constraints: BoxConstraints(
                                          minHeight: 80.h,
                                          minWidth: 100.w,
                                          maxHeight: 80.h,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(70)),
                                        ),
                                        context: context,
                                        builder: (context){
                                          return SizedBox(
                                            height: 80.h,
                                            child: StatefulBuilder(
                                                builder: (context,set) {
                                                  return Container(
                                                    height: 80.h,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff111115),
                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(70)),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 1.h,),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                                                          child: textField(context,readOnly: true,
                                                              title: true,titleText: "رقم الهاتف",
                                                              tittleStyle: TextStyle(color: Colors.white,
                                                                  fontSize: 14.sp),
                                                              controller: textEditingController,
                                                              label: 'ادخل رقم الهاتف'),
                                                        ),
                                                        SizedBox(height: 5.h,),
                                                        Container(
                                                          // Keyboard is transparent
                                                          color: Color(0xff111115),
                                                          child: Directionality(
                                                            textDirection: TextDirection.ltr,
                                                            child: VirtualKeyboard(
                                                              // Default height is 300
                                                                height: 20.h,
                                                                // Default height is will screen width
                                                                width: 100.w,
                                                                // Default is black
                                                                textColor: Colors.white,
                                                                textController: textEditingController,
                                                                // Default 14
                                                                fontSize: 20,
                                                                // the layouts supported
                                                                defaultLayouts : [VirtualKeyboardDefaultLayouts.English,
                                                                  VirtualKeyboardDefaultLayouts.Arabic],
                                                                // [A-Z, 0-9]
                                                                type: VirtualKeyboardType.Numeric,
                                                                // Callback for key press event
                                                                onKeyPress: (VirtualKeyboardKey val){
                                                                  // print(val.text);
                                                                  // print(val.action);
                                                                  // print(val.capsText);
                                                                  // print(val.keyType.name);
                                                                  // if(val.keyType.name=="String"){
                                                                  //   textEditingController.text = textEditingController.text+val.text!;
                                                                  // }else if(val.action==VirtualKeyboardKeyAction.Backspace&&textEditingController.text.isNotEmpty){
                                                                  //   textEditingController.text = textEditingController.text.substring(0,textEditingController.text.length-1);
                                                                  // }else if(val.action==VirtualKeyboardKeyAction.Space&&textEditingController.text.isNotEmpty){
                                                                  //   textEditingController.text = '${textEditingController.text} ';
                                                                  // }
                                                                }),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5.h,),
                                                        button1('التقط الصورة',width: 90.w,onTap: (){
                                                          if(textEditingController.text.isNotEmpty){
                                                            phone = textEditingController.text;
                                                            captu();
                                                          }
                                                        }),
                                                      ],
                                                    ),
                                                  );
                                                }
                                            ),
                                          );
                                        }
                                    );
                                  }

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
                                              child: Icon(Icons.print,size: 35,color: Colors.white,),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if(show&&mirror.order!.imoji.isNotEmpty)AnimatedPositioned(
            duration: Duration(seconds: 1),
            right: right,
            top: 13.8.h,
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 11.w,
                  height: 50.h,
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
                          width: 11.w,
                          height: 50.h,
                          child: Center(
                            child: Container(
                              height: 50.h,
                              width: 11.w,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: StatefulBuilder(
                                  builder: (context,set) {
                                    return CarouselSlider(
                                      options: CarouselOptions(
                                          viewportFraction: 0.12,
                                          enableInfiniteScroll: true,
                                          autoPlay: false,
                                          scrollDirection: Axis.vertical
                                      ),
                                      items: List.generate(mirror.order!.imoji.length, (i) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(vertical: 0.5.h),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            overlayColor: MaterialStateProperty
                                                .all(Colors.transparent),
                                            highlightColor: Colors.transparent,
                                            onTap: (){
                                              if(imojies.length<5){
                                                imojies.add({
                                                  "image":mirror.order!.imoji[i].image,
                                                  "left":50.w,
                                                  "top":50.h,
                                                  "leftP":50.w,
                                                  "topP":50.h,
                                                  "size":10.w,
                                                });
                                                setState(() {

                                                });
                                              }else{
                                                setState(() {
                                                  imojies.removeAt(0);
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: 10.w,
                                              height: 10.w,
                                              child: Image.network(mirror.order!.imoji[i].image),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  }
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if(show&&qrAnimation!=null)Container(
            width: 100.w,
            height: 100.h,
            color: Colors.black.withOpacity(qrAnimation!=null?0.8:0),
          ),
          if(show&&false)Center(
            child: AnimatedBuilder(
              animation: _controller3,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _translateAnimation.value),
                  child: AnimatedBuilder(
                      animation: _controller2,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY((_rotateAnimation.value)*3.14159),
                          child: Card(
                            elevation: 5,
                            child: Container(
                              width: 500,
                              height: 500,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.shade300.withOpacity(0.6),
                                    blurRadius: 5,spreadRadius: 1,
                                    blurStyle: BlurStyle.outer,),
                                ],
                              ),
                              // Add your card content here
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 300),
                                  opacity: finish?1:0,
                                  child: GestureDetector(
                                    onTap: (){
                                      if(finish){
                                        navPRRU(InputView());
                                      }
                                    },
                                    child: PrettyQr(
                                      image: AssetImage('assets/logo.png'),
                                      size: 500,
                                      data: qrAnimation??"",
                                      roundEdges: true,
                                      // elementColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String convertDateTimeToString(){
  return intl.DateFormat('d,M,y hh:mm a',)
      .format(DateTime.now());
}


class Utilities {
  static Future<String> getVoiceFilePath() async {
    Directory appDocumentsDirectory =
    await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = appDocumentsPath; // 3

    return filePath;
  }
}