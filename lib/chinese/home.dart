
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/chinese/index.dart';
import 'package:flutter_app_1/chinese/search/collections.dart';
import 'package:flutter_app_1/chinese/setting/setting.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>{

  //底部导航
  final List<BottomNavigationBarItem> bottomNavItems=[
    BottomNavigationBarItem(
      icon: Icon(
        Icons.school_outlined,
        color: Colors.lightBlueAccent,
      ),
      label: "Learning",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.favorite,
        color: Colors.lightBlueAccent,
      ),
      label: "Collections",
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
          color: Colors.lightBlueAccent,
        ),
        label: "Settings"),
  ];

  int currentIndex=0;
  Widget currentWidget=IndexPage();

  // void onChangeCurrentWidget(String identification){
  //   log("当前点击"+identification);
  //     setState(() {
  //       currentWidget=SearchList();
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("知识库"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            if(currentIndex==index){
              return;
            }else if(index==1){
              currentWidget=CollectionsPage();
            }else if(index==2){
              currentWidget=Settings();
            }else{
              currentWidget=IndexPage();
            }
            currentIndex=index;
          });
            log("index:"+index.toString());
        },
      ),
      body: currentWidget,
    );
  }
}