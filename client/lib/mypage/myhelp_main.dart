import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/mypage/myhelp_memorial.dart';
import 'package:client/mypage/myhelp_watch_others.dart';
import 'package:client/sign/password_reset.dart';
import 'package:client/style.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:exif/exif.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client/sign/sign_in.dart' as sign_in;

import 'myhelp_con.dart';

/// 도움말
class MyHelpMainPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => MyHelpMainPage(),
      ),
    );
  }

  @override
  _MyHelpMainPageState createState() => _MyHelpMainPageState();
}

class _MyHelpMainPageState extends State<MyHelpMainPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Scaffold(
          backgroundColor: Color(0xffF2F4F6),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(72),
            child: AppBar(
              title:
              Container(
                  height: 50,
                  width: screenSize.width,
                  child: Column(
                    children: [
                      SizedBox(height: 24,),
                      Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 60),
                            child: Text(
                              '도움말',
                              style: textStyle.bk20normal,
                            ),
                          )),
                    ],)
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              leading: Padding(
                padding: EdgeInsets.only(top: 20),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),extendBodyBehindAppBar: false,
          body: Container(
            width: screenSize.width,
            height: screenSize.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              scrollDirection: Axis.vertical,
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    height: 49,
                    width: screenSize.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHelpHelpPage()));
                        },
                        child: Row(
                          children: [
                            Container(width: 310,
                              child: Text('도움보내기 도움말',style: textStyle.bk14normal,),
                            ),
                            SvgPicture.asset(
                              'assets/images/memorial/blue_arrow.svg',
                              //fit: BoxFit.cover,
                            ),
                          ],
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    padding: EdgeInsets.all(16),
                    height: 49,
                    width: screenSize.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHelpMemorialPage()));
                        },
                        child: Row(
                          children: [
                            Container(width: 310,
                              child: Text('기억할개 도움말',style: textStyle.bk14normal,),
                            ),
                            SvgPicture.asset(
                              'assets/images/memorial/blue_arrow.svg',
                              //fit: BoxFit.cover,
                            ),
                          ],
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    padding: EdgeInsets.all(16),
                    height: 49,
                    width: screenSize.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHelpWatchOthersPage()));
                        },
                        child: Row(
                          children: [
                            Container(width: 310,
                              child: Text('함께할개 도움말',style: textStyle.bk14normal,),
                            ),
                            SvgPicture.asset(
                              'assets/images/memorial/blue_arrow.svg',
                              //fit: BoxFit.cover,
                            ),
                          ],
                        )
                    ),
                  ),

                ],
              ),
            ),
          )

      );

  }
}
