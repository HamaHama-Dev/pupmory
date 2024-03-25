import 'package:flutter_svg/svg.dart';
import 'package:client/conversation/intro/intro.dart';
import 'package:client/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import '../screen.dart';
import 'password_reset.dart';
import 'sign_up.dart';

String userAccessToken = "";
bool checkSignUp = false;

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorString = ''; //login error 보려고 만든 String state

  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장

  // _asyncMethod() async {
  //   // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
  //   // 데이터가 없을때는 null을 반환
  //   userInfo = await storage.read(key:'login');
  //
  //   // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
  //   if (userInfo != null) {
  //     Navigator.pushNamed(context, '/main');
  //   } else {
  //     print('로그인이 필요합니다');
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _asyncMethod();
    // });
  }


  late Map<String, dynamic> parsedResponseAT; // 액세스 토큰

  // 로그인 토큰 발급해오기
  void fetchSignInToken(String fToken) async {
    // API 엔드포인트 URL
    print("받은 로그인 토큰:" + fToken);
    String apiUrl = 'http://3.38.1.125:8080/auth/signin'; // 실제 API 엔드포인트로 변경하세요

    // 헤더 정보 설정
    Map<String, String> headers = {
      'X-Firebase-Token': fToken, // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
      'Accept': '*/*'
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

      parsedResponseAT = json.decode(jsonResponse);

      userAccessToken = parsedResponseAT['accessToken']; // 액세스 토큰을 전역변수에 저장 -> 다른 파일에서도 사용
      print("accessToken:" + userAccessToken);

      fetchUserInfo(userAccessToken);

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패(로그인 토큰 발급): ${response.statusCode}');
    }
  }

  // late List<dynamic> parsedResponseCM;
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
      print("뾰잉");
      print(parsedResponseUser["conversationStatus"]);

      print("현재 사용자의 대화 단계: "+ parsedResponseUser.toString());
      // if(parsedResponseUser["conversationStatus"].toString() == "0"){
      //   print("현재 사용자 단계 0인데?");
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => IntroPage()));
      // }else{
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => MyScreenPage(title: '스크린 페이지',)));
      // }

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패(사용자 정보 조회): ${response.statusCode}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  // 구글 사용자를 위한 함수
  late Map<String, dynamic> parsedResponseAT2; // 액세스 토큰

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

      parsedResponseAT2 = json.decode(jsonResponse);

      userAccessToken = parsedResponseAT2['accessToken']; // 액세스 토큰을 전역변수에 저장 -> 다른 파일에서도 사용
      print("accessToken:" + userAccessToken);

      userAccessToken = userAccessToken;

      fetchUserInfo(userAccessToken);

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패(회원가입): ${response.statusCode}');
    }
  }

  // 구글 로그인
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    //print("google~: " + credential.);

    //final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      // 사용자가 처음 로그인한 경우
      print("check uid(처음 로그인):"+ user.uid);
      fetchSignUpToken(user.uid, googleUser!.email);
      checkSignUp = true;

    } else{
      print("check uid(원래 있던 로그인):"+ user!.uid);
      fetchSignInToken(user!.uid);
    }

    // fetchSignUpToken(googleUser!.email,user!.uid);
    // fetchSignInToken(user!.uid);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }



  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Color(0xffDDE7FD),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 120,),
              Container(
                width: screenSize.width,
                height: 64,
                child: SvgPicture.asset(
                  'assets/images/logo/pupmory_logo3.svg',
                ),
              ),
              SizedBox(height: 32,),

              // Container(
              //   width: screenSize.width,
              //   height: 44,
              //   child:
              //   TextFormField(
              //     controller: idController,
              //     style: textStyle.bk16normal,
              //     decoration: InputDecoration(
              //       contentPadding: EdgeInsets.only(top:3, left: 5),
              //       hintStyle: textStyle.grey16normal,
              //       border: InputBorder.none,
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12.0),
              //         borderSide: BorderSide(width: 1, color: Colors.white),
              //       ),
              //       filled: true,
              //       fillColor: Color(0xffEEF3FE),
              //       hintText: '이메일',
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
              //         borderRadius: BorderRadius.circular(12.0),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                width: screenSize.width,
                height: 44,
                child: TextFormField(
                  controller: idController,
                  style: textStyle.bk16normal,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top:3, left: 5),
                    hintStyle: textStyle.grey16normal,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Color(0xffEEF3FE),
                    hintText: '이메일',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16,),

              Container(
                width: screenSize.width,
                height: 44,
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  style: textStyle.bk16normal,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top:3, left: 5),
                    hintStyle: textStyle.grey16normal,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Color(0xffEEF3FE),
                    hintText: '비밀번호',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: screenSize.width,
                    height: 44,
                    child: ElevatedButton(onPressed: ()async{

                      try{
                        UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: idController.text,
                            password: passwordController.text
                        );

                        if (credential.user != null) {
                          // checkSignIn = true;
                          print("테스트");
                          print(credential);
                          print(credential.user!.uid);

                          fetchSignInToken(credential.user!.uid);

                          print("okay");

                        }

                        User user = await FirebaseAuth.instance.currentUser!;
                        IdTokenResult tokenResult = await user.getIdTokenResult();
                        String? token = tokenResult?.token;
                        // Send token to your backend via HTTPS
                        /// 규리 언니가 해준 부분
                        print("토큰 결과:");
                        print(token); // 이거를 서버로 전달하세요

                        print("login Success");

                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (_) => const Start1Page(title: "시작 페이지")));

                      } on FirebaseAuthException catch(e){
                        print('an error occured $e');
                      }

                    },
                        style: buttonChart().signInbtn,
                        child: Text("로그인", style: textStyle.white16semibold,)
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      //PasswordResetPage
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordResetPage()));
                    },
                    child: Text("비밀번호를 잊으셨나요?", style: textStyle.bk12normal),),
                ],
              ),

              SizedBox(height: 162,),
              Container(
                height: 44,
                width: screenSize.width,
                child: ElevatedButton(onPressed: (){
                  signInWithGoogle();
                },
                    style: buttonChart().whitebtn2,
                    child: Row(
                      children: [
                        SizedBox(width: 65,),
                        SvgPicture.asset(
                          'assets/images/sign/google_logo.svg',
                        ),
                        SizedBox(width: 15,),
                        Text("Google 계정으로 로그인", style: textStyle.bk16midium,)
                      ],
                    )
                ),
              ),
              SizedBox(height: 16,),
              Container(
                height: 44,
                width: screenSize.width,
                child: ElevatedButton(onPressed: (){
                  // checkSignUp = true; // 위치 변경 필요
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpPage()));
                },
                    style: buttonChart().bluebtn,
                    child: Text("이메일로 회원가입", style: textStyle.bk16midium,)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}