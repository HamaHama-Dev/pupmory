import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
import 'package:client/home.dart' as home;

/// 내가 쓴 댓글들
class MyCommentsPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => MyCommentsPage(),
      ),
    );
  }

  @override
  _MyCommentsPageState createState() => _MyCommentsPageState();
}

class _MyCommentsPageState extends State<MyCommentsPage> {

  late Map<String, dynamic> parsedResponseUser; // 사용자 정보
  bool takeUser = false;

  // 사용자 정보 조회
  void fetchUserInfo(String aToken) async {
    // API 엔드포인트 URL
    print("받토:" + aToken);
    String apiUrl = 'http://3.38.1.125:8080/user/info'; // 실제 API 엔드포인트로 변경하세요

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    // HTTP GET 요청 보내기
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: headers, // 헤더 추가
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터(사용자 정보): ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseUser = json.decode(jsonResponse);
      takeUser = true;

      setState(() {

      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  late List<dynamic> parsedResponseCM; // 댓글
  bool isComment = false;
  // 코멘트 수
  int comments = 0;

  // 댓글 가져오기
  void fetchDataComment(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/mypage/comment/all';

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    // HTTP GET 요청 보내기
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: headers, // 헤더 추가
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      var data = json.decode(response.body);
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCM = json.decode(jsonResponse);

      // 데이터 처리
      print('서버로부터 받은 데이터(댓글): $jsonResponse');

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
    fetchUserInfo(sign_in.userAccessToken); // 사용자 정보 가져오기
    fetchDataComment(sign_in.userAccessToken);
  }

  @override
  void dispose() async {
    super.dispose();
  }

  // 리스트 위젯
  Widget listview_builder(){
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: parsedResponseCM.length,
        itemBuilder: (BuildContext context, int index){
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if(takeUser)...[
                    Container(
                      padding: EdgeInsets.all(16),
                      height: 95,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                          onTap: (){
                            // 해당 글으로 이동
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                if(home.user == parsedResponseCM[index]['postOpName'])...[
                                  Text('내가 쓴 글에 댓글을 달았습니다.',style: textStyle.bk6614normal,),
                                ]else...[
                                  Text('${parsedResponseCM[index]['postOpName']}',style: textStyle.bk6614midium,),
                                  Text('님의 글에 댓글을 달았습니다.',style: textStyle.bk6614normal,),
                                ]

                              ],),
                              SizedBox(height: 8,),
                              Text('${parsedResponseCM[index]['content']}',style: textStyle.bk14midium,),
                              SizedBox(height: 8,),
                              Text(DateFormat('MM/dd  HH:mm').format(DateTime.parse(parsedResponseCM[index]['createdAt'])).toString(),style: textStyle.bg10normal,),
                            ],
                          )
                      ),
                    ),
                    SizedBox(height: 16,),

                  ],

                ],
              ),

            ],
          );

        }
    );
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
                              '내가 쓴 댓글',
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
                  children: [
                    listview_builder()
                  ],
                )
            ),
          )

      );

  }
}
