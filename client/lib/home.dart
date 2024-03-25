import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/conversation/early_period/early_coach_mark.dart';
import 'package:client/conversation/early_period/farewell.dart';
import 'package:client/conversation/early_period/memory2.dart';
import 'package:client/conversation/early_period/start_early.dart';
import 'package:client/conversation/end_period/end.dart';
import 'package:client/conversation/end_period/end2.dart';
import 'package:client/conversation/intro/intro.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/conversation/intro/intro_coach_mark.dart';
import 'package:client/conversation/intro/intro_story.dart';
import 'package:client/conversation/middle_period/sadness.dart';
import 'package:client/style.dart';
import 'conversation/early_period/memory.dart';
import 'conversation/intro/intro2.dart';
import 'conversation/late_period/late.dart';
import 'conversation/middle_period/the_truth_untold.dart';
import 'main.dart' as main;
import 'package:client/sign/sign_in.dart' as sign_in;
import 'help/help_main.dart';
import 'package:client/conversation/early_period/start_early.dart' as constart;

String puppy = "";
String user = "";
String userprof = "";
String convs ="";

class HomePage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(),
      ),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var now = DateTime.now(); // 대화하기 버튼 - 현재시간과 DB의 시간 계산
  late DateTime conTime; // 대화 시작 시간

  // 차이에서 시간과 분 추출
  late Duration difference;

  bool nowCon = true; // 현재 대화 가능 시간인지 확인

  int hour = 0;
  int minute = 0;
  bool inHour = false; // 1시간 내 대화가능인지

  bool tap = false;
  // 사용자 정보 조회 : 대화하기가 1이면 인트로 아니면 그냥 홈으로 이동
  late Map<String, dynamic> parsedResponseUser; // 사용자 정보
  bool checkUser = false;
  void fetchUserInfo(String aToken) async {
    // API 엔드포인트 URL
    print("받토:" + aToken);
    String apiUrl = 'http://3.38.1.125:8080/user/info';

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
      print("확인"+parsedResponseUser["conversationStatus"].toString());
      checkUser = true;
      convs = parsedResponseUser["conversationStatus"].toString();
      userprof = parsedResponseUser["profileImage"].toString();
      user = parsedResponseUser["nickname"];
      puppy = parsedResponseUser["puppyName"];
      conTime = DateTime.parse(parsedResponseUser["nextConversationAt"]);

      // 현재 시각이 대화 시작 시간 보다 이전이라면 대화가 가능함
      if(DateTime.now().isAfter(conTime)){
        nowCon = true;
        print("대화가능");
        print(DateTime.now().toString());
        difference = conTime.difference(DateTime.now());
        // 현재 시각이 대화 시작 시간 보다 이후라면 대화가 불가능 = 아직 대화 시간이 안 됨
      } else{
        nowCon = false;
        difference = conTime.difference(DateTime.now());
        //hour = DateTime.parse(difference.toString()).hour;
        print("대화불가");
        print(DateTime.now().toString());
        // 문자열을 Duration 객체로 변환
        Duration duration = Duration(
          hours: int.parse(difference.toString().split(":")[0]),
          minutes: int.parse(difference.toString().split(":")[1]),
        );
        // Duration에서 시간, 분, 초, 밀리초 추출
        hour = duration.inHours;
        minute = duration.inMinutes % 60;

        if(hour == 0){
          inHour = true;
        }

        print("시간 차이: " + hour.toString());
        print("분 차이: " + minute.toString());
      }
      print("시간 차이: " + difference.toString());
      // 대화하기 버튼 지정을 위한 현재 시간과 DB 시간 계산


      // 대화 단계에 따라 배경 색을 먼저 지정
      if(convs.contains("0")){
        constart.backColor = "DDE7FD";
        constart.perc = 20;
      }else if(convs.contains("-")){
        constart.backColor = "FCCBCD";
        constart.perc = 20;
      }else if(convs.contains("1")){
        constart.backColor = "FCCBCD";
        constart.perc = 35;
      }else if(convs.contains("2")){
        constart.backColor = "FBF3B8";
        constart.perc = 55;
      }else if(convs.contains("3")){
        constart.backColor = "CEEEE9";
        constart.perc = 75;
      }else if(convs.contains("4")){
        constart.backColor = "DDE7FD";
        constart.perc = 95;
      }

      setState(() {

      });


    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  late List<dynamic> parsedResponseHA; // 도움 답변 내역
  // 내가 보낸 "도움" 내역 불러오기(GET)
  void callHelpAnswer(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/community/help/all?type=ans';

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
      print('서버로부터 받은 내용 데이터(내가 보낸도움): ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseHA = json.decode(jsonResponse);

      print("몇개인지 확인(내가 보낸도움) "+parsedResponseHA.length.toString());

      setState(() {});

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

    main.player.stop();

    fetchUserInfo(sign_in.userAccessToken);
    setState(() {

    });
    Timer(Duration(milliseconds: 500), () {
      fetchUserInfo(sign_in.userAccessToken);
    });
    callHelpAnswer(sign_in.userAccessToken);

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
          child: GestureDetector(
            onTap: (){
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title:
                Container(
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
              body:
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          if(checkUser)...[
                            Stack(
                              children: [
                                Text(
                                  "${parsedResponseUser["puppyName"]}를 기억한지",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Cafe24SsurroundAir-v1.1',
                                    //color: Color(0xff4B5396),
                                    fontSize: 20,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 3
                                      ..color = Colors.white,
                                  ),
                                ),
                                Text(
                                  "${parsedResponseUser["puppyName"]}를 기억한지",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Cafe24SsurroundAir-v1.1',
                                    //color: Color(0xff4B5396),
                                    fontSize: 20,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 0.7
                                      ..color = Color(0xff4B5396),
                                  ),
                                ),
                                Text(
                                  "${parsedResponseUser["puppyName"]}를 기억한지",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Cafe24SsurroundAir-v1.1',
                                    color: Color(0xff4B5396),
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),

                          ],
                          SizedBox(width: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(color: Color(0xff4B5396), width: 2, ),
                                  color: Color(0xffFCCBCD),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2, ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    if(checkUser)...[
                                      Stack(
                                        children: [
                                          Text(
                                            parsedResponseUser["memoryCount"].toString(),
                                            style: TextStyle(
                                              fontFamily: 'Cafe24SsurroundAir-v1.1',
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 0.7
                                                ..color = Color(0xff4B5396),
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            parsedResponseUser["memoryCount"].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Cafe24SsurroundAir-v1.1',
                                              color: Color(0xff4B5396),
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],)

                                    ]
                                  ],
                                ),
                              ),
                              SizedBox(width: 2),
                              Stack(
                                children: [
                                  Text(
                                    "일째",
                                    style: TextStyle(
                                      fontFamily: 'Cafe24SsurroundAir-v1.1',
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 3
                                        ..color = Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "일째",
                                    style: TextStyle(
                                      fontFamily: 'Cafe24SsurroundAir-v1.1',
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 0.7
                                        ..color = Color(0xff4B5396),
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "일째",
                                    style: TextStyle(
                                      fontFamily: 'Cafe24SsurroundAir-v1.1',
                                      color: Color(0xff4B5396),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                  // SizedBox(height: 15,),
                  if(checkUser)...[
                    Text("${parsedResponseUser["nickname"]}님, 오늘도 ${parsedResponseUser["puppyName"]}와의 기억을 남겨주세요!", style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff333333),
                      fontSize: 16,),),
                  ],
                  SizedBox(height: 18,),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: screenSize.width,
                            height: 348,
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 56,),
                                    Image.asset('assets/images/home/home_muji2.gif',
                                      fit: BoxFit.cover,),

                                  ],
                                ),
                                if(nowCon)...[
                                  Padding(
                                    padding: EdgeInsets.only(top: 230,left: 134),
                                    child: Container(
                                        width: 150,
                                        height: 44,
                                        child:
                                        InkWell(
                                          child: Stack(
                                            children: [
                                              Image.asset(
                                                'assets/images/home/con_btn2.png',
                                                fit: BoxFit.contain,
                                              ),
                                              SvgPicture.asset(
                                                'assets/images/home/btnframe.svg',
                                                fit: BoxFit.contain,
                                              ),
                                              Padding(padding: EdgeInsets.only(left: 22, top: 9),
                                                child:
                                                Stack(
                                                  children: [
                                                    Text(
                                                      "대화하기",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'Cafe24SsurroundAir-v1.1',
                                                        //color: Color(0xff4B5396),
                                                        fontSize: 16,
                                                        foreground: Paint()
                                                          ..style = PaintingStyle.stroke
                                                          ..strokeWidth = 0.7
                                                          ..color = Color(0xff222222),
                                                      ),
                                                    ),
                                                    Text(
                                                      "대화하기",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'Cafe24SsurroundAir-v1.1',
                                                        color: Color(0xff222222),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          onTap: (){
                                            tap = true;
                                            setState(() {});
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => StartEarlyPage()));
                                          },
                                        )
                                    ),
                                  ),
                                ] else...[
                                  Padding(
                                    padding: EdgeInsets.only(top: 230,left: 119),
                                    child: Container(
                                        width: 150,
                                        height: 44,
                                        child:
                                        InkWell(
                                          child: Stack(
                                            children: [
                                              // assets/images/home/con_btn.svg
                                              SvgPicture.asset(
                                                'assets/images/home/after_con.svg',
                                                fit: BoxFit.contain,
                                              ),
                                              Padding(padding:inHour? EdgeInsets.only(left: 18, top: 8):EdgeInsets.only(left: 18, top: 12),
                                                child:Text(
                                                  inHour?
                                                  "${minute}분 뒤 만나요!":"${hour}시간 뒤 만나요!",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Cafe24SsurroundAir-v1.1',
                                                    color: Color(0xff222222),
                                                    fontSize: 16,
                                                  ),
                                                ),)

                                            ],
                                          ),
                                          onTap: (){
                                          },
                                        )
                                    ),
                                  ),
                                ]
                              ],
                            )
                        ),
                        SizedBox(height: 8,),
                        Container(
                          padding: EdgeInsets.all(8),
                          width: 252,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Color(0xff83A8FF).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(37.5),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 2,),
                              if(parsedResponseHA.length<10)...[
                                SvgPicture.asset('assets/images/home/lev1.svg',),
                              ] else if(parsedResponseHA.length<20)...[
                                SvgPicture.asset('assets/images/home/lev2.svg',),
                              ] else if(parsedResponseHA.length<30)...[
                                SvgPicture.asset('assets/images/home/lev3.svg',),
                              ] else if(parsedResponseHA.length<40)...[
                                SvgPicture.asset('assets/images/home/lev4.svg',),
                              ] else if(parsedResponseHA.length >40)...[
                                SvgPicture.asset('assets/images/home/lev4.svg',),
                              ],
                              SizedBox(width: 12,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4,),
                                  Text("현재 ${parsedResponseHA.length.toString()}번의 도움을 보냈어요.", style: textStyle.purple12light,),
                                  SizedBox(height: 4,),
                                  if(parsedResponseHA.length<10)...[
                                    Text("도움 보내기를 10번 달성해보세요!", style: textStyle.purple12light,),
                                  ] else if(parsedResponseHA.length<20)...[
                                    Text("도움 보내기를 20번 달성해보세요!", style: textStyle.purple12light,),
                                  ] else if(parsedResponseHA.length<30)...[
                                    Text("도움 보내기를 30번 달성해보세요!", style: textStyle.purple12light,),
                                  ] else if(parsedResponseHA.length<40)...[
                                    Text("도움 보내기를 40번 달성해보세요!", style: textStyle.purple12light,),
                                  ] else if(parsedResponseHA.length >40)...[
                                    Text("도움 보내기를 50번 달성해보세요!", style: textStyle.purple12light,),
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24,),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpMainPage()));
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                            width: Get.width - 32,
                            height: 89,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/home/help_main.svg',
                                      width: 61,
                                      height: 61,
                                      fit: BoxFit.fill,

                                    ),
                                    SizedBox(width: 5,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("다른 반려인들과 도움을 주고 받아보세요!", style: TextStyle(color: Color(0xff4B5396), fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400, fontSize: 12, letterSpacing: 0.5),),
                                        SizedBox(height:8,),
                                        Text("도움 내역 보러 가기", style: TextStyle(color: Color(0xff4B5396),fontSize: 16, fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w600,),)
                                      ],
                                    ),
                                    SizedBox(width:20,),
                                    // assets/images/home/arrow.svg
                                    SvgPicture.asset(
                                      'assets/images/home/arrow.svg',
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          )
      );
  }
}
