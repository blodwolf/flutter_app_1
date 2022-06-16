import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/assert/assets.dart';
import 'package:flutter_app_1/chinese/home.dart';
import 'package:flutter_app_1/chinese/http/http.dart';
import 'package:flutter_app_1/chinese/login/login.dart';
import 'package:flutter_app_1/chinese/tools/base.dart';
import 'package:flutter_app_1/network_image/network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPage createState() {
    // TODO: implement createState
    return _StartPage();
  }
}

class _StartPage extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    int count = 0;
    const period = const Duration(seconds: 1);
    Timer.periodic(period, (timer) {
      count++;
      if (count >= 3) {
        timer.cancel();
        timer = null;
        toLogin();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: PNetworkImage(starter),
    );
  }

  void toLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString("user_id");
    var token = preferences.getString("token");
    if (userId == null || userId == "" || token == null || token == "") {
      //跳转到登陆页
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return LoginPage();
      }));
      return;
    }

    Options options = Options();
    if (options.headers == null) {
      options.headers = Map<String, dynamic>();
    }
    options.headers.putIfAbsent("token", () => token);
    options.headers.putIfAbsent("user_id", () => userId);

    Map result = await Http.request(BASE_URL + "/user/token", null, Options(method: "get"));
    if (result["data"]["code"] == 200) {
      //跳转到首页
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return HomePage();
      }));
    } else {
      Fluttertoast.showToast(msg: result["data"]["message"]);
      //跳转到登陆页
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return LoginPage();
      }));
    }
  }
}
