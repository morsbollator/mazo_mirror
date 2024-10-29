

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget textField(context,{bool obscureText = false,bool autoFocus = false
  ,required TextEditingController controller,double? w,double? h,FocusNode? node,
  bool next = true,required String label,bool suffix = false,double? borderR,
  void Function()? onTap,bool otp = false,Widget? prefix,bool readOnly = false,int max = 1,
  Color? color,TextInputType? type,bool translateOpen = true,Color? hintColor,Color? textColor,
  String? Function(String?)? validate,bool title = false,double? padding,TextStyle? tittleStyle,
  String? titleText,bool counter = false,double? titleH
  ,TextStyle? hintStyle,TextStyle? style,void Function(String?)? onChange,int? maxLength}
    ){
  return Padding(
    padding: EdgeInsets.symmetric(vertical: padding??1.h,horizontal: 1.w),
    child: SizedBox(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(title)Text(titleText??label,style: tittleStyle??TextStyle(color: Colors.black,fontSize: 11.sp),),
          if(title)SizedBox(height: titleH??0.5.h,),
          SizedBox(
            width: w,
            // height: h,
            child: TextFormField(
              obscureText: obscureText,
              onChanged: onChange,
              controller: controller,
              focusNode: node,
              cursorHeight: 25,
              cursorColor: Colors.black,
              readOnly: readOnly,
              autofocus: autoFocus,
              maxLines: max,
              maxLength: maxLength,
              style: style??TextStyle(fontSize: 14.sp,color: textColor),

              validator: validate??(value){
                if (value!.isEmpty) {
                  return 'يجب ملئ الحقل';
                }
                return null;
              },
              onEditingComplete: (){
                print('hamza');
                node?.unfocus();
                FocusScope.of(context).unfocus();
                if(next){
                  FocusScope.of(context).nextFocus();
                }
              },
              keyboardType: type,
              decoration: inputDecoration(context, label: label,
                  obscureText: obscureText,onTap: onTap,
                  suffix: suffix,color: color,max: max,
                  prefix: prefix,hintStyle: hintStyle,title: title,
                  translateOpen: translateOpen,borderR: borderR,
                  hintColor: hintColor,titleText: titleText,counter: counter),
            ),
          ),
        ],
      ),
    ),
  );
}
InputDecoration inputDecoration(context,{bool obscureText = false,
  double? borderR,void Function()? onTap,
  int max = 1,bool translateOpen = true,Color? hintColor,
  bool title = false,String? titleText,Color? color,
  Widget? prefix,required String label,bool suffix = false,
  TextStyle? hintStyle,bool counter = false
}){
  return InputDecoration(
    counterText: counter?null:'',
    hintText: title?(titleText!=null?label:null):label,
    fillColor: color??Colors.white,
    filled: true,
    hintStyle: hintStyle??TextStyle(fontSize: 10.sp,color: hintColor??Colors.black,height: 1,),
    floatingLabelStyle: TextStyle(color: Colors.white,fontSize: 11.sp),
    floatingLabelBehavior: max==1?null:FloatingLabelBehavior.always,
    border: border(borderR: borderR),
    disabledBorder:border(borderR: borderR),
    focusedBorder: border(borderR: borderR),
    enabledBorder: border(borderR: borderR),
    errorBorder: border(color: Colors.red,borderR: borderR),
    focusedErrorBorder: border(color: Colors.red,borderR: borderR),
    hoverColor: Colors.grey,
    prefixIcon: prefix,
    contentPadding: max==1?EdgeInsets.symmetric(horizontal: 3.w):EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
    suffixIcon: !suffix?null:IconButton(onPressed:onTap,
        icon: Icon(obscureText?Icons.visibility_off_outlined:Icons.visibility,
          size: 20,color: obscureText?Colors.grey:Colors.white,),
        splashColor: Colors.transparent,highlightColor: Colors.transparent),
  );
}
InputBorder border({Color? color,double? borderR}){
  return OutlineInputBorder(borderRadius: BorderRadius.circular(borderR??8),
      borderSide: BorderSide(color: color??Colors.white));
}