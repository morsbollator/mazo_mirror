import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mazo/api.dart';

class OrderRemoteDataSource {


  static Future<Either<DioException, MirrorOrder>> getOrder(Map<String, dynamic> data) async {
    var response = await ApiHandel.getInstance.get('mirror_details', data);
    return response.fold((l) => Left(l), (r) {
      return Right(MirrorOrder.fromJson(r.data['data']));
    });
  }



  static Future<Either<DioException, String>> uploadImage(Map<String, dynamic> data) async {
    var response = await ApiHandel.getInstance.post('add_order_details', data);
    return response.fold((l) => Left(l), (r) {
      return  Right(r.data['data']['image']);
    });
  }
  static Future<Either<DioException, String>> orderDetails(Map<String, dynamic> data) async {
    var response = await ApiHandel.getInstance.get('order_details', data);
    return response.fold((l) => Left(l), (r) {
      return  Right(r.data['data']);
    });
  }

}



class MirrorOrder{
  int id;
  int? orderId;

  MirrorOrder({required this.id,required this.orderId});

  factory MirrorOrder.fromJson(Map data){
    return MirrorOrder(id: data['id'], orderId: data['order']['id']);
  }



}
