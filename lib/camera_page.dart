import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:mazo/navigation.dart';
import 'package:mazo/preview_image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:ui' as ui;
class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.link});
  final String link;
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late WebViewController controller;
  ScreenshotController screenshotController = ScreenshotController();
  int count = 5;
  bool pressed = false,showWidget = true,showLoading = true;
  Timer? timer;
  final GlobalKey _globalKey = GlobalKey();

  void takePhoto()async{

    showWidget = false;
    setState(() {

    });
    String now = DateTime.now().toIso8601String().toString().replaceAll('.', "-").replaceAll(':', '-').replaceAll('-', '');
    final String filePath = 'C:\\mirror\\$now.png';
    await Process.run('nircmd.exe', ['savescreenshot', filePath]);
    // Uint8List bytes = File(filePath).readAsBytesSync();
    showWidget = true;
    setState(() {

    });
    navP(PreviewImage(image: filePath));


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();

  }
  void decreaseCount(){
    if(!pressed){
      count=5;
      timer?.cancel();
      setState(() {

      });
      pressed = true;
      timer = Timer.periodic(const Duration(seconds: 1), (t){
        if(count == 1){
          count = 0;
          setState(() {

          });

          takePhoto();
          t.cancel();
          timer?.cancel();
          pressed = false;

        }else if(count>0){
          count--;
          setState(() {

          });
        }else{

          t.cancel();
          timer?.cancel();
          pressed = false;
        }

      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.link));
    Future.delayed(Duration(seconds: 5)).then((v){
      if(mounted){
        showLoading = false;
        setState(() {
          ;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        onDoubleTap: (){
          navPop();
        },
        child: RepaintBoundary(
          key: _globalKey,
          child: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Stack(
              children: [
                SizedBox(width: 100.w,height: 100.h,child: Transform.scale(scale: 1.4,child: WebViewWidget(controller: controller))),
                if(showWidget&&!showLoading)Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: (){
                      if(!pressed){
                        decreaseCount();
                      }
                    },
                    splashColor: Colors.transparent,
                    child: SizedBox(
                      width: 100.w,
                      height: 100.h,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 500), // Animation duration
                          child: Text(
                            pressed?'$count': 'Press To Capture',
                            key: ValueKey<int>(count),
                            style: TextStyle(
                              fontSize: pressed?200:50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            const begin = 0.0;
                            const end = 1.0;
                            const curve = Curves.easeIn;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var opacityAnimation = tween.animate(animation);

                            return FadeTransition(
                              opacity: opacityAnimation,
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if(showWidget)Positioned(
                  top: 5.h,
                  left: 5.h,
                  child: Container(
                    width: 50,
                    height:50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(2.w),
                    child: Icon(Icons.close,color: Colors.white,size: 20,),
                  ),
                ),
                if(showWidget&&showLoading)Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    opacity: showLoading?1:0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      width: 50.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Lottie.asset('assets/loading.json'),
                      ),
                    )
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}

