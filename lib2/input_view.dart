import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:test_cam/buttons.dart';
import 'package:test_cam/navigation.dart';
import 'package:test_cam/random_view.dart';
import 'package:test_cam/var.dart';
import 'package:test_cam/widget.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import 'home.dart';

bool canChange = true;
class InputView extends StatefulWidget {
  const InputView({Key? key}) : super(key: key);

  @override
  State<InputView> createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  TextEditingController textEditingController = TextEditingController();
  bool gif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: gif?GestureDetector(
          onTap: (){
            if(isBooth){
              navP(Home());
            }else{
              setState(() {
                gif = false;
              });
            }
          },
          onDoubleTap: (){
            if(canChange){
              isBooth = !isBooth;
              showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Row(
                        children: [
                          Text('تم التبديل الى وضع ${isBooth?"المراية العادية":"مراية البيانات"}',
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
          },
          onLongPress: (){

            if(canChange){
              canChange = false;
              showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Row(
                        children: [
                          Text('تم اغلاق تبديل السيستم',
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
          },
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/start.gif'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ):Column(
          children: [
            SizedBox(height: 4.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: textField(context,readOnly: true,
                  title: true,titleText: "اسمك ايه ",
                  tittleStyle: TextStyle(color: Colors.blue,
                  fontSize: 20.sp),
                  controller: textEditingController,
                  label: 'الاسم بالكامل'),
            ),
            SizedBox(height: 5.h,),
            Container(
              // Keyboard is transparent
              color: Colors.black,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: VirtualKeyboard(
                  // Default height is 300
                    height: 20.h,
                    // Default height is will screen width
                    width: 100.w,
                    // Default is black
                    textColor: Colors.white,
                    textController: textEditingController,
                    // Default 14
                    fontSize: 20,
                    // the layouts supported
                    defaultLayouts : [VirtualKeyboardDefaultLayouts.English,
                    VirtualKeyboardDefaultLayouts.Arabic],
                    // [A-Z, 0-9]
                    type: VirtualKeyboardType.Alphanumeric,
                    // Callback for key press event
                    onKeyPress: (VirtualKeyboardKey val){
                      // print(val.text);
                      // print(val.action);
                      // print(val.capsText);
                      // print(val.keyType.name);
                      // if(val.keyType.name=="String"){
                      //   textEditingController.text = textEditingController.text+val.text!;
                      // }else if(val.action==VirtualKeyboardKeyAction.Backspace&&textEditingController.text.isNotEmpty){
                      //   textEditingController.text = textEditingController.text.substring(0,textEditingController.text.length-1);
                      // }else if(val.action==VirtualKeyboardKeyAction.Space&&textEditingController.text.isNotEmpty){
                      //   textEditingController.text = '${textEditingController.text} ';
                      // }
                    }),
              ),
            ),
            SizedBox(height: 5.h,),
            button1('التالي',width: 90.w,onTap: (){
              if(textEditingController.text.isNotEmpty){
                name = textEditingController.text;
                navP(RandomView());
              }
            }),

          ],
        ),
      ),
    );
  }
}
// Widget _builder(BuildContext context, VirtualKeyboardKey key) {
//   Widget keyWidget;
//
//   switch (key.keyType) {
//     case VirtualKeyboardKeyType.String:
//     // Draw String key.
//       keyWidget = _keyboardDefaultKey(key);
//       break;
//     case VirtualKeyboardKeyType.Action:
//     // Draw action key.
//       keyWidget = _keyboardDefaultActionKey(key);
//       break;
//   }
//
//   return keyWidget;
// }
