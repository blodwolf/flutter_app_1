import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/chinese/http/dio_http.dart';
import 'package:flutter_app_1/chinese/http/http.dart';
import 'package:flutter_app_1/chinese/tools/base.dart';
import 'package:flutter_app_1/chinese/types.dart';
import 'package:flutter_app_1/network_image/network_image.dart';
import 'package:text_to_speech/text_to_speech.dart';

//我的列表页使用这个
class IndexPage extends StatefulWidget {
  _IndexPage createState() => _IndexPage();
}

class _IndexPage extends State<IndexPage> {
  var sentences = [];
  TextToSpeech tts = TextToSpeech();
  bool isLoading = false;
  var searchKey = "0";
  var start = 0;
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Container(
              // color: Colors.green.shade200,
              padding: EdgeInsets.only(top: 80),
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: sentences.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == sentences.length) {
                      return _buildProgressIndicator();
                    }
                    return buildList(context, index);
                  }),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Search School",
                          hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onSubmitted: (value) {
                          if (value.isEmpty) {
                            value = "0";
                          }
                          setState(() {
                            start = 0;
                            searchKey = value.trim();
                            sentences = [];
                          });
                          Http.request(sentences_base_url + "/" + searchKey + "/" + start.toString(), null, new Options(method: "GET"));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        heightFactor: 6,
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // this.widget.onChange("search");
        // log("啥啊？" + context.widget.toStringShort());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white30,
        ),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      TypesIcon.typesIcon[sentences[index]['relevant_id']],
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          sentences[index]['sentence_zh'],
                          style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.bold, fontSize: 18),
                          maxLines: 10,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                          onPressed: () {
                            tts.speak(sentences[index]['sentence_zh']);
                          },
                          icon: Icon(
                            Icons.volume_up_outlined,
                            color: Colors.blueAccent,
                            size: 20,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      TypesIcon.typesIcon[0],
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          sentences[index]['sentence_en'],
                          style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.bold, fontSize: 18),
                          maxLines: 10,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final String sentences_base_url = BASE_URL + "/search";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          start = start + 1;
        });
        Http.request(sentences_base_url + "/" + searchKey + "/" + start.toString(), null, new Options(method: "GET"));
      }
    });
    Http.request(sentences_base_url + "/" + searchKey + "/" + start.toString(), null, new Options(method: "GET"));
  }

  /// 处理请求返回的数据，有可能是错误的response要弹框处理
  void requestCallBack(Response response) {
    if (response.statusCode == 200 && response.data != null) {
      var jsonList = jsonDecode(response.data.toString());
      setState(() {
        sentences.addAll(jsonList["data"]);
      });
      return;
    }
    //TODO 异常情况的弹框处理 tips
  }
}
