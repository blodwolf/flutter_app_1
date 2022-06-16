import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/chinese/http/dio_http.dart';
import 'package:flutter_app_1/chinese/http/http.dart';
import 'package:flutter_app_1/chinese/tools/base.dart';
import 'package:flutter_app_1/chinese/types.dart';
import 'package:text_to_speech/text_to_speech.dart';

//我的列表页使用这个
class CollectionsPage extends StatefulWidget {
  _CollectionsPage createState() => _CollectionsPage();
}

class _CollectionsPage extends State<CollectionsPage> {
  var sentences = [];
  TextToSpeech tts = TextToSpeech();
  bool isLoading = false;
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
              padding: EdgeInsets.only(top: 10),
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      TypesIcon.typesIcon[int.parse(sentences[index]['relevant_id'])],
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          sentences[index]['sentence_zh'],
                          style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 12),
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
                            size: 10,
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
                          sentences[index]['sentence'],
                          style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 12),
                          maxLines: 10,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  sentences.removeAt(index);
                });
                Http.request(collections_cancel + sentences[index]['id'], null, new Options(method: "GET"));
              },
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  final String collections_cancel = BASE_URL + "/collections/cancel/1/";
  final String sentences_base_url = BASE_URL + "/collections/1";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          start = start + 1;
        });
        Http.request(sentences_base_url + "/" + start.toString(), null, new Options(method: "GET"));
      }
    });
    Http.request(sentences_base_url + "/" + start.toString(), null, new Options(method: "GET"));
  }

  /// 处理请求返回的数据，有可能是错误的response要弹框处理
  void requestCallBack(Response response) {
    if (response.statusCode == 200 && response.data != null) {
      var jsonList = jsonDecode(response.data.toString());
      setState(() {
        sentences.addAll(new List<Map<String, dynamic>>.from(jsonList["data"]));
      });
      return;
    }
    //TODO 异常情况的弹框处理 tips
  }
}
