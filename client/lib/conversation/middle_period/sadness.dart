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
import 'package:input_slider/input_slider.dart';

/// 중기대화-슬픔

AudioPlayer player2 = AudioPlayer();

late FlutterGifController controller1, controller2, controller3;

// start
List<dynamic> voice =[
   "assets/voice/middle/sadness/start1.mp3", "assets/voice/middle/sadness/start2.mp3",
  "assets/voice/middle/sadness/start3.mp3", "assets/voice/middle/sadness/start4.mp3",
  "assets/voice/middle/sadness/start5.mp3", "assets/voice/middle/sadness/start6.mp3",
  "assets/voice/middle/sadness/start7.mp3",
];

// good
List<dynamic> goodVoice =[
  "assets/voice/middle/sadness/good1.mp3", "assets/voice/middle/sadness/good2.mp3",
  "assets/voice/middle/sadness/good3.mp3", "assets/voice/middle/sadness/good4.mp3",

];

// little
List<dynamic> littleVoice =[
  "assets/voice/middle/sadness/little_1.mp3", "assets/voice/middle/sadness/little_2.mp3",
  "assets/voice/middle/sadness/little_3.mp3", "assets/voice/middle/sadness/little_4.mp3",
];

//hard
List<dynamic> hardVoice =[
  "assets/voice/middle/sadness/hard1.mp3", "assets/voice/middle/sadness/hard2.mp3",
  "assets/voice/middle/sadness/hard3.mp3",
];

//next
List<dynamic> nextVoice =[
  "assets/voice/middle/sadness/next1.mp3", "assets/voice/middle/sadness/next2.mp3",
  "assets/voice/middle/sadness/next3.mp3", "assets/voice/middle/sadness/next4.mp3",
];

//sad
List<dynamic> sadVoice =[
  "assets/voice/middle/sadness/sad1.mp3", "assets/voice/middle/sadness/sad2.mp3",
  "assets/voice/middle/sadness/sad3.mp3",
];

//endure
List<dynamic> endureVoice =[
  "assets/voice/middle/sadness/endure1.mp3", "assets/voice/middle/sadness/endure2.mp3",
  "assets/voice/middle/sadness/endure3.mp3", "assets/voice/middle/sadness/endure4.mp3",
  "assets/voice/middle/sadness/endure5.mp3", "assets/voice/middle/sadness/endure6.mp3",
];

//last
List<dynamic> lastVoice =[
  "assets/voice/middle/sadness/last1.mp3", "assets/voice/middle/sadness/last2.mp3",
  "assets/voice/middle/sadness/last3.mp3", "assets/voice/middle/sadness/last4.mp3",
  "assets/voice/middle/sadness/last5.mp3", "assets/voice/middle/sadness/last6.mp3",
  "assets/voice/middle/sadness/last7.mp3", "assets/voice/middle/sadness/last8.mp3",
  "assets/voice/middle/sadness/last9.mp3", "assets/voice/middle/sadness/last10.mp3",
  "assets/voice/middle/sadness/last11.mp3", "assets/voice/middle/sadness/last12.mp3",
  "assets/voice/middle/sadness/last13.mp3",
];

//end
List<dynamic> endVoice =[
  "assets/voice/middle/sadness/end1.mp3", "assets/voice/middle/sadness/end2.mp3",
  "assets/voice/middle/sadness/end3.mp3", "assets/voice/middle/sadness/end4.mp3",
  "assets/voice/intro/intro2_8.mp3",
  "",
  "assets/voice/intro/intro2_9.mp3",
];




class SadnessPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => SadnessPage(),
      ),
    );
  }

  @override
  _SadnessPageState createState() => _SadnessPageState();
}

class _SadnessPageState extends State<SadnessPage> with TickerProviderStateMixin {

  bool selectedNextTime = false;
  bool chooseTime = false;
  int whatTime = 0;

  bool selectedLocate = false;
  bool chooseLocate = false;
  String whatLocate = "";

  bool selectedHow = false;
  bool chooseHow = false;
  String whatHow = "";

  // 텍스트 에디팅 컨트롤러를 생성하여 필드에 할당
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
    Timer(Duration(milliseconds: 1500), () {
      controller1.stop();
    });

    _callAPI();
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
  int startQuestion = 0;
  int voiceCount = 0;
  int voiceGoodCount = 0;
  int voiceLittleCount = 0;
  int voiceHardCount = 0;
  int voiceNextCount = 0;
  int voiceSadCount = 0;
  int voiceEndureCount = 0;
  int voiceLastCount = 0;
  int voiceEndCount = 0;

  int goodQuestion = 0;
  bool goodAns = false;
  bool ui_good = false;

  int littleQuestion = 0;
  bool littleAns = false;
  bool ui_little = false;

  int hardQuestion = 0;
  bool hardAns = false;
  bool ui_hard = false;

  int nextQuestion = 0;
  bool nextQ = false;

  bool ui_bad = false;
  bool ui_sad = false;
  bool ui_endure = false;

  int sadQuestion = 0;
  bool sadAns = false;

  int endureQuestion = 0;
  bool endureAns = false;

  int lastQuestion = 0;
  bool last = false;

  int endQuestion = 0;
  bool end = false;

  int happyVoiceCount = 0;
  int griefVoiceCount = 0;

  // 시작
  List<dynamic> startQuestions =[
    "좋아요, ${home.user}님",
    "${home.puppy}와의\n이별로 겪은 슬픈 감정들은",
    "${home.user}님의 삶에\n변화를 가져왔을 거예요.",
    "요즘 ${home.user}님은",
    "어떻게 지내고 있는지 궁금해요.",
    "현재 ${home.user}님의\n건강 상태는 어떤가요?",
    "건강 상태의 정도를 알려주세요.",

  ];

// 좋아요
  List<dynamic> good= [
    "${home.user}님은 슬픔을",
    "건강하게 극복하고 계시네요.",
    "앞으로도 ${home.user}님의\n일상을 유지하면서.",
    "차차 이별을 극복해가면 된답니다!",
  ];

// 조금 아파요
  List<dynamic> little =[
    "이별은 누구에게나\n큰 후유증을 남기죠.",
    "하지만,\n이별을 잘 보내기 위해서는",
    "건강한 몸도 정말 중요하답니다.",
    "사소한 일상을 지키며\n이별을 같이 극복해봐요!",
  ];

// 아파요
  List<dynamic> hard =[
    "이별을 겪으면 마음을 따라\n몸도 너무나 아파오죠.",
    "든든한 밥을 먹고\n간단한 야외활동을 하면서",
    "우리 사소한 것부터 시작해보아요!",
  ];

// 다음 질문
  List<dynamic> nextQuestions =[
    "다음 질문이에요.",
    "${home.user}님,\n현재 마음의 슬픔은",
    "어느 정도인가요?",
    "슬픔의 정도를 알려주세요.",
  ];

// 고통, 슬퍼요
  List<dynamic> sad =[
    "${home.user}님의\n아픈 마음이 제게도 느껴져요.",
    "슬프고 고통스러운 마음을\n저에게 털어놓으면서",
    "조금이나마 덜어지길\n바라는 마음이랍니다.",
  ];

// 견딜 수 있어요
  List<dynamic> endure =[
    "${home.user}님,",
    "슬픔을 있는 그대로 표현하는 과정은\n매우 중요하답니다.",
    "그래도 ${home.user}님은\n슬픔으로 인한 감정을",
    "잘 풀어나가고 있는 것 같아요.",
    "앞으로도 지금처럼만\n${home.user}님의 슬픔을",
    "있는 그대로 표현해 보아요.",
  ];

  List<dynamic> lastQuestions =[
    "${home.user}님",
    "${home.puppy}와의\n이별로 겪게된 슬픈 감정들이",
    "몸과 마음에\n여러가지 변화를 가져온 것 같아요.",
    "마지막으로\n${home.puppy}와의 이별이",
    "어떤 변화들을 가져왔는지\n구체적으로 얘기해보려고 해요.",
    "구체적으로 ${home.user}님은\n어떤 상황인가요?",
    "이별은 무기력하게\n때로는 하염없이 슬프게 만들기도 해요.",
    "아주 고통스럽게 만들기도 하죠.",
    "${home.user}님 혼자\n이 감정들을 감당하기에",
    "어려움이 있어 보여요.",
    "같은 상황을 경험한\n혹은 경험중인",
    "많은 반려인들의 얘기를\n들어보는 건 어떨까요?",
    "${home.user}님에게\n‘도움 요청하기’를 추천해드릴게요!",
  ];

  List<dynamic> questionsEnd =[
    "${home.user}님,",
    "오늘 제가 준비한 대화는\n여기까지예요.",
    "${home.user}님의\n슬픈 감정들을 얘기하고",
    "스스로를 다독일 수 있기를 바라요!",
    "자, 이제 우리가 다시\n만나게 될 시간을 알려주세요.",
    "자, 이제 우리가 다시\n만나게 될 시간을 알려주세요.",
  ];

  void _callAPI() async {
    // 요청 본문 데이터
    var data = {
      "stage" : "0",
      "set" : "0",
      "lineId" : "0"
    };

    var url = Uri.parse('http://3.38.1.125:8080/conversation/line'); // 엔드포인트 URL 설정

    try {
      var response = await http.post(
        url,
        body: json.encode(data), // 요청 본문에 데이터를 JSON 형식으로 인코딩하여 전달
        headers: {'Content-Type': 'application/json',}, // 요청 헤더에 Content-Type 설정
      );

      if (response.statusCode == 200) {
        // 응답 성공 시의 처리

        var jsonResponse = utf8.decode(response.bodyBytes); // 응답 본문을 JSON 형식으로 디코딩
        // JSON 값을 활용한 원하는 동작 수행
        //utf8.decode(jsonResponse);
        print(jsonResponse);

        List<String> contentList = [];

        List<dynamic> parsedResponse = json.decode(jsonResponse);

        setState(() {
          for (var item in parsedResponse) {
            if (item['content'] != null) {
              introText.add(item['content']);
            }
          }
        });

        print(introText);

        print('API 호출 성공: ${response.statusCode}');
      } else {
        // 요청 실패 시의 처리
        print('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 발생 시의 처리
      print('API 호출 중 예외 발생: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
          color: Color(0xffFBF3B8),
          child: GestureDetector(
            onTap: (){
              print("이거만 좀 확인 부탁: " + nextQuestion.toString());

              if(startQuestion < 6){
                startQuestion++; // 인트로 시작 후 count
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(startQuestion == 1){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                } else if(startQuestion == 2){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  }); // ok
                } else if(startQuestion == 3){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                } else if(startQuestion == 4){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(startQuestion == 5){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(startQuestion == 6){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 6){
                // 건강상태 정도?
              }
              else if(goodAns && goodQuestion < 3){
                goodQuestion++;
                player2.setAsset(goodVoice[voiceGoodCount]);
                voiceGoodCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(goodQuestion == 1){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                } else if(goodQuestion == 2){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  }); // ok
                }
                else if(goodQuestion == 3){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  }); // ok
                }
              }
              else if(goodQuestion == 3 && nextQ == false){
                //goodQuestion++;
                nextQ = true;
                player2.setAsset(nextVoice[voiceNextCount]);
                voiceNextCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(voiceNextCount == 1){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                }
              }
              else if(littleAns && littleQuestion < 3){
                littleQuestion++;
                player2.setAsset(littleVoice[voiceLittleCount]);
                voiceLittleCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(littleQuestion == 1){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                } else if(littleQuestion == 2){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  }); // ok
                } else if(littleQuestion == 3){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  }); // ok
                }
              }
              else if(littleQuestion == 3 && nextQ == false){
                //littleQuestion++;
                nextQ = true;
                player2.setAsset(nextVoice[voiceNextCount]);
                voiceNextCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(voiceNextCount == 1){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                }
              }
              else if(hardAns && hardQuestion < 2){
                hardQuestion++;
                player2.setAsset(hardVoice[voiceHardCount]);
                voiceHardCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(hardQuestion == 1){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                } else if(hardQuestion == 2){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  }); // ok
                }
              }
              else if(hardQuestion == 2 && nextQ == false){
                //hardQuestion++;
                nextQ = true;
                player2.setAsset(nextVoice[voiceNextCount]);
                voiceNextCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(voiceNextCount == 1){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQ && nextQuestion <3){
                nextQuestion++;
                player2.setAsset(nextVoice[voiceNextCount]);
                voiceNextCount++;
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
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  }); // ok
                } else if(nextQuestion == 3){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  }); // ok
                }
              }
              else if(nextQuestion == 3){
                // 슬픔의 정도?
              }
              else if(sadAns && sadQuestion <2){
                sadQuestion++;
                player2.setAsset(sadVoice[voiceSadCount]);
                voiceSadCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(sadQuestion == 1){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                } else if(sadQuestion == 2){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  }); // ok
                }
              }
              else if(sadQuestion == 2 && last == false){
                last = true;
                player2.setAsset(lastVoice[voiceLastCount]);
                voiceLastCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                Timer(Duration(milliseconds: 1000), () {
                  controller1.stop();
                });
              }
              else if(endureAns && endureQuestion <5){
                endureQuestion++;
                player2.setAsset(endureVoice[voiceEndureCount]);
                voiceEndureCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(endureQuestion == 1){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                } else if(endureQuestion == 2){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  }); // ok
                } else if(endureQuestion == 3){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  }); // ok
                } else if(endureQuestion == 4){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  }); // ok
                } else if(endureQuestion == 5){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  }); // ok
                }
              }
              else if(endureQuestion == 5 && last == false){
                last = true;
                player2.setAsset(lastVoice[voiceLastCount]);
                voiceLastCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                Timer(Duration(milliseconds: 1000), () {
                  controller1.stop();
                });
              }
              else if(last && lastQuestion <5){
                lastQuestion++;
                player2.setAsset(lastVoice[voiceLastCount]);
                voiceLastCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(lastQuestion == 1){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                } else if(lastQuestion == 2){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  }); // ok
                } else if(lastQuestion == 3){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  }); // ok
                } else if(lastQuestion == 4){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  }); // ok
                } else if(lastQuestion == 5){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  }); // ok
                }
              }
              else if(last && lastQuestion == 5){
                // 어떤 상황인가요
              }
              else if(last && lastQuestion > 5 && lastQuestion <12){
                // 어떤 상황인가요
                lastQuestion++;
                player2.setAsset(lastVoice[voiceLastCount]);
                voiceLastCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(lastQuestion == 7){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                } else if(lastQuestion == 8){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  }); // ok
                } else if(lastQuestion == 9){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  }); // ok
                } else if(lastQuestion == 10){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  }); // ok
                } else if(lastQuestion == 11){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  }); // ok
                } else if(lastQuestion == 12){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  }); // ok
                }

              }
              else if(last && lastQuestion == 12 && end == false){
                end = true;
                player2.setAsset(endVoice[voiceEndCount]);
                voiceEndCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                Timer(Duration(milliseconds: 1000), () {
                  controller1.stop();
                });

              }
              else if(end && endQuestion < 5){
                endQuestion++;
                player2.setAsset(endVoice[voiceEndCount]);
                voiceEndCount++;

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(endQuestion == 1){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                } else if(endQuestion == 2){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  }); // ok
                } else if(endQuestion == 3){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  }); // ok
                } else if(endQuestion == 4){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  }); // ok
                }
              }
              else if(end && endQuestion == 5){
                // 만날 시간
              }
              else if(end && endQuestion > 5 && endQuestion < 7){
                endQuestion++;
                player2.setAsset(endVoice[voiceEndCount]);
                voiceCount++;
              }
              else if(endQuestion == 7){

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
                                        Center(child: SvgPicture.asset('assets/images/conversation/bubble.svg',fit: BoxFit.fill,),),
                                        Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12, ),
                                            child: Center(
                                                child: Column(
                                                  children: [
                                                    if(goodAns == false && littleAns ==false && hardAns == false && last == false
                                                    && nextQ == false && sadAns == false && endureAns == false && end == false)...[
                                                      if(startQuestions[startQuestion].toString().contains("\n"))...[
                                                        SizedBox(height: 28,),
                                                        Text(
                                                          startQuestions[startQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ]else...[
                                                        SizedBox(height: 42,),
                                                        Text(
                                                          startQuestions[startQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ],
                                                    ]
                                                    // 좋아요일시
                                                    else if (goodAns && nextQ == false) ...[
                                                      if(good[goodQuestion].toString().contains("\n"))...[
                                                        SizedBox(height: 28,),
                                                        Text(
                                                          good[goodQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ]else...[
                                                        SizedBox(height: 42,),
                                                        Text(
                                                          good[goodQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ],
                                                    ]
                                                      // 조금 아파요일시
                                                    else if (littleAns && nextQ == false) ...[
                                                      if(little[littleQuestion].toString().contains("\n"))...[
                                                        SizedBox(height: 28,),
                                                        Text(
                                                          little[littleQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ]else...[
                                                        SizedBox(height: 42,),
                                                        Text(
                                                          little[littleQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ],
                                                    ]
                                                      // 아파요일시
                                                      else if (hardAns && nextQ == false) ...[
                                                          if(hard[hardQuestion].toString().contains("\n"))...[
                                                            SizedBox(height: 28,),
                                                            Text(
                                                              hard[hardQuestion],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ]else...[
                                                            SizedBox(height: 42,),
                                                            Text(
                                                              hard[hardQuestion],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ],
                                                        ]
                                                        // 다음 질문
                                                        else if (nextQ && sadAns == false && endureAns == false && end == false) ...[
                                                            if(nextQuestions[nextQuestion].toString().contains("\n"))...[
                                                              SizedBox(height: 28,),
                                                              Text(
                                                                nextQuestions[nextQuestion],
                                                                textAlign: TextAlign.center,
                                                                style: textStyle.bubbletext,
                                                              ),
                                                            ]else...[
                                                              SizedBox(height: 42,),
                                                              Text(
                                                                nextQuestions[nextQuestion],
                                                                textAlign: TextAlign.center,
                                                                style: textStyle.bubbletext,
                                                              ),
                                                            ],
                                                          ]
                                                          // 고통, 슬퍼요일시
                                                          else if (sadAns && last== false && end == false) ...[
                                                              if(sad[sadQuestion].toString().contains("\n"))...[
                                                                SizedBox(height: 28,),
                                                                Text(
                                                                  sad[sadQuestion],
                                                                  textAlign: TextAlign.center,
                                                                  style: textStyle.bubbletext,
                                                                ),
                                                              ]else...[
                                                                SizedBox(height: 42,),
                                                                Text(
                                                                  sad[sadQuestion],
                                                                  textAlign: TextAlign.center,
                                                                  style: textStyle.bubbletext,
                                                                ),
                                                              ],
                                                            ]
                                                            // 견딜수 있어요일시
                                                            else if (endureAns && last== false && end == false) ...[
                                                                if(endure[endureQuestion].toString().contains("\n"))...[
                                                                  SizedBox(height: 28,),
                                                                  Text(
                                                                    endure[endureQuestion],
                                                                    textAlign: TextAlign.center,
                                                                    style: textStyle.bubbletext,
                                                                  ),
                                                                ]else...[
                                                                  SizedBox(height: 42,),
                                                                  Text(
                                                                    endure[endureQuestion],
                                                                    textAlign: TextAlign.center,
                                                                    style: textStyle.bubbletext,
                                                                  ),
                                                                ],
                                                              ]
                                                              // 마지막 질문
                                                              else if (last && end == false) ...[
                                                                  if(lastQuestions[lastQuestion].toString().contains("\n"))...[
                                                                    SizedBox(height: 28,),
                                                                    Text(
                                                                      lastQuestions[lastQuestion],
                                                                      textAlign: TextAlign.center,
                                                                      style: textStyle.bubbletext,
                                                                    ),
                                                                  ]else...[
                                                                    SizedBox(height: 42,),
                                                                    Text(
                                                                      lastQuestions[lastQuestion],
                                                                      textAlign: TextAlign.center,
                                                                      style: textStyle.bubbletext,
                                                                    ),
                                                                  ],
                                                                ]
                                                                // 대화 마무리
                                                                else if (end) ...[
                                                                    if(questionsEnd[endQuestion].toString().contains("\n"))...[
                                                                      SizedBox(height: 28,),
                                                                      Text(
                                                                        questionsEnd[endQuestion],
                                                                        textAlign: TextAlign.center,
                                                                        style: textStyle.bubbletext,
                                                                      ),
                                                                    ]else...[
                                                                      SizedBox(height: 42,),
                                                                      Text(
                                                                        questionsEnd[endQuestion],
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
                                if(startQuestion < 6 || (hardAns && nextQuestion<3) ||(littleAns && nextQuestion<3) ||(goodAns && nextQuestion<3) ||
                                    (sadAns && endQuestion<5) || (endureAns && endQuestion<5) || (end && endQuestion>5))...[
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]
                                  // 현재 상태 묻기
                                else if(startQuestion == 6 && hardAns == false && littleAns == false && goodAns == false )...[
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
                                          SizedBox(height: 528,),
                                          Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left:65, top: 25),
                                              child: Container(
                                                width: 264,
                                                height: 16,
                                                color: Color(0xffC0D2FC),
                                              ),
                                              ),
                                              Padding(padding: EdgeInsets.only(left:28),
                                              child: Row(
                                                children: [
                                                  Column(
                                                      children: [
                                                        InkWell(
                                                          child:
                                                          ui_hard? SvgPicture.asset('assets/images/conversation/middle/hard.svg',):
                                                          SvgPicture.asset('assets/images/conversation/middle/hard_un.svg',),
                                                          onTap: () {
                                                            ui_hard = true;
                                                            ui_little = false;
                                                            ui_good = false;
                                                            setState(() {});
                                                          },
                                                        ),
                                                        SizedBox(height: 8,),
                                                        Text("아파요", style: ui_hard? textStyle.pp2 : textStyle.pp1)
                                                      ],
                                                    ),
                                                    SizedBox(width:68),
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        child: ui_little?
                                                        SvgPicture.asset('assets/images/conversation/middle/little.svg',):
                                                        SvgPicture.asset('assets/images/conversation/middle/little_un.svg',),
                                                        onTap: () {
                                                          ui_hard = false;
                                                          ui_little = true;
                                                          ui_good = false;
                                                          setState(() {});
                                                        },
                                                      ),
                                                      SizedBox(height: 8,),
                                                      Text("조금 아파요", style: ui_little? textStyle.pp2 : textStyle.pp1)
                                                    ],
                                                  ),
                                                  SizedBox(width:68),
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        child: ui_good?
                                                        SvgPicture.asset('assets/images/conversation/middle/good.svg',):
                                                        SvgPicture.asset('assets/images/conversation/middle/good_un.svg',),
                                                        onTap: () {
                                                          ui_hard = false;
                                                          ui_little = false;
                                                          ui_good = true;
                                                          setState(() {});
                                                        },
                                                      ),
                                                      SizedBox(height: 8,),
                                                      Text("좋아요", style: ui_good? textStyle.pp2 : textStyle.pp1)
                                                    ],
                                                  ),

                                                ],
                                              ),

                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]
                                // 슬픔의 정도 묻기
                                else if(nextQuestion == 3 && sadAns == false && endureAns == false)...[
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
                                            SizedBox(height: 528,),
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:65, top: 25),
                                                  child: Container(
                                                    width: 264,
                                                    height: 16,
                                                    color: Color(0xffC0D2FC),
                                                  ),
                                                ),
                                                Padding(padding: EdgeInsets.only(left:28),
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            InkWell(
                                                              child:
                                                              ui_bad? SvgPicture.asset('assets/images/conversation/middle/hard.svg',):
                                                              SvgPicture.asset('assets/images/conversation/middle/hard_un.svg',),
                                                              onTap: () {
                                                                ui_bad = true;
                                                                ui_sad = false;
                                                                ui_endure = false;
                                                                setState(() {});
                                                              },
                                                            ),
                                                            SizedBox(height: 8,),
                                                            Text("고통\n스러워요", style: ui_bad? textStyle.pp2 : textStyle.pp1)
                                                          ],
                                                        ),
                                                        SizedBox(width:68),
                                                        Column(
                                                          children: [
                                                            InkWell(
                                                              child: ui_sad?
                                                              SvgPicture.asset('assets/images/conversation/middle/little.svg',):
                                                              SvgPicture.asset('assets/images/conversation/middle/little_un.svg',),
                                                              onTap: () {
                                                                ui_bad = false;
                                                                ui_sad = true;
                                                                ui_endure = false;
                                                                setState(() {});
                                                              },
                                                            ),
                                                            SizedBox(height: 8,),
                                                            Text("슬퍼요", style: ui_sad? textStyle.pp2 : textStyle.pp1)
                                                          ],
                                                        ),
                                                        SizedBox(width:68),
                                                        Column(
                                                          children: [
                                                            InkWell(
                                                              child: ui_endure?
                                                              SvgPicture.asset('assets/images/conversation/middle/good.svg',):
                                                              SvgPicture.asset('assets/images/conversation/middle/good_un.svg',),
                                                              onTap: () {
                                                                ui_bad = false;
                                                                ui_sad = false;
                                                                ui_endure = true;
                                                                setState(() {});
                                                              },
                                                            ),
                                                            SizedBox(height: 8,),
                                                            Text("견딜 수\n있어요", style: ui_endure? textStyle.pp2 : textStyle.pp1)
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]
                                  else if(end && endQuestion == 5)...[
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
                                                  Container(width: 25,
                                                    child: TextField(
                                                      style: textStyle.inputfield,
                                                      onTap: (){
                                                        chooseTime = true;
                                                        selectedNextTime = true;
                                                        whatTime = int.parse(nextTimeController.text);
                                                        setState(() {
                                                        });
                                                      },
                                                      onChanged: (text){
                                                        whatTime = int.parse(nextTimeController.text);
                                                      },
                                                      keyboardType: TextInputType.number,
                                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                                      controller: nextTimeController,
                                                      decoration: InputDecoration(
                                                        hintText: '몇',
                                                        suffixStyle: TextStyle(color: Color(0xff83A8FF), fontSize: 20,),
                                                        hintStyle: textStyle.field,
                                                        //labelText: '몇',
                                                      ),
                                                    ),),
                                                  Text("시간 후에 만나요", style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                                                ],),
                                              SizedBox(height: 15,),
                                              // DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR[index]['createdAt']))
                                              // DateFormat('MM/dd HH:mm').format(DateTime.now().add(Duration(hours: whatTime)))
                                              Text(chooseTime?"${DateFormat('MM월 dd일 HH시 mm분').format(DateTime.now().add(Duration(hours: whatTime)))}":"최소 1시간에서 24시간 사이로 정해주세요.", style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffAAAAAA)),),

                                            ],),
                                        ),
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
                      if(startQuestion == 6 && (ui_little|| ui_good || ui_hard))...[
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
                                  startQuestion++;
                                  if(ui_hard){
                                    hardAns = true;
                                    player2.setAsset(hardVoice[voiceHardCount]);
                                    voiceHardCount++;
                                    player2.play();

                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 4500), () {
                                      controller1.stop();
                                    });

                                  } else if(ui_little){
                                    littleAns = true;
                                    player2.setAsset(littleVoice[voiceLittleCount]);
                                    voiceLittleCount++;
                                    player2.play();

                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 3500), () {
                                      controller1.stop();
                                    });
                                  } else if(ui_good){
                                    goodAns = true;
                                    player2.setAsset(goodVoice[voiceGoodCount]);
                                    voiceGoodCount++;
                                    player2.play();

                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 2000), () {
                                      controller1.stop();
                                    });
                                  }
                                  //player2.setAsset(voice[voiceCount]);
                                  setState(() {});
                                },
                                child: Text("다음", style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                              ),
                            ),),
                        ),
                      ]
                      else if(nextQuestion == 3 && (ui_bad|| ui_sad || ui_endure))...[
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
                                  if(ui_bad){
                                    sadAns = true;
                                    player2.setAsset(sadVoice[voiceSadCount]);
                                    voiceSadCount++;
                                    player2.play();

                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 3500), () {
                                      controller1.stop();
                                    });

                                  } else if(ui_sad){
                                    sadAns = true;
                                    player2.setAsset(sadVoice[voiceSadCount]);
                                    voiceSadCount++;
                                    player2.play();

                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 3500), () {
                                      controller1.stop();
                                    });

                                  } else if(ui_endure){
                                    endureAns = true;
                                    player2.setAsset(endureVoice[voiceEndureCount]);
                                    voiceEndureCount++;
                                    player2.play();

                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 1500), () {
                                      controller1.stop();
                                    });
                                  }
                                  //player2.setAsset(voice[voiceCount]);
                                  setState(() {});
                                },
                                child: Text("다음", style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                              ),
                            ),),
                        ),
                      ]
                      else if(lastQuestion == 5)...[
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
                                      border: Border.all(color: selectedHow? Color(colorChart.blue):Color(0xffC0D2FC)),
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
                                          hintText: '이별로 어떤 변화를 겪고 있냐면...'),
                                      onChanged: (s) {
                                        selectedHow = true;
                                        setState(() {

                                        });
                                        //text = s;
                                      },
                                      onTap: () {},
                                    ),
                                  ),
                                  Positioned(
                                    left: screenSize.width - 81,
                                    //right: 30,
                                    bottom: 3,
                                    top: 3,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          player2.setAsset(lastVoice[voiceLastCount]);
                                          voiceLastCount++;
                                          player2.play();
                                          controller1.repeat(
                                              min: 0,
                                              max: 30,
                                              period: const Duration(milliseconds: 1000)
                                          );

                                          Timer(Duration(milliseconds: 5000), () {
                                            controller1.stop();
                                          });

                                          lastQuestion++;
                                          setState(() {

                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: selectedHow? Color(colorChart.blue):Color(0xffDDE7FD),
                                          fixedSize: const Size(23, 23),
                                          shape: const CircleBorder(),
                                        ),
                                        child: Icon(
                                          Icons.arrow_upward,
                                          color: Colors.white,
                                          size: 16,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                        else if(endQuestion == 5  && selectedNextTime)...[
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
                                      questionsEnd.insertAll(6, [
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
                          else if(endQuestion == 7)...[
                              Container(
                                color: Color(0xffFFFFFF).withOpacity(0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
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
                                        saveCon(sign_in.userAccessToken, "2A", sentDate);
                                        setState(() {});
                                        main.player.stop();
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

