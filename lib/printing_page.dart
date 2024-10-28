import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class PrintingPage extends StatelessWidget {
  const PrintingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [
            SizedBox(height: 13.h,),
            Text('Your photo is in the ',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold),),
            Text('printing stage',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold),),
            SizedBox(height: 15.h,),
            Lottie.asset('assets/printing.json'),
          ],
        ),
      ),
    );
  }
}