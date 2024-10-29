import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:test_cam/var.dart' as va;

import '../api.dart';

class Mirror{
  int id;
  String name;
  bool active;
  Order? order;

  Mirror({required this.id,required this.name,
    required this.active,required this.order});

  factory Mirror.fromJson(Map data){
    return Mirror(id: data['id'],
        name: data['name'], active: data['is_active']=='yes',
        order: data['order']==null?null:Order.fomJson(data['order']));
  }
  // factory Mirror.fromJson(Map data){
  //   return Mirror(id: 0,
  //       name: "Ahmed", active: true,
  //       order: Order.fomJson({}));
  // }
  static Future getMirror()async{
    // mirror = Mirror.fromJson({});
    try{
      Map apiData = await handleApi(route: 'mirror_details?id=${va.mirrorId}',isPost: false
      );
      if(apiData['status']==1){
        mirror = Mirror.fromJson(apiData['data']['data']);

      }else if(apiData['status']==2){

      }
    }catch(e){
      debugPrint(e.toString());
    }
  }
  static Future<String?> uploadData(String image,String? boomPath,File? audio)async{
    Map<String,dynamic> data = {"order_id":mirror.order!.id};
    data['image'] = await MultipartFile.fromFile(File(image).path,
        filename: 'as.png');
    if(boomPath!=null){
      data['video'] = await MultipartFile.fromFile(File(boomPath).path,
          filename: 'as.mp4');
    }
    if(audio!=null){
      data['audio'] = await MultipartFile.fromFile(audio.path,
          filename: 'as.mp3');
    }
    if(!va.isBooth){
      data['name'] = va.name;
      data['phone'] = va.phone;
    }
    try{
      Map apiData = await handleApi(route: 'add_order_details',
        formData: FormData.fromMap(data),
      );
      if(apiData['status']==1){
        String imgPath = apiData['data']['data']['image'].toString().split('https://api.mazoboothmirror.com/').last;
        Map apiData2 = await
        handleApi(route: 'order_details?image=$imgPath',isPost: false);
        if(apiData2['status']==1){
          return apiData2['data']['data'];
        }

      }else if(apiData['status']==2){

      }
    }catch(e){
      debugPrint(e.toString());
    }
    return null;
  }
}
late Mirror mirror;
class Order{
  int id;
  bool boom;
  bool audio;
  List<Filters> filters;
  List<Imoji> imoji;
  List<Imoji> frames;

  Order(
      {required this.id,
        required this.boom,
        required this.audio,
        required this.filters,
        required this.frames,
        required this.imoji});
  factory Order.fomJson(Map data){
    List<Filters> filters = [];
    List<Imoji> imoji = [];
    List<Imoji> frames = [];
    for(var f in data['order_filter_categories']){
      for(var ff in f['category']['filter_category']){
        filters.add(Filters.fromJson(ff['filter']));
      }
    }
    print('hamza22233');
    for(var s in data['order_steker_categories']){
      for(var ss in s['category']['steker_category']){
        print('hamza22233456');
        if(ss['steker']['type']=='frame'){
          frames.add(Imoji(ss['steker']['image'],true));
        }else{
          imoji.add(Imoji(ss['steker']['image'], false));
          }

      }
    }
    print('hamza22233456');
    return Order(id: data['id'], boom: false,
        audio: true,
      filters: filters, imoji: imoji,
      frames: frames
    );
  }
  // factory Order.fomJson(Map data){
  //   List<Filters> filters = [];
  //   List<Imoji> imoji = [];
  //   List<Imoji> frames = [];
  //   // for(var f in data['order_filter_categories']){
  //   //   for(var ff in f['category']['filter_category']){
  //   //     filters.add(Filters.fromJson(ff['filter']));
  //   //   }
  //   // }
  //   // print('hamza22233');
  //   // for(var s in data['order_steker_categories']){
  //   //   for(var ss in s['category']['steker_category']){
  //   //     print('hamza22233456');
  //   //     if(ss['steker']['type']=='frame'){
  //   //       frames.add(Imoji(ss['steker']['image'],true));
  //   //     }else{
  //   //       imoji.add(Imoji(ss['steker']['image'], false));
  //   //     }
  //   //
  //   //   }
  //   // }
  //   print('hamza22233456');
  //   return Order(id: 0, boom: false,
  //       audio: false,
  //       filters: filters, imoji: imoji,
  //       frames: frames
  //   );
  // }
}
class Filters{
  String image;
  String key1;
  String? key2;
  String? key3;
  String key4;

  Filters({required this.image,required  this.key1,
    required this.key2, this.key3,required  this.key4});
  factory Filters.fromJson(Map data){
    return Filters(image: data['image'],
        key1: data['key1'].toString().toUpperCase(),
        key2: data['key2']?.toString().toUpperCase(),
        key3: data['key3']?.toString().toUpperCase(),
        key4: data['key4'].toString().toUpperCase());
  }
}
class Imoji{
  String image;
  bool frame;
  Imoji(this.image,this.frame);
}
class Frame{
  String image;
  bool frame;
  Frame(this.image,this.frame);
}