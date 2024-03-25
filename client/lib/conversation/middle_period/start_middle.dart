import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:client/progressbar/animation_progressbar.dart';
import 'package:client/style.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:just_audio/just_audio.dart';
import 'package:flutter_gif/flutter_gif.dart';

/// 중기대화 시작

class StartMiddlePage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => StartMiddlePage(),
      ),
    );
  }

  @override
  _StartMiddlePageState createState() => _StartMiddlePageState();
}

class _StartMiddlePageState extends State<StartMiddlePage> with TickerProviderStateMixin {

  late FlutterGifController controller1, controller2, controller3;

  bool grief = false; // 이별 선택 시
  bool ui_grief = false;
  bool miss = false; // 전못진 선택 시
  bool ui_miss = false;


  void showToast(){
    Fluttertoast.showToast(
        msg: '화면을 탭하면 다음으로 넘어가요',
        gravity: ToastGravity.BOTTOM,
        textColor: Color(0xff4B5396),
        backgroundColor: Colors.white.withOpacity(0.5),
        toastLength: Toast.LENGTH_SHORT
    );
  }

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    // 음원 적용
    for(int i= 0 ; i < voice.length; i++){
      _player.setAudioSource(AudioSource.uri(
          Uri.parse(voice[i]))
      );
    }
    controller1 = FlutterGifController(vsync: this);

    _callAPI();
    _focusNode.addListener(_onFocusChange);
    showToast();
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

  int nextPage = 0;

  List<String> introText =[];

  int nextQuestion = 0;
  int nextQuestionGrief = 0;
  int nextQuestionMiss = 0;

  // 인트로 사용자 정보 저장하기 (POST)
  void saveUserInfo(String aToken, String nickname, String puppyName, int puppyAge, String puppyType) async {

    // 요청 본문 데이터
    var data = {
      "nickname": nickname,
      "puppyName": puppyName,
      "puppyAge" : puppyAge,
      "puppyType" : puppyType,
      "profile-image" : "null"
    };

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    var url = Uri.parse('http://3.38.1.125:8080/conversation/intro/info'); // 엔드포인트 URL 설정

    try {
      var response = await http.post(
        url,
        body: json.encode(data), // 요청 본문에 데이터를 JSON 형식으로 인코딩하여 전달
        headers: headers, // 헤더 추가
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
        });


        print('API 호출 성공!!: ${response.statusCode}');
      } else {
        // 요청 실패 시의 처리
        print('API 호출 실패!!: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 발생 시의 처리
      print('API 호출 중 예외 발생: $e');
    }
  }

  final _player = AudioPlayer();
  int voiceCount = 0;

  List<dynamic> voice =[
    "assets/voice/start1.mp3", "assets/voice/yes.mp3",
    "assets/voice/no1.mp3", "assets/voice/no2.mp3",
  ];

  List<dynamic> question1_0= [
    "님 기다리고 있었어요!",
    "대화를 시작해볼까요?",
    "오늘은 어떤 주제로 얘기해볼까요?",
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

  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
          color: Color(0xffDDE7FD),
          child: GestureDetector(
            onTap: (){
              // _player.setAsset(voice[voiceCount]);
              if(nextQuestion == 0){
                nextQuestion++;
                _player.setAsset(voice[voiceCount]);
                voiceCount++;
                _player.play();

                // 2.5초 적정
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                Timer(Duration(milliseconds: 2500), () {
                  controller1.stop();
                });
              }
              else if(nextQuestion == 1){
                nextQuestion++; // 인트로 시작 후 count
                _player.setAsset(voice[voiceCount]);
                voiceCount++;
                _player.play();
                // 2.5초 적정
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                Timer(Duration(milliseconds: 2500), () {
                  controller1.stop();
                });
              }
              else if(nextQuestion == 2){

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
                                  currentValue: 20,
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
                                                    if(question1_0[nextQuestion].toString().contains("\n"))...[
                                                      SizedBox(height: 28,),
                                                      Text(
                                                        question1_0[nextQuestion],
                                                        textAlign: TextAlign.center,
                                                        style: textStyle.bubbletext,
                                                      ),
                                                    ]else...[
                                                      SizedBox(height: 42,),
                                                      Text(
                                                        question1_0[nextQuestion],
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
                                if(nextQuestion < 11)...[
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
                                else if(nextQuestion == 16)...[
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
                                          SizedBox(height: 465,),
                                          Row(
                                            children: [
                                              SizedBox(width: 25,),
                                              Container(
                                                width: 156,
                                                height: 156,
                                                child: ElevatedButton(
                                                    style: ui_miss? buttonChart().bluebtn2 : buttonChart().whitebtn,
                                                    onPressed: () {
                                                      //miss = true;
                                                      ui_grief = false;
                                                      if(ui_miss == false){
                                                        ui_miss = true;
                                                      } else{
                                                        ui_miss = false;
                                                      }
                                                      // nextQuestion++;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 15,),
                                                          Text("전하지 못한\n진심", style: TextStyle(fontSize: 16, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 15,),
                                                          Text("전하고픈 진심을\n이야기해요.", style: TextStyle(fontSize: 12, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 5,),
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 55,),
                                                              SvgPicture.asset('assets/images/conversation/intro/miss.svg')
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ),
                                              SizedBox(width: 20,),
                                              Container(
                                                width: 156,
                                                height: 156,
                                                child: ElevatedButton(
                                                    style: ui_grief? buttonChart().bluebtn2 : buttonChart().whitebtn,
                                                    onPressed: () {
                                                      // grief = true;
                                                      ui_miss = false;
                                                      if(ui_grief == false){
                                                        ui_grief = true;
                                                      } else{
                                                        ui_grief = false;
                                                      }
                                                      // nextQuestion++;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 15,),
                                                          Text("슬픔의\n감정", style: TextStyle(fontSize: 16, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 15,),
                                                          Text("이별로 인한\n슬픔을 이야기해요.", style: TextStyle(fontSize: 12, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                          SizedBox(height: 5,),
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 55,),
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ]
                              ],
                            )

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 입력 및 리스트 추가 작업 - 매우 중요
                // // nextQuestion 이 3과 7일때 등장
                bottomSheet: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom * 0.01),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if(nextQuestion == 1)...[
                        Column(
                          children: [
                            ElevatedButton(
                              style: buttonChart().bluebtn3,
                              onPressed: () {
                                nextQuestion++;
                                setState(() {});
                              },
                              child: Text("네 좋아요.", style: textStyle.white16semibold,),
                            ),
                            SizedBox(height: 16,),
                            ElevatedButton(
                              style: buttonChart().bluebtn3,
                              onPressed: () {
                                nextQuestion++;
                                setState(() {});
                              },
                              child: Text("아니요, 아직 시간이 필요해요.", style: textStyle.white16semibold,),
                            ),
                          ],
                        ),

                      ]
                      else if(nextQuestion == 2)...[
                        Container(
                          color: Color(0xffFFFFFF),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Container(
                              width: screenSize.width,
                              height: 40,
                              child: ElevatedButton(
                                style: buttonChart().bluebtn3,
                                onPressed: () {
                                  nextQuestion++;
                                  if(ui_miss){
                                    miss = true;
                                    _player.setAsset(voice[voiceCount]);
                                    voiceCount++;
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => IntroMarkCoachPage()));

                                  }else if (ui_grief){
                                    grief = true;
                                    _player.setAsset(voice[voiceCount]);
                                    voiceCount++;
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => IntroMarkCoachPage()));
                                  }

                                  setState(() {});
                                },
                                child: Text("다음"),
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