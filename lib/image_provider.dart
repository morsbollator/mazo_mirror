
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mazo/navigation.dart';

import 'filter_page.dart';

class ImgProvider extends ChangeNotifier{
  List<Map> clothes = [];
  List<Map> male = [
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/4.png"},
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/5.png"},
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/6.png"},
  ];
  List<Map> female = [
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/1.png"},
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/2.png"},
    {"link":"https://lens.snap.com/experience/e1406c79-7c6a-4e88-9634-f29729def841","image":"assets/3.png"},
  ];

  void loadLinks()async{
    String data = await rootBundle.loadString('assets/links.txt');

    // Split the data into lines and remove any empty lines
    List<String> urls = data.split('\n').where((url) => url.isNotEmpty).toList();
    for(int i=0;i < 3;i++){
      female[i]['link'] = urls[i];
      male[i]['link'] = urls[i+3];
    }
  }

  void goToFilterPage(String type){
    clothes =  type == 'male' ? male : female;
    navP(FilterPage());
  }
}