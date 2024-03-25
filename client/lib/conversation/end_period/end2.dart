import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:client/screen.dart';
import 'package:http/http.dart' as http;
import 'package:client/progressbar/animation_progressbar.dart';
import 'package:client/style.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:client/main.dart'as main;

/// 종결기 대화

List<dynamic> endConversation = [
  "보호자님,", //27
  "이제 모든 대화가 끝이 났어요!", //28
  "그동안 함께한 대화는\n 소중하고 의미 있는 시간이었어요.", //29
  "이제 대화는 종료되지만,", //30
  "그동안의 순간들은\n 기억 속에 간직되기를 바라요.", //31
  "지금까지\n 대화의 여정에 함께 해줘서 고마워요!", //32

  "이제 ‘기억할개’ 속\n새로운 일상이 당신을 기다리고 있어요.", //33
  "    이 대화를 닫고 나가는 순간,", //34
  "삶의 다음 장이 펼쳐지기를 바랍니다.", //35
];

AudioPlayer player2 = AudioPlayer();

late FlutterGifController controller1, controller2, controller3;

List<dynamic> voice =[
  "assets/voice/end/endp2_1.mp3",
  "assets/voice/end/endp2_2.mp3",
  "assets/voice/end/endp2_3.mp3",
  "assets/voice/end/endp2_4.mp3",
  "assets/voice/end/endp2_5.mp3",
  "assets/voice/end/the_end.mp3",
  "",""
];

class End2Page extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => End2Page(),
      ),
    );
  }

  @override
  _End2PageState createState() => _End2PageState();
}

class _End2PageState extends State<End2Page> with TickerProviderStateMixin {


  // 텍스트 에디팅 컨트롤러를 생성하여 필드에 할당
  final meController = TextEditingController();
  final memoryController = TextEditingController();
  final futureController = TextEditingController();
  final oneController = TextEditingController();
  final twoController = TextEditingController();
  final threeController = TextEditingController();
  final fiveController = TextEditingController();

  bool me = false;
  bool memory = false;
  bool future = false;
  bool one = false;
  bool two = false;
  bool three = false;
  bool five = false;


  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 음원 적용
    for(int i= 0 ; i < voice.length; i++){
      player2.setAudioSource(AudioSource.uri(
          Uri.parse(voice[i]))
      );
    }

    controller1 = FlutterGifController(vsync: this);

    player2.setAsset(voice[voiceCount]);
    voiceCount++;
    player2.play();

    // 2.5초 적정
    controller1.repeat(
        min: 0,
        max: 30,
        period: const Duration(milliseconds: 1000)
    );
    Timer(Duration(milliseconds: 1000), () {
      controller1.stop();
    });

    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // 키보드 올리기
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  void dispose() async {
    super.dispose();
  }

  List<String> introText =[];
  int nextQuestion = 0;
  int voiceCount = 0;

  // ${home.user}

  String sentDate = "";
  // 대화 단계 저장
  void saveCon(String aToken, String con, String nextcon) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/user/conversation-status';

    // 요청 본문 데이터
    var data = {
      "conversationStatus": con,
      "nextConversationAt": nextcon,
    };

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    // HTTP GET 요청 보내기
    var response = await http.put(
      Uri.parse(apiUrl),
      body: json.encode(data),
      headers: headers, // 헤더 추가
    );

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      print("대화 단계 넣기 성공");
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
          decoration: (nextQuestion > 5) ?
          BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffE4ECFF),
                  Color(0xffA2BEFF),
                ],
              )
          ) :
          BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffDDE7FD),
                  Color(0xffDDE7FD),
                ],
              )
          ),
          child: GestureDetector(
            onTap: (){
              print("확인: " + nextQuestion.toString());

              if(nextQuestion < 8){
                nextQuestion++; // 인트로 시작 후 count
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextQuestion == 1){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 2){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  }); // ok
                } else if(nextQuestion == 3){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 4){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 5){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 6){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 7){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 8){
                  // 필요없음
                  // Timer(Duration(milliseconds: 3000), () {
                  //   controller1.stop();
                  // });
                }
              }
              else if(nextQuestion == 8){
              }

              setState(() {
              });
            },
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  //title: Text("기억할개", style: TextStyle(fontSize:16, color: Colors.white ),),
                  //centerTitle: true,
                  leading: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/conversation/home_icon.svg',
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                ),
                //extendBodyBehindAppBar: true,
                body:
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 3,),
                        Container(
                          width: screenSize.width,
                          height: 25,
                          child: Padding(
                            padding: EdgeInsets.only( left:16, right: 16),
                            child: Center(
                                child: FAProgressBar(
                                  currentValue: 100,
                                  size: 5,
                                  backgroundColor: Colors.white,
                                )
                            ),
                          ),
                        ),
                        if(nextQuestion > 5)...[
                          Container(
                            width: screenSize.width,
                            height: screenSize.height,
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 64,),
                                SvgPicture.asset('assets/images/conversation/intro/intro_star.svg',fit: BoxFit.fill,),
                                SizedBox(height: 64,),
                                Stack(
                                  children: [
                                    SvgPicture.asset('assets/images/conversation/intro/intro_bubble.svg',fit: BoxFit.fill,),
                                    Padding(padding:nextQuestion >6? EdgeInsets.only(left:61, top:64) : EdgeInsets.only(left:52, top:48),
                                      child: Text(
                                          endConversation[nextQuestion],
                                          textAlign: TextAlign.center,
                                          style: textStyle.introbubbletext
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 96,),
                                Container(width: screenSize.width,
                                  child: SvgPicture.asset('assets/images/conversation/intro/intro_cloud.svg',fit: BoxFit.fill,),
                                ),
                              ],
                            ),
                          ),
                        ] else...[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              SizedBox(
                                height: 10,
                              ),
                              Stack(
                                children: [
                                  Container(
                                      height: 157,
                                      width: screenSize.width,
                                      child:
                                      Stack(
                                        children: [
                                          Center(child: SvgPicture.asset('assets/images/conversation/bubble.svg',fit: BoxFit.fill,),),
                                          Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12, ),
                                              child: Center(
                                                  child: Column(
                                                    children: [
                                                      if(endConversation[nextQuestion].toString().contains("\n"))...[
                                                        SizedBox(height: 28,),
                                                        Text(
                                                          endConversation[nextQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ]else...[
                                                        SizedBox(height: 42,),
                                                        Text(
                                                          endConversation[nextQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ],
                                                    ],
                                                  )
                                              )
                                          ),
                                        ],
                                      )
                                  ),
                                  // 무지 위치
                                  if(nextQuestion < 6)...[
                                    Stack(
                                      children: [
                                        // 유저 위치
                                        Column(
                                          children: [
                                            SizedBox(height: 420,),
                                            Container(
                                              child: SvgPicture.asset(
                                                'assets/images/conversation/user7.svg',
                                                height: 282,
                                                width: screenSize.width,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(height: 144,),
                                            Container(
                                                width: screenSize.width,
                                                height: 375,
                                                child:
                                                Stack(
                                                  children: [
                                                    Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                      child: Image.asset('assets/images/conversation/gif/muji_ear.gif',
                                                        fit: BoxFit.cover,),),
                                                    Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                      child: Image.asset('assets/images/conversation/gif/muji_base.gif', fit: BoxFit.cover,),),
                                                    Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                      child: Image.asset('assets/images/conversation/gif/muji_base_eye.gif',
                                                        fit: BoxFit.cover,),),
                                                    Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                      child:GifImage(
                                                        controller: controller1,
                                                        image: const AssetImage("assets/images/conversation/gif/muji_mouth1.gif"),
                                                      ),
                                                      // Image.asset('assets/images/conversation/gif/muji_mouth1.gif', fit: BoxFit.cover,),
                                                    )
                                                  ],
                                                )

                                              // SvgPicture.asset(
                                              //   'assets/images/conversation/con_muji.svg', fit: BoxFit.cover,
                                              // ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]
                                  else if(nextQuestion >= 6)...[
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ],

                      ],
                    ),
                  ),
                ),

                // // nextQuestion 이 3과 7일때 등장
                bottomSheet: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom * 0.001),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if(nextQuestion == 8)...[
                        Container(
                          color: Color(0xffFFFFFF).withOpacity(0),
                          child: Padding(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                            child: Container(
                              width: screenSize.width,
                              height: 40,
                              child: ElevatedButton(
                                style: buttonChart().bluebtn3,
                                onPressed: () {
                                  var now = DateTime.now();
                                  sentDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now.toLocal());
                                  saveCon(sign_in.userAccessToken, "4", sentDate);

                                  main.player.stop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyScreenPage(title: '스크린 페이지',)));
                                  setState(() {});
                                },
                                child: Text("완료", style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                              ),
                            ),),
                        ),
                      ]
                    ],
                  ),
                )),
          )

      );

  }
}

