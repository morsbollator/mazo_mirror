
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
    navP(PrintingPage());
    Map<String,dynamic> data = {};
    data['order_id'] = mirrorOrder.orderId;
    data['image'] = await MultipartFile.fromFile(filePath);
    Either<DioException,String> value = await OrderRemoteDataSource.uploadImage(data);
    value.fold((l)async {
      print('error');
    }, (r) {
      printImage(filePath,r.split('.com/')[1]);
    });
  }
  Future printImage(String fullPath,String filePath)async{
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
        height: 100.w*1.41,
        child: Stack(
          children: [
            Image.file(File(fullPath)),
            Image.asset('assets/frame.png'),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 7.h,
                height: 7.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: QrImageView(data: r,size: 7.h,),
              ),
            ),

          ],
        ),
      ))
          .then((capturedImage) {
        // print
        navPARU(HomePage());
      });

    });
  }

}