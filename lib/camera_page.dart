import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:mazo/constants.dart';
// import 'package:mazo/navigation.dart';
import 'package:mazo/preview_image.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_windows/webview_windows.dart';

import 'navigation.dart';
// import 'dart:ui' as ui;
class CameraPage extends StatefulWidget {
  const CameraPage({super.key,required this.widget});
  final Widget widget;
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final _controller = WebviewController();
  // late WebViewController controller;
  // ScreenshotController screenshotController = ScreenshotController();
  int count = 5;
  bool pressed = false,showWidget = true;
  Timer? timer;
  final GlobalKey _globalKey = GlobalKey();

  void takePhoto()async{

    showWidget = false;
    setState(() {

    });
    String now = DateTime.now().toIso8601String().toString().replaceAll('.', "-").replaceAll(':', '-').replaceAll('-', '');
    final String filePath = 'C:\\mirror\\$now.png';
    // String command = '''
    // Add-Type -AssemblyName System.Windows.Forms;
    // \$bitmap = New-Object Drawing.Bitmap -ArgumentList [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height;
    // \$graphics = [Drawing.Graphics]::FromImage(\$bitmap);
    // \$graphics.CopyFromScreen(0, 0, 0, 0, \$bitmap.Size);
    // \$bitmap.Save('$filePath', [System.Drawing.Imaging.ImageFormat]::Png);
    // \$graphics.Dispose();
    // \$bitmap.Dispose();
    // ''';
    //
    // // Run the PowerShell command
    // var result = await Process.run('powershell', ['-Command', command]);


    var result = await Process.run('C:\\src\\nircmd.exe', ['savescreenshot', filePath]);
    if (result.exitCode == 0) {
      print('Screenshot saved to: $filePath');
    } else {
      print('Error: ${result.stderr}');
    }
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
  void initWeb()async{

    // _subscriptions.add(_controller.url.listen((url) {
    //   _textController.text = url;
    // }));
    //
    // _subscriptions
    //     .add(_controller.containsFullScreenElementChanged.listen((flag) {
    //   debugPrint('Contains fullscreen element: $flag');
    //   windowManager.setFullScreen(flag);
    // }));
    // await _controller.initialize();
    // await _controller.setBackgroundColor(Colors.transparent);
    // await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.allow);
    // await _controller.loadUrl(widget.link);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initWeb();
    // controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onProgress: (int progress) {
    //         // Update loading bar.
    //       },
    //       onPageStarted: (String url) {},
    //       onPageFinished: (String url) {},
    //       onHttpError: (HttpResponseError error) {},
    //       onWebResourceError: (WebResourceError error) {},
    //       onNavigationRequest: (NavigationRequest request) {
    //         if (request.url.startsWith('https://www.youtube.com/')) {
    //           return NavigationDecision.prevent;
    //         }
    //         return NavigationDecision.navigate;
    //       },
    //     ),
    //   )
    //   ..loadRequest(Uri.parse(widget.link));


  }
  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    return  WebviewPermissionDecision.allow;
    // final decision = await showDialog<WebviewPermissionDecision>(
    //   context: Constants.globalContext(),
    //   builder: (BuildContext context) => AlertDialog(
    //     title: const Text('WebView permission requested'),
    //     content: Text('WebView has requested permission \'$kind\''),
    //     actions: <Widget>[
    //       TextButton(
    //         onPressed: () =>
    //             Navigator.pop(context, WebviewPermissionDecision.deny),
    //         child: const Text('Deny'),
    //       ),
    //       TextButton(
    //         onPressed: () =>
    //             Navigator.pop(context, WebviewPermissionDecision.allow),
    //         child: const Text('Allow'),
    //       ),
    //     ],
    //   ),
    // );


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: RepaintBoundary(
        key: _globalKey,
        child: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Stack(
            children: [
              SizedBox(width: 100.w,height: 100.h,child: widget.widget),
              // SizedBox(width: 100.w,height: 100.h,child: Transform.scale(scale: 1.4,child: WebViewWidget(controller: controller))),
              if(showWidget)Positioned(
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
                child: InkWell(
                  onTap: (){
                    navPop();
                  },
                  child: Container(
                    width: 100,
                    height:100,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(2.w),
                    child: Icon(Icons.close,color: Colors.white,size: 40,),
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}

