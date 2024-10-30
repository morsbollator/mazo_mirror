import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mazo/navigation.dart';
import 'package:mazo/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({super.key, required this.image});
  final String? image;
  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = Provider.of(context,listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(onTap: (){
                  orderProvider.uploadImage(image??"");
                },child: Image.asset('assets/done.png')),
                InkWell(onTap: (){
                  navPop();
                },child: Image.asset('assets/close.png')),
              ],
            ),
            SizedBox(height: 7.h,),

            Container(
              width: 70.w,
              height: 70.w*1.5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                image: DecorationImage(image: FileImage(File(image!)),
                  fit: BoxFit.cover,),

              ),
              child: Container(
                width: 70.w,
                height: 70.w*1.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/frame.png'),
                    fit: BoxFit.cover,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
