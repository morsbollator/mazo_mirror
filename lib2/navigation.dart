

import 'package:flutter/material.dart';

import '../main.dart';

void navP(className, {void Function(dynamic val)? then}){
  Navigator.push(GlobalVariable.navState.currentContext!, MaterialPageRoute(builder: (context)=>className)).then((value) {
    if(then!=null){
      then(value);
    }
  });
}
void navPR(className){
  Navigator.pushReplacement(GlobalVariable.navState.currentContext!, MaterialPageRoute(builder: (context)=>className));
}
void navPRRU(className){
  Navigator.pushAndRemoveUntil(GlobalVariable.navState.currentContext!, MaterialPageRoute(builder: (context)=>className), (route) => false);
}
void navPop([val]){
  Navigator.pop(GlobalVariable.navState.currentContext!,val);
}
void navPU([context]){
  Navigator.popUntil(context??GlobalVariable.navState.currentContext!, (route) => route.isFirst);
}