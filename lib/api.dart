
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class ApiHandel {
  static ApiHandel? _instance;
  late Dio dio;

  ApiHandel._();

  String? token;
  String? lang;
  late CancelToken cancelToken;

  static ApiHandel get getInstance {
    _instance ??= ApiHandel._(); // Instantiate if null
    return _instance!;
  }

  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString('language_code');
    token = prefs.getString('token');
    if (language != null) {
      lang = language;
    }
    dio = Dio(BaseOptions(
      baseUrl: Constants.domain,
      // baseUrl: Constants.domain,
      followRedirects: false,
      // will not throw errors
      validateStatus: (status) => true,
      headers: {"lang": lang ?? "en", 'Content-Type': 'application/json'},
    ));

  }



  void cancelFunction() async {
    cancelToken.cancel();
  }

  void updateHeader(String token, {String? language}) {
    if (language != null) {
      lang = language;
    }
    dio.options = BaseOptions(
      baseUrl: Constants.domain,
      // baseUrl: Constants.domain,
      headers: {
        "Authorization": token,
        "lang": lang ?? "ar",
        'Content-Type': 'application/json'
      },
    );
  }

  Future<Either<DioException, Response>> get(path,
      [Map<String, dynamic>? data]) async {
    try {
      cancelToken = CancelToken();
      Response response =
      await dio.get(path, queryParameters: data, cancelToken: cancelToken);
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return Right(response);
      }
      return Left(dioException(response));
    } on DioException catch (e) {
      // print(e.toString());
      // print(e.message);
      return  Left(e.response==null?e:dioException(e.response!));
    } catch (e) {
      // print(e.toString());
      return Left(
        DioException(requestOptions: RequestOptions(baseUrl: Constants.domain, path: path), message: 'Server Error'),
      );
    }
  }

  Future<Either<DioException, Response>> post(path,
      Map<String, dynamic> data) async {
    print(path);
    print(data);
    try {
      cancelToken = CancelToken();
      Response response = await dio.post(
        path,
        // onSendProgress:Provider.of<ProgressProvider>(Constants.globalContext(),listen: false).setData,
        data: FormData.fromMap(data),

        cancelToken: cancelToken,
      );
      // Provider.of<ProgressProvider>(Constants.globalContext(),listen: false).clear();
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return Right(response);
      }
      return Left(dioException(response));
    } on DioException catch (e) {
      // Provider.of<ProgressProvider>(Constants.globalContext(), listen: false).clear();
      // debugPrint(e.toString());
      // debugPrint(e.message);
      // print(" ON $e");
      print(" ON $path");
      return  Left(e.response==null?e:dioException(e.response!));
    } catch (e) {
      // Provider.of<ProgressProvider>(Constants.globalContext(), listen: false).clear();
      debugPrint(e.toString());
      // print("dioException ON ${e}");

      return Left(
        DioException(
            requestOptions:
            RequestOptions(baseUrl: Constants.domain, path: path),
            message: 'Server Error'),
      );
    }
  }

  DioException dioException(Response response) {
    String msg = 'Server Error';
    if (response.data is Map) {
      Map data = response.data;
      if (data['message'] is Map) {
        msg = convertMapToString(data['message']);
      } else if (data['message'] is List) {
        msg = data['message'].join('\n');
      } else {
        msg = data['message'];
      }
    }
    return DioException(
      requestOptions: response.requestOptions,
      message: msg,
      type: msg == 'Server Error'
          ? DioExceptionType.unknown
          : DioExceptionType.badResponse,
      response: response,
      error: 'Server Error',
    );
  }



}
String convertMapToString(Map data) {
  String msg = '';
  data.forEach((key, value) {
    if (value is List) {
      msg += value.join('\n');
      msg += "\n";
    } else if (value is String) {
      msg += "$value\n";
    }
  });
  if (msg.endsWith('\n')) {
    msg = msg.substring(0, msg.length - 1);
  }
  return msg;
}

late SharedPreferences sharedPreferences;
Future startSharedPref()async{
  sharedPreferences = await SharedPreferences.getInstance();
}