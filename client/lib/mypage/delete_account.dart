import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:client/style.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
// import 'sign_in.dart';

/// 회원 탈퇴 페이지
class DeleteAccountPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => DeleteAccountPage(),
      ),
    );
  }

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        print("계정 삭제 성공");
      } else {
        print("사용자 로그인 상태 아님");
      }
    } catch (e) {
      print("계정 삭제 실패: $e");
    }
  }

  // 계정 삭제 - DB 삭제
  void deleteAccount(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/user/account';

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    // HTTP GET 요청 보내기
    var response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers, // 헤더 추가
    );

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      print("삭제성공");
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 회원탈퇴 다이얼로그
  void deleteDialog() {
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
                        SizedBox(height: 32,),
                        Text("정말 탈퇴하시겠어요?",style: textStyle.bk16bold,),
                        SizedBox(height: 16,),
                        Text("탈퇴 후에는 데이터를 복구할 수 없어요.",style: textStyle.bk14normal,),
                        SizedBox(height: 16,),
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
                                child: new Text("탈퇴하기", style: textStyle.white16semibold),
                                style: buttonChart().purplebtn,
                                onPressed: () {
                                  //signOut();
                                  _deleteAccount();
                                  deleteAccount(sign_in.userAccessToken);
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

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final pwController = TextEditingController();

  // 단계를 위한 bool
  bool setPassword = false;

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
          appBar: AppBar(
            title: Text("탈퇴하기", style: textStyle.bk20normal),
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
                        Text('비밀번호를 입력해주세요.',style: textStyle.bk20semibold),
                        SizedBox(height: 16,),
                        Text('계정 비밀번호를 입력하세요.',style: textStyle.bk13light),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16,),

                Container(
                  width: screenSize.width,
                  height: 44,
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
                        fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.black)),
                    controller: pwController,
                    onChanged: (text){
                      setPassword = true;
                      setState(() {
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top:3, left: 5),
                      hintStyle: textStyle.grey16normal,
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Color(0xffF9F9F9),
                      hintText: '비밀번호',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onSaved: (value) {
                      print('Name field onSaved:$value');
                    },
                    validator: (value) {
                      if(value!.length < 8){
                        return '8자 이상의 영문, 숫자, 특수문자를 조합하여 설정해주세요.';
                      }
                      // if(!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value!)){
                      //   return '8자 이상의 영문, 숫자, 특수문자를 조합하여 설정해주세요.';
                      // } else if(!RegExp(r'[a-zA-Z]').hasMatch(value!)){
                      //   return '8자 이상의 영문, 숫자, 특수문자를 조합하여 설정해주세요.';
                      // }else if(value!.length < 8){
                      //   return '8자 이상의 영문, 숫자, 특수문자를 조합하여 설정해주세요.';
                      // }
                    },
                    onFieldSubmitted: (value) {
                      print('submitted:$value');
                    },
                  ),
                ),
                SizedBox( height: 16,),
                if(setPassword)...[
                  Container(
                    height: 44,
                    width: screenSize.width,
                    child: ElevatedButton(onPressed: (){

                      deleteDialog();
                      // if (_formKey.currentState!.validate()) {
                      //   setState(() {
                      //     _formKey.currentState!.save();
                      //     pwCheck = true;
                      //     userPassword = pwController.text;
                      //   });
                      // }
                    },
                        style: buttonChart().signInbtn,
                        child: Text("다음", style: textStyle.white16semibold,)
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
                        child: Text("다음", style: textStyle.white16semibold,)
                    ),
                  ),
                ]
              ],
            ),
          )

      );
  }
}
