import 'package:flutter/material.dart';
import 'package:mazo/camera_page.dart';
import 'package:mazo/image_provider.dart';
import 'package:mazo/navigation.dart';
import 'package:mazo/preview_image.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    ImgProvider imgProvider = Provider.of<ImgProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [
            SizedBox(height: 7.h,),
            InkWell(
              onTap: (){
                navPop();
              },
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
            SizedBox(height: 3.h,),
            Text('Choose the right clothes',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold),),
            SizedBox(height: 2.h,),
            Text('Fore Experiences ',style: TextStyle(color: Colors.white,fontSize: 16.sp),),
            SizedBox(height: 15.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(imgProvider.clothes.length, (index){
                return FilterWidget(data: imgProvider.clothes[index]);
              }),
            ),
          ],
        ),
      ),
    );
  }
}


class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key, required this.data});
  final Map data;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        navP(CameraPage(widget: data['widget']));
        // navP(PreviewImage(image: null));
      },
      child: Container(
        width: 30.w,
        height: 35.h,
        decoration: BoxDecoration(
          color: Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(data['image']),
      ),
    );
  }
}

