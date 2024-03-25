import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
//import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
import 'announcement_main.dart' as anmain;

/// 공지사항 글
class AnnouncementDetailPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => AnnouncementDetailPage(),
      ),
    );
  }

  @override
  _AnnouncementDetailPageState createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {

  late Map<String, dynamic> parsedResponseUser; // 사용자 정보
  bool takeUser = false;

  late Map<String, dynamic> parsedResponseCM; // 글 세부 내용
  bool addComment = false; // 바로 코멘트 붙였을 때
  bool isComment = false;

  String title = "";
  String content = "";

  int comments = 0;

  // 세부글 가져오기
  void fetchDataAD() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/mypage/announcement?aid=${anmain.contentId}';

    // HTTP GET 요청 보내기
    var response = await http.get(Uri.parse(apiUrl));

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      var data = json.decode(response.body);
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCM = json.decode(jsonResponse);

      title = parsedResponseCM['title'];
      content = parsedResponseCM['content'];

      // 데이터 처리
      print('서버로부터 받은 데이터: $jsonResponse');

      takeUser = true;
      isComment = true;
      comments = parsedResponseCM.length;
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchDataAD(); // 사용자 정보 가져오기
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
                              '공지사항',
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
                  if(takeUser)...[
                    SizedBox(height: 0,),
                    Container(
                      width: Get.width,
                      child:
                      ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                          child:
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8,),
                                Text('제목', style: textStyle.bk14midium,),
                                SizedBox(height: 8,),
                                Text('${title}', style: textStyle.bk16normalCon,),
                                SizedBox(height: 8,),
                              ],
                            ),
                          )
                      ),
                      //Image.network(parsedResponseCM[index]['image'], fit: BoxFit.cover,),
                    ),
                    SizedBox(height: 8,),

                    Container(
                      width: Get.width,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                          child:
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(top: 16, left: 16, right: 16,bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('내용', style: textStyle.bk14midium,),
                                SizedBox(height: 8,),
                                Text('${content}', style: textStyle.bk16normalCon,)
                              ],
                            ),
                          )
                      ),
                    ),

                  ],

                ],
              ),
            ),
          )

      );

  }
}
