
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app_1/chinese/http/http_result.dart';

class DioHttp {
  static String _baseUrl = "http://localhost:1000";
  static const CONTENT_TYPE_JSON = 'application/json';
  static const CONTENT_TYPE_FORM = 'application/x-www-form-urlencoded';

  /// @author yinjinliang
  /// callback 必须要有。用于处理返回之后的事项。
  /// response 当异常时并没有返回具体的错误信息，目的是不让业务处理太多的异常信息
  ///
  static request(url, params, Map<String, String> headers, Options options) async {
    //网络检查
    var connectivityResult = (new Connectivity().checkConnectivity());
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      return HttpResult.toJson(-1, null,null, "网络异常");
    }
    //头设置
    if (options != null) {
      options.headers = headers;
    } else {
      options = new Options(method: 'get');
      options.headers = headers;
    }
    options.sendTimeout = 1000;

    //Dio
    Dio dio = new Dio();
    //拦截器处理
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
      print('\n ===请求数据===');
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
    Response response;
    try {
      response = await dio.request(url, data: params, options: options);
    } on DioError catch (e) {
      print(e);
      response=Response();
      response.statusCode=400;
      response.statusMessage=e.message;
    }
  }
}
