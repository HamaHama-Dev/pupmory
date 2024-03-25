/// main
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/conversation/intro/intro.dart';
import 'package:client/conversation/intro/intro_story.dart';
import 'package:client/screen.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'check_user.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:client/sign/sign_up.dart' as sign_up;
import 'package:just_audio/just_audio.dart';

import 'sign/sign_in.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp()); // MyApp 클래스 실행
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


bool play = false; // 배경음악 재생
final player = AudioPlayer(); // 배경음악 플레이어
String station = ""; // 대화단계
List<dynamic> musics =[
  "assets/musics/intro_music_1.mp3", "assets/musics/early_music.mp3", "assets/musics/middle_music.mp3",
  "assets/musics/late_music.mp3", "assets/musics/end_music.mp3",
];

late Map<String, dynamic> parsedResponseAT; // 액세스 토큰
// 로그인 토큰 발급해오기
Future fetchSignInToken(String fToken) async {
  // API 엔드포인트 URL
  print("받토:" + fToken);
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

    sign_in.userAccessToken = parsedResponseAT['accessToken']; // 액세스 토큰을 전역변수에 저장 -> 다른 파일에서도 사용
    print("accessToken:" + sign_in.userAccessToken);

    fetchUserInfo(sign_in.userAccessToken);

  } else {
    // 요청이 실패한 경우 오류 처리
    print('HTTP 요청 실패: ${response.statusCode}');
  }
}

late Map<String, dynamic> parsedResponseUser; // 사용자 정보
bool userNew = false;

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
    print('서버로부터 받은 내용 데이터(사용자 정보~!): ${response.body}');
    var jsonResponse = utf8.decode(response.bodyBytes);
    parsedResponseUser = json.decode(jsonResponse);
    print("확인"+parsedResponseUser["conversationStatus"].toString());

    if(parsedResponseUser["conversationStatus"] == 0){
      print("인트로");
      userNew = true;
    } else{
      print("메인홈으로 이동");
    }

  } else {
    // 요청이 실패한 경우 오류 처리
    print('HTTP 요청 실패: ${response.statusCode}');
  }
}

class _MyAppState extends State<MyApp> {
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    return GetMaterialApp(
      builder: (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return CustomError(errorDetails: errorDetails);
        };
        return widget!;
      },
      debugShowCheckedModeBanner: false,
      home:
      StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // 로딩 스피너 또는 로딩 화면을 보여줄 수 있습니다.
          } else if (snapshot.hasData && checkSignUp == false) {
            // 사용자가 로그인한 경우, 로그인된 화면으로 이동
            // 토큰 패치
            fetchSignInToken(FirebaseAuth.instance.currentUser!.uid);
            if(play){
              if(station.contains("0")){
                player.setAsset(musics[0]);
                player.play();
              } else if(station.contains("1")){
                player.setAsset(musics[0]);
                player.play();
              } else if(station.contains("2")){
                player.setAsset(musics[0]);
                player.play();
              } else if(station.contains("3")){
                player.setAsset(musics[0]);
                player.play();
              } else if(station.contains("4")){
                player.setAsset(musics[0]);
                player.play();
              }
            }
            //return userNew? MyScreenPage(title: '홈') : IntroPage();
            //return CheckUserPage(title: "title");
            return MyScreenPage(title: '홈');
          } else if(snapshot.hasData && checkSignUp == true){
            return IntroStoryPage();
          }
          else {
            // 사용자가 로그인하지 않은 경우, 로그인 화면으로 이동
            print("로그인 안 했거나 예외수 발견");
            //print(sign_in.checkSignIn);
            return sign_in.SignInPage();
          }
        },
      ),


      //SignInPage(),
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffDDE7FD),
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white.withOpacity(0)
          )
      ),
      // getPages: [
      //   GetPage(name: '/login', page: () => LoginPage()),
      // ],
    );
  }
}



class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomError({
    Key? key,
    required this.errorDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      ),
    );
  }
}