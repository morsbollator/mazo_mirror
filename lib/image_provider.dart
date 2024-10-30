
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mazo/navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_windows/webview_windows.dart';

import 'filter_page.dart';

class ImgProvider extends ChangeNotifier{
  List<Map> clothes = [];
  List<Map> male = [
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/4.png","widget":SizedBox()},
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/5.png","widget":SizedBox()},
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/6.png","widget":SizedBox()},
  ];
  List<Map> female = [
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/1.png","widget":SizedBox()},
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/2.png","widget":SizedBox()},
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/3.png","widget":SizedBox()},
  ];

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
  void initWebView(int index,String type,String link)async{
    final _controller1 = WebviewController();
    await _controller1.initialize();
    await _controller1.setBackgroundColor(Colors.transparent);
    await _controller1.setPopupWindowPolicy(WebviewPopupWindowPolicy.allow);
    await _controller1.loadUrl(link);
    if(type=='female'){
      female[index]['link'] = link;
      female[index]['widget'] = SizedBox(
        width: 100.w,
        height: 100.h,
        child: Webview(
          _controller1,
          permissionRequested: _onPermissionRequested,
        ),
      );
    }else{
      male[index]['link'] = link;
      male[index]['widget'] = SizedBox(
        width: 100.w,
        height: 100.h,
        child: Webview(
          _controller1,
          permissionRequested: _onPermissionRequested,
        ),
      );
    }
  }
  void loadLinks()async{
    String data = await rootBundle.loadString('assets/links.txt');

    // Split the data into lines and remove any empty lines
    List<String> urls = data.split('\n').where((url) => url.isNotEmpty).toList();
    for(int i=0;i < 3;i++){
      initWebView(i, 'female', urls[i]);
      initWebView(i, 'male', urls[i+3]);
      // female[i]['link'] = urls[i];
      // male[i]['link'] = urls[i+3];
      // final _controller1 = WebviewController();
      // final _controller2 = WebviewController();
      // await _controller1.initialize();
      // await _controller1.setBackgroundColor(Colors.transparent);
      // await _controller1.setPopupWindowPolicy(WebviewPopupWindowPolicy.allow);
      // await _controller1.loadUrl(female[i]['link']);
      // await _controller2.initialize();
      // await _controller2.setBackgroundColor(Colors.transparent);
      // await _controller2.setPopupWindowPolicy(WebviewPopupWindowPolicy.allow);
      // await _controller2.loadUrl(male[i]['link']);
      // female[i]['widget'] = Webview(
      //   _controller1,
      //   permissionRequested: _onPermissionRequested,
      // );
      // male[i]['widget'] = Webview(
      //   _controller2,
      //   permissionRequested: _onPermissionRequested,
      // );
    }
  }

  void goToFilterPage(String type){
    clothes =  type == 'male' ? male : female;
    navP(FilterPage());
  }
}