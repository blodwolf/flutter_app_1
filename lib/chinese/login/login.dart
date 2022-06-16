import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/assert/assets.dart';
import 'package:flutter_app_1/chinese/home.dart';
import 'package:flutter_app_1/chinese/http/http.dart';
import 'package:flutter_app_1/chinese/tools/base.dart';
import 'package:flutter_app_1/network_image/network_image.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  String account = "", password = "";
  final String login_base_url = BASE_URL + "/user/login";

  Widget _buildPageContent(BuildContext context) {
    return Container(
      color: Colors.blue.shade200,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          CircleAvatar(
            child: PNetworkImage(origami),
            maxRadius: 50,
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            height: 20.0,
          ),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Container _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: 400,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            account = value.trim();
                          });
                        },
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                            hintText: "手机号/邮箱",
                            hintStyle: TextStyle(color: Colors.blue.shade200),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.account_box,
                              color: Colors.blue.shade400,
                            )),
                      )),
                  Container(
                    child: Divider(
                      color: Colors.blue.shade400,
                    ),
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            password = value.trim();
                          });
                        },
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                            hintText: "验证码",
                            hintStyle: TextStyle(color: Colors.blue.shade200),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.blue.shade400,
                            )),
                      )),
                  Container(
                    child: Divider(
                      color: Colors.blue.shade400,
                    ),
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.blue.shade300,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            height: 420,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  if (account.trim() == "") {
                    Fluttertoast.showToast(msg: "请输入账号");
                    return;
                  }
                  if (password.trim() == "") {
                    Fluttertoast.showToast(msg: "请输入密码");
                    return;
                  }
                  //账号密码登陆
                  Http.request(login_base_url + "/" + account + "/" + password, null, new Options(method: "GET"));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue.shade400),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                ),
                child: Text("Login", style: TextStyle(color: Colors.white70)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }

  login() async {
    if (account == null || account.trim() == "" || password == null || password.trim() == "") {
      Fluttertoast.showToast(msg: "请输入验证码");
      return;
    }
    Map result = await Http.request(BASE_URL + "/user/login/" + account + "/" + password, null, Options(method: "get"));
    var data = result["data"];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("user_id", result["data"]["user_id"].toString());
    preferences.setString(result["data"]["user_id"].toString(), result["data"]["token"].toString());
    //跳转到首页
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return HomePage();
    }));
  }
}
