import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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

/// 초기대화-기억

AudioPlayer player2 = AudioPlayer();

late FlutterGifController controller1, controller2, controller3;

List<dynamic> voice =[
  "assets/voice/early/farewell/farewell1.mp3",
  "assets/voice/early/farewell/farewell2.mp3",
  "assets/voice/early/farewell/farewell_modi.mp3",
  "assets/voice/early/farewell/farewell4.mp3",
  "assets/voice/early/farewell/farewell5.mp3",
  "assets/voice/early/farewell/farewell6.mp3",
  "",
  "assets/voice/early/farewell/farewell7.mp3",
  "assets/voice/early/farewell/farewell8.mp3",
  "assets/voice/early/farewell/farewell9.mp3",
  "",
  "assets/voice/early/farewell/farewell10.mp3",
  "assets/voice/early/farewell/farewell11.mp3",
  "assets/voice/early/farewell/farewell12.mp3",
];

List<dynamic> yesVoice =[
  "assets/voice/early/farewell/regyes1.mp3",
  "assets/voice/early/farewell/regyes2.mp3",
  "assets/voice/early/farewell/regyes3.mp3",
  "assets/voice/early/farewell/regyes4.mp3",
  "assets/voice/early/farewell/regyes5.mp3",
  "assets/voice/early/farewell/regyes6.mp3",
  "assets/voice/early/farewell/regyes7.mp3",
  "assets/voice/early/farewell/regyes8.mp3",
  "assets/voice/early/farewell/regyes9.mp3",
];

List<dynamic> noVoice =[
  "assets/voice/early/farewell/regno1.mp3",
  "assets/voice/early/farewell/regno2.mp3",
  "assets/voice/early/farewell/regno3.mp3",
  "assets/voice/early/farewell/regno4.mp3",
  "assets/voice/early/farewell/regno5.mp3",
  "assets/voice/early/farewell/regno6.mp3",
  "assets/voice/early/farewell/regno7.mp3",
  "assets/voice/early/farewell/regno8.mp3",
  "assets/voice/early/farewell/regno9.mp3",
  "assets/voice/early/farewell/regno10.mp3",
  "assets/voice/early/farewell/regno11.mp3",
  "assets/voice/early/farewell/regno12.mp3",
];

List<dynamic> endVoice =[
  "assets/voice/early/farewell/endfarewell1.mp3",
  "assets/voice/early/farewell/endfarewell2.mp3",
  "assets/voice/early/farewell/endfarewell3.mp3",
  "assets/voice/intro/intro2_8.mp3",
  "",
  "assets/voice/intro/intro2_9.mp3",
];


class FarewellPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => FarewellPage(),
      ),
    );
  }

  @override
  _FarewellPageState createState() => _FarewellPageState();
}

class _FarewellPageState extends State<FarewellPage> with TickerProviderStateMixin {

  bool yes = false; // 후회함 -> 네 선택
  bool ui_yes = false;
  bool no = false; //후회함 -> 아니오 선택
  bool ui_no = false;

  bool end = false; // 대화 마무리 단계 진입

  int nextEnd = 0;

  int nextYes = 0;
  int nextNo = 0;

  bool finish = false; // 메모리얼 및 마무리

  bool selectedWeather = false;
  bool chooseWeather = false;
  String whatWeather = "";

  bool selectedLocate = false;
  bool chooseLocate = false;
  String whatLocate = "";

  bool selectedHow = false;
  bool chooseHow = false;
  String whatHow = "";

  bool selectedNextTime = false;
  bool chooseTime = false;
  int whatTime = 0;

  // 텍스트 에디팅 컨트롤러를 생성하여 필드에 할당
  final weatherController = TextEditingController(); // nextQuestion = 7일때
  final nextTimeController = TextEditingController(); // nextQuestion = 7일때
  final locateController = TextEditingController(); // nextQuestion = 7일때
  final regretController = TextEditingController(); // nextQuestion = 7일때
  final wantController = TextEditingController(); // nextQuestion = 7일때
  final emotionController = TextEditingController(); // nextQuestion = 7일때

  bool selectRegret = false;
  bool selectWant = false;

  List<dynamic> questions0 =[
    "좋아요, ${home.user}님.", //0
    "오늘은 ${home.puppy}와의\n이별에 대해서 얘기해보도록 해요.", //1
    "만남이 있으면 이별이 있듯이\n이별의 순간은 결국 찾아와요. ", //2
    "조금 힘들더라도\n이별의 순간을 떠올리며", //3
    "${home.user}님의 감정들을\n같이 정리해보아요.", //4
    "이별의 순간,\n그날의 날씨는 어땠나요?", //5
    "이별의 순간,\n그날의 날씨는 어땠나요?", //6

    // "아이와의 이별의 순간은\n() 날이었군요.", //7
    //
    // "우리 보호자님과\n아이는", //8
    // "어떤 장소에 있었나요? ", //9
    // "어떤 장소에 있었나요? ", //10
    //
    // "그렇군요", //11
    // "()에서", //12
    //
    // "아이와 이별하는\n순간을 떠올리며 후회되는 부분이 있나요?", //13
  ];
// 네 선택시
  List<dynamic> questionYes= [
    "어떤 부분이 후회가 되나요?",
    "${home.user}님의 얘기를 들어보니",
    "${home.puppy}를 향한 그리움, 후회…",
    "그 외에도\n다양한 감정들이 느껴지는 것 같아요.",
    "이별의 순간은 지나가더라도",
    "${home.puppy}를 그리워하는 마음은\n커져만 가니 그런 것 같아요.",
    "그래도 ${home.user}님이\n${home.puppy}를 추억할 수 있게",
    "‘기억할개’에서 ${home.puppy}와의\n추억을 저장해보는 것도",
    "그리운 마음을 달래는데\n도움이 될 것 같아요.",
  ];

// 아니오 선택시
  List<dynamic> questionNo =[
    "그렇다면, 다행이에요.",
    "이별의 순간이 지나고\n후회가 남을 수 있지만,",
    "후회가 남지 않았다면\n그것도 정말 대단한 일이라고 생각해요.",
    "${home.user}님.\n만약 ${home.puppy}와의",
    "이별의 순간으로 다시 돌아간다면\n하고 싶은 것들이 있을까요?",
    "${home.user}님은\n이별의 순간을 잘 보내신 것 같아요.",
    "그 순간에 ${home.puppy}도",
    "${home.user}님의 마음을\n온전히 느꼈을거예요.",
    "그럼에도 ${home.puppy}를 향한\n그리운 마음은",
    "여전하게 남아있지 않을까 싶어요.",
    "‘기억할개’에서 ${home.puppy}와의\n추억을 저장해보면",
    "그리운 마음을 달래는데\n 도움이 될 것 같아요.",

  ];

  List<dynamic> questionsEnd =[
    "${home.user}님,\n제가 준비한 대화는 여기까지에요. ",
    "${home.puppy}와\n이별의 순간을 기억하며 ",
    "풀지 못한 ${home.user}님의\n감정들이 풀어졌으면 하는 바람이에요.",
    "자, 이제 우리가 다시\n만나게 될 시간을 알려주세요.",
    "자, 이제 우리가 다시\n만나게 될 시간을 알려주세요.",
    // "네, ${home.user}님.\n()시간 후에 다시 만나요!",
    // "네, ${home.user}님.\n()시간 후에 다시 만나요!",
  ];

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
  int nextQuestion = 0;
  int voiceCount = 0;

  int voiceNoCount = 0;
  int voiceYesCount = 0;

  int voiceEndCount = 0;


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
          color: Color(0xffFCCBCD),
          child: GestureDetector(
            onTap: (){
              print("이거만 좀 확인 부탁: " + nextQuestion.toString());

              if(nextQuestion < 6){
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
                  Timer(Duration(milliseconds: 5500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 3){
                  Timer(Duration(milliseconds: 4000), () {
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
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 6){
                // 어떤 날씨?
              }
              else if(nextQuestion>6 && nextQuestion<10){
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
                if(nextQuestion == 8){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 9){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 10){
                // 어디서 있었는지?
              }
              else if(nextQuestion >10 && nextQuestion <13){
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
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 13){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 13){
                // 후회되는 부분?
              }
              // 여기서 부터 후회에 대해서
              else if(yes && nextYes == 0){

              }
              else if(yes && (nextYes > 0 && nextYes < 8) ){
                nextYes++;
                player2.setAsset(yesVoice[voiceYesCount]);
                voiceYesCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );

                if(nextYes == 2){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextYes == 3){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextYes == 4){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextYes == 5){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                }
                else if(nextYes == 6){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextYes == 7){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextYes == 8){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
              }
              else if(no && nextNo < 4){
                nextNo++;
                player2.setAsset(noVoice[voiceNoCount]);
                voiceNoCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextNo == 1){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextNo == 2){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                }
                else if(nextNo == 3){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextNo == 4){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                }
              }
              else if(no && nextNo == 4){
              }
              else if(no && (nextNo > 4 && nextNo < 11)){
                nextNo++;
                player2.setAsset(noVoice[voiceNoCount]);
                voiceNoCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextNo == 6){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                }
                else if(nextNo == 7){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextNo == 8){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextNo == 9){
                  Timer(Duration(milliseconds: 2000), () {
                    controller1.stop();
                  });
                }
                else if(nextNo == 10){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextNo == 11){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
              }
              else if(yes && nextYes == 8){
                nextYes++;
                end = true;
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
              else if(no && nextNo == 11){
                nextNo++;
                end = true;
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
              else if(end && nextEnd < 4){
                nextEnd++;
                player2.setAsset(endVoice[voiceEndCount]);
                voiceEndCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextEnd == 1){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextEnd == 2){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                }
                else if(nextEnd == 3){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
              }
              else if(end && nextEnd == 4){
                //  언제 만날까요
              }
              else if(end && (nextEnd < 6 && nextEnd >4)){
                nextEnd++;
                player2.setAsset(endVoice[voiceEndCount]);
                voiceEndCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextEnd == 6){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
              }
              else if(end && nextEnd == 6){
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
                                                        if(yes == false && no == false)...[
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
                                                        // 후회 네
                                                        else if (yes && end == false) ...[
                                                          if(questionYes[nextYes].toString().contains("\n"))...[
                                                            SizedBox(height: 28,),
                                                            Text(
                                                              questionYes[nextYes],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ]else...[
                                                            SizedBox(height: 42,),
                                                            Text(
                                                              questionYes[nextYes],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ],
                                                          // 후회 아니오
                                                        ] else if (no && end == false) ...[
                                                          if(questionNo[nextNo].toString().contains("\n"))...[
                                                            SizedBox(height: 28,),
                                                            Text(
                                                              questionNo[nextNo],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ]else...[
                                                            SizedBox(height: 42,),
                                                            Text(
                                                              questionNo[nextNo],
                                                              textAlign: TextAlign.center,
                                                              style: textStyle.bubbletext,
                                                            ),
                                                          ],
                                                        ] else if(end)...[
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
                                    if(nextQuestion < 6 || (nextQuestion>6 && nextQuestion<10) || (nextQuestion > 10 && nextQuestion < 13))...[
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
                                    else if(nextQuestion == 6)...[
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
                                                  Container(width: containerWidth1,
                                                    child: TextField(
                                                      style: textStyle.inputfield,
                                                      onTap: (){
                                                        chooseWeather = true;
                                                        whatWeather = weatherController.text;
                                                        setState(() {
                                                        });
                                                      },
                                                      onChanged: (text){
                                                        updateContainerWidth1();
                                                        selectedWeather = true;
                                                        whatWeather = weatherController.text;
                                                      },
                                                      controller: weatherController,
                                                      decoration: InputDecoration(
                                                        hintText: '어떤',
                                                        suffixStyle: TextStyle(color: Color(0xff83A8FF), fontSize: 20,),
                                                        hintStyle: textStyle.field,
                                                        counterText:'',
                                                      ),
                                                      maxLength: 10,
                                                    ),),
                                                  Text("날씨였어요.", style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                                                ],),
                                              SizedBox(height: 15,),
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
                                                          suffixStyle: TextStyle(color: Color(0xff83A8FF), fontSize: 20,),
                                                          hintStyle: textStyle.field,
                                                          counterText:'',
                                                        ),
                                                        maxLength: 10,
                                                      ),),
                                                    Text("에 있었어요.", style: TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                                                  ],),
                                                SizedBox(height: 15,),
                                                // DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR[index]['createdAt']))
                                                // DateFormat('MM/dd HH:mm').format(DateTime.now().add(Duration(hours: whatTime)))
                                                Text("10자 이내", style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffAAAAAA)),),

                                              ],),
                                          ),
                                        ),
                                      ]
                                      else if(nextQuestion == 13)...[
                                          Stack(
                                            children: [

                                              Column(
                                                children: [
                                                  SizedBox(height: 418,),
                                                  Container(
                                                    height: 280,
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

                                                    // SvgPicture.asset(
                                                    //   'assets/images/conversation/con_muji.svg', fit: BoxFit.cover,
                                                    // ),
                                                  ),
                                                ],
                                              ),

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 444,),
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 16,),
                                                      Container(
                                                        width: 168,
                                                        height: 168,
                                                        child: ElevatedButton(
                                                            style: ui_yes? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                            onPressed: () {
                                                              //miss = true;
                                                              ui_no = false;
                                                              if(ui_yes == false){
                                                                ui_yes = true;
                                                              } else{
                                                                ui_yes = false;
                                                              }
                                                              // nextQuestion++;
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(height: 16,),
                                                                  Text("네,\n있어요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_yes? Color(0xff333333) : Color(0xff4B5396)),),
                                                                  SizedBox(height: 16,),
                                                                  Text("후회되는\n부분이 있어요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_yes? Color(0xff333333) : Color(0xff4B5396)),),
                                                                  SizedBox(height: 3,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 76,),
                                                                      SvgPicture.asset('assets/images/conversation/early/yes.svg')
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
                                                            style: ui_no? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                            onPressed: () {
                                                              // grief = true;
                                                              ui_yes = false;
                                                              if(ui_no == false){
                                                                ui_no = true;
                                                              } else{
                                                                ui_no = false;
                                                              }
                                                              // nextQuestion++;
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(height: 16,),
                                                                  Text("아니요,\n없는것 같아요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_no? Color(0xff333333) : Color(0xff4B5396)),),
                                                                  SizedBox(height: 16,),
                                                                  Text("후회되는 부분이\n없는 것 같아요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_no? Color(0xff333333) : Color(0xff4B5396)),),
                                                                  SizedBox(height: 3,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 76,),
                                                                      SvgPicture.asset('assets/images/conversation/early/no.svg')
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
                                        ] else if((yes && nextYes < 9) || (no && nextNo < 12) || (end && nextEnd < 4) || (end && nextEnd > 4 && nextEnd < 7))...[
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
                                        ] else if(end && nextEnd == 4)...[
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
                      if(nextQuestion == 6 && selectedWeather)...[
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
                                  questions0.insertAll(7, [
                                    "${home.puppy}와의 이별의 순간은\n${whatWeather}날이었군요.", //7
                                    "우리 ${home.user}님과\n${home.puppy}는", //8
                                    "어떤 장소에 있었나요? ", //9
                                    "어떤 장소에 있었나요? ", //10
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
                                  Timer(Duration(milliseconds: 4000), () {
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
                                  questions0.insertAll(11, [
                                    "그렇군요.", //11
                                    "${whatWeather}날\n${whatLocate}에서", //12
                                    "${home.puppy}와 이별하는\n순간을 떠올리며 후회되는 부분이 있나요?", //13
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
                                  setState(() {});
                                },
                                child: Text("다음", style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                              ),
                            ),),
                        ),
                      ]
                      else if(nextQuestion == 13 && (ui_no || ui_yes))...[
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
                                    if(ui_yes){
                                      yes = true;
                                      player2.setAsset(yesVoice[voiceYesCount]);
                                      voiceYesCount++;
                                      controller1.repeat(
                                          min: 0,
                                          max: 30,
                                          period: const Duration(milliseconds: 1000)
                                      );
                                      Timer(Duration(milliseconds: 2000), () {
                                        controller1.stop();
                                      });
                                    }else if (ui_no){
                                      no = true;
                                      player2.setAsset(noVoice[voiceNoCount]);
                                      voiceNoCount++;
                                      controller1.repeat(
                                          min: 0,
                                          max: 30,
                                          period: const Duration(milliseconds: 1000)
                                      );
                                      Timer(Duration(milliseconds: 2000), () {
                                        controller1.stop();
                                      });
                                    }

                                    setState(() {});
                                  },
                                  child: Text("다음"),
                                ),
                              ),),
                          ),
                        ]
                        else if (yes && nextYes == 0)...[
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
                                      border: Border.all(color: selectRegret?Color(colorChart.blue):Color(0xffDDE7FD),),
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
                                      controller: regretController,
                                      style: textStyle.bk14normal,
                                      decoration: InputDecoration(
                                          hintStyle: textStyle.grey14normal,
                                          border: InputBorder.none,
                                          hintText: '무엇이 후회되냐면...'),
                                      onChanged: (s) {
                                        //text = s;
                                        selectRegret = true;
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
                                          if(selectRegret){
                                            player2.setAsset(yesVoice[voiceYesCount]);
                                            voiceYesCount++;
                                            player2.play();

                                            controller1.repeat(
                                                min: 0,
                                                max: 20,
                                                period: const Duration(milliseconds: 1000)
                                            );

                                            Timer(Duration(milliseconds: 3000), () {
                                              controller1.stop();
                                            });

                                            nextYes++;
                                            setState(() {

                                            });
                                          }

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: selectRegret? Color(colorChart.blue):Color(0xffDDE7FD),
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
                          else if (no && nextNo == 4)...[
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
                                        border: Border.all(color: selectWant?Color(colorChart.blue):Color(0xffC0D2FC)),
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
                                        controller: regretController,
                                        style: textStyle.bk14normal,
                                        decoration: InputDecoration(
                                            hintStyle: textStyle.grey14normal,
                                            border: InputBorder.none,
                                            hintText: '어떤 행동이나 말을 하고싶냐면...'),
                                        onChanged: (s) {
                                          //text = s;
                                          selectWant = true;
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
                                            if(selectWant){
                                              player2.setAsset(noVoice[voiceNoCount]);
                                              voiceNoCount++;
                                              player2.play();

                                              controller1.repeat(
                                                  min: 0,
                                                  max: 20,
                                                  period: const Duration(milliseconds: 1000)
                                              );

                                              Timer(Duration(milliseconds: 4000), () {
                                                controller1.stop();
                                              });

                                              nextNo++;
                                              setState(() {

                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: selectWant? Color(colorChart.blue):Color(0xffDDE7FD),
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
                            else if(nextEnd == 4  && selectedNextTime)...[
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
                                          questionsEnd.insertAll(5, [
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
                              else if(nextEnd == 6)...[
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
                                            saveCon(sign_in.userAccessToken, "1B", sentDate);

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

