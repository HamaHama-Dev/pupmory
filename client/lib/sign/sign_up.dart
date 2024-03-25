import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/conversation/intro/intro.dart';
import 'package:client/conversation/intro/intro_story.dart';
import 'package:client/screen.dart';
import 'package:client/sign/sign_in.dart';
import 'package:client/style.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:client/sign/sign_in.dart' as sign_in;

// bool checkSignUp = false;

/// 회원가입 페이지(이메일 회원가입)
class SignUpPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => SignUpPage(),
      ),
    );
  }

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  //final List<XFile>? images = await _picker.pickMultiImage();

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final rePWController = TextEditingController();
  final codeController = TextEditingController();

  // 텍스트 필드 저장
  String userEmail ="";
  String userPassword ="";
  String userPasswordCheck ="";
  String codeCheck ="";

  // 단계를 위한 bool
  bool emailCheck = false;
  bool pwCheck = false;
  bool pwReCheck = false;
  bool sentEmail = false;
  bool codeSuccess = false;

  // 텍스트 필드에 입력을 했는지 확인
  bool setEmail = false;
  bool setPassword = false;
  bool setPasswordCheck = false;
  bool setCodeCheck = false;

  // 회원 인증 코드 발송(POST)
  void sendEmailCode(String email) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/auth/email?email=${email}'; // 실제 API 엔드포인트로 변경하세요

    // 헤더 정보 설정
    Map<String, String> headers = {

    };

    // HTTP GET 요청 보내기
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers, // 헤더 추가
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      setState(() {});

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 회원 코드 인증 검사
  void checkCode(String code, String email) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/auth/code?code=${code}&issuedBy=${email}'; // 실제 API 엔드포인트로 변경하세요

    // 헤더 정보 설정
    Map<String, String> headers = {
    };

    // HTTP GET 요청 보내기
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: headers, // 헤더 추가
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);
      // 파이어베이스에 값을 넣으라고??
      // 그러고 파베에서 uid 뽑아오고 ㅇㅋ


      emailCheck = true;

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  late Map<String, dynamic> parsedResponseUser; // 사용자 정보

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

      parsedResponseUser = json.decode(jsonResponse);

      // 인트로로 이동
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IntroStoryPage()));

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  late Map<String, dynamic> parsedResponseAT; // 액세스 토큰

  // 회원가입 = 회원생성 및 회원 처음 정보 db 생성을 위해서 존재
  void fetchSignUpToken(String userUid, String email) async {

    // 요청 본문 데이터
    var data = {
      "userUid": userUid,
      "email": email,
    };

    String apiUrl = 'http://3.38.1.125:8080/auth/signup'; // 실제 API 엔드포인트로 변경하세요

    // 헤더 정보 설정
    Map<String, String> headers = {
      'X-Firebase-Token': userUid, // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
      'Accept': '*/*'
    };

    // HTTP GET 요청 보내기
    var response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(data),
      headers: headers, // 헤더 추가
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseAT = json.decode(jsonResponse);

      userAccessToken = parsedResponseAT['accessToken']; // 액세스 토큰을 전역변수에 저장 -> 다른 파일에서도 사용
      print("accessToken:" + userAccessToken);
      sign_in.checkSignUp = true;
      sign_in.userAccessToken = userAccessToken;
      fetchUserInfo(userAccessToken);


    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() async {
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Scaffold(
        backgroundColor: Color(0xffF2F4F6),
        appBar: AppBar(
          title: Text("회원가입", style: textStyle.bk20normal),
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
              /// 텍스트
              if(emailCheck == false && pwCheck == false && pwReCheck == false)...[
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('이메일 주소를 입력하세요.',style: textStyle.bk20semibold),
                        SizedBox(height: 16,),
                        Text('이메일 인증을 위해 정확한 이메일을 작성해주세요.',style: textStyle.bk13light),
                      ],
                    ),
                  ],
                ),

              ] else if(emailCheck == true && pwCheck == false && pwReCheck == false )...[
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('비밀번호를 설정해주세요.',style: textStyle.bk20semibold),
                        SizedBox(height: 16,),
                        Text('로그인에 사용할 비밀번호를 입력하세요.',style: textStyle.bk13light),
                      ],
                    ),
                  ],
                ),
              ] else if(emailCheck == true && pwCheck == true && pwReCheck == false)...[
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('비밀번호를 확인해주세요.',style: textStyle.bk20semibold),
                        SizedBox(height: 16,),
                        Text('비밀번호를 다시 입력해주세요.',style: textStyle.bk13light),
                      ],
                    ),
                  ],
                ),
              ],
              // else if((emailCheck == true && pwCheck == true && pwReCheck == true))...[
              //   Row(
              //     children: [
              //       SizedBox(width: 15,),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text('본인 인증 이메일을 전송했어요.',style: textStyle.bk20semibold),
              //           SizedBox(height: 16,),
              //           Text('본인 인증을 통해 회원가입을 완료해보세요.\n이메일이 오지 않았다면, 스팸메일함을 확인해보세요.',style: textStyle.bk13light),
              //         ],
              //       ),
              //     ],
              //   ),
              // ],

              SizedBox(height: 20,),

              /// 텍스트 필드
              if(emailCheck == false && pwCheck == false && pwReCheck == false)...[
                Form(
                  key: _formKey,
                  child:
                  Container(
                    width: screenSize.width,
                    height: 44,
                    child: TextFormField(
                      style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
                          fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.black)),
                      controller: emailController,
                      onChanged: (text){
                        setEmail = true;
                        setState(() {
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top:3, left: 5),
                        hintStyle: textStyle.grey16normal,
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(width: 1, color: Colors.white),
                        ),
                        filled: true,
                        fillColor: Color(0xffF9F9F9),
                        hintText: '이메일 주소',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onSaved: (value) {
                        print('Name field onSaved:$value');
                      },
                      validator: (value) {
                        if(!RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(value!)){
                          return '잘못된 이메일 형식입니다.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        print('submitted:$value');
                      },
                    ),
                  ),

                ),

              ]else if((emailCheck == true && pwCheck == false && pwReCheck == false))...[
                Form(
                  key: _formKey,
                  child:

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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(width: 1, color: Colors.white),
                        ),
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
                ),



              ] else if((emailCheck == true && pwCheck == true && pwReCheck == false))...[
                Form(
                  key: _formKey,
                  child:
                  Container(
                    width: screenSize.width,
                    height: 44,
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
                          fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.black)),
                      controller: rePWController,
                      onChanged: (text){
                        setPasswordCheck = true;
                        setState(() {
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top:3, left: 5),
                        hintStyle: textStyle.grey16normal,
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(width: 1, color: Colors.white),
                        ),
                        filled: true,
                        fillColor: Color(0xffF9F9F9),
                        hintText: '비밀번호 확인',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onSaved: (value) {
                        print('Name field onSaved:$value');
                      },
                      validator: (value) {
                        if(!(value == userPassword)){
                          return '비밀번호가 일치하지 않습니다.';
                        }
                      },
                      onFieldSubmitted: (value) {
                        print('submitted:$value');
                      },
                    ),
                  ),


                ),

              ],
              // else if((emailCheck == true && pwCheck == true && pwReCheck == true))...[
              //
              //   Container(
              //     width: screenSize.width,
              //     height: 44,
              //     child: TextField(
              //       style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
              //           fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.black)),
              //       readOnly: true, // 읽기 전용
              //       decoration: InputDecoration(
              //         contentPadding: EdgeInsets.only(top:3, left: 5),
              //         border: InputBorder.none,
              //         filled: true,
              //         fillColor: Color(0xffEAEAEA),
              //         hintText: userEmail,
              //         hintStyle: textStyle.grey16normal,
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
              //           borderRadius: BorderRadius.circular(12.0),
              //         ),
              //       ),
              //     ),
              //   )
              // ],
              SizedBox( height: 16,),
              /// 버튼
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(emailCheck == false && pwCheck == false && pwReCheck == false)...[
                    if(setEmail)...[
                      Container(
                        height: 44,
                        width: screenSize.width,
                        child: ElevatedButton(onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _formKey.currentState!.save();
                              //emailCheck = true;
                              userEmail = emailController.text;
                              sentEmail = true;
                              sendEmailCode(emailController.text);
                            });
                          }
                          //setState(() {});
                        },
                            style: buttonChart().signInbtn,
                            child: Text("인증 코드 받기", style: textStyle.white16semibold,)
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
                            child: Text("인증 코드 받기", style: textStyle.white16semibold,)
                        ),
                      ),
                    ],
                    SizedBox(height: 32,),

                    if(sentEmail)...[
                      Container(
                        width: screenSize.width,
                        height: 44,
                        child: TextFormField(
                          obscureText: true,
                          style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
                              fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.black)),
                          controller: codeController,
                          onChanged: (text){
                            setCodeCheck = true;
                            setState(() {
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top:3, left: 5),
                            hintStyle: textStyle.grey16normal,
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(width: 1, color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Color(0xffF9F9F9),
                            hintText: '인증 번호',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onSaved: (value) {
                            print('Name field onSaved:$value');
                          },
                          onFieldSubmitted: (value) {
                            print('submitted:$value');
                          },
                        ),
                      ),
                      SizedBox(height: 16,),
                      if(setCodeCheck)...[
                        Container(
                          height: 44,
                          width: screenSize.width,
                          child: ElevatedButton(onPressed: (){
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _formKey.currentState!.save();
                                //emailCheck = true;
                                //sendEmailCode(emailController.text);
                                checkCode(codeController.text, userEmail);
                              });
                            }
                            //setState(() {});
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
                      ],
                    ],

                  ]
                  else if(emailCheck == true && pwCheck == false && pwReCheck == false)...[
                    if(setPassword)...[
                      Container(
                        height: 44,
                        width: screenSize.width,
                        child: ElevatedButton(onPressed: (){

                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _formKey.currentState!.save();
                              pwCheck = true;
                              userPassword = pwController.text;
                            });
                          }
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
                  ]
                  else if(emailCheck == true && pwCheck == true && pwReCheck == false)...[
                      if(setPasswordCheck)...[
                        Container(
                          height: 44,
                          width: screenSize.width,
                          child: ElevatedButton(onPressed: () async{
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _formKey.currentState!.save();
                                pwReCheck = true;
                                userPasswordCheck = rePWController.text;
                              });
                              try {
                                final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: userEmail, password: userPasswordCheck);
                                if (result.user != null) {
                                  // 인증 메일 발송
                                  // result.user!.sendEmailVerification();
                                  // 회원가입의 로그인
                                  checkSignUp = true;
                                  fetchSignUpToken(result.user!.uid,userEmail);
                                }
                              } on Exception catch (e) {
                                print("object");
                                //logger.e(e.toString());
                                //List<String> result = e.toString().split(", ");
                                //setLastFBMessage(result[1]);
                                //return false;
                              }
                            }
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

                    ]
                  // else if(emailCheck == true && pwCheck == true && pwReCheck == true)...[
                  //     Container(
                  //       height: 44,
                  //       width: screenSize.width,
                  //       child: ElevatedButton(onPressed: (){
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => SignInPage()));
                  //       },
                  //           style: buttonChart().signInbtn,
                  //           child: Text("확인", style: textStyle.white16semibold,)
                  //       ),
                  //     ),
                  //   ],
                ],
              ),


            ],
          ),
        ),

      );

  }
}