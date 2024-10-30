import 'package:flutter/material.dart';
import 'package:mazo/image_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'camera_page.dart';
import 'navigation.dart';


class SelectGender extends StatelessWidget {
  const SelectGender({super.key});

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
            Text('Choose your gender',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold),),
            SizedBox(height: 2.h,),
            Text('Fore clothing use',style: TextStyle(color: Colors.white,fontSize: 16.sp),),
            SizedBox(height: 15.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Gender(image: 'assets/male.png', text: 'MALE',type: 'male',),
                Gender(image: 'assets/female.png', text: 'FEMALE',type: 'female',),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class Gender extends StatelessWidget {
  const Gender({super.key, required this.image, required this.text, required this.type});
  final String image,text,type;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Provider.of<ImgProvider>(context,listen: false).goToFilterPage(type);
      },
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 5.h,),
            Image.asset(image),
            SizedBox(height: 7.h,child: Text(text,style: TextStyle(fontSize: 16.sp,
            fontWeight: FontWeight.bold),),),
          ],
        ),
      ),
    );
  }
}

