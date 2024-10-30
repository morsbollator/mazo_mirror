
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mazo/constants.dart';
import 'package:mazo/home_page.dart';
import 'package:mazo/navigation.dart';
import 'package:mazo/printing_page.dart';
import 'package:mazo/remote.dart';
import 'package:mazo/uploading_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';

class OrderProvider extends ChangeNotifier{
  late MirrorOrder mirrorOrder;

  Future getOrder()async{
    print('hamza_order2');
    Map<String,dynamic> data = {};
    data['id'] = Constants.mirrorId;
    Either<DioException,MirrorOrder> value = await OrderRemoteDataSource.getOrder(data);
    value.fold((l)async {
      print('error');
    }, (r) {
      mirrorOrder = r;
      print(r);
      print('hamza_order');
      notifyListeners();
    });
  }
  Future uploadImage(String filePath)async{
    navP(UploadingPage());
    ScreenshotController screenshotController = ScreenshotController();
    screenshotController
        .captureFromWidget(Container(
      width: 100.w,
      height: 100.w*1.5,
      child: Stack(
        children: [
          Container(
            width: 100.w,
            height: 100.w*1.41,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(filePath),),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 100.w,
            height: 100.w*1.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/frame.png',),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ))
        .then((capturedImage) async{
      String now = DateTime.now().toIso8601String().toString().replaceAll('.', "-").replaceAll(':', '-').replaceAll('-', '');
      final path = 'C:\\mirror\\Ssscreenshotframe_$now.png';
      File(path).writeAsBytesSync(capturedImage);
      Map<String,dynamic> data = {};
      data['order_id'] = mirrorOrder.orderId;
      data['image'] = await MultipartFile.fromFile(path);
      Either<DioException,String> value = await OrderRemoteDataSource.uploadImage(data);
      value.fold((l)async {
        print('error');
      }, (r) {
        printImage(filePath,r.split('.com/')[1]);
      });

    });

  }
  Future printImage(String fullPath,String filePath)async{
    navP(PrintingPage());
    ScreenshotController screenshotController = ScreenshotController();
    Map<String,dynamic> data = {};

    data['image'] =filePath;
    Either<DioException,String> value = await OrderRemoteDataSource.orderDetails(data);
    value.fold((l)async {
      print('error');
    }, (r) {

      screenshotController
          .captureFromWidget(Container(
        width: 100.w,
        height: 100.w*1.5,
        child: Stack(
          children: [
            Container(
              width: 100.w,
              height: 100.w*1.41,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(fullPath),),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 100.w,
              height: 100.w*1.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/frame.png',),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              bottom: 5.h,
              right: 3.h,
              child: Container(
                width: 17.w,
                height: 17.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: QrImageView(data: r,size: 17.w,),
              ),
            ),

          ],
        ),
      ))
          .then((capturedImage) async{
        String now = DateTime.now().toIso8601String().toString().replaceAll('.', "-").replaceAll(':', '-').replaceAll('-', '');
        final path = 'C:\\mirror\\Ssscreenshot_$now.png';
        File(path).writeAsBytesSync(capturedImage);

        await Process.run('rundll32', [
          'shimgvw.dll,ImageView_PrintTo',
          '/pt',
          path,
          'mazo',
          '/f',
          '105',
          '148.5'
        ]);
        // Process.run('rundll32 shimgvw.dll,ImageView_PrintTo /pt "$path" "mazo" /f 105 148.5');
        // print
        navPU();
      });

    });
  }

}