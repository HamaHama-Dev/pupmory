/// 옮기기 가능
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
//import 'package:client/memorial/watch_others.dart';
import 'conversation/intro/intro.dart';
import 'home.dart';
import 'memorial/memorial_main.dart';
import 'memorial/watch_others.dart';
import 'mypage/mypage_main.dart';
import 'main.dart' as main;
import 'screen.dart';
//import 'memorial/memorial_main0919.dart';


class CheckUserPage extends StatefulWidget {
  const CheckUserPage({super.key, required this.title});

  final String title;

  @override
  State<CheckUserPage> createState() => _CheckUserPageState();
}

class _CheckUserPageState extends State<CheckUserPage> {

  @override
  void initState() {
    super.initState();

  }
  int _selectedIndex = 0;



  // 메인 위젯
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        child: Text("미쳐날뛰는중~"),
      ),
    );
  }
}