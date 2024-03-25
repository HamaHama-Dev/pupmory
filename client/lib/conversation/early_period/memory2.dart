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
import 'package:client/home.dart' as home;
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:client/main.dart'as main;

/// 기억_마무리

AudioPlayer player2 = AudioPlayer();

late FlutterGifController controller1, controller2, controller3;

List<dynamic> voice =[
  "assets/voice/early/memory/memoryhappy1.mp3",
  "assets/voice/early/memory/memoryhappy9.mp3",
  "assets/voice/early/memory/memoryhappy10.mp3",
  "assets/voice/early/memory/memoryhappy11.mp3",
  "assets/voice/intro/intro2_8.mp3",
  "",
  "assets/voice/intro/intro2_9.mp3",
];

class Memory2Page extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => Memory2Page(),
      ),
    );
  }

  @override
  _Memory2PageState createState() => _Memory2PageState();
}

class _Memory2PageState extends State<Memory2Page> with TickerProviderStateMixin {

  bool finish = false; // 메모리얼 및 마무리
  bool selectedNextTime = false;
  bool chooseTime = false;
  int whatTime = 0;

  // 텍스트 에디팅 컨트롤러를 생성하여 필드에 할당
  final nextTimeController = TextEditingController(); // nextQuestion = 7일때


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
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

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

  List<dynamic> questions1_4 =[
    "${home.user}님…",
    "다른 사람들과 함께\n도움을 주고 받으면서",
    "앞으로 ${home.user}님의 마음에\n안정이 찾아오기까지",
    "도움이 되었으면\n하는 바람이에요.",
    "이제 우리가 다시\n만나게 될 시간을 알려주세요.",
    "이제 우리가 다시\n만나게 될 시간을 알려주세요.",
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
          color: Color(0xffFCCBCD),
          child: GestureDetector(
            onTap: (){
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
              print("확인: " + nextQuestion.toString());

              if(nextQuestion <5){
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
                if(nextQuestion == 1){
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 2){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 3){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 4){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }

              }
              else if(nextQuestion == 5){
                //nextQuestion++;
              }
              else if(nextQuestion == 6){
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
              }
              else if(nextQuestion == 7){

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
                body: SingleChildScrollView(
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
                                                    if(questions1_4[nextQuestion].toString().contains("\n"))...[
                                                      SizedBox(height: 28,),
                                                      Text(
                                                        questions1_4[nextQuestion],
                                                        textAlign: TextAlign.center,
                                                        style: textStyle.bubbletext,
                                                      ),

                                                    ]else...[
                                                      SizedBox(height: 42,),
                                                      Text(
                                                        questions1_4[nextQuestion],
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
                                if(nextQuestion < 5 || nextQuestion > 5)...[
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
                                else if(nextQuestion == 5)...[
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
                                                padding: EdgeInsets.only(bottom:16),
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
                                                    contentPadding: EdgeInsets.only(top: 16),
                                                    suffixStyle: TextStyle(color: Color(0xff83A8FF), fontSize: 20,),
                                                    hintStyle: textStyle.field,
                                                    //labelText: '몇',
                                                  ),
                                                ),),
                                              Text("시간 후에 만나요", style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                                            ],),
                                          SizedBox(height: 8,),
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
                  ),),

                // // nextQuestion 이 3과 7일때 등장
                bottomSheet: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom * 0.001),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if(nextQuestion == 5)...[
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
                                    player2.setAsset(voice[voiceCount]);
                                    voiceCount++;
                                    player2.play();

                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 3500), () {
                                      controller1.stop();
                                    });
                                    questions1_4.insertAll(6, [
                                      "네, ${home.user}님.\n${whatTime}시간 후에 다시 만나요!",
                                      "네, ${home.user}님.\n${whatTime}시간 후에 다시 만나요!",
                                    ]);
                                    nextQuestion++;
                                    setState(() {});
                                  },
                                  child: Text("다음", style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                                ),
                              ),),
                          ),
                        ] else if(nextQuestion == 7)...[
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
                                  saveCon(sign_in.userAccessToken, "1A", sentDate);
                                  main.player.stop();
                                  setState(() {});
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
