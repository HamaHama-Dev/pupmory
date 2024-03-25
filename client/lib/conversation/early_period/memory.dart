import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:client/conversation/early_period/early_coach_mark.dart';
import 'package:client/home.dart' as home;
import 'package:http/http.dart' as http;
import 'package:client/progressbar/animation_progressbar.dart';
import 'package:client/style.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:client/main.dart'as main;

/// 초기대화-기억

AudioPlayer player2 = AudioPlayer();

late FlutterGifController controller1, controller2, controller3;

List<dynamic> voice =[
  "assets/voice/early/memory/memory1.mp3", "assets/voice/early/memory/memory2.mp3", "assets/voice/early/memory/memory3.mp3",
  "assets/voice/early/memory/memory4.mp3", "assets/voice/early/memory/memory5.mp3", "assets/voice/early/memory/memory6.mp3",
  "assets/voice/early/memory/memory7.mp3","assets/voice/early/memory/memory8.mp3","", "assets/voice/early/memory/memory9.mp3","",
  "assets/voice/early/memory/memory10.mp3", "assets/voice/early/memory/memory11.mp3", "assets/voice/early/memory/memory12.mp3", "",
  "assets/voice/early/memory/memory13.mp3", "assets/voice/early/memory/memory14.mp3", "assets/voice/early/memory/memory15.mp3",
];

List<dynamic> griefVoice =[
  "assets/voice/early/memory/memorysad1.mp3", "assets/voice/early/memory/memorysad2.mp3", "assets/voice/early/memory/memorysad3.mp3",
  "assets/voice/early/memory/memorysad4.mp3", "assets/voice/early/memory/memorysad5.mp3", "assets/voice/early/memory/memorysad6.mp3",
  "assets/voice/early/memory/memorysad7.mp3",
];

List<dynamic> happyVoice =[
  "assets/voice/early/memory/memoryhappy1.mp3", "assets/voice/early/memory/memoryhappy2.mp3", "assets/voice/early/memory/memoryhappy3.mp3",
  "assets/voice/early/memory/memoryhappy4.mp3", "assets/voice/early/memory/memoryhappy5.mp3", "assets/voice/early/memory/memoryhappy6.mp3",
  "assets/voice/early/memory/memoryhappy7.mp3", "assets/voice/early/memory/memoryhappy8.mp3", "assets/voice/early/memory/memoryhappy9.mp3",
  "assets/voice/early/memory/memoryhappy10.mp3", "assets/voice/early/memory/memoryhappy11.mp3",
];


class MemoryPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => MemoryPage(),
      ),
    );
  }

  @override
  _MemoryPageState createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> with TickerProviderStateMixin {

  bool grief = false; //gpt결과가 슬픔
  bool happy = false; //gpt결과가 행복

  int nextGrief = 0;
  int nextHappy = 0;

  bool finish = false; // 메모리얼 및 마무리

  bool selectedNextTime = false;
  bool chooseTime = false;
  String whatTime = "";

  bool selectedLocate = false;
  bool chooseLocate = false;
  String whatLocate = "";

  bool selectedHow = false;
  bool chooseHow = false;
  String whatHow = "";

  // 텍스트 에디팅 컨트롤러를 생성하여 필드에 할당
  final nextTimeController = TextEditingController(); // nextQuestion = 7일때
  final locateController = TextEditingController(); // nextQuestion = 7일때
  final howController = TextEditingController(); // nextQuestion = 7일때
  final whatController = TextEditingController(); // nextQuestion = 7일때
  final emotionController = TextEditingController(); // nextQuestion = 7일때

  bool setWhat = false;
  bool setEmotion = false;


  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    main.play = true;
    main.player.setAsset(main.musics[1]);
    main.player.play();

    // 음원 적용
    for(int i= 0 ; i < voice.length; i++){
      player2.setAudioSource(AudioSource.uri(
          Uri.parse(voice[i]))
      );
    }

    controller1 = FlutterGifController(vsync: this);
    controller2 = FlutterGifController(vsync: this);
    controller3 = FlutterGifController(vsync: this);

    player2.setAsset(voice[voiceCount]);
    voiceCount++;
    player2.play();

    // 2.5초 적정
    controller1.repeat(
        min: 0,
        max: 30,
        period: const Duration(milliseconds: 1000)
    );
    Timer(Duration(milliseconds: 1500), () {
      controller1.stop();
    });


    controller3.repeat(
        min: 0,
        max: 30,
        period: const Duration(milliseconds: 2000)
    );
    Timer(Duration(milliseconds: 1000), () {
      controller3.stop();
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

  int happyVoiceCount = 0;
  int griefVoiceCount = 0;

  double containerWidth1 = 35.0;
  void updateContainerWidth1() {
    // TextField 내용의 길이에 따라 Container 길이 업데이트
    setState(() {
      containerWidth1 = 35.0 + (nextTimeController.text.length.toDouble() * 5.0);
    });
  }
  double containerWidth2 = 35.0;
  void updateContainerWidth2() {
    // TextField 내용의 길이에 따라 Container 길이 업데이트
    setState(() {
      containerWidth2 = 35.0 + (nextTimeController.text.length.toDouble() * 5.0);
    });
  }
  double containerWidth3 = 35.0;
  void updateContainerWidth3() {
    // TextField 내용의 길이에 따라 Container 길이 업데이트
    setState(() {
      containerWidth3 = 35.0 + (nextTimeController.text.length.toDouble() * 5.0);
    });
  }

  // ${home.user}

  List<dynamic> questions0 =[
    "좋아요, ${home.user}님.", // 0
    "사실...\n${home.user}님의 마음에", // 1
    "${home.puppy}를 향한\n그리움이 가득해 보여요.", // 2
    "${home.puppy}와의 기억을\n떠올리면", // 3
    "${home.user}님의\n그리운 마음을 달랠 수 있지 않을까요?", // 4
    "오늘은 ${home.puppy}와의\n기억에 대해 얘기해봐요.", // 5
    "${home.puppy}와 함께한\n한 가지 기억을 떠올려주세요.", // 6
    "그날은 어떤 날씨였나요?", // 7
    "그날은 어떤 날씨였나요?", // 8

    // "그렇군요. ()한 날씨에\n아이와 어디에 있었나요?", // 9
    // "그렇군요. ()한 날씨에\n아이와 어디에 있었나요?", // 10
    //
    // "()한 날씨에\n()에서 있었군요!", // 11
    // "보호자님과\n아이는 뭘 하고 있었을까요?", // 12
    // "보호자님과\n아이는 뭘 하고 있었을까요?", // 13  노
    //
    // "그렇다면 보호자님과\n아이는 어떤 모습으로 보이나요?", // 14  13
    // "그렇다면 보호자님과\n아이는 어떤 모습으로 보이나요?", // 15  14
    //
    // "우리 아이와\n보호자님의", // 16 15
    // "()한 모습을\n떠올려보면", // 17 16
    // "보호자님의 마음은\n어떤 것 같나요?", // 18 17
    // "고민중" // 19 18
  ];
// 슬픔 선택시
  List<dynamic> question1_0= [
    "${home.user}님!",
    "지금 ${home.puppy}와의\n기억을 생각하며 느끼는 감정은",
    "너무나 당연한 것이에요.",
    "그리고 이 감정을\n충분히 느끼는 것도 정말 중요해요.",
    "하지만\n저의 도움만으로 부족할 수 있기에",
    "‘함께할개’에서\n다른 사람들의 이야기를 듣고",
    "도움을 요청해 보는 것을 추천드려요!",
  ];

// 행복 선택시
  List<dynamic> questions1_1 =[
    "${home.user}님!",
    "${home.puppy}와의\n기억을 떠올려보면",
    "마냥 슬프기만 하지는\n않은 것 같아요!",
    "${home.user}님의 마음이\n잠시동안은 행복했길 바라요.",
    "이후에도 ${home.user}님은\n${home.puppy}를 생각하다보면",
    "분명 슬픈 감정이 생겨날 수 있어요.",
    "그럴때는 ‘함께할개’에서\n다른 사람들의 이야기를 듣고",
    "도움을 요청해 보는 것을 추천드려요!",

  ];

  List<dynamic> questions1_2 =[
    /// "보호자님…",
    // "다른 사람들과 함께\n도움을 주고 받으면서",
    // "앞으로 보호자님의 마음에\n안정이 찾아오기까지",
    // "도움이 되었으면\n하는 바람이에요.",
  ];

  List<dynamic> questionsEnd =[
    /// "보호자님…",
    // "이제 우리가 다시\n만나게 될 시간을 알려주세요.",
    // "네, 보호자님.\n()시간 후에 다시 만나요!",
  ];

  String result = "슬픔";
  late Map<String, dynamic> parsedResponseUser;
  void sendAnswer(String aToken, String con) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/conversation/emotion/stage1/1';

    // 요청 본문 데이터
    var data = {
      "userAnswer": con,
    };

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    // HTTP GET 요청 보내기
    var response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(data),
      headers: headers, // 헤더 추가
    );

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      print("대화 단계 넣기 성공");
      print('서버로부터 받은 내용 데이터(사용자 감정 정보): ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);
      parsedResponseUser = json.decode(jsonResponse);
      result = parsedResponseUser['emotion'];
      print(result);

      if(result == "슬픔"){
        grief = true;

        nextQuestion++;
        player2.setAsset(griefVoice[happyVoiceCount]);
        griefVoiceCount++;
        player2.play();

        controller1.repeat(
            min: 0,
            max: 30,
            period: const Duration(milliseconds: 1000)
        );
        Timer(Duration(seconds: 1), () {
          controller1.stop();
        });
      }else{
        happy = true;

        nextQuestion++;
        player2.setAsset(happyVoice[happyVoiceCount]);
        happyVoiceCount++;
        player2.play();

        controller1.repeat(
            min: 0,
            max: 30,
            period: const Duration(milliseconds: 1000)
        );
        Timer(Duration(seconds: 1), () {
          controller1.stop();
        });
      }


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
          color: Color(0xffFCCBCD),
          child: GestureDetector(
            onTap: (){
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
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
                controller2.repeat(
                    min: 0,
                    max: 32,
                    period: const Duration(milliseconds: 2000)
                );
                if(nextQuestion == 1){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                  Timer(Duration(milliseconds: 2000), () {
                    controller2.stop();
                  });
                } else if(nextQuestion == 2){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  }); // ok
                  Timer(Duration(milliseconds: 2000), () {
                    controller2.stop();
                  });
                } else if(nextQuestion == 3){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 4){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 5){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 6){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 7){
                  Timer(Duration(milliseconds: 2500), () {
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
                // 어떤 날씨?
                // controller1.repeat(
                //     min: 0,
                //     max: 30,
                //     period: const Duration(milliseconds: 1000)
                // );
                // Timer(Duration(seconds: 3), () {
                //   controller1.stop();
                // });
              }
              else if(nextQuestion == 9){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                // 2.5초 적정
                // controller1.repeat(
                //     min: 0,
                //     max: 30,
                //     period: const Duration(milliseconds: 1000)
                // );
                // Timer(Duration(seconds: 4), () {
                //   controller1.stop();
                // });
              }
              else if(nextQuestion == 10){
                // 어디서 있었는지?
              }
              else if(nextQuestion >10 && nextQuestion <12){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextQuestion == 12){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 12){
                // 뭘하고 있었는지?
                // controller1.repeat(
                //     min: 0,
                //     max: 30,
                //     period: const Duration(milliseconds: 1000)
                // );
                // Timer(Duration(milliseconds: 4000), () {
                //   controller1.stop();
                // });

              }
              else if(nextQuestion == 13){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                // controller1.repeat(
                //     min: 0,
                //     max: 30,
                //     period: const Duration(milliseconds: 1000)
                // );
                // Timer(Duration(seconds: 5), () {
                //   controller1.stop();
                // });
              }
              else if(nextQuestion == 14){
                // 어떤 모습으로 보이는지?
              }
              else if(nextQuestion > 14 && nextQuestion < 17){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextQuestion == 16){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 17){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 17){

              }
              else if(nextQuestion == 18){
                // gpt로부터 답변 가져오기
                // happy = true;
                // nextQuestion++;
                // player2.setAsset(happyVoice[happyVoiceCount]);
                // happyVoiceCount++;
                // player2.play();

                // grief = true;
                // nextQuestion++;
                // player2.setAsset(griefVoice[happyVoiceCount]);
                // griefVoiceCount++;
                // player2.play();
                //
                // controller1.repeat(
                //     min: 0,
                //     max: 30,
                //     period: const Duration(milliseconds: 1000)
                // );
                // Timer(Duration(seconds: 1), () {
                //   controller1.stop();
                // });
              }
              // 여기서부터는 감정
              else if(happy && nextHappy < 7){
                nextHappy++;
                player2.setAsset(happyVoice[happyVoiceCount]);
                happyVoiceCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );

                controller3.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 2000)
                );

                if(nextHappy == 1){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                }
                else if(nextHappy == 2){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                  Timer(Duration(milliseconds: 1000), () {
                    controller3.stop();
                  });
                }
                else if(nextHappy == 3){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextHappy == 4){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextHappy == 5){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextHappy == 6){
                  Timer(Duration(seconds: 4), () {
                    controller1.stop();
                  });
                }
                else if(nextHappy == 7){
                  Timer(Duration(seconds: 3), () {
                    controller1.stop();
                  });
                }
              }
              else if(grief && nextGrief<6){
                nextGrief++;
                player2.setAsset(griefVoice[griefVoiceCount]);
                griefVoiceCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );

                controller2.repeat(
                    min: 0,
                    max: 32,
                    period: const Duration(milliseconds: 2000)
                );

                if(nextGrief == 1){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                  Timer(Duration(milliseconds: 2000), () {
                    controller2.stop();
                  });
                }
                else if(nextGrief == 2){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                  Timer(Duration(milliseconds: 2000), () {
                    controller2.stop();
                  });
                }
                else if(nextGrief == 3){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                }
                else if(nextGrief == 4){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextGrief == 5){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
                else if(nextGrief == 6){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
              }
              else if(happy && nextHappy == 7){
                // 밑에 버튼이 생겨서 이동
              }
              else if(grief && nextGrief == 6){
                // 밑에 버튼이 생겨서 이동
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
                                      currentValue: 40,
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
                                            Center(child: SvgPicture.asset('assets/images/conversation/bubble.svg',fit: BoxFit.fill,),),
                                            Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12, ),
                                                child: Center(
                                                    child: Column(
                                                      children: [
                                                        if(grief == false && happy == false)...[
                                                          if(questions0[nextQuestion].toString().contains("\n"))...[
                                                            SizedBox(height: 28,),
                                                            Text(
                                                              questions0[nextQuestion],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ]else...[
                                                            SizedBox(height: 42,),
                                                            Text(
                                                              questions0[nextQuestion],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ],
                                                        ]
                                                        // 행복일시
                                                        else if (happy) ...[
                                                          if(questions1_1[nextHappy].toString().contains("\n"))...[
                                                            SizedBox(height: 28,),
                                                            Text(
                                                              questions1_1[nextHappy],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ]else...[
                                                            SizedBox(height: 42,),
                                                            Text(
                                                              questions1_1[nextHappy],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ],
                                                          // 슬픔일 시
                                                        ] else if (grief) ...[
                                                          if(question1_0[nextGrief].toString().contains("\n"))...[
                                                            SizedBox(height: 28,),
                                                            Text(
                                                              question1_0[nextGrief],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ]else...[
                                                            SizedBox(height: 42,),
                                                            Text(
                                                              question1_0[nextGrief],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
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
                                    if(nextQuestion < 8 || nextQuestion == 9 || (nextQuestion>10 && nextQuestion<14) || (nextQuestion > 14 && nextQuestion < 18) || nextQuestion>18)...[
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

                                                      if(nextQuestion == 2 || nextGrief == 1 || nextGrief == 2)...[
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: GifImage(
                                                            controller: controller2,
                                                            image: const AssetImage("assets/images/conversation/gif/sad_muji.gif"),
                                                          ),
                                                        ),
                                                      ] else if(nextQuestion == 0 || nextQuestion == 11 || nextHappy == 2)...[
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: GifImage(
                                                            controller: controller3,
                                                            image: const AssetImage("assets/images/conversation/gif/smile_muji.gif"),
                                                          ),
                                                        ),
                                                      ]
                                                      else...[
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: Image.asset('assets/images/conversation/gif/muji_base_eye.gif',
                                                            fit: BoxFit.cover,),),
                                                      ],


                                                      // Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                      //   child: Image.asset('assets/images/conversation/gif/muji_base_eye.gif',
                                                      //     fit: BoxFit.cover,),),
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
                                    else if(nextQuestion == 8)...[
                                      Padding(
                                        padding: EdgeInsets.only(top:175, left:45),
                                        child: Container(
                                          width: 275,
                                          height: 120,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(width: 75,),
                                                  Container(
                                                    padding: EdgeInsets.only(bottom:16),
                                                    width: containerWidth1,
                                                    child: TextField(
                                                      style: textStyle.inputfield,
                                                      onTap: (){
                                                        chooseTime = true;
                                                        whatTime = nextTimeController.text;
                                                        setState(() {
                                                        });

                                                      },
                                                      onChanged: (text){
                                                        selectedNextTime = true;
                                                        whatTime = nextTimeController.text;
                                                        updateContainerWidth1();
                                                      },
                                                      controller: nextTimeController,
                                                      decoration: InputDecoration(
                                                        hintText: '어떤',
                                                        contentPadding: EdgeInsets.only(top: 16),
                                                        suffixStyle: TextStyle(color: Color(0xff83A8FF), fontSize: 20,),
                                                        hintStyle: textStyle.field,
                                                        counterText:'',
                                                      ),
                                                      maxLength: 10,
                                                    ),),
                                                  Text(" 날씨였어요.", style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                                                ],),
                                              SizedBox(height: 8,),
                                              // DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR[index]['createdAt']))
                                              // DateFormat('MM/dd HH:mm').format(DateTime.now().add(Duration(hours: whatTime)))
                                              Text("10자 이내", style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffAAAAAA)),),

                                            ],),
                                        ),
                                      ),
                                    ]
                                    else if(nextQuestion == 10)...[
                                        Padding(
                                          padding: EdgeInsets.only(top:175, left:45),
                                          child: Container(
                                            width: 275,
                                            height: 120,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(width: 75,),
                                                    Container(width: containerWidth2,
                                                      padding: EdgeInsets.only(bottom:16),
                                                      child: TextField(
                                                        style: textStyle.inputfield,
                                                        onTap: (){
                                                          chooseLocate = true;
                                                          whatLocate = locateController.text;
                                                          setState(() {
                                                          });
                                                        },
                                                        onChanged: (text){
                                                          updateContainerWidth2();
                                                          selectedLocate = true;
                                                          whatLocate = locateController.text;
                                                        },
                                                        controller: locateController,
                                                        decoration: InputDecoration(
                                                          hintText: '어디',
                                                          contentPadding: EdgeInsets.only(top: 16),
                                                          suffixStyle: TextStyle(color: Color(0xff83A8FF), fontSize: 20,),
                                                          hintStyle: textStyle.field,
                                                          counterText:'',
                                                          //labelText: '몇',
                                                        ),
                                                        maxLength: 10,
                                                      ),),
                                                    Text("에 있었어요.", style: TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                                                  ],),
                                                SizedBox(height: 8,),
                                                // DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR[index]['createdAt']))
                                                // DateFormat('MM/dd HH:mm').format(DateTime.now().add(Duration(hours: whatTime)))
                                                Text("10자 이내", style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffAAAAAA)),),

                                              ],),
                                          ),
                                        ),
                                      ]
                                      else if(nextQuestion == 14)...[
                                          Padding(
                                            padding: EdgeInsets.only(top:175, left:45),
                                            child: Container(
                                              width: 275,
                                              height: 120,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 75,),
                                                      Container(
                                                        padding: EdgeInsets.only(bottom:16),
                                                        width: containerWidth3,
                                                        child: TextField(
                                                          style: textStyle.inputfield,
                                                          onTap: (){
                                                            chooseHow = true;

                                                            whatHow = howController.text;
                                                            setState(() {
                                                            });
                                                          },
                                                          onChanged: (text){
                                                            updateContainerWidth3();
                                                            selectedHow = true;
                                                            whatHow = howController.text;
                                                          },
                                                          controller: howController,
                                                          decoration: InputDecoration(
                                                            hintText: '어떤',
                                                            contentPadding: EdgeInsets.only(top: 16),
                                                            suffixStyle: TextStyle(color: Color(0xff83A8FF), fontSize: 20,),
                                                            hintStyle: textStyle.field,
                                                            counterText:'',
                                                          ),
                                                          maxLength: 300,
                                                        ),),
                                                      Text("모습이에요.", style: TextStyle(
                                                          fontFamily: 'Pretendard',
                                                          fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                                                    ],),
                                                  SizedBox(height: 8,),
                                                  // DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR[index]['createdAt']))
                                                  // DateFormat('MM/dd HH:mm').format(DateTime.now().add(Duration(hours: whatTime)))
                                                  Text("10자 이내", style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffAAAAAA)),),

                                                ],),
                                            ),
                                          ),
                                        ]
                                        // chat gpt 답변 받아오기 전 고민하는 무지
                                        else if(nextQuestion == 18)...[
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
                                                              child: Image.asset('assets/images/conversation/gif/think_back.gif',
                                                                fit: BoxFit.cover,),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                              child:
                                                              Image.asset('assets/images/conversation/gif/thinking1.gif', fit: BoxFit.cover,),
                                                              // GifImage(
                                                              //   controller: controller1,
                                                              //   image: const AssetImage("assets/images/conversation/gif/think_muji.gif"),
                                                              // ),
                                                            ),
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
                                  ],
                                ),

                              ],
                            ),
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
                      if(nextQuestion == 8 && selectedNextTime)...[
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
                                  questions0.insertAll(9, [
                                    "그렇군요. ${whatTime} 날씨에\n${home.puppy}와 어디에 있었나요?", // 9
                                    "그렇군요. ${whatTime} 날씨에\n${home.puppy}와 어디에 있었나요?", // 10
                                  ]);
                                  nextQuestion++;
                                  player2.setAsset(voice[voiceCount]);
                                  voiceCount++;
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
                      else if(nextQuestion == 10 && selectedLocate)...[
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
                                  questions0.insertAll(11, [
                                    "${whatTime} 날씨에\n${whatLocate}에서 있었군요!", // 11
                                    "${home.user}님과\n${home.puppy}는 뭘 하고 있었을까요?", // 12
                                     // "보호자님과\n아이는 뭘 하고 있었을까요?", // 13
                                  ]);
                                  nextQuestion++;
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

                                  controller3.repeat(
                                      min: 0,
                                      max: 30,
                                      period: const Duration(milliseconds: 2000)
                                  );
                                  Timer(Duration(milliseconds: 1500), () {
                                    controller3.stop();
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
                      else if(nextQuestion == 12)...[
                        Container(
                          color: Colors.white,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 16,right: 16),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: screenSize.width,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: setWhat? Color(colorChart.blue):Color(0xffC0D2FC)),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                Positioned(
                                  left: 15,
                                  right: 30,
                                  bottom:-4,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    maxLines: 1,
                                    controller: whatController,
                                    style: textStyle.bk14normal,
                                    decoration: InputDecoration(
                                        hintStyle: textStyle.grey14normal,
                                        border: InputBorder.none,
                                        hintText: '뭘 하고 있었냐면...'),
                                    onChanged: (s) {
                                      //text = s;
                                      setWhat = true;
                                      setState(() {

                                      });
                                    },
                                    onTap: () {},
                                  ),
                                ),
                                Positioned(
                                  left: screenSize.width - 80,
                                  //right: 30,
                                  bottom: 3,
                                  top: 3,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if(setWhat){
                                          player2.setAsset(voice[voiceCount]);
                                          voiceCount++;
                                          player2.play();
                                          controller1.repeat(
                                              min: 0,
                                              max: 30,
                                              period: const Duration(milliseconds: 1000)
                                          );

                                          Timer(Duration(milliseconds: 4000), () {
                                            controller1.stop();
                                          });

                                          questions0.insertAll(13, [
                                            "그렇다면 ${home.user}님과\n${home.puppy}는 어떤 모습으로 보이나요?", // 14
                                            "그렇다면 ${home.user}님과\n${home.puppy}는 어떤 모습으로 보이나요?", // 15
                                          ]);

                                          nextQuestion++;
                                          setState(() {

                                          });
                                        }

                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: setWhat? Color(colorChart.blue):Color(0xffDDE7FD),
                                        fixedSize: const Size(23, 23),
                                        shape: const CircleBorder(),
                                      ),
                                      child: Icon(
                                        Icons.arrow_upward,
                                        color: Colors.white,size: 16,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ]
                        else if(nextQuestion == 14 && selectedHow)...[
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
                                      questions0.insertAll(15, [
                                        "우리 ${home.puppy}와\n${home.user}님의", // 15
                                        "${whatHow} 모습을\n떠올려보면", // 16
                                        "${home.user}님의 마음은\n어떤 것 같나요?", // 17
                                        "고민중", // 18
                                      ]);
                                      nextQuestion++;
                                      player2.setAsset(voice[voiceCount]);
                                      voiceCount++;
                                      player2.play();
                                      // 2.5초 적정
                                      controller1.repeat(
                                          min: 0,
                                          max: 30,
                                          period: const Duration(milliseconds: 1000)
                                      );
                                      Timer(Duration(milliseconds: 2000), () {
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
                          else if(nextQuestion == 17)...[
                            Container(
                              color: Colors.white,
                              height: 48,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 16,right: 16),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: screenSize.width,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: setEmotion?Color(colorChart.blue):Color(0xffC0D2FC)),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    Positioned(
                                      left: 15,
                                      right: 30,
                                      bottom:-4,
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        maxLines: 1,
                                        controller: emotionController,
                                        style: textStyle.bk14normal,
                                        decoration: InputDecoration(
                                            hintStyle: textStyle.grey14normal,
                                            border: InputBorder.none,
                                            hintText: '제 마음은...'),
                                        onChanged: (s) {
                                          //text = s;
                                          setEmotion = true;
                                          setState(() {

                                          });
                                        },
                                        onTap: () {

                                        },
                                      ),
                                    ),
                                    Positioned(
                                      left: screenSize.width - 80,
                                      //right: 30,
                                      bottom: 3,
                                      top: 3,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            sendAnswer(sign_in.userAccessToken, emotionController.text);
                                            // 고민하는 무지 움직이기
                                            if(setEmotion){
                                              nextQuestion++;
                                              setState(() {
                                                controller1.repeat(
                                                    min: 2,
                                                    max: 30,
                                                    period: const Duration(milliseconds: 2000)
                                                );
                                                Timer(Duration(milliseconds: 1000), () {
                                                  controller1.stop();
                                                });
                                              });
                                            }

                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: setEmotion? Color(colorChart.blue):Color(0xffDDE7FD),
                                            fixedSize: const Size(3, 3),
                                            shape: const CircleBorder(),
                                          ),
                                          child: Icon(
                                            Icons.arrow_upward,
                                            color: Colors.white,size: 16,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ]
                            else if((happy && nextHappy == 7) || (grief && nextGrief == 6))...[
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
                                          // 함께할개 코치마크로 이동
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => EarlyMarkCoachPage()));
                                        },
                                        child: Text("다음", style: TextStyle(
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

