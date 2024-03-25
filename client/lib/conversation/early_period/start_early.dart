import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:client/conversation/early_period/memory.dart';
import 'package:client/conversation/end_period/end.dart';
import 'package:client/conversation/late_period/late.dart';
import 'package:client/conversation/middle_period/the_truth_untold.dart';
import 'package:client/progressbar/animation_progressbar.dart';
import 'package:client/screen.dart';
import 'package:client/style.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:just_audio/just_audio.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:client/home.dart' as home;
import '../middle_period/sadness.dart';
import 'farewell.dart';
/// 대화 시작

String backColor = "";
double perc = 0;

class StartEarlyPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => StartEarlyPage(),
      ),
    );
  }

  @override
  _StartEarlyPageState createState() => _StartEarlyPageState();
}

class _StartEarlyPageState extends State<StartEarlyPage> with TickerProviderStateMixin {

  late FlutterGifController controller1, controller2, controller3;

  bool grief = false; // 이별 선택 시
  bool ui_grief = false;
  bool miss = false; // 전못진 선택 시
  bool ui_miss = false;

  bool no = false;
  bool yes = false;

  // 초기
  bool early = false;
  bool memory = false;
  bool ui_memory = false;
  bool farewell = false;
  bool ui_farewell = false;

  // 중기
  bool middle = false;
  bool sadness = false;
  bool ui_sadness = false;
  bool thetruthuntold = false;
  bool ui_thetruthuntold = false;

  // 후기
  bool late = false;

  // 종결기
  bool end = false;


  FocusNode _focusNode = FocusNode();

  // 대화 단계 저장
  void saveCon(String aToken, String nextcon) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/user/conversation-status';

    // 요청 본문 데이터
    var data = {
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
      print('HTTP 요청 실패?????: ${response.statusCode}');
    }
  }


  @override
  void initState() {
    super.initState();

    conversationStage = home.convs;
    setState(() {

    });

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    // 음원 적용
    for(int i= 0 ; i < voice.length; i++){
      _player.setAudioSource(AudioSource.uri(
          Uri.parse(voice[i]))
      );
    }
    controller1 = FlutterGifController(vsync: this);

    _player.setAsset(voice[voiceCount]);
    voiceCount++;
    _player.play();

    controller1.repeat(
        min: 0,
        max: 30,
        period: const Duration(milliseconds: 1000)
    );
    Timer(Duration(milliseconds: 2500), () {
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

  String conversationStage = "";

  int nextPage = 0;

  List<String> introText =[];

  int nextQuestion = 0;
  int nextYes = 0;
  int nextNo = 0;

  bool selectedNextTime = false;
  bool chooseTime = false;
  int whatTime = 0;

  String sentDate = "";

  final nextTimeController = TextEditingController();

  final _player = AudioPlayer();
  int voiceCount = 0;
  int voiceNoCount = 0;
  int voiceYesCount = 0;

  List<dynamic> voice = [
    "assets/voice/start1.mp3",
    "",
  ];

  List<dynamic> voiceYes = [
    "assets/voice/yes.mp3",
  ];

  List<dynamic> voiceNo = [
    "assets/voice/no1.mp3", "", "assets/voice/no2.mp3", ""
  ];

  List<dynamic> question= [
    "${home.user}님!\n기다리고 있었어요!",
    "대화를 시작해볼까요?",
  ];

  List<dynamic> yesAns= [
    "오늘은 어떤 주제로 얘기해볼까요?",
  ];

  List<dynamic> noAns= [
    "그럼 우리는 언제 다시 만나면 좋을까요?",
    "그럼 우리는 언제 다시 만나면 좋을까요?",
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
          color: Color(int.parse('0xff$backColor')),
          child: GestureDetector(
            onTap: (){
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

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
                Timer(Duration(milliseconds: 2000), () {
                  controller1.stop();
                });
              }
              else if(nextQuestion == 1 && yes == false && no == false){
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
              else if(no && nextNo == 0){
                nextNo++;
                voiceNoCount++;
              } else if(no && nextNo == 1){
                //시간 넣기
              } else if(no && nextNo == 2){
                nextNo++;
              } else if(no && nextNo == 3){
                //시간 넣기
              }
              else if (yes && nextYes == 0){

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
                                  currentValue: perc,
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
                                                    if(no == false && yes == false)...[
                                                      if(question[nextQuestion].toString().contains("\n"))...[
                                                        SizedBox(height: 28,),
                                                        Text(
                                                          question[nextQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ]else...[
                                                        SizedBox(height: 42,),
                                                        Text(
                                                          question[nextQuestion],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ],
                                                    ] else if(no)...[
                                                      if(noAns[nextNo].toString().contains("\n"))...[
                                                        SizedBox(height: 28,),
                                                        Text(
                                                          noAns[nextNo],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ]else...[
                                                        SizedBox(height: 42,),
                                                        Text(
                                                          noAns[nextNo],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ],

                                                    ] else if(yes)...[
                                                      if(yesAns[nextYes].toString().contains("\n"))...[
                                                        SizedBox(height: 28,),
                                                        Text(
                                                          yesAns[nextYes],
                                                          textAlign: TextAlign.center,
                                                          style: textStyle.bubbletext,
                                                        ),
                                                      ]else...[
                                                        SizedBox(height: 42,),
                                                        Text(
                                                          yesAns[nextYes],
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
                                if( (yes == false && no==false && nextQuestion < 2) || (no && nextNo == 0) || (no && nextNo > 1))...[
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
                                else if(no && nextNo == 1)...[
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
                                else if(yes && nextYes == 0)...[
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
                                          if(early)...[
                                            if(conversationStage == "1")...[
                                              Row(
                                                children: [
                                                  SizedBox(width: 16,),
                                                  Container(
                                                    width: 168,
                                                    height: 168,
                                                    child: ElevatedButton(
                                                        style: ui_memory? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                        onPressed: () {
                                                          //miss = true;
                                                          ui_farewell = false;
                                                          if(ui_memory == false){
                                                            ui_memory = true;
                                                          } else{
                                                            ui_memory = false;
                                                          }
                                                          // nextQuestion++;
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("${home.puppy}와의\n기억", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 16,),
                                                              Text("함께한 기억에 대해\n이야기해요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 0,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 76,),
                                                                  SvgPicture.asset('assets/images/conversation/intro/miss.svg')
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
                                                        style: ui_farewell? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                        onPressed: () {
                                                          ui_memory = false;
                                                          if(ui_farewell == false){
                                                            ui_farewell = true;
                                                          } else{
                                                            ui_farewell = false;
                                                          }
                                                          // nextQuestion++;
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("${home.puppy}와의\n이별", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 16,),
                                                              Text("이별의 순간을\n이야기해요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 0,),
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
                                            ]
                                            else if(conversationStage == "-1")...[
                                              Row(
                                                children: [
                                                  SizedBox(width: 16,),
                                                  Container(
                                                    width: 168,
                                                    height: 168,
                                                    child: ElevatedButton(
                                                        style: ui_memory? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                        onPressed: () {
                                                          //miss = true;
                                                          ui_farewell = false;
                                                          if(ui_memory == false){
                                                            ui_memory = true;
                                                          } else{
                                                            ui_memory = false;
                                                          }
                                                          // nextQuestion++;
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("${home.puppy}와의\n기억", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 16,),
                                                              Text("함께한 기억에 대해\n이야기해요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 0,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 76,),
                                                                  SvgPicture.asset('assets/images/conversation/intro/miss.svg')
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
                                                        style: ui_farewell? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                        onPressed: () {
                                                          ui_memory = false;
                                                          if(ui_farewell == false){
                                                            ui_farewell = true;
                                                          } else{
                                                            ui_farewell = false;
                                                          }
                                                          // nextQuestion++;
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("${home.puppy}와의\n이별", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 16,),
                                                              Text("이별의 순간을\n이야기해요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 0,),
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
                                            ]

                                            else if(conversationStage == "1B")...[
                                              Row(
                                                children: [
                                                  SizedBox(width: 16,),
                                                  Container(
                                                    width: 168,
                                                    height: 168,
                                                    child: ElevatedButton(
                                                        style: ui_memory? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                        onPressed: () {
                                                          //miss = true;
                                                          ui_farewell = false;
                                                          if(ui_memory == false){
                                                            ui_memory = true;
                                                          } else{
                                                            ui_memory = false;
                                                          }
                                                          // nextQuestion++;
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("${home.puppy}와의\n기억", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 16,),
                                                              Text("함께한 기억에 대해\n이야기해요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 0,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 76,),
                                                                  SvgPicture.asset('assets/images/conversation/intro/miss.svg')
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(width: 16,),
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: 168,
                                                        height: 168,
                                                        child: ElevatedButton(
                                                            style: buttonChart().greybtn_1,
                                                            onPressed: () {

                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(height: 16,),
                                                                  Text("${home.puppy}와의\n이별", style: textStyle.grey16semibold),
                                                                  SizedBox(height: 16,),
                                                                  Text("이별의 순간을\n이야기해요.", style: textStyle.grey12normal),
                                                                  SizedBox(height: 0,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 76,),
                                                                      SvgPicture.asset('assets/images/conversation/done_drop.svg')
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
                                            ] else if(conversationStage == "1A")...[
                                              Row(
                                                children: [
                                                  SizedBox(width: 16,),
                                                  Container(
                                                    width: 168,
                                                    height: 168,
                                                    child: ElevatedButton(
                                                        style: buttonChart().greybtn_1,
                                                        onPressed: () {

                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("${home.puppy}와의\n기억", style: textStyle.grey16semibold),
                                                              SizedBox(height: 16,),
                                                              Text("함께한 기억에 대해\n이야기해요.", style:textStyle.grey12normal),
                                                              SizedBox(height: 0,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 76,),
                                                                  SvgPicture.asset('assets/images/conversation/done_cloud.svg')
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
                                                        style: ui_farewell? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                        onPressed: () {
                                                          ui_memory = false;
                                                          if(ui_farewell == false){
                                                            ui_farewell = true;
                                                          } else{
                                                            ui_farewell = false;
                                                          }
                                                          // nextQuestion++;
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("${home.puppy}와의\n이별", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 16,),
                                                              Text("이별의 순간을\n이야기해요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 0,),
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
                                            ],
                                          ]else if(middle)...[
                                            if(conversationStage == "2")...[
                                              Row(
                                                children: [
                                                  SizedBox(width: 16,),
                                                  Container(
                                                    width: 168,
                                                    height: 168,
                                                    child: ElevatedButton(
                                                        style: ui_sadness? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                        onPressed: () {
                                                          //miss = true;
                                                          ui_thetruthuntold = false;
                                                          if(ui_sadness == false){
                                                            ui_sadness = true;
                                                          } else{
                                                            ui_sadness = false;
                                                          }
                                                          // nextQuestion++;
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("슬픔의\n감정", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_sadness? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 16,),
                                                              Text("이별로 인한 슬픔을\n이야기해요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_sadness? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 0,),
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
                                                        style: ui_thetruthuntold? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                        onPressed: () {
                                                          // grief = true;
                                                          ui_sadness = false;
                                                          if(ui_thetruthuntold == false){
                                                            ui_thetruthuntold = true;
                                                          } else{
                                                            ui_thetruthuntold = false;
                                                          }
                                                          // nextQuestion++;
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("전하지 못한\n진심", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 16,),
                                                              Text("전하고픈 진심을\n이야기해요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 0,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 76,),
                                                                  SvgPicture.asset('assets/images/conversation/intro/miss.svg')
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ] else if(conversationStage == "2B")...[
                                              Row(
                                                children: [
                                                  SizedBox(width: 16,),
                                                  Container(
                                                    width: 168,
                                                    height: 168,
                                                    child: ElevatedButton(
                                                        style: ui_sadness? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                        onPressed: () {
                                                          //miss = true;
                                                          ui_thetruthuntold = false;
                                                          if(ui_sadness == false){
                                                            ui_sadness = true;
                                                          } else{
                                                            ui_sadness = false;
                                                          }
                                                          // nextQuestion++;
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("슬픔의\n감정", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 16,),
                                                              Text("이별로 인한 슬픔을\n이야기해요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 0,),
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
                                                        style: buttonChart().greybtn_1,
                                                        onPressed: () {

                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("전하지 못한\n진심", style: textStyle.grey16semibold),
                                                              SizedBox(height: 16,),
                                                              Text("전하고픈 진심을\n이야기해요.", style: textStyle.grey12normal),
                                                              SizedBox(height: 0,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 76,),
                                                                  SvgPicture.asset('assets/images/conversation/done_cloud.svg')
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ] else if(conversationStage == "2A")...[
                                              Row(
                                                children: [
                                                  SizedBox(width: 16,),
                                                  Container(
                                                    width: 168,
                                                    height: 168,
                                                    child: ElevatedButton(
                                                        style: buttonChart().greybtn_1,
                                                        onPressed: () {

                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("슬픔의\n감정", style: textStyle.grey16semibold),
                                                              SizedBox(height: 16,),
                                                              Text("이별로 인한 슬픔을\n이야기해요.", style:textStyle.grey12normal),
                                                              SizedBox(height: 0,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 76,),
                                                                  SvgPicture.asset('assets/images/conversation/done_drop.svg')
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
                                                        style: ui_thetruthuntold? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                        onPressed: () {
                                                          // grief = true;
                                                          ui_sadness = false;
                                                          if(ui_thetruthuntold == false){
                                                            ui_thetruthuntold = true;
                                                          } else{
                                                            ui_thetruthuntold = false;
                                                          }
                                                          // nextQuestion++;
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 16,),
                                                              Text("전하지 못한\n진심", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 16,),
                                                              Text("전하고픈 진심을\n이야기해요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                              SizedBox(height: 0,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 76,),
                                                                  SvgPicture.asset('assets/images/conversation/intro/miss.svg')
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
                                          ],

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
                      bottom: MediaQuery.of(context).viewInsets.bottom * 0.001),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if(nextQuestion == 1 && no == false && yes == false)...[
                        Container(
                          height: 136,
                          width: screenSize.width,
                          padding: EdgeInsets.only(bottom: 24, left: 16, right:16),
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: buttonChart().purplebtn,
                                onPressed: () {
                                  if(conversationStage.contains("0")){
                                    yes = true;
                                    early = true;
                                    setState(() {});

                                    _player.setAsset(voiceYes[voiceYesCount]);
                                    voiceCount++;
                                    _player.play();

                                    // 2.5초 적정
                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 2000), () {
                                      controller1.stop();
                                    });
                                  } else if(conversationStage.contains("1")){
                                    yes = true;
                                    early = true;
                                    setState(() {});

                                    _player.setAsset(voiceYes[voiceYesCount]);
                                    voiceCount++;
                                    _player.play();

                                    // 2.5초 적정
                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 3000), () {
                                      controller1.stop();
                                    });
                                  } else if(conversationStage.contains("-1")){
                                    yes = true;
                                    early = true;
                                    setState(() {});

                                    _player.setAsset(voiceYes[voiceYesCount]);
                                    voiceCount++;
                                    _player.play();

                                    // 2.5초 적정
                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 3000), () {
                                      controller1.stop();
                                    });
                                  }

                                  else if(conversationStage.contains("2")){
                                    yes = true;
                                    middle = true;
                                    setState(() {});
                                    _player.setAsset(voiceYes[voiceYesCount]);
                                    voiceCount++;
                                    _player.play();

                                    // 2.5초 적정
                                    controller1.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 1000)
                                    );
                                    Timer(Duration(milliseconds: 3000), () {
                                      controller1.stop();
                                    });
                                  } else if(conversationStage.contains("3")){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LatePage()));
                                  } else if(conversationStage.contains("4")){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EndPage()));
                                  }
                                },
                                child: Text("네, 좋아요.", style: textStyle.white16semibold,),
                              ),
                              SizedBox(height: 8,),
                              ElevatedButton(
                                style: buttonChart().purplebtn3,
                                onPressed: () {
                                  no = true;
                                  setState(() {});

                                  _player.setAsset(voiceNo[voiceNoCount]);
                                  voiceCount++;
                                  _player.play();

                                  // 2.5초 적정
                                  controller1.repeat(
                                      min: 0,
                                      max: 30,
                                      period: const Duration(milliseconds: 1000)
                                  );
                                  Timer(Duration(milliseconds: 2000), () {
                                    controller1.stop();
                                  });
                                },
                                child: Text("아니요, 아직 시간이 필요해요.", style: textStyle.purple16midium,),
                              ),
                            ],
                          ),
                        ),
                      ]
                      else if(nextNo == 1  && selectedNextTime)...[
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
                                  print("얼만큼 뒤로?:"+ whatTime.toString());
                                  noAns.insertAll(2, [
                                    "네, ${home.user}님.\n${whatTime}시간 후에 다시 만나요!",
                                    "네, ${home.user}님.\n${whatTime}시간 후에 다시 만나요!",
                                  ]);
                                  //decidedType = false;
                                  nextNo++;
                                  // player2.setAsset(endVoice[voiceEndCount]);
                                  // voiceEndCount++;
                                  // player2.play();

                                  _player.setAsset(voiceNo[2]);
                                  //voiceNoCount++;
                                  _player.play();

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
                      else if(no && nextNo == 3)...[
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
                                    var now = DateTime.now().add(Duration(hours: whatTime));
                                    sentDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
                                    saveCon(sign_in.userAccessToken, sentDate);
                                    setState(() {});
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
                      else if(yes && nextYes == 0 && (ui_memory || ui_farewell || ui_sadness || ui_thetruthuntold) )...[
                              Container(
                                color: Color(0xffFFFFFF),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 24, left: 16, right:16),
                                  child: Container(
                                    width: screenSize.width,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: buttonChart().bluebtn3,
                                      onPressed: () {
                                        if(ui_memory){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MemoryPage()));

                                        } else if (ui_farewell){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => FarewellPage()));
                                        } else if (ui_sadness){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SadnessPage()));
                                        } else if (ui_thetruthuntold){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => TheTruthUntoldPage()));
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
                )
            ),
          )

      );

  }
}