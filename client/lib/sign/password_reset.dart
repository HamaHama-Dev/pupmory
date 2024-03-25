import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/style.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_in.dart';

/// 비밀번호 재설정 페이지
class PasswordResetPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => PasswordResetPage(),
      ),
    );
  }

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {

  //final List<XFile>? images = await _picker.pickMultiImage();

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final emailController = TextEditingController();

  String setedEmail = "";

  // 단계를 위한 bool
  bool setEmail = false;
  bool sent = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() async {
    super.dispose();
  }

  // 비밀번호 재설정
  @override
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Scaffold(
        backgroundColor: Color(0xffF2F4F6),
        appBar: AppBar(
          title: Text("비밀번호 재설정", style: textStyle.bk20normal),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),extendBodyBehindAppBar: true,
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 86,),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sent ? '이메일을 전송했어요.':'가입한 이메일 주소를 입력하세요.',style: textStyle.bk20semibold),
                      SizedBox(height: 16,),
                      Text(sent ?'비밀번호 재설정을 위한 이메일을 전송했어요.\n이메일이 오지 않았다면, 스팸메일함을 확인해보세요.' : '이메일 주소로 비밀번호 재설정 링크를 전송합니다.',style: textStyle.bk13light),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16,),

              if(sent == false)...[
                Container(
                  width: screenSize.width,
                  height: 44,
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
                        fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.black)),
                    onChanged: (text){
                      setEmail = true;
                      setState(() {
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top:3, left: 5),
                      hintStyle: textStyle.grey16normal,
                      filled: true,
                      border: InputBorder.none,
                      fillColor: Color(0xffF9F9F9),
                      hintText: '이메일 주소',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ]else...[
                Container(
                  width: screenSize.width,
                  height: 44,
                  child: TextField(
                    style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
                        fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.grey)),
                    readOnly: true, // 읽기 전용
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top:3, left: 5),
                      hintStyle: textStyle.grey16normal,
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Color(0xffEAEAEA),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 16,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(sent==false)...[
                    if(setEmail)...[
                      Container(
                        height: 44,
                        width: screenSize.width,
                        child: ElevatedButton(onPressed: (){
                          // 이메일로 비밀번호 재설정 링크 전달
                          sent = true;
                          setedEmail = emailController.text;
                          resetPassword(setedEmail);
                          setState(() {});
                        },
                            style: buttonChart().signInbtn,
                            child: Text("이메일 전송", style: textStyle.white16semibold,)
                        ),
                      ),
                    ]else...[
                      Container(
                        height: 44,
                        width: screenSize.width,
                        child: ElevatedButton(onPressed: (){
                          // 아무 반응 없는 것이 맞음
                        },
                            style: buttonChart().purplebtn3,
                            child: Text("이메일 전송", style: textStyle.white16semibold,)
                        ),
                      ),
                    ]
                  ]else...[
                    Container(
                      height: 44,
                      width: screenSize.width,
                      child: ElevatedButton(onPressed: (){
                        // 처음 로그인 화면으로 이동하기
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()));
                      },
                          style: buttonChart().signInbtn,
                          child: Text("확인", style: textStyle.white16semibold,)
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        )

      );
  }
}
