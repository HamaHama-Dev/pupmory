import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:client/conversation/late_period/late_watch_others.dart';
import 'package:client/screen.dart';
import 'package:http/http.dart' as http;
import 'package:client/progressbar/animation_progressbar.dart';
import 'package:client/sign/sign_in.dart';
import 'package:client/style.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:client/home.dart' as home;
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:client/main.dart'as main;
import 'package:intl/intl.dart';

/// 후기 대화-기억

AudioPlayer player2 = AudioPlayer();

late FlutterGifController controller1, controller2, controller3;
int voiceCount = 0;
List<dynamic> voice =[
  "assets/voice/late/late1.mp3",
  "assets/voice/late/late2.mp3",
  "assets/voice/late/late3.mp3",
  "assets/voice/late/late4.mp3",
  "assets/voice/late/late5.mp3",
  "assets/voice/late/late6.mp3",
  "assets/voice/late/late7.mp3",
  "assets/voice/late/late8.mp3",
  "assets/voice/late/late9.mp3",
  "assets/voice/late/late10.mp3",
  "assets/voice/late/late11.mp3",
  "assets/voice/late/late12.mp3",
  "assets/voice/late/late13.mp3",
  "assets/voice/late/late14.mp3",
  "assets/voice/late/late15.mp3",
  "assets/voice/late/late16.mp3",
  "assets/voice/late/late17.mp3",
  "assets/voice/late/late18.mp3",
  "assets/voice/late/late19.mp3",
  "assets/voice/late/late20.mp3",
  "assets/voice/late/late21.mp3",
  "assets/voice/late/late22.mp3",
  "assets/voice/late/late23.mp3",
  "assets/voice/late/late24.mp3",
  "assets/voice/late/late25.mp3",
  "assets/voice/late/late26.mp3",
  "assets/voice/late/late27.mp3",
  "assets/voice/late/late28.mp3",
  "assets/voice/late/late29.mp3",
  "assets/voice/late/late30.mp3",
  "assets/voice/late/late31.mp3",
  "assets/voice/late/late32.mp3",
  "assets/voice/late/late33.mp3",
  "assets/voice/late/late34.mp3",
];

List<dynamic> endVoice =[
  "assets/voice/intro/intro2_8.mp3",
  "",
  "assets/voice/intro/intro2_9.mp3",
];

List<dynamic> lateConversation =[
  "네, 오늘은 ",  //0
  "${home.puppy}의 빈자리에 대해 얘기해 보아요.", //1
  "${home.puppy}가 곁을 떠난 순간,",  //2
  "감정적인 공백은 \n어딘가에 깊이 남아있을 거예요.", //3
  "하지만 그 감정을 다르게 받아들이고,", //4
  "${home.puppy}와 함께한\n순간들을 생각해본다면", //5
  "감정적인 공백이 채워질 거예요.", //6
  "${home.puppy}가 없는 삶에서", //7
  "${home.user}님은\n어떤 경험을 했나요? ", //8
  "네, 그렇군요. ", //9
  "앞선 경험들을 통해서\n${home.user}님에게", // 10
  "어떤 변화가 생겼을까요?", //11
  "${home.user}님에게\n그런 변화가 있었군요.", //12
  "그렇다면 그런 변화들을 마주하고", //13
  "즐거웠던 순간들이 있나요?", //14
  "일상 속에서 ${home.user}님을 괴롭히는", //15
  "복잡한 생각들을 정리하기 위해서\n어떤 행동을 하는지", //16
  "공간, 시간, 행동, 관계로 나누어\n생각해보아요.", //17
  "어느 곳에서 생각을 정리했나요?", //18
  "주로 언제 생각을 정리했나요?", //19
  "무엇을 하며 생각을 정리했나요?", //20
  "누구와 생각을 정리했나요?", //21
  "그렇군요.", //22
  "힘든 상황에서 사람들과 소통하고\n교류하는 건 중요해요.", //23
  "언제나 ${home.user}님 곁에\n친구와 가족이 있고,", //24
  "그분들은 ${home.user}님을\n지지하고 기다리고 있어요.", //25
  "‘함께할게’에서\n위로의 말을 주고 받으며", //26
  "함께 감정을 나눠보아요.", // 27
  "${home.user}님,\n${home.puppy}와 함께한 순간들은", //28
  "더 없이 특별하고 값진 경험이지만,", //29
  "${home.puppy}가\n없는 삶에서도", //30
  "새로운 경험을 찾아나가며\n행복을 만들어갈 수 있어요.", //31
  "그리고 이 과정에서\n더욱 더 나 자신을 이해하고", //32
  "발전시킬 수 있다는 것도\n알게 되었으면 좋겠어요.", //33
];

List<dynamic> questionsEnd =[
  "자, 이제 우리가 다시\n만나게 될 시간을 알려주세요.",
  "자, 이제 우리가 다시\n만나게 될 시간을 알려주세요.",
];

class LatePage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => LatePage(),
      ),
    );
  }

  @override
  _LatePageState createState() => _LatePageState();
}

class _LatePageState extends State<LatePage> with TickerProviderStateMixin {

  bool end = false; // 대화 마무리 단계 진입

  int nextQuestion = 0;
  int nextEnd = 0;

  int voiceEndCount = 0;

  bool selectedNextTime = false;
  bool chooseTime = false;
  int whatTime = 0;

  bool exp = false;
  bool change = false;
  bool joy = false;
  bool where = false;
  bool when = false;
  bool what = false;
  bool who = false;

  // 텍스트 에디팅 컨트롤러를 생성하여 필드에 할당
  final expController = TextEditingController(); // nextQuestion = 15일때
  final changeController = TextEditingController(); // nextQuestion = 19일때
  final joyController = TextEditingController(); // nextQuestion = 20일때
  final whereController = TextEditingController(); // nextQuestion = 21일때
  final whenController = TextEditingController(); // nextQuestion = 12일때
  final whatController = TextEditingController(); // nextQuestion = 12일때
  final whoController = TextEditingController(); // nextQuestion = 12일때

  final nextTimeController = TextEditingController(); // nextQuestion = 12일때


  FocusNode _focusNode = FocusNode();

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
    main.player.setAsset(main.musics[3]);
    main.player.play();

    voiceCount = 0;

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
          color: Color(0xffCEEEE9),
          child: GestureDetector(
            onTap: (){
              print("이거만 좀 확인 부탁: " + nextQuestion.toString());

              if(nextQuestion < 8){
                nextQuestion++;
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
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 3){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 4){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 5){
                  Timer(Duration(milliseconds: 3500), () {
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
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 8){
               // ${home.user}님은 어떤 경험을 했나요?
              }
              else if(nextQuestion > 8 && nextQuestion<11){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextQuestion == 10){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                  } else if(nextQuestion == 11){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 11){
                // 어떤 변화가 생겼나요
              }
              else if(nextQuestion > 11 && nextQuestion<14){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextQuestion == 13){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 14){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 14){
                // 어떤 변화가 생겼나요
              }
              else if(nextQuestion > 14 && nextQuestion<18){
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
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 17){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 18){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 18){
                // 어느 곳에서 생각
              }
              else if(nextQuestion == 19){
                // 주로 언제 생각
              }
              else if(nextQuestion == 20){
                // 무엇을 하며 생각
              }
              else if(nextQuestion == 21){
                // 누구와 생각
              }
              else if(nextQuestion > 21 && nextQuestion<27){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextQuestion == 23){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 24){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 25){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 26){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 27){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 27){
                // 함께 감정을 나눠보아요
              }
              else if(nextQuestion > 27 && nextQuestion < 33){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextQuestion == 29){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 30){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 31){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 32){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 33){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 33 && end == false){
                // 함께 감정을 나눠보아요
                end = true;
                // nextEnd++;
                player2.setAsset(endVoice[voiceEndCount]);
                voiceEndCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                Timer(Duration(milliseconds: 3500), () {
                  controller1.stop();
                });
              }
              else if(end && nextEnd <1){
                nextEnd++;
                voiceEndCount++;
                print("test");
              }

              else if(end && nextEnd == 1){
                // 시간 고르기
                print("설마 여기>>?");
              }
              else if(end && nextEnd == 2){
                nextEnd++;
                player2.setAsset(endVoice[voiceEndCount]);
                voiceEndCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                Timer(Duration(milliseconds: 3000), () {
                  controller1.stop();
                });
              }
              else if(end && nextEnd == 3){
                // 하단 버튼
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
                                  currentValue: 80,
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
                                                    if(end == false)...[
                                                      if(lateConversation[nextQuestion].toString().contains("\n"))...[
                                                        SizedBox(height: 28,),
                                                        Text(
                                                          lateConversation[nextQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ]else...[
                                                        SizedBox(height: 42,),
                                                        Text(
                                                          lateConversation[nextQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ],
                                                    ]
                                                      else if(end)...[
                                                      if(questionsEnd[nextEnd].toString().contains("\n"))...[
                                                        SizedBox(height: 28,),
                                                        Text(
                                                          questionsEnd[nextEnd],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ]else...[
                                                        SizedBox(height: 42,),
                                                        Text(
                                                          questionsEnd[nextEnd],
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
                                if( (nextQuestion<34 && end == false) || (end && nextEnd == 0)||(end && nextEnd > 1))...[
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
                                else if(end && nextEnd == 1)...[
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
                                                        whatTime = int.parse(nextTimeController.text);
                                                        setState(() {
                                                        });
                                                      },
                                                      onChanged: (text){
                                                        selectedNextTime = true;
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
                      if(nextQuestion == 27)...[
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
                                  nextQuestion++;
                                  voiceCount++;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LateWatchOthersPage()));
                                  setState(() {});
                                },
                                child: Text("함께할개 확인하기", style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                              ),
                            ),),
                        ),
                      ]
                        else if (nextQuestion == 8)...[
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
                                        border: Border.all(color:exp? Color(colorChart.blue):Color(0xffC0D2FC)),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    Positioned(
                                      left: 15,
                                      right: 30,
                                      bottom: -4,
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        maxLines: 1,
                                        controller: expController,
                                        style: textStyle.bk14normal,
                                        decoration: InputDecoration(
                                            hintStyle: textStyle.grey14normal,
                                            border: InputBorder.none,
                                            hintText: '이별 후 어떤 경험을 했냐면...'),
                                        onChanged: (s) {
                                          //text = s;
                                          exp = true;
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
                                            if(exp){
                                              player2.setAsset(voice[voiceCount]);
                                              voiceCount++;
                                              player2.play();

                                              controller1.repeat(
                                                  min: 0,
                                                  max: 20,
                                                  period: const Duration(milliseconds: 1000)
                                              );

                                              Timer(Duration(milliseconds: 1500), () {
                                                controller1.stop();
                                              });
                                              nextQuestion++;
                                              setState(() {
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: exp? Color(colorChart.blue):Color(0xffDDE7FD),
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
                            )

                          ]
                      else if (nextQuestion == 11)...[
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
                                      border: Border.all(color:change? Color(colorChart.blue):Color(0xffC0D2FC)),
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
                                      controller: changeController,
                                      style: textStyle.bk14normal,
                                      decoration: InputDecoration(
                                          hintStyle: textStyle.grey14normal,
                                          border: InputBorder.none,
                                          hintText: '이 경험을 통해 어떤 변화가 생겼냐면...'),
                                      onChanged: (s) {
                                        //text = s;
                                        change = true;
                                        setState(() {

                                        });
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
                                          if(change){
                                            player2.setAsset(voice[voiceCount]);
                                            voiceCount++;
                                            player2.play();

                                            controller1.repeat(
                                                min: 0,
                                                max: 20,
                                                period: const Duration(milliseconds: 1000)
                                            );

                                            Timer(Duration(milliseconds: 3000), () {
                                              controller1.stop();
                                            });
                                            nextQuestion++;
                                            setState(() {
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: change?Color(colorChart.blue):Color(0xffDDE7FD),
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
                          )

                        ]
                        else if (nextQuestion == 14)...[
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
                                        border: Border.all(color: joy? Color(colorChart.blue):Color(0xffC0D2FC)),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    Positioned(
                                      left: 15,
                                      right: 30,
                                      bottom: -4,
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        maxLines: 1,
                                        controller: joyController,
                                        style: textStyle.bk14normal,
                                        decoration: InputDecoration(
                                            hintStyle: textStyle.grey14normal,
                                            border: InputBorder.none,
                                            hintText: '변화를 마주하고 즐거운 순간이라면...'),
                                        onChanged: (s) {
                                          //text = s;
                                          joy = true;
                                          setState(() {

                                          });
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
                                            if(joy){
                                              player2.setAsset(voice[voiceCount]);
                                              voiceCount++;
                                              player2.play();

                                              controller1.repeat(
                                                  min: 0,
                                                  max: 20,
                                                  period: const Duration(milliseconds: 1000)
                                              );

                                              Timer(Duration(milliseconds: 3000), () {
                                                controller1.stop();
                                              });
                                              nextQuestion++;
                                              setState(() {
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: joy?Color(colorChart.blue):Color(0xffDDE7FD),
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
                            )

                          ]
                          else if (nextQuestion == 18)...[
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
                                          border: Border.all(color: where? Color(colorChart.blue):Color(0xffC0D2FC)),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      Positioned(
                                        left: 14,
                                        right: 30,
                                        bottom: -4,
                                        child: TextField(
                                          textAlignVertical: TextAlignVertical.center,
                                          maxLines: 1,
                                          controller: whereController,
                                          style: textStyle.bk14normal,
                                          decoration: InputDecoration(
                                              hintStyle: textStyle.grey14normal,
                                              border: InputBorder.none,
                                              hintText: '어디에서 생각을 정리하냐면...'),
                                          onChanged: (s) {
                                            //text = s;
                                            where = true;
                                            setState(() {

                                            });
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
                                              if(where){
                                                player2.setAsset(voice[voiceCount]);
                                                voiceCount++;
                                                player2.play();

                                                controller1.repeat(
                                                    min: 0,
                                                    max: 20,
                                                    period: const Duration(milliseconds: 1000)
                                                );

                                                Timer(Duration(milliseconds: 3000), () {
                                                  controller1.stop();
                                                });
                                                nextQuestion++;
                                                setState(() {
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: where?Color(colorChart.blue):Color(0xffDDE7FD),
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
                              )

                            ]
                            else if (nextQuestion == 19)...[
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
                                            border: Border.all(color: when? Color(colorChart.blue):Color(0xffC0D2FC)),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        Positioned(
                                          left: 15,
                                          right: 30,
                                          bottom: -4,
                                          child: TextField(
                                            textAlignVertical: TextAlignVertical.center,
                                            maxLines: 1,
                                            controller: whenController,
                                            style: textStyle.bk14normal,
                                            decoration: InputDecoration(
                                                hintStyle: textStyle.grey14normal,
                                                border: InputBorder.none,
                                                hintText: '언제 생각을 정리하냐면...'),
                                            onChanged: (s) {
                                              //text = s;
                                              when = true;
                                              setState(() {

                                              });
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
                                                if(when){
                                                  player2.setAsset(voice[voiceCount]);
                                                  voiceCount++;
                                                  player2.play();

                                                  controller1.repeat(
                                                      min: 0,
                                                      max: 20,
                                                      period: const Duration(milliseconds: 1000)
                                                  );

                                                  Timer(Duration(milliseconds: 3000), () {
                                                    controller1.stop();
                                                  });
                                                  nextQuestion++;
                                                  setState(() {
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: when? Color(colorChart.blue):Color(0xffDDE7FD),
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
                                )

                              ]
                              else if (nextQuestion == 20)...[
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
                                              border: Border.all(color: what? Color(colorChart.blue):Color(0xffC0D2FC)),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                          ),
                                          Positioned(
                                            left: 15,
                                            right: 30,
                                            bottom: -4,
                                            child: TextField(
                                              textAlignVertical: TextAlignVertical.center,
                                              maxLines: 1,
                                              controller: whatController,
                                              style: textStyle.bk14normal,
                                              decoration: InputDecoration(
                                                  hintStyle: textStyle.grey14normal,
                                                  border: InputBorder.none,
                                                  hintText: '뭘 하면서 생각을 정리하냐면...'),
                                              onChanged: (s) {
                                                //text = s;
                                                what = true;
                                                setState(() {

                                                });
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
                                                  if(what){
                                                    player2.setAsset(voice[voiceCount]);
                                                    voiceCount++;
                                                    player2.play();

                                                    controller1.repeat(
                                                        min: 0,
                                                        max: 20,
                                                        period: const Duration(milliseconds: 1000)
                                                    );

                                                    Timer(Duration(milliseconds: 3000), () {
                                                      controller1.stop();
                                                    });
                                                    nextQuestion++;
                                                    setState(() {
                                                    });
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: what?Color(colorChart.blue):Color(0xffC0D2FC),
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
                                  )

                                ]
                                else if (nextQuestion == 21)...[
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
                                                border: Border.all(color: Color(colorChart.blue)),
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
                                                controller: whoController,
                                                style: textStyle.bk14normal,
                                                decoration: InputDecoration(
                                                    hintStyle: textStyle.grey14normal,
                                                    border: InputBorder.none,
                                                    hintText: '누구와 생각을 정리하냐면...'),
                                                onChanged: (s) {
                                                  //text = s;
                                                  who = true;
                                                  setState(() {

                                                  });
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
                                                    if(who){
                                                      player2.setAsset(voice[voiceCount]);
                                                      voiceCount++;
                                                      player2.play();

                                                      controller1.repeat(
                                                          min: 0,
                                                          max: 20,
                                                          period: const Duration(milliseconds: 1000)
                                                      );

                                                      Timer(Duration(milliseconds: 1500), () {
                                                        controller1.stop();
                                                      });
                                                      nextQuestion++;
                                                      setState(() {
                                                      });
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: who?Color(colorChart.blue):Color(0xffDDE7FD),
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
                                    )

                                  ]

                            else if(nextEnd == 1  && selectedNextTime)...[
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
                                          nextEnd++;
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
                              else if(nextEnd == 3)...[
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
                                            //checkSignUp = false;
                                            var now = DateTime.now();
                                            sentDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now.toLocal());
                                            saveCon(sign_in.userAccessToken, "3", sentDate);
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
                )
            ),
          )

      );

  }
}