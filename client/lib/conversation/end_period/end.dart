import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:client/conversation/end_period/end_coach_mark.dart';
import 'package:http/http.dart' as http;
import 'package:client/progressbar/animation_progressbar.dart';
import 'package:client/style.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/main.dart'as main;

/// 종결기 대화


List<dynamic> endConversation = [
  "네, 오늘은\n새로운 나에 대해 얘기해보아요.", //0
  "이제 아이가\n 떠난 빈자리에", //1
  "새로운 꿈과 열정을 심을 차례에요.",  //2
  "그 영감을 받아\n 자아를 탐색하고 강점을 발견하며", //3
  "더 큰 의미와 목적을\n 찾아 나아가볼까요?",  //4
  "새로운 나를 발견하고\n성장하는 과정에서", //5
  "우리의 인생은\n 풍요롭고 의미 있는 것으로 이어질 거예요.", //6
  "보호자님!", //7
  "평소 자신에 대해 \n 한 문장으로 설명해주세요!", //8
  "그렇군요, 이번에는\n ‘나 자신’에 대해 더 알아가기 위해", //9

  "지금까지의 자신의 경험과\n 놓쳤던 감정을 발견해보아요.", //10<< 바뀔예정
  "최근에 어떤 것 때문에 웃었나요?", //11
  "그 순간을 사진과 함께 추억하며\n 기분을 회복해보아요.",  //12
  "그 순간을 사진과 함께 추억하며\n 기분을 회복해보아요.",  //13
  "좋아요. 그렇다면\n 앞으로 1년후, 2년후, 3년후, 5년 후", //14
  "보호자님은\n 무엇을 하고 있을까요?", //15
  "미래의 나에 대해 생각하는 것은\n 놀라운 경험이에요.", //16
  "어떤 미래를 만들고 싶은지\n 함께 상상해볼까요?", //17
  "보호자님은\n 미래에 어떤 사람이 되어있을까요?", //18
  "미래의 보호자님에 대한\n 계획을 상상하고", //19
  "구체화하는 과정은\n 흥미로운 여정이 될거예요!", //20
  "자신이 설정한 목표에\n 설렘을 느끼고 성취하며", //21
  "미래를 향해 나아가\n 더 풍요로운 삶을 만들어 나가보아요!", //22
  "어려운 순간을 겪을 때,", //23
  "함께하는 사람들의 지지와 이해는\n 큰 힘이 돼요.", //24
  "그러니, \n 아픔을 함께 나누고 극복할 수 있도록", //25
  "다른 반려인들에게\n 도움을 보내보는 건 어떨까요?", //26


  // "보호자님,", //27
  // "이제 모든 대화가 끝이났어요!", //28
  // "그동안 함께한 대화는\n 소중하고 의미 있는 시간이었어요.", //29
  // "이제 대화는 종료되지만,", //30
  // "그동안의 순간들은\n 기억 속에 간직되길 바라요.", //31
  // "지금까지\n 대화의 여정에 함께 해줘서 고마워요!", //32
  //
  // "이제 ‘기억할개’ 속 새로운 일상이 당신을 기다리고 있어요.", //33
  // "이 대화를 닫고 나가는 순간,", //34
  // "삶의 다음 장이 펼쳐지기를 바랍니다.", //35
];

AudioPlayer player2 = AudioPlayer();

late FlutterGifController controller1, controller2, controller3;

List<dynamic> voice =[
  "assets/voice/end/endp1.mp3",
  "assets/voice/end/endp2.mp3",
  "assets/voice/end/endp3.mp3",
  "assets/voice/end/endp4.mp3",
  "assets/voice/end/endp5.mp3",
  "assets/voice/end/endp6.mp3",
  "assets/voice/end/endp7.mp3",
  "assets/voice/end/endp8.mp3",
  "assets/voice/end/endp9.mp3",
  "assets/voice/end/endp10.mp3",
  "assets/voice/end/endp11.mp3",
  "assets/voice/end/endp12.mp3",
  "assets/voice/end/endp13.mp3",
  "",
  "assets/voice/end/endp15.mp3",
  "assets/voice/end/endp16.mp3",
  "assets/voice/end/endp17.mp3",
  "assets/voice/end/endp18.mp3",
  "assets/voice/end/endp19.mp3",
  "assets/voice/end/endp20.mp3",
  "assets/voice/end/endp21.mp3",
  "assets/voice/end/endp22.mp3",
  "assets/voice/end/endp23.mp3",
  "assets/voice/end/endp24.mp3",
  "assets/voice/end/endp25.mp3",
  "assets/voice/end/endp26.mp3",
  "assets/voice/end/endp27.mp3",
];

class EndPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => EndPage(),
      ),
    );
  }

  @override
  _EndPageState createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> with TickerProviderStateMixin {

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

  bool isPicSelected = false; // 사진이 들어가는지 확인하는 코드 -> UI 바뀜

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  bool modiImage = false;

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        modiImage= true;
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }


  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    main.play = true;
    main.player.setAsset(main.musics[4]);
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
    Timer(Duration(milliseconds: 4000), () {
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
          color: Color(0xffDDE7FD),
          child: GestureDetector(
            onTap: (){
              print("이거만 좀 확인 부탁: " + nextQuestion.toString());

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
                  Timer(Duration(milliseconds: 3500), () {
                    controller1.stop();
                  }); // ok
                } else if(nextQuestion == 3){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 4){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 5){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 6){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 7){
                  Timer(Duration(milliseconds: 1500), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 8){
                  Timer(Duration(milliseconds: 4000), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 8){
                // 평소의 나
              }
              else if(nextQuestion > 8 && nextQuestion < 13){
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
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 11){
                  Timer(Duration(milliseconds: 3000), () {
                    controller1.stop();
                  }); // ok
                } else if(nextQuestion == 12){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  }); // ok
                }

              }
              else if(nextQuestion == 13){
                // 추억 올리기
              }
              else if(nextQuestion >13 && nextQuestion <15){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextQuestion == 15){
                  Timer(Duration(milliseconds: 2500), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 15){
                // 뭘하고 있을까?

              }
              else if(nextQuestion >15 && nextQuestion < 18){
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
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 18){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 18){
                // 미래에 어떤 사람이?

              }
              else if(nextQuestion > 18 && nextQuestion < 26){
                nextQuestion++;
                player2.setAsset(voice[voiceCount]);
                voiceCount++;
                player2.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextQuestion == 20){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 21){
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 22){
                  Timer(Duration(milliseconds: 5000), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 23){
                  Timer(Duration(milliseconds: 2500), () {
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
                  Timer(Duration(milliseconds: 4500), () {
                    controller1.stop();
                  });
                }

              }
              else if(nextQuestion == 26){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EndMarkCoachPage()));
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
                                  currentValue: 95,
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
                                if(nextQuestion < 13 || (nextQuestion > 13 && nextQuestion < 15) ||(nextQuestion > 15) )...[
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
                                else if(nextQuestion == 13)...[
                                  Container(
                                      width: screenSize.width,
                                      height: 750,
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 160, left:16),
                                                        child: SvgPicture.asset('assets/images/conversation/end/paper.svg',
                                                          fit: BoxFit.contain,
                                                          height: 452,
                                                          width: screenSize.width,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 192, left:32),
                                                        child: InkWell(
                                                          onTap: (){
                                                            getImage(ImageSource.gallery);
                                                          },
                                                          child: modiImage?
                                                          Container(width: 320, height: 320,child: Image.file(File(_image!.path),fit: BoxFit.cover,),)
                                                              :
                                                          SvgPicture.asset('assets/images/conversation/end/add_btn.svg',
                                                            fit: BoxFit.contain,
                                                            height: 320,
                                                            width: screenSize.width,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top:528,left: 32, right:32, bottom:16),
                                                        child: SizedBox(
                                                          width: screenSize.width,
                                                          //height: 150,
                                                          child: TextField(
                                                            style: textStyle.bubbletext,
                                                            controller: memoryController,
                                                            decoration: InputDecoration(
                                                              contentPadding: EdgeInsets.only(top:3, left: 0),
                                                              hintStyle: textStyle.bubbletext,
                                                              border: InputBorder.none,
                                                              focusedBorder: InputBorder.none,
                                                              hintText: '이곳에 그날의 추억을 작성해주세요.(75자)',
                                                              counterText:'',
                                                            ),
                                                            maxLines: 2,
                                                            maxLength: 75,
                                                            onTap: (){
                                                              // 편지지 올리기?
                                                            },
                                                            onChanged: (text){
                                                              // 편지를 써야 다음으로 넘어갈 수 있도록 설정
                                                              memory = true;
                                                              setState(() {});
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                          ),
                                        ],
                                      )
                                  ),
                                  // Stack(
                                  //   children: [
                                  //     Padding(
                                  //       padding: EdgeInsets.only(top: 160, left:16),
                                  //       child: SvgPicture.asset('assets/images/conversation/end/paper.svg',
                                  //         fit: BoxFit.contain,
                                  //         height: 452,
                                  //         width: screenSize.width,
                                  //       ),
                                  //     ),
                                  //     Padding(
                                  //       padding: EdgeInsets.only(top: 192, left:32),
                                  //       child: InkWell(
                                  //         onTap: (){
                                  //           getImage(ImageSource.gallery);
                                  //         },
                                  //         child: modiImage?
                                  //         Container(width: 320, height: 320,child: Image.file(File(_image!.path),fit: BoxFit.cover,),)
                                  //             :
                                  //         SvgPicture.asset('assets/images/conversation/end/add_btn.svg',
                                  //           fit: BoxFit.contain,
                                  //           height: 320,
                                  //           width: screenSize.width,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Padding(
                                  //       padding: EdgeInsets.only(top:528,left: 32, right:32, bottom:16),
                                  //       child: SizedBox(
                                  //         width: screenSize.width,
                                  //         //height: 150,
                                  //         child: TextField(
                                  //           style: textStyle.bubbletext,
                                  //           controller: memoryController,
                                  //           decoration: InputDecoration(
                                  //             contentPadding: EdgeInsets.only(top:3, left: 0),
                                  //             hintStyle: textStyle.bubbletext,
                                  //             border: InputBorder.none,
                                  //             focusedBorder: InputBorder.none,
                                  //             hintText: '이곳에 그날의 추억을 작성해주세요.(75자)',
                                  //             counterText:'',
                                  //           ),
                                  //           maxLines: 2,
                                  //           maxLength: 75,
                                  //           onTap: (){
                                  //             // 편지지 올리기?
                                  //           },
                                  //           onChanged: (text){
                                  //             // 편지를 써야 다음으로 넘어갈 수 있도록 설정
                                  //             memory = true;
                                  //             setState(() {});
                                  //           },
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // )
                                ]
                                else if(nextQuestion == 15)...[
                                    Stack(
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: 160,),
                                            Image.asset('assets/images/conversation/end/future.png',
                                                fit: BoxFit.contain,
                                                height: 400,
                                                width: screenSize.width,
                                            ),
                                            // SvgPicture.asset('assets/images/conversation/end/future.png',
                                            //   fit: BoxFit.contain,
                                            //   height: 400,
                                            //   width: screenSize.width,
                                            // ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(height: 182,),
                                            Padding(padding: EdgeInsets.only(left: 29),
                                            child: SvgPicture.asset('assets/images/conversation/end/one.svg',
                                                fit: BoxFit.contain,
                                                height: 28,
                                            ),),
                                            SizedBox(height: 72,),
                                            Padding(padding: EdgeInsets.only(left: 29),
                                              child: SvgPicture.asset('assets/images/conversation/end/two.svg',
                                                fit: BoxFit.contain,
                                                height: 28,
                                              ),),
                                            SizedBox(height: 68,),
                                            Padding(padding: EdgeInsets.only(left: 29),
                                              child: SvgPicture.asset('assets/images/conversation/end/three.svg',
                                                fit: BoxFit.contain,
                                                height: 28,
                                              ),),
                                            SizedBox(height: 68,),
                                            Padding(padding: EdgeInsets.only(left: 29),
                                              child: SvgPicture.asset('assets/images/conversation/end/five.svg',
                                                fit: BoxFit.contain,
                                                height: 28,
                                              ),),

                                          ],
                                        ),

                                        Padding(padding: EdgeInsets.only(left: 32, right: 32, top:200),
                                          child: Column(
                                            children: [
                                              TextField(
                                                style: textStyle.bk16normal,
                                                controller: oneController,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top:3, left: 0),
                                                  hintStyle: textStyle.grey16normal,
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  hintText: '1년후의 나는...',
                                                  counterText:'',
                                                ),
                                                maxLines: 1,
                                                maxLength: 50,
                                                onTap: (){
                                                  // 편지지 올리기?
                                                },
                                                onChanged: (text){
                                                  // 편지를 써야 다음으로 넘어갈 수 있도록 설정
                                                  one = true;
                                                  setState(() {});
                                                },
                                              ),
                                              SizedBox(height: 48,),
                                              TextField(
                                                style: textStyle.bk16normal,
                                                controller: twoController,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top:3, left: 0),
                                                  hintStyle: textStyle.grey16normal,
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  hintText: '2년후의 나는...',
                                                  counterText:'',
                                                ),
                                                maxLines: 1,
                                                maxLength: 50,
                                                onTap: (){
                                                  // 편지지 올리기?
                                                },
                                                onChanged: (text){
                                                  // 편지를 써야 다음으로 넘어갈 수 있도록 설정
                                                  two = true;
                                                  setState(() {});
                                                },
                                              ),
                                              SizedBox(height: 48,),
                                              TextField(
                                                style: textStyle.bk16normal,
                                                controller: threeController,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top:3, left: 0),
                                                  hintStyle: textStyle.grey16normal,
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  hintText: '3년후의 나는...',
                                                  counterText:'',
                                                ),
                                                maxLines: 1,
                                                maxLength: 50,
                                                onTap: (){
                                                  // 편지지 올리기?
                                                },
                                                onChanged: (text){
                                                  // 편지를 써야 다음으로 넘어갈 수 있도록 설정
                                                  three = true;
                                                  setState(() {});
                                                },
                                              ),
                                              SizedBox(height: 48,),
                                              TextField(
                                                style: textStyle.bk16normal,
                                                controller: fiveController,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top:3, left: 0),
                                                  hintStyle: textStyle.grey16normal,
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  hintText: '5년후의 나는...',
                                                  counterText:'',
                                                ),
                                                maxLines: 1,
                                                maxLength: 50,
                                                onTap: (){
                                                  // 편지지 올리기?
                                                },
                                                onChanged: (text){
                                                  // 편지를 써야 다음으로 넘어갈 수 있도록 설정
                                                  five = true;
                                                  setState(() {});
                                                },
                                              ),
                                              SizedBox(height: 48,),
                                            ],
                                          ),
                                        ),


                                      ],
                                    )

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
                      if(nextQuestion == 8)...[
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
                                      border: Border.all(color: me? Color(colorChart.blue): Color(0xffC0D2FC)),
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
                                      controller: meController,
                                      style: textStyle.bk14normal,
                                      decoration: InputDecoration(
                                          hintStyle: textStyle.grey14normal,
                                          border: InputBorder.none,
                                          hintText: '평소의 나 자신에 대해 설명하자면...'),
                                      onChanged: (s) {
                                        //text = s;
                                        me = true;
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
                                          if(me){
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

                                            nextQuestion++;
                                            setState(() {

                                            });
                                          }

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: me?Color(colorChart.blue):Color(0xffDDE7FD),
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
                        else if(nextQuestion == 13 && memory)...[
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
                                      player2.setAsset(voice[voiceCount]);
                                      voiceCount++;
                                      player2.play();
                                      // 2.5초 적정
                                      controller1.repeat(
                                          min: 0,
                                          max: 30,
                                          period: const Duration(milliseconds: 1000)
                                      );
                                      Timer(Duration(milliseconds: 8000), () {
                                        controller1.stop();
                                      });
                                      setState(() {});
                                    },
                                    child: Text("완료", style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                                  ),
                                ),),
                            ),
                          ]
                          else if(nextQuestion == 15 && one && two && three && five)...[
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
                                  child: Text("완료", style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                                ),
                              ),),
                          ),
                            ]
                        else if(nextQuestion == 18)...[
                        Container(
                          color: Colors.white,
                          width: screenSize.width,
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
                                    border: Border.all(color: future? Color(colorChart.blue):Color(0xffC0D2FC)),
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
                                    controller: futureController,
                                    style: textStyle.bk14normal,
                                    decoration: InputDecoration(
                                        hintStyle: textStyle.grey14normal,
                                        border: InputBorder.none,
                                        hintText: '나는 미래에...'),
                                    onChanged: (s) {
                                      //text = s;
                                      future = true;
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
                                        if(future){
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

                                          nextQuestion++;
                                          setState(() {

                                          });
                                        }

                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: future? Color(colorChart.blue):Color(0xffC0D2FC),
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

                    ],
                  ),
                )),
          )

      );

  }
}


