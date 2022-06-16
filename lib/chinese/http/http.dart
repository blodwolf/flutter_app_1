import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app_1/chinese/http/http_result.dart';

class Http {
  static request(url, params, Options options) async {
    //网络检查
    var connectivityResult = (new Connectivity().checkConnectivity());
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      return HttpResult.toJson(-1, null, null, "网络未连接，请检查网络");
    }
    //头设置 默认为get
    if (options.method == null || options.method == "") {
      options.method = "get";
    }
    //请求超时时间 10s
    options.sendTimeout = 10000;

    //Dio
    Dio dio = new Dio();
    //拦截器处理
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
      print('\n ===请求数据===' + options.toString());
      print('\n url=${options.uri.toString()}');
      print('\n headers=${options.headers}');
      print('\n params=${options.data}');
      handler.next(options);
    }, onResponse: (Response response, handler) {
      print('\n ===响应数据===');
      print('\n code=${response.statusCode}');
      print('\n data=${response.data}');
      print('\n');
      handler.next(response);
    }, onError: (DioError error, handler) {
      print('\n ====错误开始====');
      print('\n 错误类型type=${error.type}');
      print('\n 错误信息message=${error.message}');
      print('\n');
      handler.next(error);
    }));
    //响应处理
    try {
      print(url);
      Response response = await dio.request(url, data: params, options: options);
      return HttpResult.toJson(response.statusCode, response.data, response.headers, response.statusMessage);
    } on DioError catch (e) {
      return HttpResult.toJson(e.response.statusCode, e.response.data, e.response.headers, e.response.statusMessage);
    }
  }
}
