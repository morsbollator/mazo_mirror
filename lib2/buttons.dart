
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget button1 (String text,{double? width,double? height,void Function()? onTap,
  double? fontS,bool hie = false,double? circular,
Color? border,Color? color,Color? textC,IconData? iconData,Color? iconColor,
bool reverse = false,bool withShadow = false}){
  return Align(
    alignment: Alignment.center,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: width??90.w,
        height: height??6.5.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circular??8),
          color: color??Colors.white,
          border: border==null?null:Border.all(color: border,width: 2),
          boxShadow: withShadow?[
            BoxShadow(color: Colors.grey.withOpacity(0.2),spreadRadius: 1,blurRadius: 5,offset: Offset(0,0)),
          ]:null,
        ),
        child: Center(
          child: Text(text,
            style: TextStyle(color: textC??Colors.black,fontSize: fontS??14.sp,
            fontWeight: FontWeight.bold,
            height: hie?1:null),),
        ),
      ),
    ),
  );
}