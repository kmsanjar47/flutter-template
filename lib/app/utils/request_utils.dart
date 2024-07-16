import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as gat;
import 'package:m_expense/app/const/const.dart';
import 'storage.dart';

/*
 * Request operation class
 * Singleton mode
 * Manual
 * https://github.com/flutterchina/dio/blob/master/README-ZH.md
*/


/*
   * error Unified processing
*/
// error message
ErrorEntity createErrorEntity(DioException error) {
  switch (error.type) {
    case DioExceptionType.cancel:
      {
        return ErrorEntity(code: -1, message: "request cancellation");
      }
    case DioExceptionType.connectionTimeout:
      {
        return ErrorEntity(code: -1, message: "Connection timed out");
      }

    case DioExceptionType.sendTimeout:
      {
        return ErrorEntity(code: -1, message: "Request timed out");
      }

    case DioErrorType.receiveTimeout:
      {
        return ErrorEntity(code: -1, message: "Response timed out");
      }
    case DioExceptionType.unknown:
      {
        try {
          int? errCode = error.response?.statusCode;
          if (errCode == null) {
            return ErrorEntity(code: -2, message: error.message);
          }
          switch (errCode) {
            case 400:
              {
                return ErrorEntity(code: errCode, message: "request syntax error");
              }
            case 401:
              {
                return ErrorEntity(code: errCode, message: "Permission denied");
              }

            case 403:
              {
                return ErrorEntity(code: errCode, message: "Server refuses to execute");
              }

            case 404:
              {
                return ErrorEntity(code: errCode, message: "can not reach server");
              }

            case 405:
              {
                return ErrorEntity(code: errCode, message: "Request method is forbidden");
              }

            case 500:
              {
                return ErrorEntity(code: errCode, message: "Internal server error");
              }

            case 502:
              {
                return ErrorEntity(code: errCode, message: "invalid request");
              }

            case 503:
              {
                return ErrorEntity(code: errCode, message: "Server hangs");
              }

            case 505:
              {
                return ErrorEntity(code: errCode, message: "HTTP protocol requests are not supported");
              }

            default:
              {
                // return ErrorEntity(code: errCode, message: "未知错误");
                return ErrorEntity(code: errCode, message: error.response?.statusMessage ?? '');
              }
          }
        } on Exception catch (_) {
          return ErrorEntity(code: -1, message: "unknown mistake");
        }
      }

    default:
      {
        return ErrorEntity(code: -1, message: error.message);
      }
  }
}

// exception handling
class ErrorEntity implements Exception {
  int code;
  String? message;
  ErrorEntity({required this.code, this.message});

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: code $code, $message";
  }
}

abstract class RequestConfig{
  RequestConfig(){
    // BaseOptions、Options、RequestOptions All parameters can be configured, the priority level increases in turn, and the parameters can be overridden according to the priority level
    BaseOptions options = BaseOptions(

      // Request base address, can include sub paths
      baseUrl: getBaseURL(),

      //Timeout for connecting to the server, in milliseconds.
      connectTimeout: const Duration(milliseconds: 100000),

      // The interval between receiving data before and after the response stream, in milliseconds.
      receiveTimeout:  const Duration(milliseconds: 100000),

      // Http request header.
      headers: {},
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    // add interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Do something before the request is sent
        // print("Access: ${AppStorage().token.val}");
        // print("Refresh: ${AppStorage().refreshToken.val}");
        return handler.next(options); //continue
      },
      onResponse: (Response response, handler) {
        // Do some preprocessing before returning the response data
        return handler.next(response); // continue
      },
      onError: (DioError e, handler) async {
        // Do some preprocessing when the request fails
        // if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
        //   var result = await refreshToken();
        //   if(result) {
        //     var res = handler.resolve(await _retry(e.requestOptions));
        //     return res;
        //   }
        //   else{
        //     if(gat.Get.currentRoute != "/login"){
        //       AppStorage().logOutUser();
        //     }
        //   }
        // }
        // return error.response;
        debugPrint("::: Api error : $e");
        return handler.resolve(e.response!);
      },
    ));
  }

  Future<bool> refreshToken() async {

    debugPrint("INFO [Init]: refreshToken()");

    var dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(
      onError: (error,handler){
        var a = error;
        return handler.resolve(error.response!);
      }
    ));
    var response = await dio.put(
        '$oURL/refresh',
        options: Options(headers: {'authorization': basicAuth, 'Content-type': 'application/json'}),
        data: jsonEncode({"refreshToken": AppStorage().refreshToken.val}));

    // if(response.containsKey("error")){
    //   debugPrint(response.toString());
    //   debugPrint("INFO [Fail]: readMessages()");
    // }
    // else{
    //
    // }
    if (response.statusCode == 200) {
      AppStorage().loginUser(
          login: true,
          userName: response.data['user']['username'],
          userId: response.data['user']['id'],
          refreshToken: response.data['refresh_token'],
          token: response.data['access_token'],
          tokenExpireAt: response.data['expires_in']
      );
      debugPrint("INFO [Done]: refreshToken()");
      return true;
    }
    else{
      debugPrint("INFO [Error]: refreshToken()");
      return false;
    }
  }
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    if(requestOptions.baseUrl.contains("api/v1/app")){
      requestOptions.headers['authorization'] = "Bearer ${AppStorage().token.val}";
    }
    else{
      requestOptions.headers['authorization'] = basicAuth;
    }
    var dio = Dio(BaseOptions(baseUrl: requestOptions.baseUrl));

    final options = Options(method: requestOptions.method, headers: requestOptions.headers);
    var res = await dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  return res;
  }

  /*
   * get token
   */
  late Dio dio;

  String getAuthorizationToken();

  String getBaseURL();

  /// get operation
  Future get(String path, { dynamic params, Options? options,}) async {
    try {
      Options requestOptions = options ?? Options();

      /// The following three lines of code are the operation of obtaining the token and then merging it into the header
      Map<String, dynamic> authorization = {"authorization": getAuthorizationToken()};
      requestOptions = requestOptions.copyWith(headers: authorization);

      var response = await dio.get(
        path,
        queryParameters: params,
        options: requestOptions,
      );
      return response.data;
    } on DioError catch (e) {
      throw createErrorEntity(e);
    }
  }

  ///  post operation
  Future post(String path, {dynamic params, Options? options}) async {
    Options requestOptions = options ?? Options();

    /// The following three lines of code are the operation of obtaining the token and then merging it into the header
    Map<String, dynamic> authorization = {"authorization": getAuthorizationToken()};
    requestOptions = requestOptions.copyWith(headers: authorization);

    var response = await dio.post(path, data: jsonEncode(params), options: requestOptions);
    return response.data;
  }

  ///  put operation
  Future put(String path, {dynamic params, Options? options}) async {
    Options requestOptions = options ?? Options();

    /// The following three lines of code are the operation of obtaining the token and then merging it into the header
    Map<String, dynamic> authorization = {"authorization": getAuthorizationToken()};
    requestOptions = requestOptions.copyWith(headers: authorization);

    var response = await dio.put(path, data: params, options: requestOptions);
    return response.data;
  }

  ///  patch operation
  Future patch(String path, {dynamic params, Options? options}) async {
    Options requestOptions = options ?? Options();

    /// The following three lines of code are the operation of obtaining the token and then merging it into the header
    Map<String, dynamic> authorization = {"token": getAuthorizationToken()};
    requestOptions = requestOptions.copyWith(headers: authorization);

    var response = await dio.patch(path, data: params, options: requestOptions);
    return response.data;
  }

  /// delete operation
  Future delete(String path, {dynamic params, Options? options}) async {
    Options requestOptions = options ?? Options();

    /// The following three lines of code are the operation of obtaining the token and then merging it into the header
    Map<String, dynamic> authorization = {"authorization": getAuthorizationToken()};
    requestOptions = requestOptions.copyWith(headers: authorization);

    var response = await dio.delete(path, data: params, options: requestOptions);
    return response.data;
  }

  ///  post form submit action
  Future postForm(String path, {Map<String, dynamic> params = const {}, Options? options}) async {
    Options requestOptions = options ?? Options(
      method: 'POST',
    );

    /// The following three lines of code are the operation of obtaining the token and then merging it into the header
    Map<String, dynamic> authorization = {"authorization": getAuthorizationToken()};
    requestOptions = requestOptions.copyWith(headers: authorization);
    Response response;
    if(options?.method=="POST") {
      response = await dio.post(path, data: FormData.fromMap(params), options: requestOptions);
    } else {
      response = await dio.put(path, data: FormData.fromMap(params), options: requestOptions);
    }
    return response.data;
  }

}




class Open extends RequestConfig{
  Open({required this.baseUrl, required this.authToken});
  final String authToken;
  final String baseUrl;

  @override
  String getAuthorizationToken() {
    return authToken;
  }

  @override
  String getBaseURL() {
    return baseUrl;
  }

}
class Auth extends RequestConfig{
  Auth({required this.baseUrl, required this.authToken});
  final String authToken;
  final String baseUrl;

  @override
  String getAuthorizationToken() {
    return 'Bearer ${AppStorage().token.val}';
  }

  @override
  String getBaseURL() {
    return baseUrl;
  }

}

class Main {
  Auth auth = Auth(baseUrl: mainAppBaseURL, authToken: AppStorage().token.val);
  Open open = Open(baseUrl: mainOpenBaseURL, authToken: basicAuth);
}
class Security {
  Auth auth = Auth(baseUrl: securityAppBaseURL, authToken: AppStorage().token.val);
  Open open = Open(baseUrl: securityOpenBaseURL, authToken: "");

}

class RequestUtil {
  static Main main = Main();
  static Security security = Security();
}