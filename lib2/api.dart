

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:test_cam/var.dart';

Future<Map<String,dynamic>> handleApi(
    {required String route,bool isPost = true,Map? data,
      FormData? formData,})async{
  final String url = '$domain/api/$route';
  try {
    print('hamza11');
    Response response = isPost?await Dio().post(url,
      data: data??formData,
    ):await Dio().get(url,
    );
    print('hamza22');
    if(response.data['code']==200){
      print('hamza1');
      return {
        'status':1,
        'data':response.data,
      };
    }else{
      if (kDebugMode) {
        print('hamza2');
      }
      debugPrint(url);
      String msg = '';
      print(response.data);
      if(response.data['message'] is String){
        print('hamza3');
        msg = response.data['message'];
      }else if(response.data['message'] is Map){
        print('hamza33');
        Map dataApi = response.data['message'];
        dataApi.forEach((key, value) {
          print('hamza333');
          if(value is List){
            for(var l in value){
              print('hamza3333');
              msg += l+'\n';
            }
          }
          if(value is String){
            msg += value+"\n";
            print('hamza33333');
          }

        });
        if(msg.endsWith('\n')){
          msg = msg.substring(0,msg.length-1);
        }
      }
      return {
        'status':2,
        'message':msg,
      };
    }
  }on DioError catch (e) {
    print('hamza0');
    debugPrint(url);
    print(e.response);
    if(e.response!=null){
      print(e.response!.data);
      print(e.response!.statusCode);
    }
    return {'status':0};
  }
  // return {'status':0};
}
void loading(context){
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
}