import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mazo/navigation.dart';
import 'package:sizer/sizer.dart';

import 'camera_page.dart';

class UploadingPage extends StatelessWidget {
  const UploadingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [
            SizedBox(height: 7.h,),
            BackButtonWidget(),
            SizedBox(height: 3.h,),
            Text('Your photo is in the ',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold),),
            Text('Processing & Deploy stage',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold),),
            SizedBox(height: 15.h,),
            Lottie.asset('assets/deploy.json'),
          ],
        ),
      ),
    );
  }
}
