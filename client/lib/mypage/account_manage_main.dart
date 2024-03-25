import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/mypage/delete_account.dart';
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
import 'package:firebase_auth/firebase_auth.dart';

/// 계정 관리
class AccountManageMainPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => AccountManageMainPage(),
      ),
    );
  }

  @override
  _AccountManageMainPageState createState() => _AccountManageMainPageState();
}

class _AccountManageMainPageState extends State<AccountManageMainPage> {

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

  // 로그아웃(이메일, 구글 둘다 포함)
  Future<void> signOut() async {
    await Firebase.initializeApp();

    try {
      await FirebaseAuth.instance.signOut();
      print("Log-Out Success");
      sign_in.userAccessToken = "";
      setState(() {

      });
    } catch (e) {
      print(e.toString());
    }
  }

  // 로그아웃 다이얼로그
  void LogOutDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(30.0))),
          content: Builder(
            builder: (context) {

              return Container(
                  height: 296,
                  width: 292,
                  child:
                  Padding(padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          width: 125,
                          height: 117,
                          child: SvgPicture.asset(
                            'assets/images/no_result.svg',
                            width: 132,
                            height: 123,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 40,),
                        Text("로그아웃 하시겠어요?",style: textStyle.bk16bold,),
                        SizedBox(height: 40,),
                        Row(
                          children: [
                            Container(width: 120,
                              child: ElevatedButton(
                                child: new Text("취소", style: textStyle.purple16midium),
                                style: buttonChart().purplebtn3,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(width: 124,
                              child: ElevatedButton(
                                child: new Text("로그아웃", style: textStyle.white16semibold),
                                style: buttonChart().purplebtn,
                                onPressed: () {
                                  signOut();
                                  Navigator.popUntil(context, ModalRoute.withName("/"));
                                  //Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),)
              );
            },
          ),
        )
    );
  }


  @override
  void initState() {
    super.initState();
    fetchUserInfo(sign_in.userAccessToken); // 사용자 정보 가져오기
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
                            '계정 관리',
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
        ),
        extendBodyBehindAppBar: false,
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
                    SizedBox(height: 4,),
                    Container(
                      padding: EdgeInsets.all(16),
                      height: 81,
                      width: screenSize.width,
                      decoration: BoxDecoration(
                        color: Color(0xffF2F6FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('이메일 주소',style: textStyle.bk14midium,),
                          SizedBox(height: 8,),
                          Text('${parsedResponseUser['email']}',style: textStyle.bk16normal,),
                        ],
                      )
                    ),
                    SizedBox(height: 16,),

                  ],
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
                                  builder: (context) => PasswordResetPage()));
                        },
                        child: Row(
                          children: [
                            Container(width: 310,
                            child: Text('비밀번호 재설정',style: textStyle.bk14normal,),
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
                          LogOutDialog();
                        },
                        child: Row(
                          children: [
                            Container(width: 310,
                              child: Text('로그아웃',style: textStyle.bk14normal,),
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
                                  builder: (context) => DeleteAccountPage()));
                        },
                        child: Row(
                          children: [
                            Container(width: 310,
                              child: Text('탈퇴하기',style: textStyle.bk14normal,),
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
