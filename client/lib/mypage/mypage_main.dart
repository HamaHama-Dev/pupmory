import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/mypage/account_manage_main.dart';
import 'package:client/mypage/announcement_main.dart';
import 'package:client/mypage/mycoments.dart';
import 'package:client/mypage/myhelp_main.dart';
import 'package:client/style.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:dio/dio.dart';


class MypagePage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => MypagePage(),
      ),
    );
  }

  @override
  _MypagePageState createState() => _MypagePageState();
}

class _MypagePageState extends State<MypagePage> {
  
  late Map<String, dynamic> parsedResponseUser; // 사용자 정보
  
  bool checkUser = false;

  // 사용자 정보 조회 : 대화하기가 1이면 인트로 아니면 그냥 홈으로 이동
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

      checkUser = true;
      parsedResponseUser = json.decode(jsonResponse);
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    fetchUserInfo(sign_in.userAccessToken);
  }

  @override
  void dispose() async {
    super.dispose();
  }

  bool time = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
          color: Color(0xffDDE7FD),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Container(
                width: screenSize.width,
                height: 46,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18,),
                    SvgPicture.asset(
                      'assets/images/logo/pup_logo.svg',
                      height: 25.41,
                      width: 110.19,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: false,
            ),
            body: Container(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child:
                Column(
                  children: [
                    if(checkUser)...[
                      Row(children: [
                        SizedBox(width: 16,),
                        Text('${parsedResponseUser['nickname']}',style: textStyle.bk20semibold,),
                        Text('님',style: textStyle.bk16normal,),
                      ],),
                      SizedBox(height: 8,),
                      Row(children: [
                        SizedBox(width: 16,),
                        Text('${parsedResponseUser['puppyName']}',style: textStyle.bk16semibold,),
                        Text('(${parsedResponseUser['puppyType']}, ${parsedResponseUser['puppyAge']}살)의 반려인',style: textStyle.bk12normal,),
                      ],),
                    ],
                    SizedBox(height: 32,),
                    Row(children: [
                      SizedBox(width: 16,),
                      Container(
                        //padding: EdgeInsets.fromLTRB(14, 13, 0, 15),
                        width: 168,
                        height: 108,
                        decoration: BoxDecoration(
                          color: Color(0xffF2F4F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountManageMainPage()));
                          },
                          child: Container(
                            //padding: EdgeInsets.fromLTRB(14, 13, 0, 15),
                            decoration: BoxDecoration(
                              color: Color(0xffF2F4F6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 32,),
                              Image.asset(
                                'assets/images/mypage/setting.png',
                                width: 28,
                                height: 28,
                              ),
                                SizedBox(height: 16,),
                              Text('계정 관리',style: textStyle.bk12midium,),
                            ],)

                          ),
                        ),
                      ),
                      SizedBox(width: 16,),
                      Container(
                        //padding: EdgeInsets.fromLTRB(14, 13, 0, 15),
                        width: 168,
                        height: 108,
                        decoration: BoxDecoration(
                          color: Color(0xffF2F4F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyCommentsPage()));
                          },
                          child: Container(
                            //padding: EdgeInsets.fromLTRB(14, 13, 0, 15),
                            decoration: BoxDecoration(
                              color: Color(0xffF2F4F6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 28,),
                                SvgPicture.asset(
                                  'assets/images/mypage/comment.svg',
                                ),
                                SizedBox(height: 8,),
                                Text('내가 쓴 댓글',style: textStyle.bk12midium,),
                              ],)
                          ),
                        ),
                      ),
                    ],),
                    SizedBox(height: 16,),
                    Row(
                      children: [
                        SizedBox(width: 16,),
                        Container(
                          //padding: EdgeInsets.fromLTRB(14, 13, 0, 15),
                          width: 168,
                          height: 108,
                          decoration: BoxDecoration(
                            color: Color(0xffF2F4F6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHelpMainPage()));
                            },
                            child: Container(
                              //padding: EdgeInsets.fromLTRB(14, 13, 0, 15),
                              decoration: BoxDecoration(
                                color: Color(0xffF2F4F6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 32,),
                                  SvgPicture.asset(
                                    'assets/images/mypage/help.svg',
                                  ),
                                  SizedBox(height: 8,),
                                  Text('도움말',style: textStyle.bk12midium,),
                                ],)
                            ),
                          ),
                        ),
                        SizedBox(width: 16,),
                        Container(
                          //padding: EdgeInsets.fromLTRB(14, 13, 0, 15),
                          width: 168,
                          height: 108,
                          decoration: BoxDecoration(
                            color: Color(0xffF2F4F6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AnnouncementMainPage()));
                            },
                            child: Container(
                              //padding: EdgeInsets.fromLTRB(14, 13, 0, 15),
                              decoration: BoxDecoration(
                                color: Color(0xffF2F4F6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 24,),
                                  SvgPicture.asset(
                                    'assets/images/mypage/announce.svg',
                                  ),
                                  SizedBox(height: 8,),
                                  Text('공지사항',style: textStyle.bk12midium,),
                                ],)
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 117,),
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 28),
                          width: screenSize.width,
                        child: Image.asset(
                          'assets/images/mypage/cloud.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:88,),
                        child: SvgPicture.asset(
                          'assets/images/mypage/smart.svg',
                        ),),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
      );

  }
}


