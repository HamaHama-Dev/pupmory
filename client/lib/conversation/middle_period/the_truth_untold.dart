import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:client/home.dart' as home;
import 'package:client/screen.dart';
import 'package:http/http.dart' as http;
import 'package:client/progressbar/animation_progressbar.dart';
import 'package:client/sign/sign_in.dart';
import 'package:client/style.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:client/main.dart'as main;

/// 중기 대화 - 전하지 못한 진심

AudioPlayer player2 = AudioPlayer();

late FlutterGifController controller1, controller2, controller3;

List<dynamic> voice =[
  "assets/voice/middle/truth/truth1.mp3", "assets/voice/middle/truth/truth2.mp3",
  "assets/voice/middle/truth/truth3.mp3", "assets/voice/middle/truth/truth4.mp3",
  "assets/voice/middle/truth/truth5.mp3", "assets/voice/middle/truth/truth6.mp3",
  "assets/voice/middle/truth/truth7.mp3", "assets/voice/middle/truth/truth8.mp3",
  "assets/voice/middle/truth/truth9.mp3", "assets/voice/middle/truth/truth10.mp3",
  "assets/voice/middle/truth/truth11.mp3", "", // 아이에게 보낼편지
  "assets/voice/middle/truth/truth12.mp3", "assets/voice/middle/truth/truth13.mp3",
  "assets/voice/middle/truth/truth14.mp3", "", // 작성중
  "assets/voice/middle/truth/truth15.mp3", "assets/voice/middle/truth/truth16.mp3",
  "assets/voice/middle/truth/truth17.mp3", "assets/voice/middle/truth/truth18.mp3",
  "assets/voice/middle/truth/truth19.mp3", "","", // 나레이션
  "assets/voice/middle/truth/truth20.mp3", "assets/voice/middle/truth/truth21.mp3",
  "assets/voice/middle/truth/truth22.mp3", "assets/voice/middle/truth/truth23.mp3",
  "assets/voice/middle/truth/truth24.mp3", "assets/voice/middle/truth/truth25.mp3",
  "assets/voice/middle/truth/truth26.mp3", "assets/voice/middle/truth/truth27.mp3",
  "assets/voice/middle/truth/truth28.mp3", "assets/voice/middle/truth/truth29.mp3",
  "assets/voice/middle/truth/truth30.mp3", "assets/voice/middle/truth/truth31.mp3",
];

List<dynamic> endVoice =[
  "assets/voice/intro/intro2_8.mp3",
  "assets/voice/intro/intro2_9.mp3",
];


class TheTruthUntoldPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => TheTruthUntoldPage(),
      ),
    );
  }

  @override
  _TheTruthUntoldPageState createState() => _TheTruthUntoldPageState();
}

class _TheTruthUntoldPageState extends State<TheTruthUntoldPage> with TickerProviderStateMixin {

  List<dynamic> questions0 =[
    "${home.puppy}는 지금",
    "무지개다리 너머에\n잘 도착했을 거예요.",
    "분명 잘 지내고 있을 것을 알아도",
    "여전히\n${home.user}님에게는",
    "${home.puppy}에게\n해주고 싶은 말이 남아있겠죠.",
    "오늘은 ${home.puppy}에게\n전하지 못한",
    "${home.user}님의\n진심을 담아",
    "무지개 너머로 편지를 보낼거예요.",
    "편지를 쓰기 전에,\n먼저 편지를 꾸며볼게요.",
    "${home.puppy}는\n어떤 날씨를 좋아했나요?",

    "${home.puppy}에게 보낼\n편지지가 완성되었어요!",
    "${home.puppy}에게 보낼\n편지지가 완성되었어요!",
    "완성된 편지지에",
    "${home.puppy}에게\n전하고 싶었던 진심을 담아",
    "편지를 작성해주세요.",
    "", // 작성중

    "${home.user}님,",
    "편지에 ${home.puppy}를 향한 진심을",
    "잘 적어보았나요?",
    "${home.user}님의\n소중한 마음을 담아",
    "${home.puppy}에게\n직접 편지를 전달해드릴게요!",

    "무지개 다리 너머 ${home.puppy}에게\n편지가 전달되는 중...",
    "${home.puppy}에게\n편지가 전달되었습니다!",

    "${home.user}님의 편지가\n${home.puppy}에게 전달되었어요.",
    "${home.puppy}가\n${home.user}님의 편지를 받고",
    "이 말을 꼭 전해달라고 했어요.",
    "${home.puppy}는\n${home.user}님을",
    "정말 많이 사랑한답니다.",
    "${home.user}님과\n다시 만나는 그날까지",
    "친구들과 기다리고 있을거라고 했어요!",
    "${home.user}님의\n소중한 마음이",
    "${home.puppy}에게도\n잘 전달된 것 같아요!",
    "편지를 통해\n${home.user}님의 마음 속",
    "전하지 못했던 진심들이",
    "조금은 가벼워졌기를 바라요.",
  ];

  List<dynamic> questionsEnd =[
    "자, 이제 우리가 다시\n만나게 될 시간을 알려주세요.",
    "자, 이제 우리가 다시\n만나게 될 시간을 알려주세요.",
    "네, ${home.user}님.\n()시간 후에 다시 만나요!",
    "네, ${home.user}님.\n()시간 후에 다시 만나요!",
  ];

  int voiceEndCount = 0;
  bool selectedNextTime = false;
  bool chooseTime = false;
  int whatTime = 0;

  bool ui_sunny = false;
  bool sunny = false;
  bool ui_cool = false;
  bool cool = false;
  bool ui_rainy = false;
  bool rainy = false;
  bool ui_snow = false;
  bool snow = false;

  bool startWrite = false;
  bool wrote = false; // 편지를 썼는지

  // 텍스트 에디팅 컨트롤러를 생성하여 필드에 할당
  final letterController = TextEditingController(); // nextQuestion = 7일때
  final nextTimeController = TextEditingController(); // nextQuestion = 7일때
  final whatController = TextEditingController(); // nextQuestion = 7일때

  FocusNode _focusNode = FocusNode();

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
      print('HTTP 요청 실패..?: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();

    main.play = true;
    main.player.setAsset(main.musics[2]);
    main.player.play();

    // 음원 적용
    for(int i= 0 ; i < voice.length; i++){
      player2.setAudioSource(AudioSource.uri(
          Uri.parse(voice[i]))
      );
    }

    player2.setAsset(voice[voiceCount]);
    voiceCount++;
    player2.play();
    controller1 = FlutterGifController(vsync: this);

    // 2.5초 적정
    controller1.repeat(
        min: 0,
        max: 30,
        period: const Duration(milliseconds: 1000)
    );
    Timer(Duration(milliseconds: 1500), () {
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

  int nextQuestion = 0;
  bool nextQ = false;

  int voiceCount = 0;

  int endQuestion = 0;
  bool end = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
        decoration: (nextQuestion>20 && nextQuestion<23)?
        BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffFCCBCC),
                Color(0xffFEF3B0),
              ],
            )
        ) :
        BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xffFBF3B8),
                Color(0xffFBF3B8),
              ],
            )
        ),
          child: GestureDetector(
            onTap: (){
              print("이거만 좀 확인 부탁: " + nextQuestion.toString());

              if(nextQuestion < 9){
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
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 2){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  }); // ok
                } else if(nextQuestion == 3){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 4){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 5){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 6){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 7){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 8){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 9){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 9){
                // ${home.puppy}가 좋아하는 계절 고르기
              }
              else if(nextQuestion >9 && nextQuestion < 15){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );

                if(nextQuestion == 11){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 12){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  }); // ok
                } else if(nextQuestion == 13){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 14){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 15){
                  Timer(Duration(milliseconds: 1000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 15){
                // 편지지 작성
              }
              else if(nextQuestion >15 && nextQuestion < 34){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );

                if(nextQuestion == 17){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 18){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  }); // ok
                } else if(nextQuestion == 19){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 20){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 21){
                  Timer(Duration(milliseconds: 1000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 22){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 23){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 24){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 25){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 26){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 27){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 28){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 29){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 30){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 31){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 32){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 33){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 34){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 34 && end == false){
                end = true;
                nextQuestion++;
                player2.setAsset(endVoice[voiceEndCount]);
                voiceEndCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                Timer(Duration(milliseconds: 4000), () {
                  controller1.stop();
                });

              }
              else if(end && endQuestion < 1){
                endQuestion++;
              }
              else if(endQuestion == 1){
              }
              else if(endQuestion == 2){
                endQuestion++;
              }
              else if(endQuestion == 3){
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
                                  currentValue: 60,
                                  size: 5,
                                  backgroundColor: Colors.white,
                                )
                            ),
                          ),
                        ),
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
                                        if(nextQuestion < 15 || (nextQuestion > 15 && nextQuestion<21) || (nextQuestion > 22) )...[
                                          // 편지지 쓰기전 말풍선
                                          Center(child: SvgPicture.asset('assets/images/conversation/bubble.svg',fit: BoxFit.fill,),),
                                        ] else if(nextQuestion > 20 && nextQuestion < 23)...[
                                          // 나레이션
                                          Center(child: SvgPicture.asset('assets/images/conversation/intro/intro_bubble.svg',fit: BoxFit.fill,),),
                                        ],
                                        Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12, ),
                                            child: Center(
                                                child: Column(
                                                  children: [
                                                    if(end == false)...[
                                                      if(questions0[nextQuestion].toString().contains("\n"))...[
                                                        SizedBox(height: (nextQuestion>20 && nextQuestion<23)? 39 : 28,),
                                                        Text(
                                                          questions0[nextQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: (nextQuestion>20 && nextQuestion<23)? textStyle.introbubbletext : textStyle.bubbletext,
                                                        ),
                                                      ]else...[
                                                        SizedBox(height: (nextQuestion>20 && nextQuestion<23)? 48 :42,),
                                                        Text(
                                                          questions0[nextQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: (nextQuestion>20 && nextQuestion<23)? textStyle.introbubbletext : textStyle.bubbletext,
                                                        ),
                                                      ],
                                                    ]
                                                    // 대화 마무리
                                                    else if (end) ...[
                                                        if(questionsEnd[endQuestion]
                                                            .toString()
                                                            .contains("\n"))...[
                                                          SizedBox(height: 28,),
                                                          Text(questionsEnd[endQuestion], textAlign: TextAlign.center,
                                                            style: textStyle.bubbletext,),
                                                        ]else...[
                                                            SizedBox(height: 42,),
                                                            Text(questionsEnd[endQuestion], textAlign: TextAlign.center, style: textStyle.bubbletext,),
                                                          ],
                                                      ]
                                                  ],
                                                )
                                            )
                                        ),
                                      ],
                                    )
                                ),
                                // 무지 위치
                                if(nextQuestion < 9 || nextQuestion == 10 || (nextQuestion > 11 && nextQuestion < 15) ||
                                    (nextQuestion > 15 && nextQuestion < 21) || (nextQuestion > 15 && nextQuestion < 21) ||
                                    (nextQuestion > 22 && nextQuestion < 35) || (end && endQuestion<1) || (end && endQuestion>1))...[
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
                                  else if(nextQuestion == 9)...[
                                  Stack(
                                    children: [

                                      Column(
                                        children: [
                                          SizedBox(height: 418,),
                                          Container(
                                            height: 284,
                                            width: screenSize.width,
                                            color: Color(0xffFFFFF7),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(height: 418,),
                                          SvgPicture.asset(
                                            'assets/images/conversation/shadow.svg', fit: BoxFit.cover,
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
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 256,),
                                          Row(
                                            children: [
                                              SizedBox(width: 16,),
                                              Container(
                                                width: 168,
                                                height: 168,
                                                child: ElevatedButton(
                                                    style: ui_sunny? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                    onPressed: () {
                                                      ui_sunny = true;
                                                      ui_cool = false;
                                                      ui_rainy = false;
                                                      ui_snow = false;
                                                      // nextQuestion++;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 16,),
                                                          Text("화창한 날씨", style: TextStyle(fontSize: 16, color: ui_sunny? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 16,),
                                                          Text("해가 화창한 날씨를\n좋아했어요.", style: TextStyle(fontSize: 12, color: ui_sunny? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 16,),
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 76,),
                                                              SvgPicture.asset('assets/images/conversation/middle/sun.svg')
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ),
                                              SizedBox(width: 16,),
                                              Container(
                                                width: 168,
                                                height: 168,
                                                child: ElevatedButton(
                                                    style: ui_cool? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                    onPressed: () {
                                                      ui_sunny = false;
                                                      ui_cool = true;
                                                      ui_rainy = false;
                                                      ui_snow = false;
                                                      // nextQuestion++;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 16,),
                                                          Text("선선한 날씨", style: TextStyle(fontSize: 16, color: ui_cool? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 16,),
                                                          Text("선선하고 시원한 날씨를\n좋아했어요.", style: TextStyle(fontSize: 12, color: ui_cool? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 16,),
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 76,),
                                                              SvgPicture.asset('assets/images/conversation/intro/grief.svg')
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 16,),
                                          Row(
                                            children: [
                                              SizedBox(width: 16,),
                                              Container(
                                                width: 168,
                                                height: 168,
                                                child: ElevatedButton(
                                                    style: ui_rainy? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                    onPressed: () {
                                                      ui_sunny = false;
                                                      ui_cool = false;
                                                      ui_rainy = true;
                                                      ui_snow = false;
                                                      // nextQuestion++;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 16,),
                                                          Text("비오는 날씨", style: TextStyle(fontSize: 16, color: ui_rainy? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 16,),
                                                          Text("추적추적 비오는 날씨를\n좋아했어요.", style: TextStyle(fontSize: 12, color: ui_rainy? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 16,),
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 76,),
                                                              SvgPicture.asset('assets/images/conversation/intro/grief.svg')
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ),
                                              SizedBox(width: 16,),
                                              Container(
                                                width: 168,
                                                height: 168,
                                                child: ElevatedButton(
                                                    style: ui_snow? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                    onPressed: () {
                                                      ui_sunny = false;
                                                      ui_cool = false;
                                                      ui_rainy = false;
                                                      ui_snow = true;
                                                      // nextQuestion++;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 16,),
                                                          Text("눈 오는 날씨", style: TextStyle(fontSize: 16, color: ui_snow? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 16,),
                                                          Text("흰 눈이 오는 날씨를\n좋아했어요.", style: TextStyle(fontSize: 12, color: ui_snow? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 16,),
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 76,),
                                                              SvgPicture.asset('assets/images/conversation/middle/sno.svg')
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]
                                  // 편지지 작성하기
                                else if(nextQuestion == 15)...[
                                  Column(
                                    children: [
                                      SizedBox(height: 96,),
                                      Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 16),
                                            child: Column(
                                              children: [
                                                if(sunny)...[
                                                  SvgPicture.asset('assets/images/conversation/middle/sunny.svg',
                                                    fit: BoxFit.contain,
                                                    height: 438,
                                                    width: screenSize.width,
                                                  ),
                                                ]
                                                else if(cool)...[
                                                  SvgPicture.asset('assets/images/conversation/middle/cool.svg',
                                                    fit: BoxFit.contain,
                                                    height: 438,
                                                    width: screenSize.width,
                                                  ),
                                                ]
                                                else if(rainy)...[
                                                    SvgPicture.asset('assets/images/conversation/middle/rainy.svg',
                                                      fit: BoxFit.contain,
                                                      height: 438,
                                                      width: screenSize.width,
                                                    ),
                                                  ]
                                                  else if(snow)...[
                                                      SvgPicture.asset('assets/images/conversation/middle/snow.svg',
                                                        fit: BoxFit.contain,
                                                        height: 438,
                                                        width: screenSize.width,
                                                      ),
                                                    ],
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(top:16,left: 48, right:48, bottom:16),
                                            child: SizedBox(
                                              width: screenSize.width,
                                              //height: 150,
                                              child: TextField(
                                                style: textStyle.bubbletext,
                                                controller: letterController,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top:3, left: 0),
                                                  hintStyle: textStyle.bubbletext,
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  hintText: '이곳에 편지를 작성해주세요.(300자)',
                                                  counterText:'',
                                                ),
                                                maxLines: 14,
                                                maxLength: 300,
                                                onTap: (){
                                                  // 편지지 올리기?
                                                },
                                                onChanged: (text){
                                                  // 편지를 써야 다음으로 넘어갈 수 있도록 설정
                                                  wrote = true;
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                  ]
                                // 마무리
                              else if (end && endQuestion == 1) ...[
                                Padding(
                                  padding: EdgeInsets.only(top: 175, left: 45),
                                  child: Container(
                                    width: 275,
                                    height: 120,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 75,
                                            ),
                                            Container(
                                              width: 25,
                                              child: TextField(
                                                style: textStyle.inputfield,
                                                onTap: () {
                                                  chooseTime = true;
                                                  whatTime = int.parse(
                                                      nextTimeController.text);
                                                  setState(() {});
                                                },
                                                onChanged: (text) {
                                                  selectedNextTime = true;
                                                  whatTime = int.parse(
                                                      nextTimeController.text);
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp('[0-9]'))
                                                ],
                                                controller: nextTimeController,
                                                decoration: InputDecoration(
                                                  hintText: '몇',
                                                  suffixStyle: TextStyle(
                                                    color: Color(0xff83A8FF),
                                                    fontSize: 20,
                                                  ),
                                                  hintStyle: textStyle.field,
                                                  //labelText: '몇',
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "시간 후에 만나요",
                                              style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        // DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR[index]['createdAt']))
                                        // DateFormat('MM/dd HH:mm').format(DateTime.now().add(Duration(hours: whatTime)))
                                        Text(
                                          chooseTime
                                              ? "${DateFormat('MM월 dd일 HH시 mm분').format(DateTime.now().add(Duration(hours: whatTime)))}"
                                              : "최소 1시간에서 24시간 사이로 정해주세요.",
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xffAAAAAA)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ] else if (nextQuestion == 11) ...[
                                Stack(
                                  children: [
                                    // 유저 위치
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 420,
                                        ),
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
                                        SizedBox(
                                          height: 144,
                                        ),
                                        Container(
                                            width: screenSize.width,
                                            height: 375,
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 0, left: 0),
                                                  child: Image.asset(
                                                    'assets/images/conversation/gif/muji_ear.gif',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 0, left: 0),
                                                  child: Image.asset(
                                                    'assets/images/conversation/gif/muji_base.gif',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 0, left: 0),
                                                  child: Image.asset(
                                                    'assets/images/conversation/gif/muji_base_eye.gif',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 0, left: 0),
                                                  child: GifImage(
                                                    controller: controller1,
                                                    image: const AssetImage(
                                                        "assets/images/conversation/gif/muji_mouth1.gif"),
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

                                    // 편지 위치
                                    Padding(padding: EdgeInsets.only(top:240, left:65),
                                      child: Column(
                                        children: [
                                          if(sunny)...[
                                            SvgPicture.asset('assets/images/conversation/middle/sunny_min.svg', fit: BoxFit.cover,),
                                          ]else if(cool)...[
                                            SvgPicture.asset('assets/images/conversation/middle/cool_min.svg', fit: BoxFit.cover,),
                                          ] else if(rainy)...[
                                            SvgPicture.asset('assets/images/conversation/middle/rainy_min.svg', fit: BoxFit.cover,),
                                          ] else if(snow)...[
                                            SvgPicture.asset('assets/images/conversation/middle/snow_min.svg', fit: BoxFit.cover,),
                                          ],
                                        ],
                                      ),)
                                  ],
                                ),
                              ] else if (nextQuestion == 21) ...[
                                Padding(padding: EdgeInsets.only(top:248, left:80),
                                  child: SvgPicture.asset('assets/images/conversation/middle/realmuji.svg', fit: BoxFit.cover,),),
                              ] else if (nextQuestion == 22) ...[
                                Padding(padding: EdgeInsets.only(top:256, left:56),
                                  child: SvgPicture.asset('assets/images/conversation/middle/myletter.svg', fit: BoxFit.cover,),),
                              ]
                            ],
                          ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                bottomSheet: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom * 0.001),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                       if(nextQuestion == 9 && (ui_sunny|| ui_cool || ui_rainy || ui_snow))...[
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
                                  //decidedType = false;
                                  nextQuestion++;
                                  if(ui_sunny){
                                    sunny = true;
                                  } else if(ui_cool){
                                    cool = true;
                                  } else if(ui_rainy){
                                    rainy = true;
                                  } else if(ui_snow){
                                    snow = true;
                                  }
                                  player2.setAsset(voice[voiceCount]);
                                  voiceCount++;
                                  player2.play();

                                  controller1.repeat(
                                      min: 0,
                                      max: 30,
                                      period: const Duration(milliseconds: 1000)
                                  );
                                  Timer(Duration(milliseconds: 3000), () {
                                    controller1.stop();
                                  });

                                  setState(() {});
                                },
                                child: Text("다음", style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                              ),
                            ),),
                        ),
                      ]
                       else if(nextQuestion == 15 && wrote)...[
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
                                   nextQuestion++;
                                   player2.setAsset(voice[voiceCount]);
                                   voiceCount++;
                                   player2.play();
                                   setState(() {});

                                   controller1.repeat(
                                       min: 0,
                                       max: 30,
                                       period: const Duration(milliseconds: 1000)
                                   );
                                   Timer(Duration(milliseconds: 1500), () {
                                     controller1.stop();
                                   });
                                 },
                                 child: Text("다음", style: TextStyle(
                                     fontFamily: 'Pretendard',
                                     fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                               ),
                             ),),
                         ),
                       ]
                        else if(endQuestion == 1  && selectedNextTime)...[
                            Container(
                              color: Color(0xffFFFFFF).withOpacity(0.0),
                              child: Padding(
                                padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                                child: Container(

                                  width: screenSize.width,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: buttonChart().bluebtn3,
                                    onPressed: () {
                                      questionsEnd.insertAll(2, [
                                        "네, ${home.user}님.\n${whatTime}시간 후에 다시 만나요!",
                                        "네, ${home.user}님.\n${whatTime}시간 후에 다시 만나요!",
                                      ]);
                                      //decidedType = false;
                                      endQuestion++;
                                      player2.setAsset(endVoice[voiceEndCount]);
                                      voiceEndCount++;
                                      player2.play();
                                      // 2.5초 적정
                                      controller1.repeat(
                                          min: 0,
                                          max: 30,
                                          period: const Duration(milliseconds: 1000)
                                      );
                                      Timer(Duration(milliseconds: 3500), () {
                                        controller1.stop();
                                      });
                                      setState(() {});
                                    },
                                    child: Text("다음", style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                                  ),
                                ),),
                            ),
                          ]
                          else if(endQuestion == 3)...[
                              Container(
                                color: Color(0xffFFFFFF).withOpacity(0.0),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                                  child: Container(

                                    width: screenSize.width,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: buttonChart().bluebtn3,
                                      onPressed: () {
                                        //decidedType = false;
                                        //checkSignUp = false;
                                        //checkSignIn = true;
                                        checkSignUp = false;
                                        var now = DateTime.now();
                                        sentDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now.toLocal());
                                        saveCon(sign_in.userAccessToken, "2B", sentDate);
                                        setState(() {});
                                        main.player.stop();
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyScreenPage(title: '스크린 페이지',)));
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

